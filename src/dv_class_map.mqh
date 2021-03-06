#include "dv_common.mqh"
#include "dv_vector.mqh"
#include "dv_class_vector.mqh"

#ifndef DV_CLASS_MAP_H
#define DV_CLASS_MAP_H

//@START@
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

//@END@
#endif // DV_CLASS_MAP_H