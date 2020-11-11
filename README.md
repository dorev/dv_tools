# An attempt to love MQL4



## Why?

I have been programming Forex ExpertAdvisors (aka. currency trading bots) recreationally and contractually for a time. I always thought it was a fun topic to program since you're being thrown simple, formalized, *real* data all week long and you have to try to make sense of it, try to beat the system. It can really be addressed as a game. Some people do it for money too, essentially to lose it though...

This being said, as a day-to-day C++ developer, MQL4 is a game missing a lot of relevant components, such as `vector`s and `map`s and other things you could expect from a modern language. In its defense, it is not a modern language at all, so instead of hating, I started this project.

DV Tools is a collection of classes and utilities allowing you to code faster and to skip a bunch of MQL4 boilerplate.



## A quick tour



### Simple containers

The `vector` and `map` templates mostly mimic the functionalities of the same C++ STL container.

```cpp
vector<string> v;
v.push("hello");        // {"hello"}
v.push(" ~ ");          // {"hello", " ~ "}
v.push("world");        // {"hello", " ~ ", "world"}
v.set(1, "$");          // {"hello", " $ ", "world"}
v.find("world");        // returns 2, index of first "world" found
v.get(0);               // returns "hello"
v.erase(0);             // {" ~ ", "world"}
v.clear();              // {}
```

```cpp
map<string, double> m;
m.set("foo", 12.3);     // {{"foo", 12.3}}
m.set("bar", 45.6);     // {{"foo", 12.3}, {"bar", 45.6}}
m.set("foo", 7.89);     // {{"foo", 7.89}, {"bar", 45.6}}
m.contains("bar");      // return true
m.erase("bar");         // {{"foo", 7.89}}
m.contains("bar");      // return false
m.clear();              // {}
```



### Object containers

A specific container had to be made for containers of classes, since MQL4 passes classes only by reference, but forbids the use of pointers with some primitives (no `int*` can you believe this...). This is an example with `class_map`, there is a similar `class_vector` implementation.

> **NOTE: classes used in these containers must minimally implement a default-constructor and a copy-constructor**



```cpp
class my_obj {                  // declaring some class
public:
    int num;
    my_obj(int n) : num(n) {}
};

class_map<string, my_obj> cm;
cm.emplace("one", 1);           // { {"one", &my_obj{num:1}} }
cm.get_ref("one").num;          // returns 1

my_obj* cm_dest;
if(cm.access("one", cm_dest))   // true if key "one" valid
    cm_dest.num;                // returns 1

cm.emplace("two", 2);
cm.emplace("three", 3);
cm.get_keys_ref();              // returns &vector<string>{"one", "two", "three"}
```



### Chart graphic elements management

The `ui_manager` class keeps track of labels, lines and triangles states and redraws modified objects when `update()` is called on it. A pattern of columns and rows can be setup to position labels and objects with more regularity. The default size of rows/cols can be set with the macros `DV_ROW_SIZE` and `DV_COL_SIZE`.

```cpp
ui_manager ui;
ui.create_label("archon", "power overwheling", ui.col(2), ui.row(4));

label_t* label;
if(ui.access("archon", label))
    label.set_font("Comic Sans MS")     // builder pattern on ui objects
         .set_color(clrPurple)
         .set_size(72)
         .set_text("POWER OVERWHELING");

ui.update();
```



### Orders management

The `order_manager` scans the positions known by the broker to expose them as useful objects.

```cpp
order_manager orders;
orders.refresh();                           // scan existing orders
order_t* order;                             // declare a receiving order pointer

if(orders.new_closed_orders())              // check if any order was recently closed
{
    if(orders.access_new_closed(order))     // "access_..." methods are provided with
    {                                       // a destination pointerand return true if
        if(order.get_profit() < 0)          // an object has been referenced
        {
            // order was recently closed with losses
        }
    }
}
```



### Logging

Four macros: `DEBUG`, `INFO`, `WARNING` and `ERROR` that can be individually toggled on or off. The output can be log to either or both the MetaTrader Expert console or to a file. All the options macros can be found in `dv_config.mqh`.

```cpp
#define DV_ENABLE_LOG_FILE
//#define DV_LOG_DEBUG
#define DV_LOG_WARNING

//...

DEBUG("foo::bar(int a) called with a=" + a)     // prints nothing, nowhere
WARNING("No baz was found")                     // prints message to console and log file 
```

### Other macro utils

Iterating on all trades is quite tiresome to write in MQL4, so this was probably the first thing I made.

* `FOR_TRADES` iterates over every opened position of the current symbol and `MagicNumber`
* `FOR_HISTORY` iterates over every closed position of the current symbol and `MagicNumber`
* `FOR_ALL_TRADES` goes over every opened position visible by the broker

```cpp
FOR_TRADES
    order_t order = orders.get_ticket(OrderTicket());
    if(order == NULL) { continue; }

    if(order.is_buy() && order.get_profit() > 0)
        order.close_partial(order.get_lots() / 2.0);
FOR_TRADES_END
```



## Setup

`dv_tools.mqh` contains the whole thing, it can be copied or `#include`d in your own EA. I would recommend to add it between your external parameters and the rest of your EA.

```cpp
// notice & copyright...
// header...

extern int TP = 20;
extern int SL = 20;
extern int MagicNumber = 20;    // <-- important!

#define DV_ENABLE_LOG_FILE
#define DV_LOG_WARNING
#define DV_LOG_ERROR
#include "dv_tools.mqh"

// code...
```
> **NOTE: it is important to setup a variable named exactly `MagicNumber` before including `dv_tools.mqh` because it is used in the order iteration macros.**

Another option is to let it declare `MagicNumber` for you :

```cpp
#define DV_EA_NAME      "MyStrategy"    // used to seed `MagicNumber`
#define DV_EA_VERSION   "2.0.1.13"      // used to seed `MagicNumber`
#define DV_GENERATE_MAGIC_NUMBER
#include "dv_tools.mqh"
```



## Next steps

* Elegant HTTP API
* BST reimplementation of maps
* Rework new position opening
* Order monitoring with trailing stop and break even
* ...