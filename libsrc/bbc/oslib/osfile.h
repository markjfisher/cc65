#ifndef osfile_H
#define osfile_H

/* C header file for BBC Micro OSFILE calls.
 *
 * Wraps the BBC MOS OSFILE entry point (&FFDD) which provides
 * file catalogue operations: save, load, write (attributes),
 * read catalogue info, and delete.
 *
 * Adapted from the OSLib OSFile header for cc65.
 * The xosfile_* variants return an os_error * on error;
 * the osfile_* variants return the object type directly.
 */

#ifndef types_H
#include "oslib/types.h"
#endif

#ifndef os_H
#include "oslib/os.h"
#endif

#ifndef fileswitch_H
#include "oslib/fileswitch.h"
#endif

#define osfile_NOT_FOUND                        ((fileswitch_object_type) 0x0u)
#define osfile_IS_FILE                          ((fileswitch_object_type) 0x1u)
#define osfile_IS_DIR                           ((fileswitch_object_type) 0x2u)
#define osfile_IS_IMAGE                         ((fileswitch_object_type) 0x3u)

#define osfile_FILE_TYPE_SHIFT                  8

extern os_error *xosfile_write (char const *file_name,
      bits32 load_addr,
      bits32 exec_addr,
      fileswitch_attr attr);
extern void osfile_write (char const *file_name,
      bits32 load_addr,
      bits32 exec_addr,
      fileswitch_attr attr);

extern os_error *xosfile_write_load (char const *file_name,
      bits32 load_addr);
extern void osfile_write_load (char const *file_name,
      bits32 load_addr);

extern os_error *xosfile_write_exec (char const *file_name,
      bits32 exec_addr);
extern void osfile_write_exec (char const *file_name,
      bits32 exec_addr);

extern os_error *xosfile_write_attr (char const *file_name,
      fileswitch_attr attr);
extern void osfile_write_attr (char const *file_name,
      fileswitch_attr attr);

extern os_error *xosfile_delete (char const *file_name,
      fileswitch_object_type *obj_type,
      bits32 *load_addr,
      bits32 *exec_addr,
      long *size,
      fileswitch_attr *attr);
extern fileswitch_object_type osfile_delete (char const *file_name,
      bits32 *load_addr,
      bits32 *exec_addr,
      long *size,
      fileswitch_attr *attr);

extern os_error * __cdecl__ xosfile_load (char const *file_name,
      byte *addr,
      fileswitch_object_type *obj_type,
      bits32 *load_addr,
      bits32 *exec_addr,
      long *size,
      fileswitch_attr *attr);
extern fileswitch_object_type __cdecl__ osfile_load (char const *file_name,
      byte *addr,
      bits32 *load_addr,
      bits32 *exec_addr,
      long *size,
      fileswitch_attr *attr);

extern os_error *xosfile_save (char const *file_name,
      bits32 load_addr,
      bits32 exec_addr,
      byte const *data,
      byte const *end);
extern void osfile_save (char const *file_name,
      bits32 load_addr,
      bits32 exec_addr,
      byte const *data,
      byte const *end);

extern os_error *xosfile_read (char const *file_name,
      fileswitch_object_type *obj_type,
      bits32 *load_addr,
      bits32 *exec_addr,
      long *size,
      fileswitch_attr *attr);
extern fileswitch_object_type osfile_read (char const *file_name,
      bits32 *load_addr,
      bits32 *exec_addr,
      long *size,
      fileswitch_attr *attr);

#endif