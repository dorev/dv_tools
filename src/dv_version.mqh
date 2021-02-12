#ifndef DV_VERSION_H
#define DV_VERSION_H

//@START@
#define DV_MAJOR 1
#define DV_MINOR 0
#define DV_PATCH 2
#define DV_BUILD 44

string dv_version()
{
    return IntegerToString(DV_MAJOR) + "." +
           IntegerToString(DV_MINOR) + "." +
           IntegerToString(DV_PATCH) + "." +
           IntegerToString(DV_BUILD);
}

//@END@
#endif // DV_VERSION_H
