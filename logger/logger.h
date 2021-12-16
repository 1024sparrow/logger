#include <stdint.h>

#include <list>
#include <thread>

class Logger
{
public:

    struct Settings // Эту структуру мы должны заполнить по содержимому конфигурационного файла
    {
        struct Tag
        {
            bool showOnScreen {true};
            const char *tag;
            const char *directory {nullptr};
            const char *baseFileName {nullptr};
            uint32_t fileSizeLimit;
            uint64_t directorySizeLimit;
            enum class CompressType
            {
                None
            } compressType;
            bool binary;
            std::list<Tag *> subtags;
        };

        bool printToTty {false};
        const char *pipePath;
        enum class PipeType
        {
            Pipe, // как-то так...
            Socket
        } pipeType;
        Tag tags;
    };

    Logger();

private:
};
