#ifndef DV_CONFIG_H
#define DV_CONFIG_H

// Log level (comment to disable log type)
#define DV_LOG_DEBUG
#define DV_LOG_WARNING
#define DV_LOG_ERROR

// Base reserve of all container at init
#define DV_DEFAULT_CONTAINER_RESERVE    16

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

#endif // DV_CONFIG_H