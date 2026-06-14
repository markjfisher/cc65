#ifndef fileswitch_H
#define fileswitch_H

/* Shared type definitions for BBC MOS file operations.
 *
 * These types are used by osfile.h and osgbpb.h to describe
 * file object type and attribute values returned by BBC MOS
 * calls (OSFILE, OSGBPB, etc.).
 *
 * This header is a minimal adaptation of the OSLib FileSwitch
 * compatibility layer for RISC OS. On BBC Micro, the underlying
 * MOS calls (OSFILE, OSGBPB, OSFIND, OSBGET, OSBPUT, OSARGS)
 * provide file/directory metadata directly. The types here
 * simply wrap the MOS return values in a self-documenting form.
 */

#ifndef types_H
#include "oslib/types.h"
#endif

#ifndef os_H
#include "oslib/os.h"
#endif

typedef byte fileswitch_object_type;

#define fileswitch_NOT_FOUND    ((fileswitch_object_type) 0x0u)
#define fileswitch_IS_FILE      ((fileswitch_object_type) 0x1u)
#define fileswitch_IS_DIR       ((fileswitch_object_type) 0x2u)
#define fileswitch_IS_IMAGE     ((fileswitch_object_type) 0x3u)

#endif