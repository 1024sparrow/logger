#include "config.h"

#include <stdlib.h>

int parseConfigInit(Config *config)
{
    config = (Config *) malloc(sizeof(Config));
}

int parseConfigProcess(Config *config, size_t dataLen, void *data)
{
    return 1;
}

int parseConfigFinish(Config *config)
{
    return 1;
}

void parseConfigFree(Config *config)
{
    free(config);
}
