#pragma once

#include <sys/types.h>

// This class in NOT thread safe
class RingBuffer
{
public:
    RingBuffer(int pageCount, int pageSize);
    ~RingBuffer();

    struct Chunk
    {
        ssize_t size;
        void *data;
    };

    int pageSize() const;

    // если не заполнен, вставляет сообщение
    enum class PushResult
    {
        Success = 0,
        Overflow,
        TooBigChunk
    };
    PushResult push(const Chunk &chunk);

    // если не пуст, выдаёт сообщение
    enum class PopResult
    {
        Success = 0,
        NoMessages
    };
    PopResult pop(Chunk &chunk);

private:
    const int
        _pageCount,
        _pageSize
    ;
    Chunk *_buffer;
    ssize_t _size = 0;
    int _indexWrite = 0;
    int _indexRead = 0;
};
