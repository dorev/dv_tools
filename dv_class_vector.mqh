#include "dv_common.mqh"

#ifndef DV_CLASS_VECTOR_H
#define DV_CLASS_VECTOR_H

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
        resize(reserve_size);
    }

    // Copy-constructor
    class_vector(class_vector<CLASS_TYPE>& other)
        : _size(0)
        , _capacity(0)
    {
        resize(DV_DEFAULT_CONTAINER_RESERVE);

        for(int i = 0; i < other.size(); ++i)
        {
            emplace(other.get_ref(i));
        }
    }

    // Destructor frees all owned class instances
    ~class_vector()
    {
        for(int i = 0; i < _size; ++i)
        {
            safe_delete(_classes[i]);
        }
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
        if(bad_index(index))
        {
            WARNING("Attempt to access an invalid index")
        }

        return _classes[index];
    }

    // Mutators

    // Called to construct a class in the vector
    class_vector<CLASS_TYPE>* emplace()
    {
        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE();
        return &this;
    }

    // Series of calls to construct a class in the vector
    // with various number of arguments
    template<typename ARG1>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1)
    {
        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1);
        return &this;
    }

    template<typename ARG1>
    class_vector<CLASS_TYPE>* emplace(const ARG1& arg1)
    {
        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1);
        return &this;
    }

    template<typename ARG1, typename ARG2>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2)
    {
        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2);
        return &this;
    }

    template<typename ARG1, typename ARG2, typename ARG3>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2, ARG3 arg3)
    {
        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2, arg3);
        return &this;
    }

    template<typename ARG1, typename ARG2, typename ARG3, typename ARG4>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4)
    {
        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2, arg3, arg4);
        return &this;
    }

    template<typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5)
    {
        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2, arg3, arg4, arg5);
        return &this;
    }

    template<typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5, typename ARG6>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5, ARG6 arg6)
    {
        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2, arg3, arg4, arg5, arg6);
        return &this;
    }

    template<typename ARG1, typename ARG2, typename ARG3, typename ARG4, typename ARG5, typename ARG6, typename ARG7>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1, ARG2 arg2, ARG3 arg3, ARG4 arg4, ARG5 arg5, ARG6 arg6, ARG7 arg7)
    {
        bust_resize_check();
        _classes[_size++] = new CLASS_TYPE(arg1, arg2, arg3, arg4, arg5, arg6, arg7);
        return &this;
    }

    // Deletes the object and the specified index and shifts-left remaining pointers
    bool erase(int index)
    {
        if(bad_index(index))
        {
            WARNING("Attempt to erase an invalid index prevented")
            return false;
        }

        if(_classes[index] == NULL)
        {
            WARNING("Attempt to erase an NULL object prevented")
        }
        else
        {
            // Destroy & deallocate class
            safe_delete(_classes[index]);
        }

        --_size;

        for(int i = index; i < _size; ++i)
        {
            _classes[i] = _classes[i + 1];
        }

        //_classes[_size + 1] = NULL;

        return true;
    }

    // Resets the number of element to 0 deletes held classes
    class_vector<CLASS_TYPE>* clear(bool reset_reserve = false)
    {
        _size = 0;

        for(int i = 0; i < _size; ++i)
        {
            safe_delete(_classes[i]);
        }

        if(reset_reserve)
        {
            resize(DV_DEFAULT_CONTAINER_RESERVE);
        }

        return &this;
    }

    class_vector<CLASS_TYPE>* reserve(int new_size)
    {
        if(new_size > _capacity)
        {
            ArrayResize(_classes, new_size);
            _capacity = new_size;
        }

        return &this;
    }

    // Resizes the underlying data array, might erase values when shrinking
    class_vector<CLASS_TYPE>* resize(int new_size)
    {
        _capacity = ArrayResize(_classes, new_size);

        if(_capacity < _size)
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

            if(!--panic)
            {
                WARNING("CRITICAL : class_vector size/capacity overflow");
                break;
            }
        }
    }

    // Members

    CLASS_TYPE* _classes[];
    int _size;
    int _capacity;

};

#endif // DV_CLASS_VECTOR_H