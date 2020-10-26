#ifndef DV_CONFIG_H
#define DV_CONFIG_H

//@START@
// Trades config
#define DV_MAX_PIP_SLIPPAGE             5

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

// Chart default values
#define DV_DEFAULT_BG_COLOR             clrAliceBlue
#define DV_DEFAULT_GRID_COLOR           clrWhiteSmoke

// UI grid sizing
#define DV_COL_SIZE                     (8 * DV_DEFAULT_LABEL_SIZE + 2)
#define DV_ROW_SIZE                     (DV_DEFAULT_LABEL_SIZE + 2)

// Base reserve of all container at init
#define DV_DEFAULT_CONTAINER_RESERVE    16

//@END@
#endif // DV_CONFIG_H