# DV Tools

## Why?

MQL4 looks a lot like C++, but it lacks a few things... DV Tools is a collection of classes and utilities allowing you to code faster and to skip most of MQL4's boilerplate.

As a C++ developer, the absence of `vector` and `map` templates was a great pain. At some point it was too much frustration and so this project began.

## What's in there?

* `vector` and `map` for simple types (int, double, string, etc.)
* `class_vector` and `class_map templates`
* `ui_manager`
* `order_book` (not MQL5 compliant)
* macros to iterate over current trades
* macros to iterate over history
* logging macros with log level settings

> The reason why there is different vector/map implementation for primitives and classes is twofold:
>
> *  MQL4 does not handle references and pointers the same way C++ does. Try it, you'll see... 
> * Template metaprogramming is not quite there in MQL4, so sharing a common template has been pushed back to later. Or never.

### Next steps

HTTP objects to make requests in a more elegant fashion, then a refactoring of the `map` implementation (which is currently a pair of vectors where keys are linearly looked up).

## API

### `vector<T>`
```cpp
constructor ()
constructor (const vector<T>& other)

T       get(int index)
&self   push(T value)
&self   set(int index, T value)
&self   fill(T value)
&self   fill(int offset, int count, T value)
&self   clear(int index)
bool    erase(int index)
int     size()
int     capacity()
```
