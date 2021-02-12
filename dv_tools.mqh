///////////////////////////////////////////////////////////////////////////////
// dv_config.mqh

// Naming
#ifndef DV_EA_NAME
#define DV_EA_NAME                         "Unnamed"
#endif

#ifndef DV_EA_VERSION
#define DV_EA_VERSION                      "0.0.0.0"
#endif

// Pip multiplier depending on digits
#define PipFactor ((bool)(_Digits & 1) ? 10 : 1)

// Trades config
#ifndef DV_MAX_PIP_SLIPPAGE
#define DV_MAX_PIP_SLIPPAGE             (5 * PipFactor)
#endif
#ifndef DV_MAX_ORDER_SEND_RETRY
#define DV_MAX_ORDER_SEND_RETRY         3
#endif
#ifndef DV_DEFAULT_TAKEPROFIT
#define DV_DEFAULT_TAKEPROFIT           30
#endif
#ifndef DV_DEFAULT_STOPLOSS
#define DV_DEFAULT_STOPLOSS             15
#endif

// Log level
//#define DV_LOG_DEBUG
//#define DV_LOG_INFO
//#define DV_LOG_WARNING
//#define DV_LOG_ERROR

// Log to file
//#define DV_ENABLE_LOG_FILE
#define DV_LOG_FILE_DEBUG
#define DV_LOG_FILE_INFO
#define DV_LOG_FILE_WARNING
#define DV_LOG_FILE_ERROR

// Label default values
#ifndef DV_DEFAULT_LABEL_COLOR
#define DV_DEFAULT_LABEL_COLOR          clrRed
#endif
#ifndef DV_DEFAULT_LABEL_FONT
#define DV_DEFAULT_LABEL_FONT           "Consolas"
#endif
#ifndef DV_DEFAULT_LABEL_SIZE
#define DV_DEFAULT_LABEL_SIZE           12
#endif

// Lines default values
#ifndef DV_DEFAULT_LINE_COLOR
#define DV_DEFAULT_LINE_COLOR           clrRed
#endif
#ifndef DV_DEFAULT_LINE_STYLE
#define DV_DEFAULT_LINE_STYLE           STYLE_SOLID
#endif
#ifndef DV_DEFAULT_LINE_WIDTH
#define DV_DEFAULT_LINE_WIDTH           2
#endif

// Chart default values (MetaTrader default colors)
#ifndef DV_DEFAULT_BG_COLOR
#define DV_DEFAULT_BG_COLOR             clrBlack
#endif
#ifndef DV_DEFAULT_AXIS_COLOR
#define DV_DEFAULT_AXIS_COLOR           clrWhite
#endif
#ifndef DV_DEFAULT_GRID_COLOR
#define DV_DEFAULT_GRID_COLOR           clrLightSlateGray
#endif

// UI grid sizing
#ifndef DV_COL_SIZE
#define DV_COL_SIZE                     48
#endif
#ifndef DV_ROW_SIZE
#define DV_ROW_SIZE                     16
#endif

// Base reserve of all container at init
#ifndef DV_DEFAULT_CONTAINER_RESERVE
#define DV_DEFAULT_CONTAINER_RESERVE    16
#endif

///////////////////////////////////////////////////////////////////////////////
// dv_version.mqh

#define DV_MAJOR 1
#define DV_MINOR 0
#define DV_PATCH 2
#define DV_BUILD 44

string dv_version()
{
    return IntegerToString(DV_MAJOR) + "." +
           IntegerToString(DV_MINOR) + "." +
           IntegerToString(DV_PATCH) + "." +
           IntegerToString(DV_BUILD);
}

///////////////////////////////////////////////////////////////////////////////
// dv_logger.mqh

class logger
{
public:

    static void set_file_path(string log_file_path)
    {
        _log_file_path = log_file_path;
    }

    static bool init()
    {
        if (_log_file_path == "")
        {
            // Default log file path
            _log_file_path = "dv_logger_" + _Symbol + "_" + timestamp() + ".log";
        }

        _log_file_handle = FileOpen(_log_file_path, FILE_READ|FILE_WRITE|FILE_ANSI);
        _is_init = _log_file_handle != INVALID_HANDLE;
        return _is_init;
    }

    static void shutdown()
    {
        FileClose(_log_file_handle);
    }

    static void print(string tag, string message)
    {
        if (!_is_init && !init())
        {
            return;
        }

        FileSeek(_log_file_handle, 0, SEEK_END);
        FileWriteString(_log_file_handle, tag + " : " + message + "\n");
    }

    static string timestamp()
    {
        string timestamp = TimeToString(TimeLocal(), TIME_DATE|TIME_MINUTES|TIME_SECONDS) + "." + IntegerToString(GetMicrosecondCount());
        StringReplace(timestamp, ":", ".");
        StringReplace(timestamp, " ", "_");
        return timestamp;
    }

    inline static bool available() { return _is_init; }

private:

    static string _log_file_path;
    static bool _is_init;
    static int _log_file_handle;
};

string  logger::_log_file_path      = "";
bool    logger::_is_init            = false;
int     logger::_log_file_handle    = INVALID_HANDLE;

///////////////////////////////////////////////////////////////////////////////
// dv_candle.mqh


class candle_t
{

public:

    bool is_bull;
    bool is_bear;
    double open;
    double high;
    double low;
    double close;
    double half;
    double body_top;
    double body_buttom;
    double body_size;
    double total_size;
    datetime time;
    int timeframe;

    candle_t(string symbol = NULL, int timeframe_ = 0, int shift = 0)
    {
        timeframe = timeframe_;
        if (timeframe == PERIOD_CURRENT)
        {
            timeframe = Period();
        }

        time    = iTime(symbol, timeframe_, shift);
        open    = iOpen(symbol, timeframe_, shift);
        high    = iHigh(symbol, timeframe_, shift);
        low     = iLow(symbol, timeframe_, shift);
        close   = iClose(symbol, timeframe_, shift);
        is_bull = open < close;
        is_bear = !is_bull;
        total_size = high - low;

        if (is_bull)
        {
            half = close - ((close - open) / 2);
            body_top = close;
            body_buttom = open;
        }
        else
        {
            half = open  - ((open - close) / 2);
            body_top = open;
            body_buttom = close;
        }

        body_size = body_top - body_buttom;
    }
};

///////////////////////////////////////////////////////////////////////////////
// dv_common.mqh

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

///////////////////////////////////////////////////////////////////////////////
// dv_vector.mqh

template <typename VALUE_TYPE>
class vector
{
public:

    // Default constructor
    vector(int reserved_size = DV_DEFAULT_CONTAINER_RESERVE)
        : _size(0)
        , _capacity(0)

    {
        DEBUG("vector constructed with reserve of " + reserved_size)
        reserve(reserved_size);
        fill(0, _capacity);
    }

    // Constructor base on initialization-array
    vector(const VALUE_TYPE& array[])
        : _size(0)
        , _capacity(0)

    {
        DEBUG("vector copy-constructed")

        reserve(ArraySize(array));
        for(int i = 0; i < _capacity; ++i)
        {
            push((const VALUE_TYPE)array[i]);
        }
    }

    // Copy-constructor
    vector(const vector<VALUE_TYPE>& other)
        : _size(0)
        , _capacity(0)

    {
        reserve(other.capacity());
        for(int i = 0; i < other.size(); ++i)
        {
            push(other.get(i));
        }
    }

    // Accessors //////////////////////////////////////////////////////////////

    // Get a copy of the value at the specified index
    VALUE_TYPE get(int index) const
    {
        if (bad_index(index))
        {
            WARNING("Accessing an invalid vector index")
        }

        return _data[index];
    }

    // Returns the number of items in the vector
    int size() const
    {
        return _size;
    }

    // Returns the size of the underlying data array
    int capacity() const
    {
        return _capacity;
    }

    // Mutators ///////////////////////////////////////////////////////////////

    // Adds a value passed by reference at the end of the vector
    vector<VALUE_TYPE>* push(const VALUE_TYPE& new_item)
    {
        bust_resize_check();
        _data[_size++] = new_item;
        return &this;
    }

    // Adds a value passed by copy at the end of the vector

    vector<VALUE_TYPE>* push(VALUE_TYPE new_item)
    {
        bust_resize_check();
        _data[_size++] = new_item;
        return &this;
    }

    // Changes the value of a vector index with a value passed by reference
    vector<VALUE_TYPE>* set(int index, VALUE_TYPE value)
    {
        if (bad_index(index))
        {
            WARNING("Attempt to set an invalid index of vector prevented")
        }

        _data[index] = value;
        return &this;
    }

    // Changes the value of a vector index with a value passed by copy
    vector<VALUE_TYPE>* set(const int& index, const VALUE_TYPE& value)
    {
        if (bad_index(index))
        {
            WARNING("Attempt to set an invalid index of vector prevented")
        }

        _data[index] = value;
        return &this;
    }

    // Grows the underlying data array and fills the empty slots with NULL
    vector<VALUE_TYPE>* reserve(int reserve_size)
    {
        if (reserve_size < 0)
        {
            WARNING("Attempt to reserve a negative amount of data prevented")
        }

        if (reserve_size > _capacity)
        {
            resize(reserve_size);
            fill(_size, _capacity - _size);
        }
        return &this;
    }

    // Fills a certain amount of the specified value starting at the specified offset
    vector<VALUE_TYPE>* fill(int offset, int count, VALUE_TYPE value = NULL)
    {
        if (count > (_capacity - offset))
        {
            count =_capacity - offset;
            WARNING("Overfilling of vector prevented")
        }

        // Adjust values to also fill indices between _size and offset
        if (offset > _size)
        {
            count += offset - _size;
            offset = _size;

            WARNING("fill() offset argument was above the current size of the vector, that gap was also filled")
        }

        int end = offset + count;
        for(int i = offset; i < end; ++i)
        {
            _data[i] = value;
        }
        return &this;
    }

    // Fills a certain amount of the reffered value starting at the specified offset
    vector<VALUE_TYPE>* fill(int offset, int count, const VALUE_TYPE& value)
    {
        if (count > (_capacity - offset))
        {
            count =_capacity - offset;
            WARNING("Overfilling of vector prevented")
        }

        // Adjust values to also fill indices between _size and offset
        if (offset > _size)
        {
            count += offset - _size;
            offset = _size;

            WARNING("fill() offset argument was above the current size of the vector, that gap was also filled")
        }

        int end = offset + count;
        for(int i = offset; i < end; ++i)
        {
            _data[i] = value;
        }
        return &this;
    }

    // Fills the whole capacity of the vector with the specified value
    vector<VALUE_TYPE>* fill(VALUE_TYPE value = NULL)
    {
        for(int i = 0; i < _capacity; ++i)
        {
            _data[i] = value;
        }
        _size = _capacity;
        return &this;
    }

    // Fills the whole capacity of the vector with the specified value
    vector<VALUE_TYPE>* fill(const VALUE_TYPE& value)
    {
        for(int i = 0; i < _capacity; ++i)
        {
            _data[i] = value;
        }
        _size = _capacity;
        return &this;
    }

