# An attempt to love MQL4

## Why?

As a C++ developer, the absence of `vector` and many other things in MQL4 was a great pain. At some point it was too much frustration and so this project began. DV Tools is a collection of classes and utilities allowing you to code faster and to skip most of MQL4's boilerplate.

## A quick tour

### Containers

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

A specific container had to be made for containers of classes, since MQL4 passes classes only by reference, but forbids the use of pointers with some primitives (no `int*` can you believe this...). This is an example with `class_map`, there is a similar `class_vector` implementation.

> NOTE: classes used in these container must minimally implement a default-constructor and a copy-constructor

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

The `ui_manager` class keeps track of labels, lines and triangles states and redraws modified objects when `update()` is called on it.

```cpp
ui_manager ui;
ui.create_label("archon", "power overwheling");

label_t* label;
if(ui.access("archon", label))
    label.set_font("Comic Sans MS")     // builder pattern on ui objects
         .set_color(clrPurple)
         .set_size(72)
         .set_text("POWER OVERWHELING");

ui.update();
```

### Orders management

The `order_manager` scans the current trades and history to expose them as useful objects.

```cpp
order_manager orders;
orders.refresh();                   // scan existing orders
order_t* order;
if(orders.new_closed_orders())      // check if any order was recently closed
{
    if(orders.access_new_closed(order))
    {
        if(order.get_profit() < 0)
        {
            // order is an order newly closed with losses
        }
    }
}
```

### Logging

Four macros: `DEBUG`, `INFO`, `WARNING` and `ERROR` that can be individually toggled on or off. The output can be log to either or both the MetaTrader Expert console or to a file.

### Some macros

DISCARD
FOR_TRADES

## Setup

* A macro use the variable `MagicNumber` so if you want to define your own, it should be declared above `#include "dv_tools.mqh"`


## Next steps

* Elegant HTTP API
* BST reimplementation of maps