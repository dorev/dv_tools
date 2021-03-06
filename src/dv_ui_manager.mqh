#include "dv_common.mqh"
#include "dv_class_map.mqh"

#ifndef DV_UI_MANAGER_H
#define DV_UI_MANAGER_H

//@START@
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
        DEBUG("label_t::set_size of " + _id + " with " + IntegerToString(size))

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
        DEBUG("hline_t::set_width of " + _id + " with " + IntegerToString(width))

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
        DEBUG("vline_t::set_width of " + _id + " with " + IntegerToString(width))

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
        DEBUG("rectangle_t::set_width of " + _id + " with " + IntegerToString(width))

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

        init_tick();
    }

    void init_default()
    {
        set_background_color(DV_DEFAULT_BG_COLOR);
        set_axis_color(DV_DEFAULT_AXIS_COLOR);
        set_grid_color(DV_DEFAULT_GRID_COLOR);
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

    bool delete_label(string label_name)
    {
        return delete_item(label_name, _label_map);
    }

    bool delete_hline(string hline_name)
    {
        return delete_item(hline_name, _hline_map);
    }

    bool delete_vline(string vline_name)
    {
        return delete_item(vline_name, _vline_map);
    }

    bool delete_rectangle(string rectangle_name)
    {
        return delete_item(rectangle_name, _rectangle_map);
    }

    bool delete_triangle(string triangle_name)
    {
        return delete_item(triangle_name, _triangle_map);
    }

    template <typename MAP_CLASS>
    bool delete_item(string name, MAP_CLASS& item_map)
    {
        DEBUG("ui_namager::delete_item " + name)

        if(ObjectFind(0, name) < 0)
        {
            if (item_map.contains(name))
            {
                item_map.erase(name);
            }

            return true;
        }

        if (!ObjectDelete(0, name))
        {
            WARNING("Unable to delete item " + name)
            return false;
        }

        if (item_map.contains(name))
        {
            item_map.erase(name);
        }

        return true;
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

//@END@
#endif // DV_UI_MANAGER_H