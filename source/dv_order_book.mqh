#include "dv_common.mqh"
#include "dv_class_map.mqh"

#ifndef DV_ORDER_BOOK_H
#define DV_ORDER_BOOK_H

//@START@
#ifdef __MQL4__ // order and order_book not implemented for MT5

class order_t
{
public:

    // Default constructor
    order_t(int ticket = NULL) : _ticket(ticket)
    {
        DEBUG("order_t constructed with ticket " + (ticket == NULL ? "NULL" : ticket))
        update();
    }

    // Copy constructor
    order_t(const order_t& other)
        : _ticket(other.get_ticket())
        , _symbol(other.get_symbol())
        , _magic_number(other.get_magic_number())
        , _type(other.get_type())
        , _lots(other.get_lots())
        , _open_price(other.get_open_price())
        , _open_time(other.get_open_time())
        , _close_price(other.get_close_price())
        , _close_time(other.get_close_time())
        , _take_profit(other.get_take_profit())
        , _stop_loss(other.get_stop_loss())
        , _profit(other.get_profit())
    {
        DEBUG("order_t copy constructor")
    }

    // Update all order values
    bool update()
    {
        DEBUG("order_t::update on order " + _ticket)

        if(_ticket == NULL)
        {
            WARNING("Order created with NULL ticket")
            return false;
        }

        if(!OrderSelect(_ticket, SELECT_BY_TICKET))
        {
            ERROR("Unable to find ticket " + _ticket)
            return false;
        }

        _symbol         = OrderSymbol();
        _magic_number   = OrderMagicNumber();
        _type           = OrderType();
        _lots           = OrderLots();
        _open_price     = OrderOpenPrice();
        _open_time      = OrderOpenTime();
        _close_price    = OrderOpenPrice();
        _close_time     = OrderOpenTime();
        _take_profit    = OrderTakeProfit();
        _stop_loss      = OrderStopLoss();
        _profit         = OrderProfit();

        return true;
    }

    bool close(double slippage = DV_MAX_PIP_SLIPPAGE)
    {
        DEBUG("closing order " + _ticket + " with slippage " + slippage)

        double price = is_sell() ? Ask : Bid;

        if(OrderClose(_ticket, _lots, price, slippage))
        {
            return true;
        }

        ERROR("Unable to close order " + _ticket)
        return false;
    }

    bool close_partial(double lots, double slippage = DV_MAX_PIP_SLIPPAGE)
    {
        DEBUG("partially closing order " + _ticket + " for " + lots + " lots with slippage " + slippage)

        double price = is_sell() ? Ask : Bid;

        if(OrderClose(_ticket, lots, price, slippage))
        {
            update();
            return true;
        }

        ERROR("Unable to close order " + _ticket)
        return false;
    }
    
    inline bool is(int ticket) const
    {
        return ticket == _ticket;
    }

    // Static utilities

    // Returns true if the order exists
    static bool exists(int ticket)
    {
        return OrderSelect(ticket, SELECT_BY_TICKET);
    }

    // Returns true if the order is closed
    static bool is_closed(int ticket)
    {
        if(OrderSelect(ticket, SELECT_BY_TICKET))
        {
            return OrderCloseTime() > 0;
        }

        ERROR("Unable to select a ticket in order_t::is:open()")
        return false;
    }
    
    bool is_closed()
    {
        return is_closed(_ticket);
    }

    static string type_to_string(int op_type)
    {
        switch(op_type)
        {
            case OP_BUY        : return "buy";
            case OP_BUYLIMIT   : return "buy limit";
            case OP_BUYSTOP    : return "buy stop";
            case OP_SELL       : return "sell";
            case OP_SELLLIMIT  : return "sell limit";
            case OP_SELLSTOP   : return "sell stop";
            default:
                ERROR("Evalutating an invalid order type")
                return "invalid order type";
        }
    }

    static int open(int op_type, double lots, double price, double takeprofit = NULL, double stoploss = NULL, string comment = "", double slippage = NULL)
    {
        bool is_sell = (bool)(op_type & 1);
        double pip_with_sign = is_sell ? -1 * Pip : Pip;
        
        if(takeprofit == NULL)
        {
            takeprofit = price + (DV_DEFAULT_TAKEPROFIT * pip_with_sign);
        }

        if(stoploss == NULL)
        {
            stoploss = price - (DV_DEFAULT_STOPLOSS * pip_with_sign);
        }

        if(slippage == NULL)
        {
            slippage = DV_MAX_PIP_SLIPPAGE * Pip;
        }

        int send_attempts = DV_MAX_ORDER_SEND_RETRY;
        int ticket = -1;
        
        DEBUG("Sending " + type_to_string(op_type) + " order : " + lots + " lots - " + price + " - TP " + takeprofit + " - SL " + stoploss + " - slippage " + slippage)

        while((bool)send_attempts--)
        {
            ResetLastError();
            ticket = OrderSend(
                _Symbol,
                op_type,
                lots,
                price,
                slippage,
                stoploss,
                takeprofit,
                comment,
                MagicNumber,
                0,
                clrAzure
            );

            if(ticket < 0 && send_attempts > 0)
            {
                int error = GetLastError();
                WARNING("Unable to send " + type_to_string(op_type) + " order (error " + error + ") retrying...")
                Sleep(100);
            }
            else
            {
                break;
            }
        }

        if(ticket < 0)
        {
            ERROR("Failed to open " + type_to_string(op_type) + " order")
        }
        else
        {
            INFO("Opened new " + type_to_string(op_type) + " order " + ticket)
        }

        return ticket;
    }

