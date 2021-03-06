#include "dv_common.mqh"
#include "dv_class_map.mqh"

#ifndef DV_ORDER_H
#define DV_ORDER_H

//@START@
#ifdef __MQL4__ // order and order_manager not implemented for MT5

/*

Usage:

order_t represents the actual order and exposes it commonly used values

*/


class order_t
{
public:

    // Default constructor
    order_t(int ticket = NULL)
        : _ticket(ticket)
        , _trailing_stop_value(0)
        , _breakeven_threshold(0)
        , _breakeven_reached(false)
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
        , _takeprofit(other.get_takeprofit())
        , _stoploss(other.get_stoploss())
        , _profit(other.get_profit())
        , _trailing_stop_value(other.get_trailing_stop())
        , _breakeven_threshold(other.get_breakeven_threshold())
        , _breakeven_reached(other.breakeven_reached())
    {
        DEBUG("order_t copy constructor")
    }

    // Update all order values
    bool update()
    {
        DEBUG("order_t::update on order " + IntegerToString(_ticket))

        if (_ticket == NULL)
        {
            WARNING("Order created with NULL ticket")
            return false;
        }

        if (!OrderSelect(_ticket, SELECT_BY_TICKET))
        {
            ERROR("Unable to find ticket " + IntegerToString(_ticket))
            return false;
        }

        check_breakeven();
        check_trailing_stop();

        _symbol         = OrderSymbol();
        _magic_number   = OrderMagicNumber();
        _type           = OrderType();
        _lots           = OrderLots();
        _open_price     = OrderOpenPrice();
        _open_time      = OrderOpenTime();
        _close_price    = OrderOpenPrice();
        _close_time     = OrderOpenTime();
        _takeprofit     = OrderTakeProfit();
        _stoploss       = OrderStopLoss();
        _profit         = OrderProfit();

        return true;
    }

    void set_trailing_stop(int trailing_stop_pip)
    {
        _trailing_stop_value = trailing_stop_pip * Pip;
    }

    void check_trailing_stop()
    {
        if (!is_closed() && _trailing_stop_value != 0)
        {
            if (is_buy() && (Bid - _trailing_stop_value) > OrderStopLoss())
            {
                change_stoploss(Bid - _trailing_stop_value);
            }
            else if (is_sell() && (Ask + _trailing_stop_value) < OrderStopLoss())
            {
                change_stoploss(Ask + _trailing_stop_value);
            }
        }
    }

    void set_breakeven(int breakeven_threshold_pip)
    {
        if(OrderSelect(_ticket, SELECT_BY_TICKET))
        {
            double breakeven_buffer = OrderSwap() + OrderCommission() + Pip;
            double breakeven_value = breakeven_threshold_pip * Pip + breakeven_buffer;

            if(is_buy())
            {
                _breakeven_threshold = _open_price + breakeven_value;
            }
            else
            {
                _breakeven_threshold = _open_price - breakeven_value;
            }
        }
        else
        {
            ERROR("Unable to enable breakeven for order " + IntegerToString(_ticket));
        }
    }

    void check_breakeven()
    {
        if (!_breakeven_reached &&
            !is_closed() &&
            _breakeven_threshold != 0)
        {
            double breakeven_buffer = OrderSwap() + OrderCommission() + Pip;

            if (is_buy() &&
                _open_price > OrderStopLoss() &&
                Bid > _breakeven_threshold)
            {
                change_stoploss(_open_price + breakeven_buffer);
                _breakeven_reached = true;
            }
            else if(is_sell() &&
                _open_price < OrderStopLoss() &&
                Ask < _breakeven_threshold)
            {
                change_stoploss(_open_price - breakeven_buffer);
                _breakeven_reached = true;
            }
            else
            {
                return;
            }
        }
    }

    bool close(int slippage = NULL)
    {
        if (slippage == NULL)
        {
            slippage = DV_MAX_PIP_SLIPPAGE;
        }

        DEBUG("closing order " + _ticket + " with slippage " + slippage)

        double price = is_sell() ? Ask : Bid;

        RefreshRates();
        if (OrderClose(_ticket, _lots, price, slippage))
        {
            return true;
        }

        ERROR("Unable to close order " + IntegerToString(_ticket))
        return false;
    }

