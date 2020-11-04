#ifndef DV_CONFIG_H
#define DV_CONFIG_H

//@START@
// Naming
#define DV_EA_NAME                      "Unnamed"
#define DV_EA_VERSION                   "0.0.0.0"

// Comment to define your own "MagicNumber" variable
#define GENERATE_MAGIC_NUMBER

// Trades config
#define DV_MAX_PIP_SLIPPAGE             5
#define DV_MAX_ORDER_SEND_RETRY         3
#define DV_DEFAULT_TAKEPROFIT           30
#define DV_DEFAULT_STOPLOSS             15

// Log level (comment to disable)
//#define DV_LOG_DEBUG
#define DV_LOG_INFO
#define DV_LOG_WARNING
#define DV_LOG_ERROR

// Log to file (comment to disable)
#define DV_ENABLE_LOG_FILE
#define DV_LOG_FILE_DEBUG
#define DV_LOG_FILE_INFO
#define DV_LOG_FILE_WARNING
#define DV_LOG_FILE_ERROR

// Label default values
#define DV_DEFAULT_LABEL_COLOR          clrRed
#define DV_DEFAULT_LABEL_FONT           "Consolas"
#define DV_DEFAULT_LABEL_SIZE           12

// Lines default values
#define DV_DEFAULT_LINE_COLOR           clrRed
#define DV_DEFAULT_LINE_STYLE           STYLE_SOLID
#define DV_DEFAULT_LINE_WIDTH           2

// Chart default values (MetaTrader default colors)
#define DV_DEFAULT_BG_COLOR             clrBlack
#define DV_DEFAULT_AXIS_COLOR           clrWhite
#define DV_DEFAULT_GRID_COLOR           clrLightSlateGray

// UI grid sizing
#define DV_COL_SIZE                     (4 * DV_DEFAULT_LABEL_SIZE + 4)
#define DV_ROW_SIZE                     (DV_DEFAULT_LABEL_SIZE + 4)

// Base reserve of all container at init
#define DV_DEFAULT_CONTAINER_RESERVE    16

//@END@
#endif // DV_CONFIG_H