    // Erases a specific index and shifts back the follwing values to keep the
    // vector underlying data contiguous
    bool erase(int index)
    {
        if (bad_index(index))
        {
            WARNING("Attempt to erase an invalid index prevented")
            return false;
        }

        --_size;

        for(int i = index; i < _size; ++i)
        {
            _data[i] = _data[i + 1];
        }

        return true;
    }

    // Resets the number of element to 0 and sets underlying data array to NULL
    // Also allows to reset the underlying data array to the initial size
    vector<VALUE_TYPE>* clear(bool reset_reserve = false)
    {
        _size = 0;

        if (reset_reserve)
        {
            resize(DV_DEFAULT_CONTAINER_RESERVE);
        }

        fill(0, _capacity);
        return &this;
    }

    // Resizes the underlying data array, might erase values when shrinking
    vector<VALUE_TYPE>*  resize(int new_size)
    {
        _capacity = ArrayResize(_data, new_size);

        if (_capacity < _size)
        {
            _size = _capacity;
            WARNING("Data erased from vector when resizing")
        }
        return &this;
    }

    // Utilities //////////////////////////////////////////////////////////////

    // Returns the index of a given value, -1 if not found
    int find(VALUE_TYPE value) const
    {
        for(int i = 0; i < _size; ++i)
        {
            if (equals(_data[i], value))
            {
                return i;
            }
        }

        return -1;
    }

private:

    // Internal utilities /////////////////////////////////////////////////////

    bool bad_index(int index) const
    {
        return index < 0 || index >= _size;
    }

    void bust_resize_check()
    {
        int panic = 10;
        while(_size >= _capacity)
        {
            reserve(_capacity * 2);

            if (!--panic)
            {
                WARNING("CRITICAL : vector size/capacity overflow");
                break;
            }
        }
    }

    // Members

    VALUE_TYPE _data[];
    int _size;
    int _capacity;
};

///////////////////////////////////////////////////////////////////////////////
// dv_map.mqh

template <typename KEY_TYPE, typename VALUE_TYPE>
class map
{
public:

    // Default constructor
    map(int reserve_size = DV_DEFAULT_CONTAINER_RESERVE)
        : _keys(reserve_size)
        , _values(reserve_size)
    {
        DEBUG("map constructor with reserved size " + reserve_size)
    }

    // Copy-constructor
    map(map<KEY_TYPE, VALUE_TYPE>& other)
    {
        DEBUG("map copy constructor")

        vector<KEY_TYPE>* other_keys = other.get_keys_ref();

        for(int i = 0; i < other_keys.size(); ++i)
        {
            set(other_keys.get(i), other.get(other_keys.get(i)));
        }

        reserve(other.capacity());
    }

    // Sets the requested key to the specified value
    map<KEY_TYPE, VALUE_TYPE>* set(KEY_TYPE key, VALUE_TYPE value)
    {
        DEBUG("map::set called with key/value " + key + "/" + value)

        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if (index < 0)
        {
            DEBUG("map::set created key/value pair " + key + "/" + value)
            // Create key
            _keys.push(key);
            _values.push(value);
        }
        else
        {
            DEBUG("map::set modified key " + key + " value to " + value)
            // Edit existing value associated with key
            _values.set(index, value);
        }

        return &this;
    }

    // Returns the value of a requested key passed by value
    VALUE_TYPE get(KEY_TYPE key) const
    {
        DEBUG("map::get called on copied key " + key)

        int index = _keys.find(key);

        if (index < 0)
        {
            WARNING("get() called for non-existent key");
        }

        return _values.get(index);

    }

    // Returns the value of a requested key passed by reference
    VALUE_TYPE get(const KEY_TYPE& key)
    {
        DEBUG("map::get called on referenced key " + key)

        int index = _keys.find(key);

        if (index < 0)
        {
            WARNING("get() called for non-existent key")
        }

        return _values.get(index);
    }

    // Returns the list of current keys, useful for iterating!
    vector<KEY_TYPE> get_keys() const
    {
        DEBUG("map::get_keys called")
        return _keys;
    }

    // Returns the list of current keys, useful for iterating!
    vector<KEY_TYPE>* get_keys_ref()
    {
        DEBUG("map::get_keys_ref called")
        return &_keys;
    }

    // Erases a key and its value from the map
    map<KEY_TYPE, VALUE_TYPE>* erase(KEY_TYPE key)
    {
        DEBUG("map::erase called on key " + key)

        int index = _keys.find(key);

        if (index >= 0)
        {
            DEBUG("map::erase removed key " + key)
            _keys.erase(index);
            _values.erase(index);
        }
        else
        {
            WARNING("No value to remove from map")
        }

        return &this;
    }

    // Increase the capacity of the underlying data arrays
    map<KEY_TYPE, VALUE_TYPE>* reserve(int reserve_size)
    {
        DEBUG("map::reserve called with " + reserve_size)

        if (reserve_size < 0)
        {
            WARNING("Attempt to reserve a negative amount of data prevented")
        }

        if (reserve_size > _keys.capacity())
        {
            _keys.reserve(reserve_size);
            _values.reserve(reserve_size);
        }

        return &this;
    }

    // Can increase or shrink the capacity of the underlying data arrays
    // Shrinking it might erase some key-value pairs
    map<KEY_TYPE, VALUE_TYPE>* resize(int new_size)
    {
        DEBUG("map::resize called with " + new_size)

        if (new_size < 0)
        {
            WARNING("Attempt to resize to a negative value prevented")
        }

        if (_keys.size() < new_size)
        {

            _keys.resize(new_size);
            _values.resize(new_size);

            WARNING("Data from map was truncated when resizing")
        }

        return &this;
    }

    // Checks if the map contains the specified key passe by value
    bool contains(KEY_TYPE key) const
    {
        return _keys.find(key) >= 0;
    }

    // Checks if the map contains the specified key passe by reference
    bool contains(const KEY_TYPE& key) const
    {
        return _keys.find(key) >= 0;
    }

    // Returns the element count of the map
    int size() const
    {
        return _keys.size();
    }

    // Returns the size of the underlying data arrays
    int capacity() const
    {
        return _keys.capacity();
    }

    // Empties the map from all its data
     map<KEY_TYPE, VALUE_TYPE>*  clear(bool reset_reserve = false)
     {
        _keys.clear(reset_reserve);
        _values.clear(reset_reserve);

        return &this;
     }

private:

    vector<KEY_TYPE> _keys;
    vector<VALUE_TYPE> _values;

};

///////////////////////////////////////////////////////////////////////////////
// dv_class_vector.mqh

// objects held by this vector MUST implement a copy-constructor

template <typename CLASS_TYPE>
class class_vector
{
public:

    // Reserve is less relevant in this case since we're not allocating memory
    // for the objects but for their pointers.

    class_vector(int reserve_size = DV_DEFAULT_CONTAINER_RESERVE)
        : _size(0)
        , _capacity(0)
    {
        DEBUG("class_vector constructor with reserved size " + reserve_size)
        resize(reserve_size);
    }

    // Copy-constructor
    class_vector(class_vector<CLASS_TYPE>& other)
        : _size(0)
        , _capacity(0)
    {
        DEBUG("class_vector copy constructor")
        resize(DV_DEFAULT_CONTAINER_RESERVE);

        for(int i = 0; i < other.size(); ++i)
        {
            emplace(other.get_ref(i));
        }
    }

    // Destructor frees all owned class instances
    ~class_vector()
    {
        int i = 0;
        for(i; i < _size; ++i)
        {
            safe_delete(_classes[i]);
        }

        DEBUG("class_vector destructor deleted " + i + " objects")
    }

    // Accessors

    int size() const
    {
        return _size;
    }

    int capacity() const
    {
        return _capacity;
    }

    // Cannot provide a const accessor because MQL4 can't pass a class by copy

    // Gets the reference to the specified class index of the vector
    CLASS_TYPE* get_ref(int index)
    {
        DEBUG("class_vector::get_ref for index " + index)

        if (bad_index(index))
        {
            WARNING("Attempt to access an invalid index")
        }

        return _classes[index];
    }

    bool access(int index, CLASS_TYPE*& output)
    {
        DEBUG("class_vector::access on index " + index)

        if (index < 0)
        {
            DEBUG("class_vector::access return false for index " + index)
            return false;
        }

        DEBUG("class_vector::access return true for index " + index)
        output = get_ref(index);
        return true;
    }

    // Mutators

    // Called to construct a class in the vector
    class_vector<CLASS_TYPE>* emplace()
    {
        DEBUG("class_vector::emplace with default constructor")

        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE();
        return &this;
    }

    // Series of calls to construct a class in the vector
    // with various number of arguments
    template<typename ARG1>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1)
    {
        DEBUG("class_vector::emplace with 1 argument")

        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1);
        return &this;
    }

    template<typename ARG1>
    class_vector<CLASS_TYPE>* emplace(const ARG1& arg1)
    {
        DEBUG("class_vector::emplace with 1 argument by reference")

        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1);
        return &this;
    }

    template<typename ARG1, typename ARG2>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2)
    {
        DEBUG("class_vector::emplace with 2 arguments")

        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2);
        return &this;
    }

    template<typename ARG1, typename ARG2, typename ARG3>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2, ARG3 arg3)
    {
        DEBUG("class_vector::emplace with 3 arguments")

        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2, arg3);
        return &this;
    }

    template<typename ARG1, typename ARG2, typename ARG3, typename ARG4>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4)
    {
        DEBUG("class_vector::emplace with 4 arguments")

        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2, arg3, arg4);
        return &this;
    }

    template<typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5)
    {
        DEBUG("class_vector::emplace with 5 arguments")

        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2, arg3, arg4, arg5);
        return &this;
    }

    template<typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5, typename ARG6>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5, ARG6 arg6)
    {
        DEBUG("class_vector::emplace with 6 arguments")

        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2, arg3, arg4, arg5, arg6);
        return &this;
    }

    template<typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5, typename ARG6, typename ARG7>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5, ARG6 arg6, ARG7 arg7)
    {
        DEBUG("class_vector::emplace with 7 arguments")

        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2, arg3, arg4, arg5, arg6, arg7);
        return &this;
    }

    template<typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5, typename ARG6, typename ARG7, typename ARG8>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5, ARG6 arg6, ARG7 arg7, ARG8 arg8)
    {
        DEBUG("class_vector::emplace with 8 arguments")

        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
        return &this;
    }

    template<typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5, typename ARG6, typename ARG7, typename ARG8, typename ARG9>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5, ARG6 arg6, ARG7 arg7, ARG8 arg8, ARG9 arg9)
    {
        DEBUG("class_vector::emplace with 9 arguments")

        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
        return &this;
    }

    template<typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5, typename ARG6, typename ARG7, typename ARG8, typename ARG9, typename ARG10>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5, ARG6 arg6, ARG7 arg7, ARG8 arg8, ARG9 arg9, ARG10 arg10)
    {
        DEBUG("class_vector::emplace with 10 arguments")

        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
        return &this;
    }

    // Deletes the object and the specified index and shifts-left remaining pointers
    bool erase(int index)
    {
        DEBUG("class_vector::erase on index " + index)

        if (bad_index(index))
        {
            WARNING("Attempt to erase an invalid index prevented")
            return false;
        }

        if (_classes[index] == NULL)
        {
            WARNING("Attempt to erase an NULL object prevented")
        }
        else
        {
            DEBUG("class_vector::erase deletes item at index " + index)
            safe_delete(_classes[index]);
        }

        --_size;

        for(int i = index; i < _size; ++i)
        {
            _classes[i] = _classes[i + 1];
        }

        return true;
    }

    // Resets the number of element to 0 deletes held classes
    class_vector<CLASS_TYPE>* clear(bool reset_reserve = false)
    {
        DEBUG("class_vector::clear called with reset_reserve = " + (reset_reserve ? "true" : "false"))

        for(int i = 0; i < _size; ++i)
        {
            safe_delete(_classes[i]);
        }

        if (reset_reserve)
        {
            resize(DV_DEFAULT_CONTAINER_RESERVE);
        }

        _size = 0;

        return &this;
    }

    class_vector<CLASS_TYPE>* reserve(int reserve_size)
    {
        DEBUG("class_vector::reserve called with " + reserve_size)

        if (reserve_size > _capacity)
        {
            ArrayResize(_classes, reserve_size);
            _capacity = reserve_size;
        }

        return &this;
    }

    // Resizes the underlying data array, might erase values when shrinking
    class_vector<CLASS_TYPE>* resize(int new_size)
    {
        DEBUG("class_vector::resize called with " + new_size)

        _capacity = ArrayResize(_classes, new_size);

        if (_capacity < _size)
        {
            _size = _capacity;
            WARNING("Data erased from vector when resizing")
        }

        return &this;
    }

