#include "logger.h"

#include <unistd.h>
#include <string.h>

#include <sys/types.h> // open
#include <sys/stat.h> // open
#include <fcntl.h> // open

const int CONFIG_BUFFER_SIZE = 1024;

Logger::Logger()
{
    puts("Logger()");
}

Logger::~Logger()
{
    puts("~Logger()");
    if (_bufferRead)
    {
        free(_bufferRead);
    }
    if (_bufferConfig)
    {
        free(_bufferConfig);
    }
}

void Logger::start(const Settings &settings)
{
    _bufferRead = malloc(settings.bufferSize);
    _bufferConfig = malloc(CONFIG_BUFFER_SIZE);
    _settings = settings;

    _tRead = std::thread(&Logger::routineRead, this);
    _tConf = std::thread(&Logger::routineConf, this);
    _tWrite = std::thread(&Logger::routineWrite, this);

//    _tRead.join();
//    _tConf.join();
//    _tWrite.join();

    _tConf.detach();
    _tWrite.detach();

    _tRead.join();
}

void Logger::routineRead()
{
    ssize_t readCount = 0;
    while(true)
    {
        readCount = read(0, _bufferRead, _settings.bufferSize);
        write(1, _bufferRead, readCount);
    }
}

void Logger::routineConf()
{
    ssize_t readCount = 0;
    int fd = open(
        "/home/boris/boris.fifo",
        O_RDONLY
    );
    if (fd < 0)
    {
        perror("can not open configure pipe");
        return;
    }
    while(true)
    {
        readCount = read(fd, _bufferConfig, CONFIG_BUFFER_SIZE);
        //read(fd, _bufferConfig, readCount);
        printf("read res: %d\n", readCount);
    }
}

void Logger::routineWrite()
{
//    int counter = 0;
//    while(true)
//    {
//        std::this_thread::sleep_for(std::chrono::seconds(1));
//        printf("write %d\n", ++counter % 10);
//    }
}
