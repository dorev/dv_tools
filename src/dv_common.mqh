#include "dv_config.mqh"
#include "dv_logger.mqh"

#ifndef DV_COMMON_H
#define DV_COMMON_H

//@START@
#ifdef __MQL5__
#define Bid SymbolInfoDouble(_Symbol, SYMBOL_BID)
#define Ask SymbolInfoDouble(_Symbol, SYMBOL_ASK)
#endif

///////////////////////////////////////////////////////////////////////////////
// Magic number (used with macro below)

#ifdef DV_GENERATE_MAGIC_NUMBER
int scramble(string input_string)
{
    int result = 1;
    for(int i = 0; i < StringLen(input_string); ++i)
    {
        result *= (int)StringGetCharacter(input_string, i) - 31;
    }

    return result;
}

const int MagicNumber = MathAbs((scramble(_Symbol)    << 16) |
                                (scramble(DV_EA_NAME) <<  8) |
                                (scramble(DV_EA_VERSION)));
#endif

///////////////////////////////////////////////////////////////////////////////

// Global value for LastError
int global_last_error = 0;

// Pip adjustment
const double Pt = PipFactor * _Point;

// Defining a macro to highlight it when reading the code
#define Pip Pt

///////////////////////////////////////////////////////////////////////////////
// Log macros

#define FILE_AND_LINE " @ " + __FILE__ + " l." + IntegerToString(__LINE__)

#define DV_DEBUG_TAG    "[DEBUG] " + logger::timestamp()
#define DV_INFO_TAG     "[INFO ] " + logger::timestamp()
#define DV_WARN_TAG     "[WARN ] " + logger::timestamp()
#define DV_ERROR_TAG    "[ERROR] " + logger::timestamp()

#ifdef DV_ENABLE_LOG_FILE
    #define LOG_TO_FILE(level, log) if (logger::available()) { logger::print(level, log); }
#else
    #define LOG_TO_FILE(level, log) ;
#endif

#ifdef DV_LOG_DEBUG
    #ifdef DV_LOG_FILE_DEBUG
        #define DEBUG(x) Print(DV_DEBUG_TAG + " : " + x); LOG_TO_FILE(DV_DEBUG_TAG, x + FILE_AND_LINE)
    #else
        #define DEBUG(x) Print(DV_DEBUG_TAG + " : " + x);
    #endif
#else
    #ifdef DV_LOG_FILE_DEBUG
        #define DEBUG(x) LOG_TO_FILE(DV_DEBUG_TAG, x + FILE_AND_LINE)
    #else
        #define DEBUG(x) ;
    #endif
#endif

#ifdef DV_LOG_INFO
    #ifdef DV_LOG_FILE_INFO
        #define INFO(x) Print(DV_INFO_TAG + " : " + x); LOG_TO_FILE(DV_INFO_TAG, x + FILE_AND_LINE)
    #else
        #define INFO(x) Print(DV_INFO_TAG + " : " + x);
    #endif
#else
    #ifdef DV_LOG_FILE_INFO
        #define INFO(x) LOG_TO_FILE(DV_INFO_TAG, x + FILE_AND_LINE)
    #else
        #define INFO(x) ;
    #endif
#endif

#ifdef DV_LOG_WARNING
    #ifdef DV_LOG_FILE_WARNING
        #define WARNING(x) Print(DV_WARN_TAG + " : " +  x + FILE_AND_LINE); LOG_TO_FILE(DV_WARN_TAG, x + FILE_AND_LINE)
    #else
        #define WARNING(x) Print(DV_WARN_TAG + " : " +  x + FILE_AND_LINE);
    #endif
#else
    #ifdef DV_LOG_FILE_WARNING
        #define WARNING(x) LOG_TO_FILE(DV_WARN_TAG, x + FILE_AND_LINE)
    #else
        #define WARNING(x) ;
    #endif
#endif

#ifdef DV_LOG_ERROR
    #ifdef DV_LOG_FILE_ERROR
        #define ERROR(x) Print(DV_ERROR_TAG + " : " + x + FILE_AND_LINE); LOG_TO_FILE(DV_ERROR_TAG, x + FILE_AND_LINE)
    #else
        #define ERROR(x) Print(DV_ERROR_TAG + " : " + x + FILE_AND_LINE);
    #endif
#else
    #ifdef DV_LOG_FILE_ERROR
        #define ERROR(x) LOG_TO_FILE(DV_ERROR_TAG, x + FILE_AND_LINE)
    #else
        #define ERROR(x) ;
    #endif
#endif

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

///////////////////////////////////////////////////////////////////////////////
// Swap

template <typename VALUE_TYPE>
void swap(VALUE_TYPE& lhs, VALUE_TYPE& rhs)
{
    VALUE_TYPE temp = lhs;
    lhs = rhs;
    rhs = temp;
}

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
int __order__ = 0;
#define FOR_TRADES  for(__order__ = OrdersTotal() - 1; __order__ >= 0 ; --__order__){ if (!OrderSelect(__order__, SELECT_BY_POS, MODE_TRADES) || MagicNumber != OrderMagicNumber() || OrderSymbol() != _Symbol) { continue; }
#define FOR_ALL_TRADES  for(__order__ = OrdersTotal() - 1; __order__ >= 0 ; --__order__){ if (!OrderSelect(__order__, SELECT_BY_POS, MODE_TRADES)) { continue; }
#define FOR_HISTORY for(__order__ = OrdersHistoryTotal() - 1; __order__ >= 0 ; --__order__){ if (!OrderSelect(__order__, SELECT_BY_POS, MODE_HISTORY) || MagicNumber != OrderMagicNumber() || OrderSymbol() != _Symbol) { continue; }
#define ORDER_INDEX __order__
#define FOR_TRADES_END }
#define FOR_HISTORY_END }

///////////////////////////////////////////////////////////////////////////////
// Delete function for class types

template <typename CLASS_TYPE>
void safe_delete(CLASS_TYPE* object)
{
    if (object != NULL)
    {
        delete object;
        object = NULL;
    }
}

template <typename CLASS_TYPE>
void safe_delete_array(CLASS_TYPE* object)
{
    if (object != NULL)
    {
        delete[] object;
        object = NULL;
    }
}

//@END@
#endif // DV_COMMON_H