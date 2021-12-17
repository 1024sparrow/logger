#include <stdio.h>

#include <sys/types.h> // open
#include <sys/stat.h> // open
#include <fcntl.h> // open
#include <unistd.h> // write, close
#include <string.h> // strlen

#include "logger.h"

#define CHECK_UNEXPECTED_KEY(T) if (T[0] == '-'){printf("Unexpected argument: %s\n", T);return 1;}

int main(int argc, char **argv)
{
    for (int iArg = 0 ; iArg < argc ; ++iArg)
	{
		char *arg = argv[iArg];
		if (!strcmp(arg, "--help"))
		{
			puts(R"(logger

Valid arguments:
--help
--generate-config <FILENAME>
--config <DILENAME>

Generate config first. Then change that config (if needed) and use it.

Source code available on https://github.com/1024sparrow/logger
)");
			return 0;
		}
	}

    enum
    {
        sNormal,
        sGenerateConfigPathExpected,
        sConfigPathExpected
    } state {sNormal};

    const char
        *configPath = nullptr,
        *generateConfigPath = nullptr
    ;
    for (int iArg = 1 ; iArg < argc ; ++iArg)
    {
        char *arg = argv[iArg];
        if (state == sNormal)
        {
            if (!strcmp(arg, "--generate-config"))
            {
                state = sGenerateConfigPathExpected;
            }
            else if (!strcmp(arg, "--config"))
            {
                state = sConfigPathExpected;
            }
            else CHECK_UNEXPECTED_KEY(arg)
            else
            {
                printf("Incorrect argument \"%s\". See help.\n", arg);
                return 1;
            }
        }
        else if (state == sGenerateConfigPathExpected)
        {
            CHECK_UNEXPECTED_KEY(arg);
            generateConfigPath = arg;
            state = sNormal;
        }
        else if (state == sConfigPathExpected)
        {
            CHECK_UNEXPECTED_KEY(arg);
            configPath = arg;
            state = sNormal;
        }
    }
    if (state == sGenerateConfigPathExpected)
    {
        puts("Expected a path generate config to");
        return 1;
    }
    else if (state == sConfigPathExpected)
    {
        puts("Path to config expected");
        return 1;
    }

    if (!configPath && !generateConfigPath)
    {
        puts("There is not arguments. Nothing to do.");
        return 1;
    }

    if (generateConfigPath)
    {
        int fdFile = open(
            generateConfigPath,
            O_CREAT | O_TRUNC | O_WRONLY,
            0644
        );
        if (fdFile < 0)
        {
            perror("can not open file to write configuration example");
            return 1;
        }
        const char *strConfigTemplate =
#include "config-template.txt"
        ;
        if (write(fdFile, strConfigTemplate, strlen(strConfigTemplate)) < 0)
        {
            perror("can not write configuration example");
        }
        close(fdFile);
    }
    if (configPath)
    {
//        Logger logger( // boris e: надо сделать инициализацию по содержимому конфигурационного файла
//            Logger::Settings{
//                true,
//                nullptr,
//                Logger::Settings::PipeType::None,
//                Logger::Settings::Tag {
//                    true,
//                    nullptr,
//                    "/home/boris/logs",
//                    "test-log",
//                    50,
//                    1024,
//                    Logger::Settings::Tag::CompressType::None,
//                    false
//                }
//            }
//        );
        Logger::Settings settings;
        Logger logger;
        logger.start(settings);
    }

	return 0;
}
