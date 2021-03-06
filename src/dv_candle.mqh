#ifndef DV_CANDLE_H
#define DV_CANDLE_H

//@START@

class candle_t
{

public:

    bool is_bull;
    bool is_bear;
    double open;
    double high;
    double low;
    double close;
    double half;
    double body_top;
    double body_buttom;
    double body_size;
    double total_size;
    datetime time;
    int timeframe;

    candle_t(string symbol = NULL, int timeframe_ = 0, int shift = 0)
    {
        timeframe = timeframe_;
        if (timeframe == PERIOD_CURRENT)
        {
            timeframe = Period();
        }

        time    = iTime(symbol, timeframe_, shift);
        open    = iOpen(symbol, timeframe_, shift);
        high    = iHigh(symbol, timeframe_, shift);
        low     = iLow(symbol, timeframe_, shift);
        close   = iClose(symbol, timeframe_, shift);
        is_bull = open < close;
        is_bear = !is_bull;
        total_size = high - low;

        if (is_bull)
        {
            half = close - ((close - open) / 2);
            body_top = close;
            body_buttom = open;
        }
        else
        {
            half = open  - ((open - close) / 2);
            body_top = open;
            body_buttom = close;
        }

        body_size = body_top - body_buttom;
    }
};

//@END@
#endif // DV_CANDLE_H