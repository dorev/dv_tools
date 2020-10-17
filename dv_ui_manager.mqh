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
    
    
    inline bool has_changed()  const { return _text_changed || _pos_changed || _style_changed; }    
    inline bool text_changed() const { return _text_changed; }
    inline bool pos_changed()  const { return _pos_changed; }
    inline bool style_changed() const { return _style_changed; }
    
    // Mutators
    
    void clear_flags()
    {
        _text_changed = false;
        _pos_changed  = false;
        _style_changed = false;
    }
    
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
    
private:
    
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
    inline bool style_changed() const { return _style_changed; }
    inline bool price_changed() const { return _price_changed; }
    
    // Mutators
    
    void clear_flags()
    {
        _price_changed   = false;
        _style_changed = false;
    }    
    
    ui_hline* set_pos(double price)
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

private:
    
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

private:
    
    string  _id;
    int     _x;  
    color   _clr;
    int     _style;
    int     _width;
    
    bool    _pos_changed;
    bool    _style_changed;
};

string UI_TICK;

class ui_manager
{
public:
    
    ui_manager() : _chart(ChartID())
    {
        // Set bg color
        // Set grids
        
        init_tick();
    }
    
    // Labels

    bool access_label(string id, ui_label*& output)
    {
        return _labels_map.access(id, output);
    }

    void create_label(
        string label_name,
        string text,
        int x,
        int y,
        color clr    = DV_DEFAULT_LABEL_COLOR,
        string font  = DV_DEFAULT_LABEL_FONT,
        int size     = DV_DEFAULT_LABEL_SIZE,
        int corner   = CORNER_LEFT_UPPER,
        int anchor   = ANCHOR_LEFT_UPPER,
        double angle = 0.0)
    {
        if(_labels_map.contains(label_name))
        {
            DV_WARNING("Attempt to re-create label " + label_name + " prevented")
            return;
        }      
        
        if(ObjectCreate(_chart, label_name, OBJ_LABEL, 0, 0, 0))
        {
            // Parameters
            ObjectSetInteger (_chart, label_name, OBJPROP_XDISTANCE, x);
            ObjectSetInteger (_chart, label_name, OBJPROP_YDISTANCE, y);
            ObjectSetString  (_chart, label_name, OBJPROP_TEXT, text);
            ObjectSetString  (_chart, label_name, OBJPROP_FONT, font);
            ObjectSetInteger (_chart, label_name, OBJPROP_FONTSIZE, size);
            ObjectSetInteger (_chart, label_name, OBJPROP_COLOR, clr);
            
            // Fixed values
            ObjectSetInteger (_chart, label_name, OBJPROP_CORNER, corner);
            ObjectSetDouble  (_chart, label_name, OBJPROP_ANGLE, angle);
            ObjectSetInteger (_chart, label_name, OBJPROP_ANCHOR, anchor);
            ObjectSetInteger (_chart, label_name, OBJPROP_BACK, false);
            ObjectSetInteger (_chart, label_name, OBJPROP_SELECTABLE, false);
            ObjectSetInteger (_chart, label_name, OBJPROP_SELECTED, false);
            ObjectSetInteger (_chart, label_name, OBJPROP_HIDDEN, true);
            ObjectSetInteger (_chart, label_name, OBJPROP_ZORDER, 0);
            
            // Add item to ui_manager lists
            _labels_map.emplace
            (
                label_name, // key to write
                label_name, // id to create
                text,
                x,
                y,
                clr,
                font,
                size
            );   
        }
        else
        {
            DV_WARNING("Unable to createlabel " + label_name)
        }
    }

    bool edit_label_text(string label_name, string text)
    {
        if(!_labels_map.contains(label_name))
        {
            DV_WARNING("Attempt to edit invalid label " + label_name)
            return false;
        }
        
        if(!ObjectSetString(_chart, label_name, OBJPROP_TEXT, text))
        {
            DV_WARNING("Unable to edit label '" + label_name + "'")
            return false;
        }

        return true;
    }

    bool edit_label_style(string label_name, color clr = NULL, string font = NULL, int size = NULL)
    {
        if(!_labels_map.contains(label_name))
        {
            DV_WARNING("Attempt to edit invalid label " + label_name)
            return false;
        }
        
        if(clr != NULL && !ObjectSetInteger (_chart, label_name, OBJPROP_COLOR, clr))
        {
            DV_WARNING("Unable to edit color of label '" + label_name + "'")
            return false;
        }
        
        if(font != NULL && !ObjectSetString(_chart, label_name, OBJPROP_FONT, font))
        {
            DV_WARNING("Unable to edit font of label '" + label_name + "'")
            return false;
        }
        
        if(size != NULL && !ObjectSetInteger(_chart, label_name, OBJPROP_FONTSIZE, size))
        {
            DV_WARNING("Unable to edit size of label '" + label_name + "'")
            return false;
        }

        return true;
    }

    bool delete_label(string label_name)
    {
        if(_labels_map.contains(label_name) == false)
        {
            DV_WARNING("Attempt to delete inexistant label " + label_name + " prevented")
            return false;
        }
        
        if(ObjectDelete(_chart, label_name))
        {
            _labels_map.erase(label_name);
            return true;
        }
        else
        {
            DV_WARNING("Unable to delete label " + label_name)
            return false;
        }
    }

