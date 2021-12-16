cmake_minimum_required(VERSION 2.8)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(SOURCES
	WIN32 main.cpp
    logger.h
    logger.cpp
)
#file(GLOB SOURCES *.cpp)
add_executable(logger ${SOURCES} ${RCC_SOURCES})
target_link_libraries(logger
        $<$<PLATFORM_ID:Linux>:pthread>
)

