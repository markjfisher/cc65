// Dominic Beesley, 2005
// Mark Fisher, 2026
//

#ifndef types_H
#define types_H

/* 
 * Base types for BBC Micro cc65 library.
 */

typedef unsigned int                            bits;
typedef unsigned long                           bits32;
typedef signed char                             osbool;
typedef unsigned char                           byte;

#ifndef NULL
#define NULL                                    0
#endif
#ifndef FALSE
#define FALSE                                   ((osbool) 0)
#endif
#ifndef TRUE
#define TRUE                                    ((osbool) 1)
#endif
#ifndef UNKNOWN
#define UNKNOWN                                 1
#endif

#endif