#include <string.h>
#include <stdio.h>
#include <thread>

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
    puts("==============");


	return 0;
}
