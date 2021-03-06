#include "dv_common.mqh"

#ifndef DV_CLASS_VECTOR_H
#define DV_CLASS_VECTOR_H

//@START@
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

//@END@
#endif // DV_CLASS_VECTOR_H