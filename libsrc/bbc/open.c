#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include "fdtable.h"
#include <errno.h>
#include <stdarg.h>

// This implementation requires fixing. Not all flags are supported

unsigned char __fastcall__ osfind(unsigned char mode, const char *name);
int __fastcall__ close_file(unsigned char channel);

int open(const char *name, int flags, ...) {
    char *p;
    unsigned char channel;
    unsigned char fd_flags;
    int fd;
    char filename[128];

    // Copy to filename to avoid modifying the original string
    // strncpy copies up to 127 chars and null-terminates, leaving room for $0D
    strncpy(filename, name, 127);
    filename[127] = '\0';  // Ensure null termination

    // bbc requires $0D as filename terminator
    p = strchr(filename, '\0');
    *p = '\x0D';

    // Fix the flag checking logic
    if ((flags & O_RDWR) == O_RDONLY) {
        channel = osfind(0x40, filename);
        fd_flags = FD_FLAG_READ;
    } else if ((flags & O_RDWR) == O_WRONLY) {
        channel = osfind(0x80, filename);
        fd_flags = FD_FLAG_WRITE;
    } else if ((flags & O_RDWR) == O_RDWR) {
        channel = osfind(0xc0, filename);
        fd_flags = FD_FLAG_READ | FD_FLAG_WRITE;
    } else {
        channel = 0; //error;
    }

    if (!channel) {
        __errno = EIO;    // Use errno symbol
        return -1;
    }

    fd = _fd_getfree(channel, fd_flags);

    if (fd == -1) {
        close_file(channel);
    }

    return fd;
}