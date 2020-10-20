#include "dv_common.mqh"
#include "dv_class_map.mqh"

#ifndef DV_ORDER_BOOK_H
#define DV_ORDER_BOOK_H

#ifdef __MQL4__ // order and order_book not implemented for MT5

class order
{
public:

    // Default constructor
    order(int ticket = NULL) : _ticket(ticket)
    {
        update();
    }

    // Copy constructor
    order(const order& other)
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
    }

    // Update all order values
    bool update()
    {
        if(_ticket == NULL)
        {
            WARNING("Order created with NULL ticket")
            return false;
        }

        if(OrderSelect(_ticket, SELECT_BY_TICKET))
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
        double price = is_sell() ? Ask : Bid;

        if(OrderClose(_ticket, _lots, price, slippage))
        {
            return true;
        }

        return false;
    }

    bool close_partial(double lots, double slippage = DV_MAX_PIP_SLIPPAGE)
    {
        double price = is_sell() ? Ask : Bid;

        if(OrderClose(_ticket, lots, price, slippage))
        {
            return true;
        }

        return false;
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

        ERROR("Unable to select a ticket in order::is:open()")
        return false;
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

    bool is_sell()
    {
        // odd type value is a sell order
        return (bool)(_type & 1);
    }

    bool is_buy()
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

    order_book()
        : _magic_number(MagicNumber)
        , _symbol(Symbol())
    {
        DEBUG("order_book created for " + _symbol + " with magic number " + _magic_number)
    }

    bool add_order(int ticket)
    {
        if(!order::exists(ticket))
        {
            WARNING("Attempt to add a non-existent ticket prevented")
            return false;
        }

        if(order::is_closed(ticket))
        {
            _closed_orders.emplace(ticket, ticket);
        }
        else
        {
            _opened_orders.emplace(ticket, ticket);
        }

        DEBUG("Added ticket " + ticket + " to order book")
        return true;
    }

    void refresh()
    {
        // Working variables
        int ticket = 0;
        order* order_ref = NULL;

        // Scan all open trades and history to validate/update the current content
        FOR_TRADES
            ticket = OrderTicket();

            if(_opened_orders.access(ticket, order_ref))
            {
                order_ref.update();
            }
            else if(_closed_orders.access(ticket, order_ref))
            {
                WARNING("Unlikely detection of closed order")
                order_ref.update();
            }
            else if(_archived_orders.find(ticket))
            {
                // do nothing
            }
            else
            {
                // new ticket!!
                add_order(ticket);
            }
        FOR_END

        FOR_HISTORY
            ticket = OrderTicket();

            if(_opened_orders.access(ticket, order_ref))
            {
                WARNING("Unlikely detection of opened order")
                order_ref.update();
            }
            else if(_closed_orders.access(ticket, order_ref))
            {
                order_ref.update();
            }
            else if(_archived_orders.find(ticket))
            {
                // do nothing
            }
            else
            {
                // Add "old" tickets to archive at least to map them
                if(order::is_closed(ticket))
                {
                    _archived_orders.push(ticket);
                    WARNING("Unknown closed order added to order_book archive")
                }
                else
                {
                    add_order(ticket);
                    WARNING("VERY unlikely detection of opened order in history")
                }
            }
        FOR_END

        // Check if any opened order is now closed
        vector<int>* opened_tickets = _opened_orders.get_keys_ref();
        for(int i = 0; i < opened_tickets.size(); ++i)
        {
            ticket = opened_tickets.get(i);

            if(order::is_closed(ticket))
            {
                if(_opened_orders.access(ticket, order_ref))
                {
                    order_ref.update();
                    _newly_closed_tickets.push(ticket);
                    _closed_orders.emplace(ticket, order_ref);
                    _opened_orders.erase(ticket);
                }
            }
        }
    }

    bool is_known(int ticket)
    {
        return _opened_orders.contains(ticket) ||
               _closed_orders.contains(ticket) ||
               _archived_orders.find(ticket);
    }

    void close_all(bool archive_all = false)
    {
        refresh();

        order* order_ = NULL;

        vector<int>* keys = _opened_orders.get_keys_ref();

        for(int i = 0; i < keys.size(); ++i)
        {
            if(_opened_orders.access(keys.get(i), order_))
            {
                order_.close();
            }
        }

        refresh();
    }

private:

    int _magic_number;
    string _symbol;
    class_map<int, order> _opened_orders;
    class_map<int, order> _closed_orders;
    vector<int> _newly_closed_tickets;
    vector<int> _archived_orders;
};

/*

int lastTicketClosed = 0;
void ScanForClosedOrders()
{
    int newlyClosedTickets[16];
    ArrayFill(newlyClosedTickets,0,16,0);
    int newTicketIndex = 0;

    FOR_EACH_PAST_ORDER
        int currentTicket = OrderTicket();
        if(currentTicket != lastTicketClosed)
        {
            newlyClosedTickets[newTicketIndex++] = currentTicket;
        }
        else
        {
            break;
        }
    FOR_EACH_END

    if(newTicketIndex != 0)
    {
        lastTicketClosed = newlyClosedTickets[0];

        for(int i = 0; i < newTicketIndex; ++i)
        {
            if(OrderSelect(newlyClosedTickets[i], SELECT_BY_TICKET, MODE_HISTORY))
            {
                double profit = OrderProfit();
                Print("---> NEW CLOSE DETECTED! Order #", OrderTicket(),
                        " was closed at ", TimeToStr(OrderCloseTime()),
                        " with ", profit > 0 ? "profit" : "loss",": ", DoubleToStr(profit, Digits));
            }

        }

    }

}

*/
#endif // __MQL4__

#endif // DV_ORDER_BOOK_H