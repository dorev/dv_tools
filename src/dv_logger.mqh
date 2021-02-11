#ifndef DV_LOG_FILE_H
#define DV_LOG_FILE_H

//@START@
class logger
{
public:

    static void set_file_path(string log_file_path)
    {
        _log_file_path = log_file_path;
    }

    static bool init()
    {
        if (_log_file_path == "")
        {
            // Default log file path
            _log_file_path = "dv_logger_" + _Symbol + "_" + timestamp() + ".log";
        }

        _log_file_handle = FileOpen(_log_file_path, FILE_READ|FILE_WRITE|FILE_ANSI);
        _is_init = _log_file_handle != INVALID_HANDLE;
        return _is_init;
    }

    static void shutdown()
    {
        FileClose(_log_file_handle);
    }

    static void print(string tag, string message)
    {
        if (!_is_init && !init())
        {
            return;
        }

        FileSeek(_log_file_handle, 0, SEEK_END);
        FileWriteString(_log_file_handle, tag + " : " + message + "\n");
    }

    static string timestamp()
    {
        string timestamp = TimeToString(TimeLocal(), TIME_DATE|TIME_MINUTES|TIME_SECONDS) + "." + IntegerToString(GetMicrosecondCount());
        StringReplace(timestamp, ":", ".");
        StringReplace(timestamp, " ", "_");
        return timestamp;
    }

    inline static bool available() { return _is_init; }

private:

    static string _log_file_path;
    static bool _is_init;
    static int _log_file_handle;
};

string  logger::_log_file_path      = "";
bool    logger::_is_init            = false;
int     logger::_log_file_handle    = INVALID_HANDLE;

//@END@
#endif // DV_LOG_FILE_H