    bool close_partial(double lots, int slippage = NULL)
    {
        if (slippage == NULL)
        {
            slippage = DV_MAX_PIP_SLIPPAGE;
        }

        DEBUG("partially closing order " + IntegerToString(_ticket) + " for " + lots + " lots with slippage " + slippage)

        double price = is_sell() ? Ask : Bid;

        RefreshRates();
        if (OrderClose(_ticket, lots, price, slippage))
        {
            update();
            return true;
        }

        ERROR("Unable to close order " + IntegerToString(_ticket))
        return false;
    }

    int change_stoploss(double new_stoploss_value)
    {
        ResetLastError();
        RefreshRates();
        if (!OrderModify(_ticket, _open_price, new_stoploss_value, _takeprofit, 0))
        {
            global_last_error = GetLastError();
            return global_last_error;
        }

        return 0;
    }

    int change_takeprofit(double new_takeprofit_value)
    {
        update();

        ResetLastError();
        RefreshRates();
        if (!OrderModify(_ticket, _open_price, _stoploss, new_takeprofit_value, 0))
        {
            global_last_error = GetLastError();
            return global_last_error;
        }

        return 0;
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
        if (OrderSelect(ticket, SELECT_BY_TICKET))
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

    static int open(
        int op_type,
        double lots,
        double price,
        double takeprofit = NULL,
        double stoploss = NULL,
        string comment = "",
        int slippage = NULL)
    {
        bool is_sell = (bool)(op_type & 1);
        double pip_with_sign = is_sell ? -1 * Pip : Pip;

        if (takeprofit == NULL)
        {
            takeprofit = price + (DV_DEFAULT_TAKEPROFIT * pip_with_sign);
        }

        if (stoploss == NULL)
        {
            stoploss = price - (DV_DEFAULT_STOPLOSS * pip_with_sign);
        }

        if (slippage == NULL)
        {
            slippage = DV_MAX_PIP_SLIPPAGE;
        }

        int send_attempts = DV_MAX_ORDER_SEND_RETRY;
        int ticket = -1;

        DEBUG("Sending " + type_to_string(op_type) + " order : " + lots + " lots - " + price + " - TP " + takeprofit + " - SL " + stoploss + " - slippage " + slippage)

        while((bool)send_attempts--)
        {
            RefreshRates();
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

            if (ticket < 0 && send_attempts > 0)
            {
                global_last_error = GetLastError();
                WARNING("Unable to send " + type_to_string(op_type) + " order (error " + IntegerToString(global_last_error) + ") retrying...")
                Sleep(100);
            }
            else
            {
                break;
            }
        }

        if (ticket >= 0)
        {
            INFO("Opened new " + type_to_string(op_type) + " order " + IntegerToString(ticket))
        }
        else
        {
            ERROR("Failed to open " + type_to_string(op_type) + " order")
        }

        return ticket;
    }

    bool is_sell() const
    {
        // odd type value is a sell order
        return (bool)(_type & 1);
    }

    bool is_buy() const
    {
        return !is_sell();
    }

    inline int         get_ticket()                 const { return _ticket; }
    inline string      get_symbol()                 const { return _symbol; }
    inline int         get_magic_number()           const { return _magic_number; }
    inline int         get_type()                   const { return _type; }
    inline double      get_lots()                   const { return _lots; }
    inline double      get_open_price()             const { return _open_price; }
    inline datetime    get_open_time()              const { return _open_time; }
    inline double      get_close_price()            const { return _close_price; }
    inline datetime    get_close_time()             const { return _close_time; }
    inline datetime    get_expiration()             const { return _expiration; }
    inline double      get_takeprofit()             const { return _takeprofit; }
    inline double      get_stoploss()               const { return _stoploss; }
    inline double      get_profit()                 const { return _profit; }
    inline double      get_trailing_stop()          const { return _trailing_stop_value; }
    inline double      get_breakeven_threshold()    const { return _breakeven_threshold; }
    inline bool        breakeven_reached()          const { return _breakeven_reached; }

private:

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
    double      _takeprofit;
    double      _stoploss;
    double      _profit;
    double      _trailing_stop_value;
    double      _breakeven_threshold;
    bool        _breakeven_reached;
};

#endif // __MQL4__

//@END@
#endif // DV_ORDER_H