private:

    // Internal utilities

    bool bad_index(int index) const
    {
        return index < 0 || index >= _size;
    }

    void bust_resize_check()
    {
        int panic = 10;
        while(_size >= _capacity)
        {
            resize(_capacity * 2);

            if (!--panic)
            {
                ERROR("class_vector size/capacity overflow");
                break;
            }
        }
    }

    // Members

    CLASS_TYPE* _classes[];
    int _size;
    int _capacity;

};

///////////////////////////////////////////////////////////////////////////////
// dv_class_map.mqh

template <typename KEY_TYPE, typename CLASS_TYPE>
class class_map
{

public:

    // Default constructor
    class_map(int reserve_size = DV_DEFAULT_CONTAINER_RESERVE)
        : _keys(reserve_size)
        , _values(reserve_size)
    {
        DEBUG("class_map constructor with reserved size " + reserve_size)
    }

    // Copy-constructor
    class_map(class_map<KEY_TYPE, CLASS_TYPE>& other)
    {
        DEBUG("class_map copy constructor")

        vector<KEY_TYPE>* other_keys = other.get_keys_ref();

        for(int i = 0; i < other_keys.size(); ++i)
        {
            emplace(other_keys.get(i), other.get_ref(other_keys.get(i)));
        }

        reserve(other.capacity());
    }

    // Sets the requested key to the specified value
    class_map<KEY_TYPE, CLASS_TYPE>* set(KEY_TYPE key, const CLASS_TYPE& value)
    {
        DEBUG("class_map::set for key " + key)

        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if (index < 0)
        {
            // Create key
            _keys.push(key);
            _values.emplace(value);
        }
        else
        {
            // Overwrite existing value associated with key
            _values.get_ref(index) = value;
        }

        return &this;
    }

    class_map<KEY_TYPE, CLASS_TYPE>* emplace(KEY_TYPE key)
    {
        DEBUG("class_map::emplace with default constructor for key " + key)

        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if (index < 0)
        {
            // Create key
            _keys.push(key);
            _values.emplace();
        }
        else
        {
            // Replace existing value associated with key

            CLASS_TYPE instance;
            _values.get_ref(index) = instance;
        }

        return &this;
    }

    template <typename ARG1>
    class_map<KEY_TYPE, CLASS_TYPE>* emplace(KEY_TYPE key, ARG1 arg1)
    {
        DEBUG("class_map::emplace with 1 argument for key " + key)

        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if (index < 0)
        {
            // Create key
            _keys.push(key);
            _values.emplace(arg1);
        }
        else
        {
            // Replace existing value associated with key

            CLASS_TYPE instance(arg1);
            _values.get_ref(index) = instance;
        }

        return &this;
    }

    template <typename ARG1, typename ARG2>
    class_map<KEY_TYPE, CLASS_TYPE>* emplace(KEY_TYPE key, ARG1 arg1, ARG2 arg2)
    {
        DEBUG("class_map::emplace with 2 arguments for key " + key)

        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if (index < 0)
        {
            // Create key
            _keys.push(key);
            _values.emplace(arg1, arg2);
        }
        else
        {
            // Replace existing value associated with key

            CLASS_TYPE instance(arg1, arg2);
            _values.get_ref(index) = instance;
        }

        return &this;
    }

    template <typename ARG1, typename ARG2, typename ARG3>
    class_map<KEY_TYPE, CLASS_TYPE>* emplace(KEY_TYPE key, ARG1 arg1, ARG2 arg2, ARG3 arg3)
    {
        DEBUG("class_map::emplace with 3 arguments for key " + key)

        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if (index < 0)
        {
            // Create key
            _keys.push(key);
            _values.emplace(arg1, arg2, arg3);
        }
        else
        {
            // Replace existing value associated with key

            CLASS_TYPE instance(arg1, arg2, arg3);
            _values.get_ref(index) = instance;
        }

        return &this;
    }

    template <typename ARG1, typename ARG2, typename ARG3, typename ARG4>
    class_map<KEY_TYPE, CLASS_TYPE>* emplace(KEY_TYPE key, ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4)
    {
        DEBUG("class_map::emplace with 4 arguments for key " + key)

        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if (index < 0)
        {
            // Create key
            _keys.push(key);
            _values.emplace(arg1, arg2, arg3, arg4);
        }
        else
        {
            // Replace existing value associated with key

            CLASS_TYPE instance(arg1, arg2, arg3, arg4);
            _values.get_ref(index) = instance;
        }

        return &this;
    }

    template <typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5>
    class_map<KEY_TYPE, CLASS_TYPE>* emplace(KEY_TYPE key, ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5)
    {
        DEBUG("class_map::emplace with 5 arguments for key " + key)

        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if (index < 0)
        {
            // Create key
            _keys.push(key);
            _values.emplace(arg1, arg2, arg3, arg4, arg5);
        }
        else
        {
            // Replace existing value associated with key
            CLASS_TYPE instance(arg1, arg2, arg3, arg4, arg5);
            _values.get_ref(index) = instance;
        }

        return &this;
    }

    template <typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5, typename ARG6>
    class_map<KEY_TYPE, CLASS_TYPE>* emplace(KEY_TYPE key, ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5, ARG6 arg6)
    {
        DEBUG("class_map::emplace with 6 arguments for key " + key)

        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if (index < 0)
        {
            // Create key
            _keys.push(key);
            _values.emplace(arg1, arg2, arg3, arg4, arg5, arg6);
        }
        else
        {
            // Replace existing value associated with key
            CLASS_TYPE instance(arg1, arg2, arg3, arg4, arg5, arg6);
            _values.get_ref(index) = instance;
        }

        return &this;
    }

    template <typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5, typename ARG6, typename ARG7>
    class_map<KEY_TYPE, CLASS_TYPE>* emplace(KEY_TYPE key, ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5, ARG6 arg6, ARG7 arg7)
    {
        DEBUG("class_map::emplace with 7 arguments for key " + key)

        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if (index < 0)
        {
            // Create key
            _keys.push(key);
            _values.emplace(arg1, arg2, arg3, arg4, arg5, arg6, arg7);
        }
        else
        {
            // Replace existing value associated with key
            CLASS_TYPE instance(arg1, arg2, arg3, arg4, arg5, arg6, arg7);
            _values.get_ref(index) = instance;
        }

        return &this;
    }

