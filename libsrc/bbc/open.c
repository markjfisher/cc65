#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include "fdtable.h"
#include <errno.h>
#include <stdarg.h>

//??? doesnt work for all flags yet! danger will overwrite when it shouldnt!

unsigned char __fastcall__ osfind(unsigned char mode, const char *name);
int __fastcall__ close_file(unsigned char channel);
extern char *bbc_string_buf;

int open(const char *name, int flags, ...) {
    char *p;
    unsigned char channel;
    unsigned char fd_flags;
    int fd;
        
    // Copy bbc_string_buf to avoid modifying the original string
    strcpy(bbc_string_buf, name);
    
    // bbc requires $0D as filename terminator
    p = strchr(bbc_string_buf, '\0');
    *p = '\x0D';
    
    // Fix the flag checking logic
    if ((flags & O_RDWR) == O_RDONLY) {
        channel = osfind(0x40, bbc_string_buf);
        fd_flags = FD_FLAG_READ;
    } else if ((flags & O_RDWR) == O_WRONLY) {
        channel = osfind(0x80, bbc_string_buf);
        fd_flags = FD_FLAG_WRITE;
    } else if ((flags & O_RDWR) == O_RDWR) {
        channel = osfind(0xc0, bbc_string_buf);
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