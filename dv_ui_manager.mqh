#include "dv_common.mqh"
#include "dv_class_map.mqh"

#ifndef DV_UI_MANAGER_H
#define DV_UI_MANAGER_H

class ui_label
{
public:
    
    // Default constructor
    ui_label(
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
        if(_id == NULL)
        {
            DV_WARNING("A ui_label was created with NULL id")
        }
    }
    
    // Copy constructor
    ui_label(const ui_label& other)
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
        if(_id == NULL)
        {
            DV_WARNING("A ui_label was copy-constructed with NULL id")
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
    
    ui_label* set_text(string text)
    {
        if(equals(_text, text) == false)
        {
            _text = text;
            _text_changed = true;
        }
        
        return &this;
    }
    
    ui_label* set_x(int x)
    {
        if(equals(_x, x) == false)
        {
            _x = x;
            _pos_changed = true;
        }
        
        return &this;
    }
    
    ui_label* set_y(int y)
    {
        if(equals(_y, y) == false)
        {
            _y = y;
            _pos_changed = true;
        }
        
        return &this;
    }
    
    ui_label* set_xy(int x, int y)
    {
        set_x(x);
        set_y(y);
        
        return &this;
    }
    
    ui_label* set_color(color clr)
    {
        if(equals(_clr, clr) == false)
        {
            _clr = clr;
            _style_changed = true;
        }
        
        return &this;
    }
    
    ui_label* set_font(string font)
    {
        if(equals(_font, font) == false)
        {
            _font = font;
            _style_changed = true;
        }
        
        return &this;
    }
    
    ui_label* set_size(int size)
    {
        if(equals(_size, size) == false)
        {
            _size = size;
            _style_changed = true;
        }
        
        return &this;
    }
    
    void update()
    {
        if(_text_changed && !ObjectSetString(0, _id, OBJPROP_TEXT, _text))
        {
            DV_WARNING("Unable to edit label '" + _id + "'")
        }
        
        if(_pos_changed)
        {        
            if(!ObjectSetInteger(0, _id, OBJPROP_XDISTANCE, _x))
            {
                DV_WARNING("Unable to move object " + _id + " on x axis")
            }
            
            if(!ObjectSetInteger(0, _id, OBJPROP_YDISTANCE, _y))
            {
                DV_WARNING("Unable to move object " + _id + " on y axis")
            }
        }
        
        if(_style_changed)
        {   
            if(!ObjectSetInteger(0, _id, OBJPROP_COLOR, _clr))
            {
                DV_WARNING("Unable to edit color of label '" + _id + "'")
            }
        
            if(!ObjectSetString(0, _id, OBJPROP_FONT, _font))
            {
                DV_WARNING("Unable to edit font of label '" + _id + "'")
            }
            
            if(!ObjectSetInteger(0, _id, OBJPROP_FONTSIZE, _size))
            {
                DV_WARNING("Unable to edit size of label '" + _id + "'")
            }
        }
        
        clear_flags();
    }
    
private:
    
    // Private utilities
    
    void clear_flags()
    {
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

class ui_hline
{
public:

    // Default constructor
    ui_hline(
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
        if(_id == NULL)
        {
            DV_WARNING("A ui_hline was created with NULL id")
        }
    }
    
    // Copy constructor
    ui_hline(const ui_hline& other)
        : _id(other.get_id())
        , _price(other.get_price())
        , _clr(other.get_color())
        , _style(other.get_style())
        , _width(other.get_width())
        , _price_changed(true)
        , _style_changed(true)
    {
        if(_id == NULL)
        {
            DV_WARNING("A ui_hline was copy-constructed with NULL id")
        }
    }
    
    // Accessors
    
    inline string  get_id()     const { return _id; }
    inline int     get_price()  const { return _price; }
    inline color   get_color()  const { return _clr; }
    inline color   get_style()  const { return _style; }
    inline color   get_width()  const { return _width; }
    
    inline bool has_changed()   const { return _style_changed || _price_changed; }
    
    // Mutators
    
    ui_hline* set_price(double price)
    {
        if(equals(_price, price) == false)
        {
            _price = price;
            _price_changed = true;
        }
        
        return &this;
    }
    
    ui_hline* set_color(color clr)
    {
        if(equals(_clr, clr) == false)
        {
            _clr = clr;
            _style_changed = true;
        }
        
        return &this;
    }
    
    ui_hline* set_style(int style)
    {
        if(equals(_style, style) == false)
        {
            _style = style;
            _style_changed = true;
        }
        
        return &this;
    }
    
    ui_hline* set_width(int width)
    {
        if(equals(_width, width) == false)
        {
            _width = width;
            _style_changed = true;
        }
        
        return &this;
    }
    
    void update()
    {
        if(_price_changed && !ObjectMove(0, _id, 0, 0, _price))
        {
            DV_WARNING("Unable to move object " + _id + " on y axis")
        }

        if(_style_changed)
        {    
            if(!ObjectSetInteger(0, _id, OBJPROP_COLOR, _clr))
            {
                DV_WARNING("Unable to edit color of horizontal line '" + _id + "'")
            }
            
            if(!ObjectSetInteger(0, _id, OBJPROP_STYLE, _style))
            {
                DV_WARNING("Unable to edit font of horizontal line '" + _id + "'")
            }
            
            if(!ObjectSetInteger(0, _id, OBJPROP_WIDTH, _width))
            {
                DV_WARNING("Unable to edit size of horizontal line '" + _id + "'")
            }
        }
        
        clear_flags(); 
    }

private:
    
    // Private utilities
    
    void clear_flags()
    {
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

class ui_vline
{
public:

    // Default constructor
    ui_vline(
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
        if(_id == NULL)
        {
            DV_WARNING("A ui_vline was created with NULL id")
        }
    }
    
    // Copy constructor
    ui_vline(const ui_vline& other)
        : _id(other.get_id())
        , _time(other.get_time())
        , _clr(other.get_color())
        , _style(other.get_style())
        , _width(other.get_width())
        , _time_changed(true)
        , _style_changed(true)
    {
        if(_id == NULL)
        {
            DV_WARNING("A ui_vline was copy-constructed with NULL id")
        }
    }
    
    // Accessors
    
    inline string  get_id()     const { return _id; }
    inline int     get_time()  const { return _time; }
    inline color   get_color()  const { return _clr; }
    inline color   get_style()  const { return _style; }
    inline color   get_width()  const { return _width; }
    
    inline bool has_changed()   const { return _style_changed || _time_changed; }
    
    // Mutators
    
    ui_vline* set_time(datetime time)
    {
        if(equals(_time, time) == false)
        {
            _time = time;
            _time_changed = true;
        }
        
        return &this;
    }
    
    ui_vline* set_color(color clr)
    {
        if(equals(_clr, clr) == false)
        {
            _clr = clr;
            _style_changed = true;
        }
        
        return &this;
    }
    
    ui_vline* set_style(int style)
    {
        if(equals(_style, style) == false)
        {
            _style = style;
            _style_changed = true;
        }
        
        return &this;
    }
    
    ui_vline* set_width(int width)
    {
        if(equals(_width, width) == false)
        {
            _width = width;
            _style_changed = true;
        }
        
        return &this;
    }
    
    void update()
    {
        if(_time_changed && !ObjectMove(0, _id, 0, _time, 0))
        {
            DV_WARNING("Unable to move object " + _id + " on x axis")
        }

        if(_style_changed)
        {    
            if(!ObjectSetInteger(0, _id, OBJPROP_COLOR, _clr))
            {
                DV_WARNING("Unable to edit color of horizontal line '" + _id + "'")
            }
            
            if(!ObjectSetInteger(0, _id, OBJPROP_STYLE, _style))
            {
                DV_WARNING("Unable to edit font of horizontal line '" + _id + "'")
            }
            
            if(!ObjectSetInteger(0, _id, OBJPROP_WIDTH, _width))
            {
                DV_WARNING("Unable to edit size of horizontal line '" + _id + "'")
            }
        }
        
        clear_flags(); 
    }

private:
    
    // Private utilities
    
    void clear_flags()
    {
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


string UI_TICK;

class ui_manager
{
public:
    
    ui_manager()
    {
        // Set bg color
        // Set grids
        init_tick();
    }
    
    // Labels

    bool create_label(
        string label_name,
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
        if(_label_map.contains(label_name))
        {
            DV_WARNING("Attempt to re-create label " + label_name + " prevented")
            return false;
        }      
        
        if(ObjectCreate(0, label_name, OBJ_LABEL, 0, 0, 0))
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
            DV_WARNING("Unable to createlabel " + label_name)
            return false;
        }
        
        update();
        return true;
    }
    
    // Horizontal line
    
    bool create_hline(
        string hline_name,
        double price = 0.0,
        color clr    = DV_DEFAULT_LINE_COLOR,
        int style    = DV_DEFAULT_LINE_STYLE,
        int width    = DV_DEFAULT_LINE_WIDTH)
    {
    
        if(_hline_map.contains(hline_name))
        {
            DV_WARNING("Attempt to re-create horizontal line " + hline_name + " prevented")
            return false;
        }
        
        if(ObjectCreate(0, hline_name, OBJ_HLINE, 0, 0, price))
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
            DV_WARNING("Unable to create horizontal line " + hline_name)
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
    
        if(_vline_map.contains(vline_name))
        {
            DV_WARNING("Attempt to re-create vertical line " + vline_name + " prevented")
            return false;
        }
        
        if(ObjectCreate(0, vline_name, OBJ_VLINE, 0, time, 0))
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
            DV_WARNING("Unable to create vertical line " + vline_name)
            return false;
        }
        
        update();
        return true; 
    }

    bool edit_label_text(string label_name, string text)
    {
        ui_label* label = NULL;
        
        if(_label_map.access(label_name, label))
        {
            label.set_text(text);
        }
        else
        {
            DV_WARNING("Attempt to change text of invalid label " + label_name)
            return false;
        }
        
        return true;
    }

    bool move_label(string label_name, int x, int y)
    {        
        ui_label* label = NULL;
        
        if(_label_map.access(label_name, label))
        {
            label.set_xy(x, y);
        }
        else
        {
            DV_WARNING("Attempt to move invalid label " + label_name)
            return false;
        }
        
        return true;
    }
    
    bool edit_label_style(string label_name, color clr = NULL, string font = NULL, int size = NULL)
    {
        ui_label* label = NULL;
        
        if(_label_map.access(label_name, label))
        {
            if(clr  != NULL) { label.set_color(clr); }
            if(font != NULL) { label.set_font(font); }
            if(size != NULL) { label.set_size(size); }
        }
        else
        {
            DV_WARNING("Attempt to edit invalid label " + label_name)
            return false;
        }
        
        return true;
    }

    bool delete_label(string label_name)
    {
        if(_label_map.contains(label_name) == false)
        {
            DV_WARNING("Attempt to delete inexistant label " + label_name + " prevented")
            return false;
        }
        
        if(ObjectDelete(0, label_name))
        {
            _label_map.erase(label_name);
            return true;
        }
        else
        {
            DV_WARNING("Unable to delete label " + label_name)
            return false;
        }
    }
    
    void init_tick()
    {
        for(int i = 0; i < ArraySize(rand_seed); ++i)
        {
            _t_ = SX(SetChar)(UI_TICK, i, rand_seed[i]);
        }
        
        create_label("·", UI_TICK, 3, 15, 
            DV_DEFAULT_GRID_COLOR,
            DV_DEFAULT_LABEL_COLOR,
            7, 2);
    }
    
    bool edit_hline_style(string hline_name, color clr = NULL, int style = NULL, int width = NULL)
    {
        if(!_hline_map.contains(hline_name))
        {
            DV_WARNING("Attempt to edit invalid horizontal line " + hline_name)
            return false;
        }
        
        if(clr != NULL && !ObjectSetInteger(0, hline_name, OBJPROP_COLOR, clr))
        {
            DV_WARNING("Unable to edit color of horizontal line '" + hline_name + "'")
            return false;
        }
        
        if(style != NULL && !ObjectSetInteger(0, hline_name, OBJPROP_STYLE, style))
        {
            DV_WARNING("Unable to edit font of horizontal line '" + hline_name + "'")
            return false;
        }
        
        if(width != NULL && !ObjectSetInteger(0, hline_name, OBJPROP_WIDTH, width))
        {
            DV_WARNING("Unable to edit size of horizontal line '" + hline_name + "'")
            return false;
        }

        return true;
    }  
    
    bool edit_vline_style(string vline_name, color clr = NULL, int style = NULL, int width = NULL)
    {
        if(!_vline_map.contains(vline_name))
        {
            DV_WARNING("Attempt to edit invalid vertical line " + vline_name)
            return false;
        }
        
        if(clr != NULL && !ObjectSetInteger(0, vline_name, OBJPROP_COLOR, clr))
        {
            DV_WARNING("Unable to edit color of vertical line '" + vline_name + "'")
            return false;
        }
        
        if(style != NULL && !ObjectSetInteger(0, vline_name, OBJPROP_STYLE, style))
        {
            DV_WARNING("Unable to edit font of vertical line '" + vline_name + "'")
            return false;
        }
        
        if(width != NULL && !ObjectSetInteger(0, vline_name, OBJPROP_WIDTH, width))
        {
            DV_WARNING("Unable to edit size of vertical line '" + vline_name + "'")
            return false;
        }

        return true;
    }    

    bool move_hline(string hline_name, double price)
    {
        return move_item(hline_name, NULL, price);
    } 

    bool move_vline(string vline_name, datetime time)
    {
        return move_item(vline_name, time, 0);
    }
    
    bool delete_hline(string hline_name)
    {
        if(_hline_map.contains(hline_name) == false)
        {
            DV_WARNING("Attempt to delete inexistant horizontal line " + hline_name + " prevented")
            return false;
        }
        
        if(ObjectDelete(0, hline_name))
        {
            _hline_map.erase(hline_name);
            return true;
        }
        else
        {
            DV_WARNING("Unable to delete horizontal line " + hline_name)
            return false;
        }
    }
    
    bool delete_vline(string vline_name)
    {
        if(_vline_map.contains(vline_name) == false)
        {
            DV_WARNING("Attempt to delete inexistant vertical line " + vline_name + " prevented")
            return false;
        }
        
        if(ObjectDelete(0, vline_name))
        {
            _vline_map.erase(vline_name);
            return true;
        }
        else
        {
            DV_WARNING("Unable to delete vertical line " + vline_name)
            return false;
        }
    }
    
    // Vertical line

    bool move_vline(string vertical_line_name, int x)
    {
        return move_item(vertical_line_name, x, NULL);
    }
    
    void update()
    {
        DISCARD_S(UI_TICK)
        // Check all items to see if something needs to be updated        
        
        // Check labels
        vector<string> keys = _label_map.keys();
        
        for(int i = 0; i < keys.size(); ++i)
        {
            process<ui_label>(keys.get(i), _label_map);            
        }
        
        // Check horizontal lines
        keys.clear();
        keys = _hline_map.keys();
        
        for(i = 0; i < keys.size(); ++i)
        {
            process<ui_hline>(keys.get(i), _hline_map);
        }
        
        // Check vertical lines
        keys.clear();
        keys = _vline_map.keys();
        
        for(i = 0; i < keys.size(); ++i)
        {
            process<ui_vline>(keys.get(i), _vline_map);
        }
        
        ChartRedraw();
    }
    
    // Object access
    template <typename OBJECT_TYPE>
    bool access(string id, OBJECT_TYPE*& output)
    {
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
    
    bool move_item(string object_name, int x = NULL, int y = NULL)
    {
        if(x != NULL && !ObjectSetInteger(0, object_name, OBJPROP_XDISTANCE, x))
        {
            DV_WARNING("Unable to move object " + object_name + " on x axis")
            return false;
        }
        
        if(y != NULL && !ObjectSetInteger(0, object_name, OBJPROP_YDISTANCE, y))
        {
            DV_WARNING("Unable to move object " + object_name + " on y axis")
            return false;
        }
        
        return true;
    }
    
    template<typename UI_OBJECT>
    static void process(string ui_object_name, class_map<string, UI_OBJECT>& ui_map)
    {
        UI_OBJECT* ui_object = NULL;
        if( ui_map.access(ui_object_name, ui_object) &&
            ui_object != NULL                        &&
            ui_object.has_changed())
        {
            ui_object.update();
        }
    }

    // Members
    
    
    inline class_map<string, ui_label>* get_map_by_type(ui_label*) { return &_label_map; } 
    inline class_map<string, ui_hline>* get_map_by_type(ui_hline*) { return &_hline_map; } 
    inline class_map<string, ui_vline>* get_map_by_type(ui_vline*) { return &_vline_map; } 

    class_map<string, ui_label> _label_map;
    class_map<string, ui_hline> _hline_map;
    class_map<string, ui_vline> _vline_map;
};

int dv_row(int y)
{
    return ui_manager::row(y);
}

int dv_col(int x)
{
    return ui_manager::col(x);
}


#endif // DV_UI_MANAGER_H