    inline int         get_ticket()       const { return _ticket; }
    inline string      get_symbol()       const { return _symbol; }
    inline int         get_magic_number() const { return _magic_number; }
    inline int         get_type()         const { return _type; }
    inline double      get_lots()         const { return _lots; }
    inline double      get_open_price()   const { return _open_price; }
    inline datetime    get_open_time()    const { return _open_time; }
    inline double      get_close_price()  const { return _close_price; }
    inline datetime    get_close_time()   const { return _close_time; }
    inline datetime    get_expiration()   const { return _expiration; }
    inline double      get_take_profit()  const { return _take_profit; }
    inline double      get_stop_loss()    const { return _stop_loss; }
    inline double      get_profit()       const { return _profit; }

private:

    // Internal utilities

    bool is_sell() const
    {
        // odd type value is a sell order
        return (bool)(_type & 1);
    }

    bool is_buy() const
    {
        return !is_sell();
    }

    // Members

    int         _ticket;
    string      _symbol;
    int         _magic_number;
    int         _type;
    double      _lots;
    double      _open_price;
    datetime    _open_time;
    double      _close_price;
    datetime    _close_time;
    datetime    _expiration;
    double      _take_profit;
    double      _stop_loss;
    double      _profit;
};

///////////////////////////////////////////////////////////////////////////////

class order_book
{
public:

    order_book(bool track_history = true)
        : _magic_number(MagicNumber)
        , _symbol(_Symbol)
        , _track_history(track_history)
    {
        INFO("order_book created for " + _symbol + " with magic number " + _magic_number)
    }
    
    // Tracking history enables to monitor closed orders and archived orders
    // If history is not tracked, _closed and _archived are always emptied
    void track_history(bool track_history)
    {
        DEBUG("order_book::track_history " + track_history)
        
        _track_history = track_history;
        
        if(!_track_history)
        {
            DEBUG("Clearing order_book history")
            _new_closed.clear();
            _archived.clear();
            _closed.clear();
        }
    }

    void refresh()
    {
        DEBUG("order_book::refresh")

        // Working variables
        int ticket = 0;
        order_t* order_ref = NULL;

        // Scan all open trades and history to validate/update the current content
        FOR_TRADES         
            ticket = OrderTicket();
            DEBUG("order_book::refresh processing ticket " + ticket + "...")

            if(_opened.access(ticket, order_ref))
            {
                DEBUG("order_book::refresh detected opened ticket " + ticket)
                order_ref.update();
            }
            else if(_track_history && _closed.access(ticket, order_ref))
            {
                WARNING("Unlikely detection of closed order " + ticket)
                order_ref.update();
                
                if(!order_ref.is_closed())
                {
                    _opened.emplace(ticket, order_ref);
                    _closed.erase(ticket);
                }
            }
            else if(_track_history && _archived.find(ticket) >= 0)
            {
                // do nothing
                DEBUG("order_book::refresh discovered archived ticket " + ticket)
            }
            else
            {
                DEBUG("order_book::refresh discovered new ticket " + ticket)
                add_order(ticket);
            }
        FOR_TRADES_END

        if(_track_history)
        {
            FOR_HISTORY
                ticket = OrderTicket();

                if(_closed.access(ticket, order_ref))
                {
                    order_ref.update();
                }
                else if(_archived.find(ticket) >= 0)
                {
                    // do nothing
                }
                else
                {
                    // Add "old" tickets to archive at least to map them
                    if(order_t::is_closed(ticket))
                    {
                        _archived.push(ticket);
                        DEBUG("Untracked closed order added to order_book archive")
                    }
                    else
                    {
                        add_order(ticket);
                        WARNING("VERY unlikely detection of opened order in history")
                    }
                }
            FOR_HISTORY_END
        }

        // Check if any opened order is now closed
        vector<int>* opened_tickets = _opened.get_keys_ref();
        for(int i = 0; i < opened_tickets.size(); ++i)
        {
            ticket = opened_tickets.get(i);

            if(order_t::is_closed(ticket))
            {
                DEBUG("Detected new closed order " + ticket)
                
                if(_opened.access(ticket, order_ref))
                {
                    if(_track_history)
                    {
                        order_ref.update();
                        _new_closed.push(ticket);
                        _closed.emplace(ticket, order_ref);
                        _opened.erase(ticket);
                    }
                    else
                    {
                        DEBUG("Skipping new closed order storage because history is not tracked")
                    }
                }
            }
        }
        
        
        DEBUG("order_book content : " + opened_orders_count()   + " opened - " 
                                      + closed_orders_count()   + " closed - " 
                                      + new_closed_orders()     + " new closed - " 
                                      + archived_orders_count() + " archived")
    }

