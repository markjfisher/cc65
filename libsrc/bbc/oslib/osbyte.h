#ifndef osbyte_H
#define osbyte_H

/* C header for BBC Micro OSBYTE calls.
 *
 * Adapted from the OSLib OSByte header. Retains the subset of
 * OSBYTE operations and variables that are meaningful on the
 * BBC Micro MOS. The RISC OS-only configure and extended
 * variable constants have been removed.
 */

#ifndef types_H
#include "oslib/types.h"
#endif

#ifndef os_H
#include "oslib/os.h"
#endif

typedef byte osbyte_op;
typedef byte osbyte_var;

/* OSBYTE reason codes */
#define osbyte_VERSION                          ((osbyte_op) 0x0u)
#define osbyte_USER_FLAG                        ((osbyte_op) 0x1u)
#define osbyte_INPUT_STREAM                     ((osbyte_op) 0x2u)
#define osbyte_OUTPUT_STREAMS                   ((osbyte_op) 0x3u)
#define osbyte_INTERPRETATION_ARROWS            ((osbyte_op) 0x4u)
#define osbyte_PRINTER                          ((osbyte_op) 0x5u)
#define osbyte_IGNORE_CHAR                      ((osbyte_op) 0x6u)
#define osbyte_DISABLE_EVENT                    ((osbyte_op) 0xDu)
#define osbyte_ENABLE_EVENT                     ((osbyte_op) 0xEu)
#define osbyte_FLUSH_BUFFERS                    ((osbyte_op) 0xFu)
#define osbyte_AWAIT_VSYNC                      ((osbyte_op) 0x13u)
#define osbyte_UPDATE_KEYBOARD                  ((osbyte_op) 0x76u)
#define osbyte_SCAN_KEYBOARD                    ((osbyte_op) 0x79u)
#define osbyte_CLEAR_ESCAPE                     ((osbyte_op) 0x7Cu)
#define osbyte_SET_ESCAPE                       ((osbyte_op) 0x7Du)
#define osbyte_ACKNOWLEDGE_ESCAPE               ((osbyte_op) 0x7Eu)
#define osbyte_READ_EOF_STATUS                  ((osbyte_op) 0x7Fu)
#define osbyte_BUFFER_OP                        ((osbyte_op) 0x80u)
#define osbyte_IN_KEY                           ((osbyte_op) 0x81u)
#define osbyte_READ_TOP                         ((osbyte_op) 0x84u)
#define osbyte_TEXT_CURSOR_POSITION             ((osbyte_op) 0x86u)
#define osbyte_SCREEN_CHAR                      ((osbyte_op) 0x87u)
#define osbyte_OPT                              ((osbyte_op) 0x8Bu)
#define osbyte_TV                               ((osbyte_op) 0x90u)
#define osbyte_BUFFER_REMOVE                    ((osbyte_op) 0x91u)
#define osbyte_BUFFER_STATUS                    ((osbyte_op) 0x98u)
#define osbyte_WRITE_VDU_CONTROL                ((osbyte_op) 0x9Au)
#define osbyte_READ_CMOS                        ((osbyte_op) 0xA1u)
#define osbyte_WRITE_CMOS                       ((osbyte_op) 0xA2u)
#define osbyte_CPU_TYPE                         ((osbyte_op) 0xA4u)

/* Buffer operation sub-commands (for osbyte_BUFFER_OP) */
#define osbyte_OP_JOYSTICK_STATE                0
#define osbyte_OP_CHANNEL_POSITION1             1
#define osbyte_OP_CHANNEL_POSITION2             2
#define osbyte_OP_CHANNEL_POSITION3             3
#define osbyte_OP_CHANNEL_POSITION4             4
#define osbyte_OP_MOUSE_BUFFER_USED             246
#define osbyte_OP_PRINTER_BUFFER_FREE           252
#define osbyte_OP_SERIAL_OUTPUT_BUFFER_FREE     253
#define osbyte_OP_SERIAL_INPUT_BUFFER_USED      254
#define osbyte_OP_KEYBOARD_BUFFER_USED          255

/* OSBYTE variable addresses */
#define osbyte_VAR_VSYNC_TIMER                  ((osbyte_var) 0xB0u)
#define osbyte_VAR_INPUT_STREAM                 ((osbyte_var) 0xB1u)
#define osbyte_VAR_KEYBOARD_SEMAPHORE           ((osbyte_var) 0xB2u)
#define osbyte_VAR_IGNORE_STATE                 ((osbyte_var) 0xB6u)
#define osbyte_VAR_ESCAPE_STATE                 ((osbyte_var) 0xE5u)
#define osbyte_VAR_ESCAPE_EFFECTS               ((osbyte_var) 0xE6u)

/* Reset types */
#define os_RESET_SOFT                           0
#define os_RESET_POWER_ON                       1
#define os_RESET_HARD                           2

/* Caps lock state */
#define osbyte_CAPS_SHIFT                       0x1u
#define osbyte_CAPS_NONE                        0x2u
#define osbyte_CAPS_LOCK                        0x4u

/* Function declarations */
extern os_error *xos_byte (osbyte_op op,
      int r1,
      int r2,
      int *r1_out,
      int *r2_out);
extern void os_byte (osbyte_op op,
      int r1,
      int r2,
      int *r1_out,
      int *r2_out);

extern os_error *xosbyte (osbyte_op op,
      int r1,
      int r2);
extern void osbyte (osbyte_op op,
      int r1,
      int r2);

extern os_error *xosbyte1 (osbyte_op op,
      int r1,
      int r2,
      int *r1_out);
extern int osbyte1 (osbyte_op op,
      int r1,
      int r2);

extern os_error *xosbyte2 (osbyte_op op,
      int r1,
      int r2,
      int *r2_out);
extern int osbyte2 (osbyte_op op,
      int r1,
      int r2);

extern os_error *xosbyte_read (osbyte_var var,
      int *value);
extern int osbyte_read (osbyte_var var);

extern os_error *xosbyte_write (osbyte_var var,
      int value);
extern void osbyte_write (osbyte_var var,
      int value);

#endif