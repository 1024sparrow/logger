#pragma once

#include <stdint.h>
#include <string.h>

/*
{
    types:{
        size_t:{
            type: 'size_t',
            include: '<string.h>'
            // какой файл надо приинклюдить
            // какую библиотеку необходимо добавить в зависимости
        },
        boolean:{
            type: 'int'
        },
        string:{
            type: 'const char *'
        }
    },
    body:{
        bufferSize: 'size_t',
        printToTty: 'boolean',
        pipePath: 'string'
    }
}
 */

struct Config // Эту структуру мы должны заполнить по содержимому конфигурационного файла
{
    struct Tag
    {
        bool showOnScreen {true};
        const char *tag {nullptr};
        const char *directory {nullptr};
        const char *baseFileName {nullptr};
        uint32_t fileSizeLimit;
        uint64_t directorySizeLimit;
//            enum class CompressType
//            {
//                None
//            } compressType {CompressType::None};
        bool binary {false};
        size_t subratsCount {0};
        Tag * subtags {nullptr};
    };

    size_t bufferSize {4096};
    bool printToTty {false};
    const char *pipePath {nullptr};
//        enum class PipeType
//        {
//            None,
//            Pipe, // как-то так...
//            Socket
//        } pipeType {PipeType::None};
    Tag tags;
};

int parseConfigInit(Config *config);
int parseConfigProcess(Config *config, size_t dataLen, void *data);
int parseConfigFinish(Config *config);
void parseConfigFree(Config *config);
