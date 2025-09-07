/* Dominic Beesley 27.04.2005
*/

#include "fdtable.h"
#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include "lseek_extra.h"

off_t __fastcall__ lseek(int fd, off_t offset, int whence) {

	unsigned char channel, flags;

	off_t startpos;
		
	/* check the fd is ok */
	flags = _fd_getflags(fd);
	if (flags == 0xFF) 
		return -1;
	
	if (flags & FD_FLAG_CON)
		goto epipe;
		
	if (whence < 0 || whence >=3)
		goto einval;
		
	if (flags == 0xFF)
		return -1;
		
	channel = _fd_getchannel(fd);
		
	if (whence == SEEK_SET) {
		startpos = 0;
	} else if (whence == SEEK_CUR) {
		if (flags & FD_FLAG_SEEKPEND) {
			/* seek is already pending use that value */
			startpos = _fd_getseek(fd);
		} else {
			startpos = __ptr(channel);
		}
	} else {
		startpos = __ext(channel);
	}
	
	startpos = startpos + offset;

	if (startpos < 0) 
		goto einval;
		
	_fd_setseek(startpos, fd);
		
	return startpos;
	
einval:
	__errno = EINVAL;
	return -1;
		
epipe:
	__errno = ESPIPE;
	return -1;
		

}