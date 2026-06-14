#ifndef types_H
#define types_H

/* Base types for BBC Micro cc65 library.
 *
 * Adapted from the OSLib types header.
 * (c) 1994 Jonathan Coxhead. cc65 adaptation (c) Dominic Beesley 2005.
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