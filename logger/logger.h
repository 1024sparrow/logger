#include "config.h"
#include "ringbuffer.h"

#include <stdint.h>

#include <list>
#include <thread>
#include <atomic>
#include <mutex>
#include <condition_variable>

class Logger final
{
public:
    Logger();
    ~Logger();

    void start(const Config &settings);

private:
    void routineRead();
    void routineConf();
    void routineWrite();
    void writeFile(ssize_t size, void * data);

private:
    enum State
    {
        Normal,
        Receiving
    } _state {State::Normal};

    Config _settings;
    std::mutex _mutex;
    std::condition_variable _cvMessageReceived;
    std::thread _tConf;
    std::thread _tWrite;
    void *_bufferRead = nullptr;
    void *_bufferConfig = nullptr;
    RingBuffer _bufferWrite;
};
