#ifndef DV_CONFIG_H
#define DV_CONFIG_H

//@START@
// Naming
#ifndef DV_EA_NAME
#define DV_EA_NAME                         "Unnamed"
#endif

#ifndef DV_EA_VERSION
#define DV_EA_VERSION                      "0.0.0.0"
#endif

// Pip multiplier depending on digits
#define PipFactor ((bool)(_Digits & 1) ? 10 : 1)

// Trades config
#ifndef DV_MAX_PIP_SLIPPAGE
#define DV_MAX_PIP_SLIPPAGE             (5 * PipFactor)
#endif
#ifndef DV_MAX_ORDER_SEND_RETRY
#define DV_MAX_ORDER_SEND_RETRY         3
#endif
#ifndef DV_DEFAULT_TAKEPROFIT
#define DV_DEFAULT_TAKEPROFIT           30
#endif
#ifndef DV_DEFAULT_STOPLOSS
#define DV_DEFAULT_STOPLOSS             15
#endif

// Log level
//#define DV_LOG_DEBUG
//#define DV_LOG_INFO
//#define DV_LOG_WARNING
//#define DV_LOG_ERROR

// Log to file
//#define DV_ENABLE_LOG_FILE
//#define DV_LOG_FILE_DEBUG
//#define DV_LOG_FILE_INFO
//#define DV_LOG_FILE_WARNING
//#define DV_LOG_FILE_ERROR

// Label default values
#ifndef DV_DEFAULT_LABEL_COLOR
#define DV_DEFAULT_LABEL_COLOR          clrRed
#endif
#ifndef DV_DEFAULT_LABEL_FONT
#define DV_DEFAULT_LABEL_FONT           "Consolas"
#endif
#ifndef DV_DEFAULT_LABEL_SIZE
#define DV_DEFAULT_LABEL_SIZE           12
#endif

// Lines default values
#ifndef DV_DEFAULT_LINE_COLOR
#define DV_DEFAULT_LINE_COLOR           clrRed
#endif
#ifndef DV_DEFAULT_LINE_STYLE
#define DV_DEFAULT_LINE_STYLE           STYLE_SOLID
#endif
#ifndef DV_DEFAULT_LINE_WIDTH
#define DV_DEFAULT_LINE_WIDTH           2
#endif

// Chart default values (MetaTrader default colors)
#ifndef DV_DEFAULT_BG_COLOR
#define DV_DEFAULT_BG_COLOR             clrBlack
#endif
#ifndef DV_DEFAULT_AXIS_COLOR
#define DV_DEFAULT_AXIS_COLOR           clrWhite
#endif
#ifndef DV_DEFAULT_GRID_COLOR
#define DV_DEFAULT_GRID_COLOR           clrLightSlateGray
#endif

// UI grid sizing
#ifndef DV_COL_SIZE
#define DV_COL_SIZE                     48
#endif
#ifndef DV_ROW_SIZE
#define DV_ROW_SIZE                     16
#endif

// Base reserve of all container at init
#ifndef DV_DEFAULT_CONTAINER_RESERVE
#define DV_DEFAULT_CONTAINER_RESERVE    16
#endif

//@END@
#endif // DV_CONFIG_H