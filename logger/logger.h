#include <stdint.h>

#include <list>
#include <thread>

class Logger final
{
public:

    struct Settings // Эту структуру мы должны заполнить по содержимому конфигурационного файла
    {
        struct Tag
        {
            bool showOnScreen {true};
            const char *tag {nullptr};
            const char *directory {nullptr};
            const char *baseFileName {nullptr};
            uint32_t fileSizeLimit;
            uint64_t directorySizeLimit;
            enum class CompressType
            {
                None
            } compressType {CompressType::None};
            bool binary;
            std::list<Tag *> subtags;
        };

        size_t bufferSize {4096};
        bool printToTty {false};
        const char *pipePath {nullptr};
        enum class PipeType
        {
            None,
            Pipe, // как-то так...
            Socket
        } pipeType {PipeType::None};
        Tag tags;
    };

    Logger(const Settings &settings);
    ~Logger();

    void start();
    void routine();

private:
    Settings _settings;
    std::thread _t;
    void *_buffer;
};
