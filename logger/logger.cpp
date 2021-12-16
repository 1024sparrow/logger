#include "logger.h"

#include <unistd.h>
#include <string.h>

Logger::Logger(const Settings &settings)
    :_settings{settings}
{
    _t = std::thread(&Logger::routine, this);
    _buffer = malloc(settings.bufferSize);
}

Logger::~Logger()
{
    free(_buffer);
}

void Logger::start()
{
    _t.join();
}

void Logger::routine()
{
    ssize_t readCount = 0;
    while(true)
    {
        readCount = read(0, _buffer, _settings.bufferSize);
        write(1, _buffer, readCount);
    }
}
