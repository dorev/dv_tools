#include "dv_config.mqh"

#ifndef DV_COMMON_H
#define DV_COMMON_H

///////////////////////////////////////////////////////////////////////////////
// Magic number (used with macro below)

int MagicNumber = 0;

const double Pt = (bool)(Digits & 1) ? Point * 10 : Point;

///////////////////////////////////////////////////////////////////////////////
// Log macros

#define FILE_AND_LINE " @ " + __FILE__ + " l." + IntegerToString(__LINE__)

#ifdef DV_LOG_DEBUG
#define DEBUG(x) Print("DEBUG: ", x + FILE_AND_LINE);
#else
#define DEBUG(x)
#endif

#ifdef DV_LOG_WARNING
#define WARNING(x) Print("WARNING: ", x + FILE_AND_LINE);
#else
#define WARNING(x)
#endif

#ifdef DV_LOG_ERROR
#define ERROR(x) Print("ERROR: ", x + FILE_AND_LINE);
#else
#define ERROR(x)
#endif


///////////////////////////////////////////////////////////////////////////////
// Utility macros
#define DV_TIME_ZERO D'01.01.1970'
#define UI_TICK _t_
string  _discard_s_ = "";
#define DISCARD_S(x) _discard_s_  = x;
int     _discard_i_ = 0;
#define DISCARD_I(x) _discard_i_  = x; 
bool    _discard_b_ = false;
#define DISCARD_B(x) _discard_b_  = x; 

// Convenience macro to iterate over orders

#define FOR_EACH_ORDER      for(int __order__ = OrdersTotal() - 1; __order__ >= 0 ; --__order__){ if(!OrderSelect(__order__, SELECT_BY_POS, MODE_HISTORY) || MagicNumber == OrderMagicNumber() || OrderSymbol() != Symbol()) { continue; }
#define FOR_EACH_PAST_ORDER for(int __order__ = OrdersHistoryTotal() - 1; __order__ >= 0 ; --__order__){ if(!OrderSelect(__order__, SELECT_BY_POS, MODE_HISTORY) || MagicNumber == OrderMagicNumber() || OrderSymbol() != Symbol()) { continue; }
#define CURRENT_ORDER_INDEX __order__
#define FOR_EACH_END }

///////////////////////////////////////////////////////////////////////////////
// Delete function for class types

template <typename CLASS_TYPE>
void safe_delete(CLASS_TYPE* object)
{
    if(object != NULL)
    {
        delete object;
        object = NULL;
    }
}

template <typename CLASS_TYPE>
void safe_delete_array(CLASS_TYPE* object)
{
    if(object != NULL)
    {
        delete[] object;
        object = NULL;
    }
}

///////////////////////////////////////////////////////////////////////////////
// Random seed

ushort rand_seed[] = {112, 111, 'w', 101, 114, 101, 100, ' ', 98, 
                      'y', 32, 100, 118, '_', 116, 'o', 111, 108, 115};

///////////////////////////////////////////////////////////////////////////////
// Generic comparaison

#define SX(x) String##x
bool equals(string lhs, string rhs)
{
    return SX(Compare)(lhs, rhs) == 0;
}

template <typename VALUE_TYPE>
bool equals(VALUE_TYPE lhs, VALUE_TYPE rhs)
{
    return lhs == rhs;
}

#endif // DV_COMMON_H