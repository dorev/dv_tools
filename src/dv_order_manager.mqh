#include "dv_common.mqh"
#include "dv_class_map.mqh"
#include "dv_order.mqh"

#ifndef DV_ORDER_MANAGER_H
#define DV_ORDER_MANAGER_H

//@START@
#ifdef __MQL4__ // order and order_manager not implemented for MT5

class order_manager
{
public:

    order_manager(bool track_history = true)
        : _magic_number(MagicNumber)
        , _symbol(_Symbol)
        , _track_history(track_history)
    {
        INFO("order_manager created for " + _symbol + " with magic number " + _magic_number)
    }

    // Tracking history enables to monitor closed orders and archived orders
    // If history is not tracked, _closed and _archived are always emptied
    void track_history(bool track_history)
    {
        DEBUG("order_manager::track_history " + track_history)

        _track_history = track_history;

        if (!_track_history)
        {
            DEBUG("Clearing order_manager history")
            _new_closed.clear();
            _archived.clear();
            _closed.clear();
        }
    }

    order_t* open_order(
        int op_type,
        double lots,
        double price,
        double takeprofit = NULL,
        double stoploss = NULL,
        int trailing_stop_pip = 0,
        int breakeven_pip = 0,
        string comment = "",
        int slippage = NULL)
    {
        int ticket = order_t::open(op_type, lots, price, takeprofit, stoploss, comment, slippage);

        if(ticket < 0)
        {
            // Error already thrown by order_t::open
            return NULL;
        }

        refresh();

        order_t* new_order = get_ticket(ticket);

        if(new_order == NULL)
        {
            ERROR("Order manager unable to reach ticket " + IntegerToString(ticket));
            return NULL;
        }

        new_order.set_trailing_stop(trailing_stop_pip);
        new_order.set_breakeven(breakeven_pip);
        new_order.update();

        return new_order;
    }

    order_t* get_ticket(int ticket)
    {
        if (_opened.contains(ticket))
        {
            return _opened.get_ref(ticket);
        }

        if (_closed.contains(ticket))
        {
            return _closed.get_ref(ticket);
        }

        return NULL;
    }

    void refresh()
    {
        DEBUG("order_manager::refresh")

        // Working variables
        int ticket = 0;
        order_t* order_ref = NULL;

        // Scan all open trades and history to validate/update the current content
        FOR_TRADES
            ticket = OrderTicket();
            DEBUG("order_manager::refresh processing ticket " + IntegerToString(ticket) + "...")

            if (_opened.access(ticket, order_ref))
            {
                DEBUG("order_manager::refresh detected opened ticket " + IntegerToString(ticket))
                order_ref.update();
            }
            else if (_track_history && _closed.access(ticket, order_ref))
            {
                WARNING("Unlikely detection of closed order " + IntegerToString(ticket))
                order_ref.update();

                if (!order_ref.is_closed())
                {
                    _opened.emplace(ticket, order_ref);
                    _closed.erase(ticket);
                }
            }
            else if (_track_history && _archived.find(ticket) >= 0)
            {
                // do nothing
                DEBUG("order_manager::refresh discovered archived ticket " + IntegerToString(ticket))
            }
            else
            {
                DEBUG("order_manager::refresh discovered new ticket " + IntegerToString(ticket))
                add_order(ticket);
            }
        FOR_TRADES_END

        if (_track_history)
        {
            FOR_HISTORY
                ticket = OrderTicket();

                if (_closed.access(ticket, order_ref))
                {
                    order_ref.update();
                }
                else if (_archived.find(ticket) >= 0)
                {
                    // do nothing
                }
                else
                {
                    // Add "old" tickets to archive at least to map them
                    if (order_t::is_closed(ticket))
                    {
                        _archived.push(ticket);
                        DEBUG("Untracked closed order added to order_manager archive")
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

            if (order_t::is_closed(ticket))
            {
                DEBUG("Detected new closed order " + IntegerToString(ticket))

                if (_opened.access(ticket, order_ref))
                {
                    if (_track_history)
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


        DEBUG("order_manager content : " + opened_orders_count()   + " opened - "
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
            if (_opened.access(keys.get(i), order))
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

            if (_opened.access(current_ticket, order) && !order.is(ticket_to_keep))
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
        if (!_track_history)
        {
            return false;
        }

        DEBUG("order_manager::new_closed_orders")

        if (_new_closed.size() > 0)
        {
            if (_closed.access(_new_closed.get(0), output))
            {
                _new_closed.erase(0);
                return true;
            }
        }

        DEBUG("order_manager::new_closed_orders found no new closed order")
        return false;
    }

    class_map<int, order_t>* get_opened_orders_map_ref()
    {
        DEBUG("order_manager::get_opened_orders_map_ref")
        return &_opened;
    }

    class_map<int, order_t>* get_closed_orders_map_ref()
    {
        DEBUG("order_manager::get_closed_orders_map_ref")
        return &_closed;
    }

    void archive(int ticket)
    {
        if (!_track_history)
        {
            return;
        }

        DEBUG("order_manager::archive ticket " + IntegerToString(ticket))

        bool add_to_archive = false;

        if (_opened.contains(ticket))
        {
            _opened.erase(ticket);
            add_to_archive = true;
        }

        if (_closed.contains(ticket))
        {
            _closed.erase(ticket);
            add_to_archive = true;
        }

        int index = _new_closed.find(ticket);
        if (index > -1)
        {
            _new_closed.erase(index);
        }

        if (add_to_archive)
        {
            _archived.push(ticket);
        }
    }

    void archive_closed_orders()
    {
        if (!_track_history)
        {
            return;
        }

        DEBUG("order_manager::archive_closed_orders")

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
        if (!_track_history)
        {
            return;
        }

        DEBUG("order_manager::clear_archive")
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
        INFO("Adding order " + IntegerToString(ticket))

        if (!order_t::exists(ticket))
        {
            WARNING("Attempt to add a non-existent ticket prevented")
            return false;
        }

        if (_track_history && order_t::is_closed(ticket))
        {
            DEBUG("Adding order " + IntegerToString(ticket) + " to closed orders")
            _closed.emplace(ticket, ticket);
        }
        else
        {
            DEBUG("Adding order " + IntegerToString(ticket) + " to opened orders")
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
#endif // DV_ORDER_MANAGER_H