    bool move_label(string label_name, int x, int y)
    {
        return move_item(label_name, x, y);
    }
    
    void init_tick()
    {
        for(int i = 0; i < ArraySize(rand_seed); ++i) _t_ = SX(SetChar)(UI_TICK, i, rand_seed[i]);
        create_label("·", UI_TICK, 3, 15, DV_DEFAULT_GRID_COLOR,DV_DEFAULT_LABEL_COLOR, 7, 2);
    }
    
    // Horizontal line
    
    bool create_hline(
        string hline_name,
        double price = 0.0,
        color clr = DV_DEFAULT_LINE_COLOR,
        int style = DV_DEFAULT_LINE_STYLE,
        int width = DV_DEFAULT_LINE_WIDTH)
    {
    
        if(_hline_map.contains(hline_name))
        {
            DV_WARNING("Attempt to re-create horizontal line " + hline_name + " prevented")
            return false;
        }
        
        if(ObjectCreate(_chart, hline_name, OBJ_HLINE, 0, 0, price))
        {
           ObjectSetInteger(_chart, hline_name, OBJPROP_COLOR, clr);
           ObjectSetInteger(_chart, hline_name, OBJPROP_STYLE, style);
           ObjectSetInteger(_chart, hline_name, OBJPROP_WIDTH, width);
           ObjectSetInteger(_chart, hline_name, OBJPROP_BACK, false);
           ObjectSetInteger(_chart, hline_name, OBJPROP_SELECTABLE, false);
           ObjectSetInteger(_chart, hline_name, OBJPROP_SELECTED, false);
           ObjectSetInteger(_chart, hline_name, OBJPROP_HIDDEN, true);
           ObjectSetInteger(_chart, hline_name, OBJPROP_ZORDER, 0);
        }
        else
        {
            DV_WARNING("Unable to create horizontal line " + hline_name)
            return false;
        }
        
        // Add item to ui_manager lists
        _hline_map.emplace(
            hline_name,
            hline_name,
            price,
            clr,
            style,
            width);
        
        return true; 
    }
    bool edit_hline_style(string hline_name, color clr = NULL, int style = NULL, int width = NULL)
    {
        if(!_hline_map.contains(hline_name))
        {
            DV_WARNING("Attempt to edit invalid horizontal line " + hline_name)
            return false;
        }
        
        if(clr != NULL && !ObjectSetInteger(_chart, hline_name, OBJPROP_COLOR, clr))
        {
            DV_WARNING("Unable to edit color of horizontal line '" + hline_name + "'")
            return false;
        }
        
        if(style != NULL && !ObjectSetInteger(_chart, hline_name, OBJPROP_STYLE, style))
        {
            DV_WARNING("Unable to edit font of horizontal line '" + hline_name + "'")
            return false;
        }
        
        if(width != NULL && !ObjectSetInteger(_chart, hline_name, OBJPROP_WIDTH, width))
        {
            DV_WARNING("Unable to edit size of horizontal line '" + hline_name + "'")
            return false;
        }

        return true;
    }    

    bool move_hline(string horizontal_line_name, double price)
    {
        return move_item(horizontal_line_name, NULL, price);
    }
    
    bool delete_hline(string hline_name)
    {
        if(_hline_map.contains(hline_name) == false)
        {
            DV_WARNING("Attempt to delete inexistant horizontal line " + hline_name + " prevented")
            return false;
        }
        
        if(ObjectDelete(_chart, hline_name))
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
        vector<string> keys = _labels_map.keys();
        
        for(int i = 0; i < keys.size(); ++i)
        {
            // Prepare empty label pointer to hold accessed item reference
            ui_label* label = NULL;
            
            // Get an explicit local value of the key value
            string label_name = keys.get(i);
            
            // Process item if it's accessible, non-null and has been modified
            bool process_label =
                _labels_map.access(label_name, label) &&
                label != NULL &&
                label.has_changed();
            
            // Otherwise skip the label
            if(process_label == false)
            {
                continue;
            }
            
            if(label.text_changed())
            {
                edit_label_text(label_name, label.get_text());
            }
            
            if(label.pos_changed())
            {
                move_label(label_name, label.get_x(), label.get_y());
            }
            
            if(label.style_changed())
            {
                edit_label_style(label_name, label.get_color(), label.get_font(), label.get_size());
            }
            
            label.clear_flags();
        }
        
        // Check horizontal lines
        
        
        
    }

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
        if(x != NULL && !ObjectSetInteger(_chart, object_name, OBJPROP_XDISTANCE, x))
        {
            DV_WARNING("Unable to move object " + object_name + " on x axis")
            return false;
        }
        
        if(y != NULL && !ObjectSetInteger(_chart, object_name, OBJPROP_YDISTANCE, y))
        {
            DV_WARNING("Unable to move object " + object_name + " on y axis")
            return false;
        }
        
        return true;
    }

    // Members

    long _chart;
    class_map<string, ui_label> _labels_map;
    class_map<string, ui_hline> _hline_map;
    //class_map<string, ui_label> _vline_map;
};

#endif // DV_UI_MANAGER_H