    void close_all()
    {
        INFO("Closing all orders")

        refresh();

        order_t* order = NULL;
        vector<int>* keys = _opened.get_keys_ref();

        for(int i = 0; i < keys.size(); ++i)
        {
            if(_opened.access(keys.get(i), order))
            {
                order.close();
            }
        }

        refresh();
    }

    void close_all_except(int ticket_to_keep)
    {
        INFO("Closing all orders except " + ticket_to_keep)

        refresh();

        order_t* order = NULL;
        vector<int>* keys = _opened.get_keys_ref();

        for(int i = 0; i < keys.size(); ++i)
        {
            int current_ticket = keys.get(i);
            
            if(_opened.access(current_ticket, order) && !order.is(ticket_to_keep))
            {
                INFO("Closing ticket " + current_ticket)
                order.close();
            }
        }

        refresh();
    }

    // Returns true if there is a newly closed order
    // and sets the function parameter with its reference
    bool access_new_closed(order_t*& output)
    { 
        if(!_track_history)
        {
            return false;
        }
        
        DEBUG("order_book::new_closed_orders")

        if(_new_closed.size() > 0)
        {
            if(_closed.access(_new_closed.get(0), output))
            {
                _new_closed.erase(0);
                return true;
            }
        }

        DEBUG("order_book::new_closed_orders found no new closed order")
        return false;
    }

    class_map<int, order_t>* get_opened_orders_map_ref()
    {
        DEBUG("order_book::get_opened_orders_map_ref")
        return &_opened;
    }

    class_map<int, order_t>* get_closed_orders_map_ref()
    {
        DEBUG("order_book::get_closed_orders_map_ref")
        return &_closed;
    }

    void archive(int ticket)
    {
        if(!_track_history)
        {
            return;
        }
        
        DEBUG("order_book::archive ticket " + ticket)
        
        bool add_to_archive = false;
        
        if(_opened.contains(ticket))
        {
            _opened.erase(ticket);
            add_to_archive = true;
        }  
        
        if(_closed.contains(ticket))
        {
            _closed.erase(ticket);
            add_to_archive = true;
        }    
        
        int index = _new_closed.find(ticket);
        if(index > -1)
        {
            _new_closed.erase(index);
        }
        
        if(add_to_archive)
        {
            _archived.push(ticket);
        }
    }

    void archive_closed_orders()
    {
        if(!_track_history)
        {
            return;
        }
        
        DEBUG("order_book::archive_closed_orders")
        
        vector<int>* keys = _closed.get_keys_ref();

        for(int i = 0; i < keys.size(); ++i)
        {
            _archived.push(keys.get(i));
        }

        _closed.clear();
        _new_closed.clear();
    }

    void clear_archive()
    {
        if(!_track_history)
        {
            return;
        }
        
        DEBUG("order_book::clear_archive")
        _archived.clear();
    }
    
    inline int opened_orders_count() const
    {
        return _opened.size();
    }
    
    inline int closed_orders_count() const
    {
        return _closed.size();
    }
    
    inline int new_closed_orders_count() const
    {
        return _new_closed.size();
    }
    
    inline int archived_orders_count() const
    {
        return _archived.size();
    }
    
    inline bool new_closed_orders() const
    {
        return _new_closed.size() > 0;
    }

private:

    // Private utilities

    // Adds an order to the book
    // Private because it should not be called manually
    bool add_order(int ticket)
    {
        INFO("Adding order " + ticket)

        if(!order_t::exists(ticket))
        {
            WARNING("Attempt to add a non-existent ticket prevented")
            return false;
        }

        if(_track_history && order_t::is_closed(ticket))
        {
            DEBUG("Adding order " + ticket + " to closed orders")
            _closed.emplace(ticket, ticket);
        }
        else
        {
            DEBUG("Adding order " + ticket + " to opened orders")
            _opened.emplace(ticket, ticket);
        }

        return true;
    }
    
    // Members

    int     _magic_number;
    string  _symbol;
    bool    _track_history;
    vector<int> _new_closed;
    vector<int> _archived;
    class_map<int, order_t> _opened;
    class_map<int, order_t> _closed;
};

#endif // __MQL4__

//@END@
#endif // DV_ORDER_BOOK_H