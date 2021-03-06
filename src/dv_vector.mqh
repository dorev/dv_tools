#include "dv_common.mqh"

#ifndef DV_VECTOR_H
#define DV_VECTOR_H

//@START@
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

//@END@
#endif // DV_VECTOR_H