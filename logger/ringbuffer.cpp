#include "ringbuffer.h"

#include <stdlib.h>
#include <string.h>

RingBuffer::RingBuffer(int pageCount, int pageSize)
    : _pageCount(pageCount)
    , _pageSize(pageSize)
{
    _buffer = new Chunk[pageCount];//(Chunk *)malloc(pageCount * sizeof(Chunk));
    for (int i = 0 ; i < pageCount ; ++i)
    {
        _buffer[i].data = malloc(pageSize);
    }
}

RingBuffer::~RingBuffer()
{
    for (int i = 0 ; i < _pageCount ; ++i)
    {
        free(_buffer[i].data);
    }
    //free(_buffer);
    delete[] _buffer;
}

int RingBuffer::pageSize() const
{
    return _pageSize;
}

RingBuffer::PushResult RingBuffer::push(const Chunk &chunk)
{
    if (_size == _pageCount)
        return PushResult::Overflow;

    if (chunk.size >= _pageSize)
        return PushResult::TooBigChunk;

    Chunk &bufferChunk = _buffer[_indexWrite];
    bufferChunk.size = chunk.size;
    memcpy(bufferChunk.data, chunk.data, chunk.size);
    _indexWrite = (_indexWrite + 1) % _pageSize;
    ++_size;
    // boris: уведомления о переполнении очереди сообщений (не успевает писать логи) отсылать отсюда
    // boris: уведомления о поступлении сообщения отсылать отсюда
    return PushResult::Success;
}

RingBuffer::PopResult RingBuffer::pop(Chunk &chunk)
{
    if (_size == 0)
        return PopResult::NoMessages;

    Chunk &bufferChunk = _buffer[_indexRead];
    chunk.size = bufferChunk.size;
    memcpy(chunk.data, bufferChunk.data, bufferChunk.size);
//    memcpy(chunk.data, "blablabla", 9);
    _indexRead = (_indexRead + 1) % _pageSize;
    --_size;
    return PopResult::Success;
}
