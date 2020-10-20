#include "dv_common.mqh"
#include "dv_vector.mqh"
#include "dv_class_vector.mqh"

#ifndef DV_CLASS_MAP_H
#define DV_CLASS_MAP_H

template <typename KEY_TYPE, typename CLASS_TYPE>
class class_map
{

public:

    // Default constructor
    class_map(int reserve_size = DV_DEFAULT_CONTAINER_RESERVE)
        : _keys(reserve_size)
        , _values(reserve_size)
    {}

    // Copy-constructor
    class_map(class_map<KEY_TYPE, CLASS_TYPE>& other)
    {
        vector<KEY_TYPE> other_keys = other.keys();
        
        for(int i = 0; i < other_keys.size(); ++i)
        {
            KEY_TYPE key = other_keys.get(i);
            set(other_keys.get(i), other.get_ref(key));
        }
        
        reserve(other.capacity());
    }
    
    // Sets the requested key to the specified value
    class_map<KEY_TYPE, CLASS_TYPE>* set(KEY_TYPE key, const CLASS_TYPE& value)
    {
        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if(index < 0)
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
        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if(index < 0)
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
        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if(index < 0)
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
        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if(index < 0)
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
        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if(index < 0)
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
        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if(index < 0)
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
        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if(index < 0)
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
        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if(index < 0)
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
        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if(index < 0)
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
    
    // Series of calls to construct a class in the vector
    // with various number of arguments
    template<typename ARG1>
    class_vector<CLASS_TYPE>* emplace(ARG1 arg1)
    {
        if(_size == _capacity)
        {
            resize(_capacity + 1);
        }
        
        _classes[_size++] = new CLASS_TYPE(arg1);
        
        return &this;
    }
    
    bool access(KEY_TYPE key, CLASS_TYPE*& output)
    {
        const int index = _keys.find(key);

        if(index < 0)
        {
            return false;
        }
        
        output = _values.get_ref(index);
        return true;
    }
    
    
    // Returns the value of a requested key passed by value
    CLASS_TYPE* get_ref(KEY_TYPE key)
    {
        const int index = _keys.find(key);

        if(index < 0)
        {
            WARNING("get() called for non-existent key");
        }
        
        return _values.get_ref(index);        
    }
    
    // Returns the value of a requested key passed by reference
    CLASS_TYPE* get_ref(const KEY_TYPE& key)
    {
        int index = _keys.find(key);

        if(index < 0)
        {
            WARNING("get() called for non-existent key")
        }
            
        return _values.get_ref(index);        
    }  
    
    // Returns the list of current keys, useful for iterating!
    vector<KEY_TYPE> keys() const
    {
        return _keys;
    }
    
    // Returns the list of current keys, useful for iterating!
    vector<KEY_TYPE>* keys_ref()
    {
        return &_keys;
    }
    
    // Erases a key and its value from the map
    class_map<KEY_TYPE, CLASS_TYPE>* erase(KEY_TYPE key)
    {
        int index = _keys.find(key);
        
        if(index >= 0)
        {
            _keys.erase(index);
            _values.erase(index);
        }
    
        return &this;
    }
    
    // Increase the capacity of the underlying data arrays
    class_map<KEY_TYPE, CLASS_TYPE>* reserve(int reserve_size)
    {
        if(reserve_size < 0)
        {
            WARNING("Attempt to reserve a negative amount of data prevented")
        }
        
        if(reserve_size > _keys.capacity())
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
        if(new_size < 0)
        {
            WARNING("Attempt to resize to a negative value prevented")
        }
        
        if(_keys.size() < new_size)
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
        _keys.clear(reset_reserve);
        _values.clear(reset_reserve);
        
        return &this;
     }    
    
private:

    vector<KEY_TYPE> _keys;
    class_vector<CLASS_TYPE> _values;
};

#endif // DV_CLASS_MAP_H