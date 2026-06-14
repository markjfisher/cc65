#ifndef osgbpb_H
#define osgbpb_H

/* C header file for BBC Micro OSGBPB calls.
 *
 * Adapted from the OSLib OSGBPB header. Retains BBC Micro-relevant
 * OSGBPB reason codes and minimal structure definitions. The RISC OS
 * extended/stamped info variants have been removed.
 *
 * Note: No osgbpb function implementations currently exist in the
 * bbc target library. These are provided here as a reference for
 * the OSGBPB API. Applications that need OSGBPB should call it
 * directly via the BBC MOS entry point at &FFD1 or use the
 * OSGBPB constant definitions below.
 */

#ifndef types_H
#include "oslib/types.h"
#endif

#ifndef os_H
#include "oslib/os.h"
#endif

/* OSGBPB reason codes */
#define OSGBPB_WriteAt                          0x1
#define OSGBPB_Write                            0x2
#define OSGBPB_ReadAt                           0x3
#define OSGBPB_Read                             0x4
#define OSGBPB_ReadDiscName                     0x5
#define OSGBPB_ReadCSDName                      0x6
#define OSGBPB_ReadLibName                      0x7
#define OSGBPB_CSDEntries                       0x8
#define OSGBPB_DirEntries                       0x9

/* Structure declarations */
typedef struct osgbpb_name                      osgbpb_name;
typedef struct osgbpb_disc_name                 osgbpb_disc_name;
typedef struct osgbpb_dir_name                  osgbpb_dir_name;

struct osgbpb_name
   {  byte count;
      char c [1];
   };

struct osgbpb_disc_name
   {  osgbpb_name name;
   };

struct osgbpb_dir_name
   {  byte reserved;
      osgbpb_name name;
   };

#endif