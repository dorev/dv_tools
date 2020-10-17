#include "dv_common.mqh"
#include "dv_vector.mqh"

#ifndef DV_MAP_H
#define DV_MAP_H

template <typename KEY_TYPE, typename VALUE_TYPE>
class map
{
public:

    // Default constructor
    map(int reserve_size = DV_DEFAULT_CONTAINER_RESERVE)
        : _keys(reserve_size)
        , _values(reserve_size)
    {}

    // Copy-constructor
    map(const map<KEY_TYPE, VALUE_TYPE>& other)
    {
        vector<KEY_TYPE> other_keys = other.keys();
        
        for(int i = 0; i < other_keys.size(); ++i)
        {
            set(other_keys.get(i), other.get(other_keys.get(i)));
        }
        
        reserve(other.capacity());
    }
    
    // Sets the requested key to the specified value
    map<KEY_TYPE, VALUE_TYPE>* set(KEY_TYPE key, VALUE_TYPE value)
    {
        int index = _keys.find(key);

        // If the key can't be looked up, create it
        if(index < 0)
        {
            // Create key
            _keys.push(key);
            _values.push(value);
        }
        else
        {
            // Edit existing value associated with key
            _values.set(index, value);
        }
        
        return &this;
    }
    
    // Returns the value of a requested key passed by value
    VALUE_TYPE get(KEY_TYPE key) const
    {
        int index = _keys.find(key);

        if(index < 0)
        {
            DV_WARNING("get() called for non-existent key");
        }
        
        return _values.get(index);        
    }
    
    // Returns the value of a requested key passed by reference
    VALUE_TYPE get(const KEY_TYPE& key)
    {
        int index = _keys.find(key);

        if(index < 0)
        {
            DV_WARNING("get() called for non-existent key")
        }
            
        return _values.get(index);
    }
    
    // Returns the list of current keys, useful for iterating!
    vector<KEY_TYPE> keys()const
    {
        return _keys;
    }
    
    // Erases a key and its value from the map
    map<KEY_TYPE, VALUE_TYPE>* erase(KEY_TYPE key)
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
    map<KEY_TYPE, VALUE_TYPE>* reserve(int reserve_size)
    {
        if(reserve_size < 0)
        {
            DV_WARNING("Attempt to reserve a negative amount of data prevented")
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
    map<KEY_TYPE, VALUE_TYPE>* resize(int new_size)
    {
        if(new_size < 0)
        {
            DV_WARNING("Attempt to resize to a negative value prevented")
        }
        
        if(_keys.size() < new_size)
        {            
            _keys.resize(new_size);
            _values.resize(new_size);
            
            DV_WARNING("Data from map was truncated when resizing")
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

#endif // DV_MAP_H