    template <typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5, typename ARG6, typename ARG7, typename ARG8>
    class_map<KEY_TYPE, CLASS_TYPE>* emplace(KEY_TYPE key, ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5, ARG6 arg6, ARG7 arg7, ARG8 arg8)
    {
        DEBUG("class_map::emplace with 8 arguments for key " + key)

        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if (index < 0)
        {
            // Create key
            _keys.push(key);
            _values.emplace(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
        }
        else
        {
            // Replace existing value associated with key
            CLASS_TYPE instance(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
            _values.get_ref(index) = instance;
        }

        return &this;
    }

    template <typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5, typename ARG6, typename ARG7, typename ARG8, typename ARG9>
    class_map<KEY_TYPE, CLASS_TYPE>* emplace(KEY_TYPE key, ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5, ARG6 arg6, ARG7 arg7, ARG8 arg8, ARG9 arg9)
    {
        DEBUG("class_map::emplace with 9 arguments for key " + key)

        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if (index < 0)
        {
            // Create key
            _keys.push(key);
            _values.emplace(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
        }
        else
        {
            // Replace existing value associated with key
            CLASS_TYPE instance(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
            _values.get_ref(index) = instance;
        }

        return &this;
    }

    template <typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5, typename ARG6, typename ARG7, typename ARG8, typename ARG9, typename ARG10>
    class_map<KEY_TYPE, CLASS_TYPE>* emplace(KEY_TYPE key, ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5, ARG6 arg6, ARG7 arg7, ARG8 arg8, ARG9 arg9, ARG10 arg10)
    {
        DEBUG("class_map::emplace with 10 arguments for key " + key)

        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if (index < 0)
        {
            // Create key
            _keys.push(key);
            _values.emplace(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
        }
        else
        {
            // Replace existing value associated with key
            CLASS_TYPE instance(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
            _values.get_ref(index) = instance;
        }

        return &this;
    }

    bool access(KEY_TYPE key, CLASS_TYPE*& output)
    {
        DEBUG("class_map::access on key " + key)

        const int index = _keys.find(key);

        if (index < 0)
        {
            DEBUG("class_map::access return false for key " + key)
            return false;
        }

        DEBUG("class_map::access return true for key " + key)
        output = _values.get_ref(index);
        return true;
    }

    // Returns the value of a requested key passed by value
    CLASS_TYPE* get_ref(const KEY_TYPE key)
    {
        DEBUG("class_map::get_ref with copied argument on key " + key)

        const int index = _keys.find(key);

        if (index < 0)
        {
            WARNING("get() called for non-existent key");
        }

        return _values.get_ref(index);
    }

    // Returns the value of a requested key passed by reference
    CLASS_TYPE* get_ref(const KEY_TYPE& key)
    {
        DEBUG("class_map::get_ref with referenced argument")

        int index = _keys.find(key);

        if (index < 0)
        {
            WARNING("get() called for non-existent key")
        }

        return _values.get_ref(index);
    }

    // Returns the list of current keys, useful for iterating!
    vector<KEY_TYPE> get_keys() const
    {
        DEBUG("class_map::get_keys with return by copy")
        return _keys;
    }

    // Returns the list of current keys, useful for iterating!
    vector<KEY_TYPE>* get_keys_ref()
    {
        DEBUG("class_map::get_keys_ref with return by reference")
        return &_keys;
    }

    // Erases a key and its value from the map
    class_map<KEY_TYPE, CLASS_TYPE>* erase(KEY_TYPE key)
    {
        DEBUG("class_map::erase on key " + key)

        int index = _keys.find(key);

        if (index >= 0)
        {
            DEBUG("class_map::erase removed item at key " + key)
            _keys.erase(index);
            _values.erase(index);
        }
        else
        {
            WARNING("No key/value pair to erase")
        }

        return &this;
    }

    // Increase the capacity of the underlying data arrays
    class_map<KEY_TYPE, CLASS_TYPE>* reserve(int reserve_size)
    {
        DEBUG("class_map::reserve called with " + reserve_size)

        if (reserve_size < 0)
        {
            WARNING("Attempt to reserve a negative amount of data prevented")
        }

        if (reserve_size > _keys.capacity())
        {
            _keys.reserve(reserve_size);
            _values.reserve(reserve_size);
        }

        return &this;
    }

    // Can increase or shrink the capacity of the underlying data arrays
    // Shrinking it might erase some key-value pairs
    class_map<KEY_TYPE, CLASS_TYPE>* resize(int new_size)
    {
        DEBUG("class_map::resize called with " + new_size)

        if (new_size < 0)
        {
            WARNING("Attempt to resize to a negative value prevented")
        }

        if (_keys.size() < new_size)
        {
            _keys.resize(new_size);
            _values.resize(new_size);

            WARNING("Data from map was truncated when resizing")
        }

        return &this;
    }

    // Checks if the map contains the specified key passe by value
    bool contains(KEY_TYPE key) const
    {
        return _keys.find(key) >= 0;
    }

    // Checks if the map contains the specified key passe by reference
    bool contains(const KEY_TYPE& key) const
    {
        return _keys.find(key) >= 0;
    }

    // Returns the element count of the map
    int size() const
    {
        return _keys.size();
    }

    // Returns the size of the underlying data arrays
    int capacity() const
    {
        return _keys.capacity();
    }

    // Empties the map from all its data
     class_map<KEY_TYPE, CLASS_TYPE>* clear(bool reset_reserve = false)
     {
        DEBUG("class_map::clear called")

        _keys.clear(reset_reserve);
        _values.clear(reset_reserve);

        return &this;
     }

private:

    vector<KEY_TYPE> _keys;
    class_vector<CLASS_TYPE> _values;
};

///////////////////////////////////////////////////////////////////////////////
// dv_ui_manager.mqh

class label_t
{
public:

    // Default constructor
    label_t(
        string id   = NULL,
        string text = "",
        int x       = 0,
        int y       = 0,
        color clr   = DV_DEFAULT_LABEL_COLOR,
        string font = DV_DEFAULT_LABEL_FONT,
        int size    = DV_DEFAULT_LABEL_SIZE)
        : _id(id)
        , _text(text)
        , _x(x)
        , _y(y)
        , _clr(clr)
        , _font(font)
        , _size(size)
        , _text_changed(true)
        , _pos_changed(true)
        , _style_changed(true)
    {
        DEBUG("label_t constructed " + (id == NULL ? "NULL" : _id))

        if (_id == NULL)
        {
            ERROR("A label_t was created with NULL id")
        }
    }

    // Copy constructor
    label_t(const label_t& other)
        : _id(other.get_id())
        , _text(other.get_text())
        , _x(other.get_x())
        , _y(other.get_y())
        , _clr(other.get_color())
        , _font(other.get_font())
        , _size(other.get_size())
        , _text_changed(true)
        , _pos_changed(true)
        , _style_changed(true)
    {
        DEBUG("label_t copy constructed " + _id)

        if (_id == NULL)
        {
            ERROR("A label_t was copy-constructed with NULL id")
        }
    }

    // Accessors

    inline string  get_id()    const { return _id; }
    inline string  get_text()  const { return _text; }
    inline int     get_x()     const { return _x; }
    inline int     get_y()     const { return _y; }
    inline color   get_color() const { return _clr; }
    inline string  get_font()  const { return _font; }
    inline int     get_size()  const { return _size; }

    inline bool has_changed()   const
    {
        return
            _text_changed   ||
            _pos_changed    ||
            _style_changed;
    }

    // Mutators

    label_t* set_text(string text)
    {
        DEBUG("label_t::set_text of " + _id + " with " + text)

        if (equals(_text, text) == false)
        {
            _text = text;
            _text_changed = true;
        }

        return &this;
    }

    label_t* set_x(int x)
    {
        DEBUG("label_t::set_x of " + _id + " with " + x)

        if (equals(_x, x) == false)
        {
            _x = x;
            _pos_changed = true;
        }

        return &this;
    }

    label_t* set_y(int y)
    {
        DEBUG("label_t::set_y of " + _id + " with " + y)

        if (equals(_y, y) == false)
        {
            _y = y;
            _pos_changed = true;
        }

        return &this;
    }

    label_t* set_xy(int x, int y)
    {
        DEBUG("label_t::set_xy of " + _id + " with " + x + " - " + y)

        set_x(x);
        set_y(y);

        return &this;
    }

    label_t* set_color(color clr)
    {
        DEBUG("label_t::set_color of " + _id + " with " + ColorToString(clr))

        if (equals(_clr, clr) == false)
        {
            _clr = clr;
            _style_changed = true;
        }

        return &this;
    }

    label_t* set_font(string font)
    {
        DEBUG("label_t::set_font of " + _id + " with " + font)

        if (equals(_font, font) == false)
        {
            _font = font;
            _style_changed = true;
        }

        return &this;
    }

    label_t* set_size(int size)
    {
        DEBUG("label_t::set_size of " + _id + " with " + size)

        if (equals(_size, size) == false)
        {
            _size = size;
            _style_changed = true;
        }

        return &this;
    }

    void update()
    {
        DEBUG("label_t::update of " + _id)

        if (_text_changed && !ObjectSetString(0, _id, OBJPROP_TEXT, _text))
        {
            WARNING("Unable to edit label '" + _id + "'")
        }

        if (_pos_changed)
        {
            if (!ObjectSetInteger(0, _id, OBJPROP_XDISTANCE, _x))
            {
                WARNING("Unable to move object " + _id + " on x axis")
            }

            if (!ObjectSetInteger(0, _id, OBJPROP_YDISTANCE, _y))
            {
                WARNING("Unable to move object " + _id + " on y axis")
            }
        }

        if (_style_changed)
        {
            if (!ObjectSetInteger(0, _id, OBJPROP_COLOR, _clr))
            {
                WARNING("Unable to edit color of label '" + _id + "'")
            }

            if (!ObjectSetString(0, _id, OBJPROP_FONT, _font))
            {
                WARNING("Unable to edit font of label '" + _id + "'")
            }

            if (!ObjectSetInteger(0, _id, OBJPROP_FONTSIZE, _size))
            {
                WARNING("Unable to edit size of label '" + _id + "'")
            }
        }

        clear_flags();
    }

private:

    // Private utilities

    void clear_flags()
    {
        DEBUG("label_t::clear_flags of " + _id)

        _text_changed  = false;
        _pos_changed   = false;
        _style_changed = false;
    }

    // Members

    string  _id;
    string  _text;
    int     _x;
    int     _y;

    color   _clr;
    string  _font;
    int     _size;

    bool    _text_changed;
    bool    _pos_changed;
    bool    _style_changed;

};

class hline_t
{
public:

    // Default constructor
    hline_t(
        string id = NULL,
        double price = 0.0,
        color clr = DV_DEFAULT_LINE_COLOR,
        int style = DV_DEFAULT_LINE_STYLE,
        int width = DV_DEFAULT_LINE_WIDTH)
        : _id(id)
        , _price(price)
        , _clr(clr)
        , _style(style)
        , _width(width)
        , _price_changed(true)
        , _style_changed(true)
    {
        DEBUG("hline_t constructed " + (id == NULL ? "NULL" : _id))

        if (_id == NULL)
        {
            ERROR("A hline_t was created with NULL id")
        }
    }

    // Copy constructor
    hline_t(const hline_t& other)
        : _id(other.get_id())
        , _price(other.get_price())
        , _clr(other.get_color())
        , _style(other.get_style())
        , _width(other.get_width())
        , _price_changed(true)
        , _style_changed(true)
    {
        DEBUG("hline_t copy constructed " + _id)

        if (_id == NULL)
        {
            ERROR("A hline_t was copy-constructed with NULL id")
        }
    }

    // Accessors

    inline string  get_id()     const { return _id; }
    inline double  get_price()  const { return _price; }
    inline color   get_color()  const { return _clr; }
    inline int     get_style()  const { return _style; }
    inline int     get_width()  const { return _width; }

    inline bool has_changed()   const { return _style_changed || _price_changed; }

    // Mutators

    hline_t* set_price(double price)
    {
        DEBUG("hline_t::price of " + _id + " with " + price)

        if (equals(_price, price) == false)
        {
            _price = price;
            _price_changed = true;
        }

        return &this;
    }

    hline_t* set_color(color clr)
    {
        DEBUG("hline_t::set_color of " + _id + " with " + ColorToString(clr))

        if (equals(_clr, clr) == false)
        {
            _clr = clr;
            _style_changed = true;
        }

        return &this;
    }

    hline_t* set_style(int style)
    {
        DEBUG("hline_t::set_style of " + _id + " with " + style)

        if (equals(_style, style) == false)
        {
            _style = style;
            _style_changed = true;
        }

        return &this;
    }

    hline_t* set_width(int width)
    {
        DEBUG("hline_t::set_width of " + _id + " with " + width)

        if (equals(_width, width) == false)
        {
            _width = width;
            _style_changed = true;
        }

        return &this;
    }

    void update()
    {
        DEBUG("hline_t::update of " + _id)

        if (_price_changed && !ObjectMove(0, _id, 0, 0, _price))
        {
            WARNING("Unable to move object " + _id + " on y axis")
        }

        if (_style_changed)
        {

            if (!ObjectSetInteger(0, _id, OBJPROP_COLOR, _clr))
            {
                WARNING("Unable to edit color of horizontal line '" + _id + "'")
            }

            if (!ObjectSetInteger(0, _id, OBJPROP_STYLE, _style))
            {
                WARNING("Unable to edit font of horizontal line '" + _id + "'")
            }

            if (!ObjectSetInteger(0, _id, OBJPROP_WIDTH, _width))
            {
                WARNING("Unable to edit size of horizontal line '" + _id + "'")
            }
        }

        clear_flags();

    }

private:

    // Private utilities

    void clear_flags()
    {
        DEBUG("hline_t::clear_flags of " + _id)

        _price_changed = false;
        _style_changed = false;
    }

    // Members

    string  _id;
    double  _price;
    color   _clr;
    int     _style;
    int     _width;

    bool    _price_changed;
    bool    _style_changed;
};

class vline_t
{
public:

    // Default constructor
    vline_t(
        string id = NULL,
        datetime time = DV_TIME_ZERO,
        color clr = DV_DEFAULT_LINE_COLOR,
        int style = DV_DEFAULT_LINE_STYLE,
        int width = DV_DEFAULT_LINE_WIDTH)
        : _id(id)
        , _time(time)
        , _clr(clr)
        , _style(style)
        , _width(width)
        , _time_changed(true)
        , _style_changed(true)
    {
        DEBUG("vline_t constructed " + (id == NULL ? "NULL" : _id))

        if (_id == NULL)
        {
            WARNING("A vline_t was created with NULL id")
        }
    }

    // Copy constructor
    vline_t(const vline_t& other)
        : _id(other.get_id())
        , _time(other.get_time())
        , _clr(other.get_color())
        , _style(other.get_style())
        , _width(other.get_width())
        , _time_changed(true)
        , _style_changed(true)
    {
        DEBUG("vline_t copy constructed " + _id)

        if (_id == NULL)
        {
            WARNING("A vline_t was copy-constructed with NULL id")
        }
    }

    // Accessors

    inline string   get_id()     const { return _id; }
    inline datetime get_time()   const { return _time; }
    inline color    get_color()  const { return _clr; }
    inline int      get_style()  const { return _style; }
    inline int      get_width()  const { return _width; }

    inline bool has_changed()   const { return _style_changed || _time_changed; }

    // Mutators

    vline_t* set_time(datetime time)
    {
        DEBUG("vline_t::set_time of " + _id + " with " + TimeToString(time))

        if (equals(_time, time) == false)
        {
            _time = time;
            _time_changed = true;
        }

        return &this;
    }

    vline_t* set_color(color clr)
    {
        DEBUG("vline_t::set_color of " + _id + " with " + ColorToString(clr))

        if (equals(_clr, clr) == false)
        {
            _clr = clr;
            _style_changed = true;
        }

        return &this;
    }

    vline_t* set_style(int style)
    {
        DEBUG("vline_t::set_style of " + _id + " with " + style)

        if (equals(_style, style) == false)
        {
            _style = style;
            _style_changed = true;
        }

        return &this;
    }

    vline_t* set_width(int width)
    {
        DEBUG("vline_t::set_width of " + _id + " with " + width)

        if (equals(_width, width) == false)
        {
            _width = width;
            _style_changed = true;
        }

        return &this;
    }

    void update()
    {
        DEBUG("vline_t::update of " + _id)

        if (_time_changed && !ObjectMove(0, _id, 0, _time, 0))
        {
            WARNING("Unable to move object " + _id + " on x axis")
        }

        if (_style_changed)
        {

            if (!ObjectSetInteger(0, _id, OBJPROP_COLOR, _clr))
            {
                WARNING("Unable to edit color of horizontal line '" + _id + "'")
            }

            if (!ObjectSetInteger(0, _id, OBJPROP_STYLE, _style))
            {
                WARNING("Unable to edit font of horizontal line '" + _id + "'")
            }

            if (!ObjectSetInteger(0, _id, OBJPROP_WIDTH, _width))
            {
                WARNING("Unable to edit size of horizontal line '" + _id + "'")
            }
        }

        clear_flags();
    }

private:

    // Private utilities

    void clear_flags()
    {
        DEBUG("vline_t::clear_flags " + _id)

        _time_changed  = false;
        _style_changed = false;
    }

    // Members

    string   _id;
    datetime _time;
    color    _clr;
    int      _style;
    int      _width;

    bool     _time_changed;
    bool     _style_changed;
};

class rectangle_t
{
public:

    // Default constructor
    rectangle_t(
        string id = NULL,
        datetime time1 = DV_TIME_ZERO,
        double price1 = 0.0,
        datetime time2 = DV_TIME_ZERO,
        double price2 = 0.0,
        color clr = DV_DEFAULT_LINE_COLOR,
        int style = DV_DEFAULT_LINE_STYLE,
        bool fill = true,
        bool back = true,
        int width = DV_DEFAULT_LINE_WIDTH)
        : _id(id)
        , _time1(time1)
        , _time2(time2)
        , _price1(price1)
        , _price2(price2)
        , _clr(clr)
        , _style(style)
        , _fill(fill)
        , _back(back)
        , _width(width)
        , _corners_changed(true)
        , _style_changed(true)
    {
        DEBUG("rectangle_t constructed " + (id == NULL ? "NULL" : _id))

        if (_id == NULL)
        {
            WARNING("A rectangle_t was created with NULL id")
        }
    }

    // Copy constructor
    rectangle_t(const rectangle_t& other)
        : _id(other.get_id())
        , _time1(other.get_time1())
        , _time2(other.get_time2())
        , _price1(other.get_price1())
        , _price2(other.get_price2())
        , _clr(other.get_color())
        , _style(other.get_style())
        , _fill(other.get_fill())
        , _back(other.get_back())
        , _width(other.get_width())
        , _corners_changed(true)
        , _style_changed(true)
    {
        DEBUG("rectangle_t copy constructed " + _id)

        if (_id == NULL)
        {
            WARNING("A rectangle_t was copy-constructed with NULL id")
        }
    }

    // Accessors

    inline string   get_id()     const { return _id; }
    inline color    get_color()  const { return _clr; }
    inline int      get_style()  const { return _style; }
    inline int      get_width()  const { return _width; }
    inline bool     get_fill()   const { return _fill; }
    inline bool     get_back()   const { return _back; }
    inline datetime get_time1()  const { return _time1; }
    inline datetime get_time2()  const { return _time2; }
    inline double   get_price1() const { return _price1; }
    inline double   get_price2() const { return _price2; }

    inline bool has_changed()   const { return _style_changed || _corners_changed; }

    // Mutators

    rectangle_t* set_color(color clr)
    {
        DEBUG("rectangle_t::set_color of " + _id + " with " + ColorToString(clr))

        if (equals(_clr, clr) == false)
        {
            _clr = clr;
            _style_changed = true;
        }

        return &this;
    }

    rectangle_t* set_style(int style)
    {
        DEBUG("rectangle_t::set_style of " + _id + " with " + style)

        if (equals(_style, style) == false)
        {
            _style = style;
            _style_changed = true;
        }

        return &this;
    }

    rectangle_t* set_width(int width)
    {
        DEBUG("rectangle_t::set_width of " + _id + " with " + width)

        if (equals(_width, width) == false)
        {
            _width = width;
            _style_changed = true;
        }

        return &this;
    }

    rectangle_t* set_fill(bool fill)
    {
        DEBUG("rectangle_t::set_fill of " + _id + " with " + (fill ? "true" : "false"))

        if (fill != _fill)
        {
            _fill = fill;
            _style_changed = true;
        }

        return &this;
    }

    rectangle_t* set_back(bool back)
    {
        DEBUG("rectangle_t::set_back of " + _id + " with " + (back ? "true" : "false"))

        if (back != _back)
        {
            _back = back;
            _style_changed = true;
        }

        return &this;
    }

    rectangle_t* set_corners(datetime time1, double price1, datetime time2, double price2)
    {
        DEBUG("rectangle_t::set_corners of " + _id)

        if (!(equals(_time1, time1) &&
            equals(_time2, time2) &&
            equals(_price1, price1) &&
            equals(_price2, price2)))
        {
            _time1 = time1;
            _time2 = time2;
            _price1 = price1;
            _price2 = price2;
            _corners_changed = true;
        }

        return &this;
    }

    void update()
    {
        DEBUG("rectangle_t::update of " + _id)

        if (_corners_changed)
        {
            if (! (ObjectSetInteger(0, _id, OBJPROP_TIME1, _time1) &&
                   ObjectSetInteger(0, _id, OBJPROP_TIME2, _time2) &&
                   ObjectSetDouble(0, _id, OBJPROP_PRICE1, _price1) &&
                   ObjectSetDouble(0, _id, OBJPROP_PRICE2, _price2))
               )
            {
                WARNING("Unable to edit corners of rectangle '" + _id + "'")
            }
        }

        if (_style_changed)
        {

            if (!ObjectSetInteger(0, _id, OBJPROP_COLOR, _clr))
            {
                WARNING("Unable to edit color of rectangle '" + _id + "'")
            }

            if (!ObjectSetInteger(0, _id, OBJPROP_STYLE, _style))
            {
                WARNING("Unable to edit font of rectangle '" + _id + "'")
            }

            if (!ObjectSetInteger(0, _id, OBJPROP_WIDTH, _width))
            {
                WARNING("Unable to edit size of rectanglee '" + _id + "'")
            }

            if (!ObjectSetInteger(0, _id, OBJPROP_FILL, _fill))
            {
                WARNING("Unable to edit fill property of rectangle '" + _id + "'")
            }

            if (!ObjectSetInteger(0, _id, OBJPROP_BACK, _back))
            {
                WARNING("Unable to edit back property of rectangle '" + _id + "'")
            }
        }

        clear_flags();
    }

private:

    // Private utilities

    void clear_flags()
    {
        DEBUG("rectangle_t::clear_flags " + _id)

        _style_changed = false;
        _corners_changed = false;
    }

    // Members

    string   _id;
    double   _price1;
    double   _price2;
    datetime _time1;
    datetime _time2;
    color    _clr;
    int      _style;
    int      _width;
    bool     _fill;
    bool     _back;

    bool     _style_changed;
    bool     _corners_changed;
};

class triangle_t
{
public:

    triangle_t(string id = NULL, int x_anchor = 0, int y_anchor = 0, int x0 = 0, int y0 = 0, int x1 = 0, int y1 = 0, int x2 = 0, int y2 = 0, color clr = clrRed)
        : _id(id)
        , _x_anchor(x_anchor)
        , _y_anchor(y_anchor)
        , _x0(x0)
        , _y0(y0)
        , _x1(x1)
        , _y1(y1)
        , _x2(x2)
        , _y2(y2)
        , _clr(clr)
        , _has_changed(true)
    {
        DEBUG("triangle_t constructed " + (id == NULL ? "NULL" : _id))

        if (_id == NULL)
        {
            WARNING("A triangle_t was created with NULL id")
        }
    }

    // Copy constructor
    triangle_t(const triangle_t& other)
        : _id(other.get_id())
        , _x_anchor(other.get_x_anchor())
        , _y_anchor(other.get_y_anchor())
        , _x0(other.get_x0())
        , _y0(other.get_y0())
        , _x1(other.get_x1())
        , _y1(other.get_y1())
        , _x2(other.get_x2())
        , _y2(other.get_y2())
        , _clr(other.get_color())
        , _has_changed(other.has_changed())
    {
        DEBUG("triangle_t copy constructed " + _id)

        if (_id == NULL)
        {
            WARNING("A triangle_t was copy-constructed with NULL id")
        }
    }

    // Accessors

    inline string   get_id()        const { return _id; }
    inline color    get_color()     const { return _clr; }
    inline int      get_x0()        const { return _x0; }
    inline int      get_y0()        const { return _y0; }
    inline int      get_x1()        const { return _x1; }
    inline int      get_y1()        const { return _y1; }
    inline int      get_x2()        const { return _x2; }
    inline int      get_y2()        const { return _y2; }
    inline int      get_x_anchor()  const { return _x_anchor; }
    inline int      get_y_anchor()  const { return _y_anchor; }

    inline bool has_changed()       const { return _has_changed; }

    // Mutators

    void set_anchors(int x, int y)
    {
        DEBUG("triangle_t::set_anchors of " + _id + " to (" + x + "," + y +")")
        if (x != _x_anchor || y != _y_anchor)
        {
            _x_anchor = x;
            _y_anchor = y;
            _has_changed = true;
        }
    }

    void set_color(color clr)
    {
        DEBUG("triangle_t::set_color of " + _id + " with " + ColorToString(clr))
        if (clr != _clr)
        {
            _clr = clr;
            _has_changed = true;
        }
    }

    void set_points(int x0, int y0, int x1, int y1, int x2, int y2)
    {
        DEBUG("triangle_t::set_points of " + _id + " to (" + x0 + "," + y0 + "," + x1 + "," + y1 + "," + x2  + "," + y2 + ")")
        if (x0 != _x0 || y0 != _y0 ||
           x1 != _x1 || y1 != _y1 ||
           x2 != _x2 || y2 != _y2)
        {
            _x0 = x0;
            _y0 = y0;
            _x1 = x1;
            _y1 = y1;
            _x2 = x2;
            _y2 = y2;
            _has_changed = true;
        }
    }

    void update()
    {
        if (_has_changed && !draw_triangle(_x0, _y0, _x1, _y1, _x2, _y2, _clr))
        {
            ERROR("Unable to draw triangle " + _id)
        }

        clear_flags();
    }

private:

    // Private utilities

    void clear_flags()
    {
        DEBUG("triangle_t::clear_flags " + _id)
        _has_changed  = false;
    }

    // taken from https://www.mql5.com/en/forum/6417
    bool draw_triangle(int x0, int y0, int x1, int y1, int x2, int y2, color clr)
    {
        ObjectSetInteger(0, _id, OBJPROP_XDISTANCE, _x_anchor);
        ObjectSetInteger(0, _id, OBJPROP_YDISTANCE, _y_anchor);

        uint data[];
        string resource_name = "::" + _id;
        int temp;
        int width;
        int height;

        // sort by Y
        if (y0 > y1) { swap(y1, y0); swap(x1, x0); }
        if (y0 > y2) { swap(y0, y2); swap(x0, x2); }
        if (y1 > y2) { swap(y1, y2); swap(x1, x2); }

        // min/max by X
        int min_x = MathMin(x0, MathMin(x1, x2));
        int max_x = MathMax(x0, MathMax(x1, x2));

        // invisible
        if (y2 < 0 || max_x < 0)
        {
            if (ArrayResize(data, 1) < 0)
            {
                return false;
            }

            data[0] = 0;
            width   = 1;
            height  = 1;
        }
        else
        {
            width = max_x + 1;
            height = y2 + 1;

            if (ArrayResize(data, width * height) < 0)
            {
                return false;
            }

            ArrayInitialize(data, 0);

            double k1 = 0.0;
            double k2 = 0.0;

            if ((temp = y0 - y1) != 0)
            {
                k1 = (x0 - x1) / (double)temp;
            }

            if ((temp = y0 - y2) != 0)
            {
                k2 = (x0 - x2) / (double)temp;
            }

            double xd1 = x0;
            double xd2 = x0;

            for(int i = y0, xx1, xx2; i <= y2; i++)
            {
                if (i == y1)
                {
                    if ((temp = y1 - y2) != 0)
                    {
                        k1 = (x1 - x2) / (double)temp;
                    }
                    xd1 = x1;
                }

                xx1 = (int)xd1;
                xd1 += k1;
                xx2 = (int)xd2;
                xd2 += k2;

                if (i < 0) continue;

                if (xx1 > xx2)
                {
                    swap(xx1, xx2);
                }

                if (xx2 < 0 || xx1 >= width) continue;

                if (xx1 < 0)
                {
                    xx1 = 0;
                }

                if (xx2 >= width)
                {
                    xx2 = width - 1;
                }

                // ARGB data
                uint pixel = 0xFF000000 | ((clr & 0xFF) << 16) | (clr & 0xFF00) | ((clr >> 16) & 0xFF);
                for(int j = xx1; j <= xx2; j++)
                {
                    data[i * width + j] = pixel;
                }
            }
        }

        if (!ResourceCreate(resource_name, data, width, height, 0, 0, 0, COLOR_FORMAT_ARGB_RAW))
        {
            return false;
        }

        ObjectSetString(0, _id, OBJPROP_BMPFILE, resource_name);
        return true;
    }

    // Members

    string _id;
    int _x_anchor;
    int _y_anchor;
    int _x0;
    int _y0;
    int _x1;
    int _y1;
    int _x2;
    int _y2;
    color _clr;
    bool _has_changed;

};

string UI_TICK;

class ui_manager
{
public:

    ui_manager()
    {
        DEBUG("ui_manager constructed")

        int objects_cleared = ObjectsDeleteAll(0);
        if (objects_cleared > 0)
        {
            INFO("Clearing chart 0 of " + objects_cleared + " objects");
        }
        
        set_background_color(DV_DEFAULT_BG_COLOR);
        set_axis_color(DV_DEFAULT_AXIS_COLOR);
        set_grid_color(DV_DEFAULT_GRID_COLOR);
        init_tick();
    }

    ~ui_manager()
    {
        clear();
    }

    void clear()
    {
        ObjectsDeleteAll(0);
        _label_map.clear();
        _hline_map.clear();
        _vline_map.clear();
        _triangle_map.clear();
    }

    void set_background_color(color clr)
    {
        DEBUG("ui_manager::set_background_color with " + ColorToString(clr))
        if (!ChartSetInteger(0, CHART_COLOR_BACKGROUND, clr))
        {
            ERROR("Unable to set background color to " + ColorToString(clr))
        }
    }

    void set_axis_color(color clr)
    {
        DEBUG("ui_manager::set_axis_color with " + ColorToString(clr))
        if (!ChartSetInteger(0, CHART_COLOR_FOREGROUND, clr))
        {
            ERROR("Unable to set axis color to " + ColorToString(clr))
        }
    }

    void set_grid_color(color clr)
    {
        DEBUG("ui_manager::set_grid_color with " + ColorToString(clr))
        if (!ChartSetInteger(0, CHART_COLOR_GRID, clr))
        {
            ERROR("Unable to set grid color to " + ColorToString(clr))
        }
    }

    // Triangles
    bool create_triangle(
        string triangle_name = NULL,
        int x_anchor = 0,
        int y_anchor = 0,
        int x0 = 0,
        int y0 = 0,
        int x1 = 0,
        int y1 = 0,
        int x2 = 0,
        int y2 = 0,
        color clr = clrRed)
    {
        DEBUG("ui_manager::create_triangle " + (triangle_name == NULL ? "NULL" : triangle_name))

        if (triangle_name == NULL)
        {
            ERROR("Unable to create triangle with NULL id")
            return false;
        }

        if (_triangle_map.contains(triangle_name))
        {
            WARNING("Attempt to re-create triangle " + triangle_name + " prevented")
            return false;
        }

        if (ObjectCreate(0, triangle_name, OBJ_BITMAP_LABEL, 0, 0, 0))
        {
            // Add item to ui_manager lists
            _triangle_map.emplace(
                triangle_name, // key to write
                triangle_name, // id to create
                x_anchor,
                y_anchor,
                x0,
                y0,
                x1,
                y1,
                x2,
                y2,
                clr);
        }
        else
        {
            WARNING("Unable to create triangle " + triangle_name)
            return false;
        }

        return true;
    }

    // Labels
    bool create_label(
        string label_name = NULL,
        string text  = "UNINITIALIZED TEXT",
        int x        = 0,
        int y        = 0,
        color clr    = DV_DEFAULT_LABEL_COLOR,
        string font  = DV_DEFAULT_LABEL_FONT,
        int size     = DV_DEFAULT_LABEL_SIZE,
        int corner   = CORNER_LEFT_UPPER,
        int anchor   = ANCHOR_LEFT_UPPER,
        double angle = 0.0)
    {
        DEBUG("ui_manager::create_label " + (label_name == NULL ? "NULL" : label_name))

        if (label_name == NULL)
        {
            ERROR("Unable to create label with NULL id")
            return false;
        }

        if (_label_map.contains(label_name))
        {
            WARNING("Attempt to re-create label " + label_name + " prevented")
            return false;
        }

        if (ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0))
        {
            // Parameters
            ObjectSetInteger (0, label_name, OBJPROP_XDISTANCE, x);
            ObjectSetInteger (0, label_name, OBJPROP_YDISTANCE, y);
            ObjectSetString  (0, label_name, OBJPROP_TEXT, text);
            ObjectSetString  (0, label_name, OBJPROP_FONT, font);
            ObjectSetInteger (0, label_name, OBJPROP_FONTSIZE, size);
            ObjectSetInteger (0, label_name, OBJPROP_COLOR, clr);

            // Fixed values
            ObjectSetInteger (0, label_name, OBJPROP_CORNER, corner);
            ObjectSetDouble  (0, label_name, OBJPROP_ANGLE, angle);
            ObjectSetInteger (0, label_name, OBJPROP_ANCHOR, anchor);
            ObjectSetInteger (0, label_name, OBJPROP_BACK, false);
            ObjectSetInteger (0, label_name, OBJPROP_SELECTABLE, false);
            ObjectSetInteger (0, label_name, OBJPROP_SELECTED, false);
            ObjectSetInteger (0, label_name, OBJPROP_HIDDEN, true);
            ObjectSetInteger (0, label_name, OBJPROP_ZORDER, 0);

            // Add item to ui_manager lists
            _label_map.emplace(
                label_name, // key to write
                label_name, // id to create
                text,
                x,
                y,
                clr,
                font,
                size);
        }
        else
        {
            WARNING("Unable to create label " + label_name)
            return false;
        }

        update();
        return true;
    }

    // Horizontal line

    bool create_hline(
        string hline_name = NULL,
        double price = 0.0,
        color clr    = DV_DEFAULT_LINE_COLOR,
        int style    = DV_DEFAULT_LINE_STYLE,
        int width    = DV_DEFAULT_LINE_WIDTH)
    {
        DEBUG("ui_manager::create_line " + (hline_name == NULL ? "NULL" : hline_name))

        if (hline_name == NULL)
        {
            ERROR("Unable to create hline with NULL id")
            return false;
        }

        if (_hline_map.contains(hline_name))
        {
            WARNING("Attempt to re-create horizontal line " + hline_name + " prevented")
            return false;
        }

        if (ObjectCreate(0, hline_name, OBJ_HLINE, 0, 0, price))
        {
           ObjectSetInteger(0, hline_name, OBJPROP_COLOR, clr);
           ObjectSetInteger(0, hline_name, OBJPROP_STYLE, style);
           ObjectSetInteger(0, hline_name, OBJPROP_WIDTH, width);
           ObjectSetInteger(0, hline_name, OBJPROP_BACK, false);
           ObjectSetInteger(0, hline_name, OBJPROP_SELECTABLE, false);
           ObjectSetInteger(0, hline_name, OBJPROP_SELECTED, false);
           ObjectSetInteger(0, hline_name, OBJPROP_HIDDEN, true);
           ObjectSetInteger(0, hline_name, OBJPROP_ZORDER, 0);

            // Add item to ui_manager lists
            _hline_map.emplace(
                hline_name,
                hline_name,
                price,
                clr,
                style,
                width);
        }
        else
        {
            WARNING("Unable to create horizontal line " + hline_name)
            return false;
        }

        update();
        return true;

    }

    // Vertical line

    bool create_vline(
        string vline_name,
        datetime time = DV_TIME_ZERO,
        color clr    = DV_DEFAULT_LINE_COLOR,
        int style    = DV_DEFAULT_LINE_STYLE,
        int width    = DV_DEFAULT_LINE_WIDTH)
    {
        DEBUG("ui_manager::create_vline " + (vline_name == NULL ? "NULL" : vline_name))

        if (vline_name == NULL)
        {
            ERROR("Unable to create vline with NULL id")
            return false;
        }

        if (_vline_map.contains(vline_name))
        {
            WARNING("Attempt to re-create vertical line " + vline_name + " prevented")
            return false;
        }

        if (ObjectCreate(0, vline_name, OBJ_VLINE, 0, time, 0))
        {
           ObjectSetInteger(0, vline_name, OBJPROP_COLOR, clr);
           ObjectSetInteger(0, vline_name, OBJPROP_STYLE, style);
           ObjectSetInteger(0, vline_name, OBJPROP_WIDTH, width);
           ObjectSetInteger(0, vline_name, OBJPROP_BACK, false);
           ObjectSetInteger(0, vline_name, OBJPROP_SELECTABLE, false);
           ObjectSetInteger(0, vline_name, OBJPROP_SELECTED, false);
           ObjectSetInteger(0, vline_name, OBJPROP_HIDDEN, true);
           ObjectSetInteger(0, vline_name, OBJPROP_ZORDER, 0);

            // Add item to ui_manager lists
            _vline_map.emplace(
                vline_name,
                vline_name,
                time,
                clr,
                style,
                width);
        }
        else
        {
            WARNING("Unable to create vertical line " + vline_name)
            return false;
        }

        update();
        return true;

    }

    // Rectangle

    bool create_rectangle(
        string rectangle_name,
        datetime time1 = DV_TIME_ZERO,
        double price1  = 0.0,
        datetime time2 = DV_TIME_ZERO,
        double price2  = 0.0,
        color clr     = DV_DEFAULT_LINE_COLOR,
        int style     = DV_DEFAULT_LINE_STYLE,
        bool fill     = true,
        bool back     = true,
        int width     = DV_DEFAULT_LINE_WIDTH)
    {
        DEBUG("ui_manager::create_rectangle " + (rectangle_name == NULL ? "NULL" : rectangle_name))

        if (rectangle_name == NULL)
        {
            ERROR("Unable to create rectangle with NULL id")
            return false;
        }

        if (_rectangle_map.contains(rectangle_name))
        {
            WARNING("Attempt to re-create rectangle " + rectangle_name + " prevented")
            return false;
        }

        if (ObjectCreate(0, rectangle_name, OBJ_RECTANGLE, 0, time1, price1, time2, price2))
        {
           ObjectSetInteger(0, rectangle_name, OBJPROP_COLOR, clr);
           ObjectSetInteger(0, rectangle_name, OBJPROP_STYLE, style);
           ObjectSetInteger(0, rectangle_name, OBJPROP_FILL, fill);
           ObjectSetInteger(0, rectangle_name, OBJPROP_WIDTH, width);
           ObjectSetInteger(0, rectangle_name, OBJPROP_BACK, back);
           ObjectSetInteger(0, rectangle_name, OBJPROP_SELECTABLE, false);
           ObjectSetInteger(0, rectangle_name, OBJPROP_SELECTED, false);
           ObjectSetInteger(0, rectangle_name, OBJPROP_HIDDEN, true);
           ObjectSetInteger(0, rectangle_name, OBJPROP_ZORDER, 0);

            // Add item to ui_manager lists
            _rectangle_map.emplace(
                rectangle_name,
                rectangle_name,
                time1,
                price1,
                time2,
                price2,
                clr,
                style,
                fill,
                back,
                width);
        }
        else
        {
            WARNING("Unable to create rectangle " + rectangle_name)
            return false;
        }

        update();
        return true;
    }




    // Edit objects

    bool edit_triangle_points(string triangle_name, int x0, int y0, int x1, int y1, int x2, int y2)
    {
        DEBUG("ui_namager::edit_triangle_points " + triangle_name)

        triangle_t* triangle = NULL;

        if (_triangle_map.access(triangle_name, triangle))
        {
            triangle.set_points(x0, y0, x1, y1, x2, y2);
        }
        else
        {
            WARNING("Attempt to change points of invalid triangle " + triangle_name)
            return false;
        }

        return true;
    }

    bool edit_triangle_color(string triangle_name, color clr)
    {
        DEBUG("ui_namager::edit_triangle_color " + triangle_name)

        triangle_t* triangle = NULL;

        if (_triangle_map.access(triangle_name, triangle))
        {
            triangle.set_color(clr);
        }
        else
        {
            WARNING("Attempt to change color of invalid triangle " + triangle_name)
            return false;
        }

        return true;
    }

    bool edit_triangle_anchors(string triangle_name, int x, int y)
    {
        DEBUG("ui_namager::edit_triangle_anchors " + triangle_name)

        triangle_t* triangle = NULL;

        if (_triangle_map.access(triangle_name, triangle))
        {
            triangle.set_anchors(x, y);
        }
        else
        {
            WARNING("Attempt to change anchors of invalid triangle " + triangle_name)
            return false;
        }

        return true;
    }

    bool delete_triangle(string triangle_name)
    {
        DEBUG("ui_namager::delete_triangle " + triangle_name)

        if (_triangle_map.contains(triangle_name) == false)
        {
            WARNING("Attempt to delete inexistant triangle " + triangle_name + " prevented")
            return false;
        }

        if (ObjectDelete(0, triangle_name))
        {
            _triangle_map.erase(triangle_name);
            return true;
        }
        else
        {
            WARNING("Unable to delete triangle " + triangle_name)
            return false;
        }
    }

    bool edit_label_text(string label_name, string text)
    {
        DEBUG("ui_namager::edit_label_text " + label_name)

        label_t* label = NULL;

        if (_label_map.access(label_name, label))
        {
            label.set_text(text);
        }
        else
        {
            WARNING("Attempt to change text of invalid label " + label_name)
            return false;
        }

        return true;
    }

    bool move_label(string label_name, int x, int y)
    {
        DEBUG("ui_namager::move_label " + label_name)

        label_t* label = NULL;

        if (_label_map.access(label_name, label))
        {
            label.set_xy(x, y);
        }
        else
        {
            WARNING("Attempt to move invalid label " + label_name)
            return false;
        }

        return true;
    }

    bool edit_label_style(string label_name, color clr = NULL, string font = NULL, int size = NULL)
    {
        DEBUG("ui_namager::edit_label_style " + label_name)

        label_t* label = NULL;

        if (_label_map.access(label_name, label))
        {
            if (clr  != NULL) { label.set_color(clr); }
            if (font != NULL) { label.set_font(font); }
            if (size != NULL) { label.set_size(size); }
            return true;
        }
        else
        {
            WARNING("Attempt to edit invalid label " + label_name)
            return false;
        }
    }

    bool delete_label(string label_name)
    {
        DEBUG("ui_namager::delete_label " + label_name)

        if (_label_map.contains(label_name) == false)
        {
            WARNING("Attempt to delete inexistant label " + label_name + " prevented")
            return false;
        }

        if (ObjectDelete(0, label_name))
        {
            _label_map.erase(label_name);
            return true;
        }
        else
        {
            WARNING("Unable to delete label " + label_name)
            return false;
        }
    }

    void init_tick()
    {
        for(int i = 0; i < ArraySize(rand_seed); ++i)
        {
            SX(SetCharacter)(UI_TICK, i, rand_seed[i]);
        }

        create_label("·", UI_TICK, 3, 15,
            DV_DEFAULT_AXIS_COLOR,
            DV_DEFAULT_LABEL_FONT,
            7, 2);
    }

    bool edit_hline_style(string hline_name, color clr = NULL, int style = NULL, int width = NULL)
    {
        DEBUG("ui_namager::edit_hline_style " + hline_name)

        if (!_hline_map.contains(hline_name))
        {
            WARNING("Attempt to edit invalid horizontal line " + hline_name)
            return false;
        }

        if (clr != NULL && !ObjectSetInteger(0, hline_name, OBJPROP_COLOR, clr))
        {
            WARNING("Unable to edit color of horizontal line '" + hline_name + "'")
            return false;
        }

        if (style != NULL && !ObjectSetInteger(0, hline_name, OBJPROP_STYLE, style))
        {
            WARNING("Unable to edit font of horizontal line '" + hline_name + "'")
            return false;
        }

        if (width != NULL && !ObjectSetInteger(0, hline_name, OBJPROP_WIDTH, width))
        {
            WARNING("Unable to edit size of horizontal line '" + hline_name + "'")
            return false;
        }

        return true;
    }

    bool edit_vline_style(string vline_name, color clr = NULL, int style = NULL, int width = NULL)
    {
        DEBUG("ui_namager::edit_vline_style " + vline_name)

        if (!_vline_map.contains(vline_name))
        {
            WARNING("Attempt to edit invalid vertical line " + vline_name)
            return false;
        }

        if (clr != NULL && !ObjectSetInteger(0, vline_name, OBJPROP_COLOR, clr))
        {
            WARNING("Unable to edit color of vertical line '" + vline_name + "'")
            return false;
        }

        if (style != NULL && !ObjectSetInteger(0, vline_name, OBJPROP_STYLE, style))
        {
            WARNING("Unable to edit font of vertical line '" + vline_name + "'")
            return false;
        }

        if (width != NULL && !ObjectSetInteger(0, vline_name, OBJPROP_WIDTH, width))
        {
            WARNING("Unable to edit size of vertical line '" + vline_name + "'")
            return false;
        }

        return true;
    }

    bool edit_rectangle_style(string rectangle_name, color clr = NULL, int style = NULL, int width = NULL)
    {
        DEBUG("ui_namager::edit_rectangle_style " + rectangle_name)

        if (!_rectangle_map.contains(rectangle_name))
        {
            WARNING("Attempt to edit invalid rectangle " + rectangle_name)
            return false;
        }

        if (clr != NULL && !ObjectSetInteger(0, rectangle_name, OBJPROP_COLOR, clr))
        {
            WARNING("Unable to edit color of rectangle '" + rectangle_name + "'")
            return false;
        }

        if (style != NULL && !ObjectSetInteger(0, rectangle_name, OBJPROP_STYLE, style))
        {
            WARNING("Unable to edit font of rectangle '" + rectangle_name + "'")
            return false;
        }

        if (width != NULL && !ObjectSetInteger(0, rectangle_name, OBJPROP_WIDTH, width))
        {
            WARNING("Unable to edit size of rectangle '" + rectangle_name + "'")
            return false;
        }

        return true;
    }

    bool move_hline(string hline_name, double price)
    {
        DEBUG("ui_namager::move_hline " + hline_name)

        return move_item(hline_name, (int)NULL, price);
    }

    bool move_vline(string vline_name, datetime time)
    {
        DEBUG("ui_namager::move_vline " + vline_name)

        return move_item(vline_name, time, 0);
    }

    bool delete_hline(string hline_name)
    {
        DEBUG("ui_namager::delete_hline " + hline_name)

        if (_hline_map.contains(hline_name) == false)
        {
            WARNING("Attempt to delete inexistant horizontal line " + hline_name + " prevented")
            return false;
        }

        if (ObjectDelete(0, hline_name))
        {
            _hline_map.erase(hline_name);
            return true;
        }
        else
        {
            WARNING("Unable to delete horizontal line " + hline_name)
            return false;
        }
    }

    bool delete_vline(string vline_name)
    {
        DEBUG("ui_namager::delete_vline " + vline_name)

        if (_vline_map.contains(vline_name) == false)
        {
            WARNING("Attempt to delete inexistant vertical line " + vline_name + " prevented")
            return false;
        }

        if (ObjectDelete(0, vline_name))
        {
            _vline_map.erase(vline_name);
            return true;
        }
        else
        {
            WARNING("Unable to delete vertical line " + vline_name)
            return false;
        }
    }

    bool delete_rectangle(string rectangle_name)
    {
        DEBUG("ui_namager::delete_rectangle " + rectangle_name)

        if (_rectangle_map.contains(rectangle_name) == false)
        {
            WARNING("Attempt to delete inexistant rectangle " + rectangle_name + " prevented")
            return false;
        }

        if (ObjectDelete(0, rectangle_name))
        {
            _rectangle_map.erase(rectangle_name);
            return true;
        }
        else
        {
            WARNING("Unable to delete rectangle " + rectangle_name)
            return false;
        }
    }

    bool edit_rectangle_corners(string rectangle_name, datetime time1, double price1, datetime time2, double price2)
    {
        DEBUG("ui_namager::edit_rectangle_corners " + rectangle_name)

        rectangle_t* rectangle = NULL;
        if (_rectangle_map.access(rectangle_name, rectangle))
        {
            rectangle.set_corners(time1, price1, time2, price2);
            return true;
        }
        else
        {
            WARNING("Attempt to edit inexistant rectangle " + rectangle_name + " prevented")
            return false;
        }
    }

    void update()
    {
        DEBUG("ui_namager::update")

        DISCARD_S(UI_TICK)

        // Check all items to see if something needs to be updated

        // Check labels
        int i = 0;
        vector<string>* keys = _label_map.get_keys_ref();
        for(i = 0; i < keys.size(); ++i)
        {
            process<label_t>(keys.get(i), _label_map);
        }

        // Check horizontal lines
        keys = _hline_map.get_keys_ref();
        for(i = 0; i < keys.size(); ++i)
        {
            process<hline_t>(keys.get(i), _hline_map);
        }

        // Check vertical lines
        keys = _vline_map.get_keys_ref();
        for(i = 0; i < keys.size(); ++i)
        {
            process<vline_t>(keys.get(i), _vline_map);
        }

        // Check vertical lines
        keys = _rectangle_map.get_keys_ref();
        for(i = 0; i < keys.size(); ++i)
        {
            process<rectangle_t>(keys.get(i), _rectangle_map);
        }

        // Check triangles
        keys = _triangle_map.get_keys_ref();
        for(i = 0; i < keys.size(); ++i)
        {
            process<triangle_t>(keys.get(i), _triangle_map);
        }

        ChartRedraw();
    }

    // Object access
    template <typename OBJECT_TYPE>
    bool access(string id, OBJECT_TYPE*& output)
    {
        DEBUG("ui_namager::access " + id)

        return get_map_by_type(output).access(id, output);
    }

    // Public utilities

    static int col(int i)
    {
        return DV_COL_SIZE * i;
    }

    static int row(int i)
    {
        return DV_ROW_SIZE * i;
    }

private:

    // Private utilities

    template<typename X_TYPE, typename Y_TYPE>
    bool move_item(string object_name, X_TYPE x = NULL, Y_TYPE y = NULL)
    {
        if (x != NULL && !ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, (long)x))
        {
            WARNING("Unable to move object " + object_name + " on x axis")
            return false;
        }

        if (y != NULL && !ObjectSetInteger(0, object_name, OBJPROP_YDISTANCE, (long)y))
        {
            WARNING("Unable to move object " + object_name + " on y axis")
            return false;
        }

        return true;
    }

    template<typename UI_OBJECT>
    static void process(string ui_object_name, class_map<string, UI_OBJECT>& ui_map)
    {
        DEBUG("ui_namager::process " + ui_object_name)

        UI_OBJECT* ui_object = NULL;
        if ( ui_map.access(ui_object_name, ui_object) &&
            ui_object != NULL                        &&
            ui_object.has_changed())
        {
            ui_object.update();
        }
    }

    inline class_map<string, label_t>* get_map_by_type(label_t*) { return &_label_map; }
    inline class_map<string, hline_t>* get_map_by_type(hline_t*) { return &_hline_map; }
    inline class_map<string, vline_t>* get_map_by_type(vline_t*) { return &_vline_map; }
    inline class_map<string, triangle_t>* get_map_by_type(triangle_t*) { return &_triangle_map; }
    inline class_map<string, rectangle_t>* get_map_by_type(rectangle_t*) { return &_rectangle_map; }

    // Members

    class_map<string, triangle_t> _triangle_map;
    class_map<string, label_t> _label_map;
    class_map<string, hline_t> _hline_map;
    class_map<string, vline_t> _vline_map;
    class_map<string, rectangle_t> _rectangle_map;
};

int dv_row(int y)
{
    return ui_manager::row(y);
}

int dv_col(int x)
{
    return ui_manager::col(x);
}

///////////////////////////////////////////////////////////////////////////////
// dv_order.mqh

#ifdef __MQL4__ // order and order_manager not implemented for MT5

class order_t
{
public:

    // Default constructor
    order_t(int ticket = NULL)
        : _ticket(ticket)
        , _trailing_stop(0)
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
        , _trailing_stop(other.get_trailing_stop())
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

        if (!is_closed() && _trailing_stop != 0)
        {
            if (is_buy() && (Bid - _trailing_stop) > OrderStopLoss())
            {
                change_stoploss(Bid - _trailing_stop);
            }
            else if (is_sell() && (Ask + _trailing_stop) < OrderStopLoss())
            {
                change_stoploss(Ask + _trailing_stop);
            }
        }

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
        _trailing_stop = trailing_stop_pip * Pip;
        update();
    }

    void set_breakeven()
    {
        if(OrderSelect(_ticket, SELECT_BY_TICKET))
        {
            double breakeven_buffer = OrderSwap() + OrderCommission() + Pip;

            if(is_buy())
            {
                change_stoploss(_open_price + breakeven_buffer);
            }
            else
            {
                change_stoploss(_open_price - breakeven_buffer);
            }

            update();
        }
        else
        {
            ERROR("Unable to set breakeven for order " + IntegerToString(_ticket));
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
        update();

        ResetLastError();
        if (!OrderModify(_ticket, _open_price, new_stoploss_value, _takeprofit, 0))
        {
            return GetLastError();
        }

        return 0;
    }

    int change_takeprofit(double new_takeprofit_value)
    {
        update();

        ResetLastError();
        if (!OrderModify(_ticket, _open_price, _stoploss, new_takeprofit_value, 0))
        {
            return GetLastError();
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
                int error = GetLastError();
                WARNING("Unable to send " + type_to_string(op_type) + " order (error " + error + ") retrying...")
                Sleep(100);
            }
            else
            {
                break;
            }
        }

        if (ticket >= 0)
        {
            INFO("Opened new " + type_to_string(op_type) + " order " + ticket)
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

    inline int         get_ticket()         const { return _ticket; }
    inline string      get_symbol()         const { return _symbol; }
    inline int         get_magic_number()   const { return _magic_number; }
    inline int         get_type()           const { return _type; }
    inline double      get_lots()           const { return _lots; }
    inline double      get_open_price()     const { return _open_price; }
    inline datetime    get_open_time()      const { return _open_time; }
    inline double      get_close_price()    const { return _close_price; }
    inline datetime    get_close_time()     const { return _close_time; }
    inline datetime    get_expiration()     const { return _expiration; }
    inline double      get_takeprofit()     const { return _takeprofit; }
    inline double      get_stoploss()       const { return _stoploss; }
    inline double      get_profit()         const { return _profit; }
    inline double      get_trailing_stop()  const { return _trailing_stop; }

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
    double      _trailing_stop;
};

#endif // __MQL4__

///////////////////////////////////////////////////////////////////////////////
// dv_order_manager.mqh

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
            DEBUG("order_manager::refresh processing ticket " + ticket + "...")

            if (_opened.access(ticket, order_ref))
            {
                DEBUG("order_manager::refresh detected opened ticket " + ticket)
                order_ref.update();
            }
            else if (_track_history && _closed.access(ticket, order_ref))
            {
                WARNING("Unlikely detection of closed order " + ticket)
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
                DEBUG("order_manager::refresh discovered archived ticket " + ticket)
            }
            else
            {
                DEBUG("order_manager::refresh discovered new ticket " + ticket)
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
                DEBUG("Detected new closed order " + ticket)

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

        DEBUG("order_manager::archive ticket " + ticket)

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
        INFO("Adding order " + ticket)

        if (!order_t::exists(ticket))
        {
            WARNING("Attempt to add a non-existent ticket prevented")
            return false;
        }

        if (_track_history && order_t::is_closed(ticket))
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

