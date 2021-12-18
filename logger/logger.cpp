#include "logger.h"

#include <unistd.h>
#include <string.h>

#include <sys/types.h> // open
#include <sys/stat.h> // open
#include <fcntl.h> // open

// 0x40 - 64, 0x400 - 1024, 0x400000 - миллион
const int
    CONFIG_BUFFER_SIZE = 0x400, // 1 KB

    WRITE_BUFFER_PAGE = 0x1000, // вот такими вот кусочками заполняется буфер (это же ограничение на размер одного текстового сообщения). Т.е. если даже пришло сообщение лога размером 1 байт, всё равно в памяти это займёт 4096 байтов. Это же ограничение на размер сообщения.
    WRITE_BUFFER_SIZE = 0x4000 // число кусочков. 16384.
    // Всего выделяется памяти 64МБ (67108864 байт)
;

Logger::Logger()
    : _bufferWrite(WRITE_BUFFER_SIZE, WRITE_BUFFER_PAGE)
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

void Logger::start(const Config &settings)
{
//    writeBufferPageLimit = WRITE_BUFFER_SIZE;
//    freeBufferCount = writeBufferPageLimit;
    //_bufferWrite = alloc();

    _bufferRead = malloc(settings.bufferSize);
    _bufferConfig = malloc(CONFIG_BUFFER_SIZE);
    _settings = settings;

//    _tRead = std::thread(&Logger::routineRead, this);
    _tConf = std::thread(&Logger::routineConf, this);
    _tWrite = std::thread(&Logger::routineWrite, this);

    _tConf.detach();
    _tWrite.detach();
    routineRead();
}

void Logger::routineRead()
{
    ssize_t readCount = 0;
    while(true)
    {
        readCount = read(0, _bufferRead, _settings.bufferSize);
        write(1, _bufferRead, readCount); // пишем в консоль (на экран) // boris e: на случай слишком плотного потока логов. У нас есть защита от задержки на запись в файл. Но у нас нет защиты от задержки от вывода на экран.

        if (readCount > 0)
        {
            if (readCount == WRITE_BUFFER_PAGE)
            {
                printf("LOGGER Warning! incorrect message. Message size must be less then %d bytes (encoding utf-8).\n", _bufferWrite.pageSize());
            }
            else
            {
                std::unique_lock<std::mutex> lock(_mutex);

                auto res = _bufferWrite.push({readCount, _bufferRead});
                if (res == RingBuffer::PushResult::Success)
                {
                    _cvMessageReceived.notify_one();
                }
                else
                {
                    if (res == RingBuffer::PushResult::Overflow)
                        puts("... can not write log message: buffer overflow ...");
                    else
                        printf("oops.. Unexpected push error: %d\n", static_cast<int>(res));
                }
            }
        }
    }
}

void Logger::routineConf()
{
    int fd = 0;
    ssize_t readCount = 0;
    while(true)
    {
        fd = open(
            "/home/boris/boris.fifo",
            O_RDONLY
        );
        if (fd < 0)
        {
            perror("can not open configure pipe");
            return;
        }
        readCount = read(fd, _bufferConfig, CONFIG_BUFFER_SIZE);
        printf("read res: %ld\n", readCount);
    }
}

void Logger::routineWrite()
{
    while(true)
    {
        std::unique_lock<std::mutex> lock(_mutex);
        _cvMessageReceived.wait(lock);

        RingBuffer::Chunk chunk;
        auto res = _bufferWrite.pop(chunk);
        if (res == RingBuffer::PopResult::Success)
        {
            writeFile(chunk.size, chunk.data);
        }
    }
}

void Logger::writeFile(ssize_t size, void * data)
{
    puts("-- data written --");

//    for (char *ch = (char *)_bufferRead, *chLast = (char *)_bufferRead + readCount - 1  ; ch <= chLast ; ++ch)
//    {
//        if ()
//    }
}
