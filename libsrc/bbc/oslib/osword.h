// Dominic Beesley, 2005
// Mark Fisher, 2026
//

#ifndef osword_H
#define osword_H

/* C header file for BBC Micro OSWORD calls.
 *
 * Adapted from the OSLib OSWord header. Retains only the BBC
 * Micro-relevant OSWORD reason codes and parameter blocks.
 */

#ifndef types_H
#include "oslib/types.h"
#endif

#ifndef os_H
#include "oslib/os.h"
#endif

/* OSWord reason codes */
#define OSWord_ReadLine                         0x0
#define OSWord_ReadSystemClock                  0x1
#define OSWord_WriteSystemClock                 0x2
#define OSWord_ReadIntervalTimer                0x3
#define OSWord_WriteIntervalTimer               0x4
#define OSWord_ReadIOSpace                      0x5
#define OSWord_WriteIOSpace                     0x6
#define OSWord_Sound                            0x7
#define OSWord_Envelope                         0x8
#define OSWord_ReadGCOL                         0x9
#define OSWord_ReadCharDefinition               0xA
#define OSWord_ReadPalette                      0xB
#define OSWord_WritePalette                     0xC
#define OSWord_ReadCursorPosition               0xD
#define OSWord_ReadClock                        0xE
#define OSWord_WriteClock                       0xF
#define OSWord_EconetTransmit                   0x10
#define OSWord_EconetReceive                    0x11
#define OSWord_WriteScreenBase                  0x16

/* Parameter block types */
typedef struct osword_line_block                osword_line_block;
typedef struct osword_timer_block               osword_timer_block;
typedef struct osword_char_definition_block     osword_char_definition_block;
typedef struct osword_palette_block             osword_palette_block;
typedef struct osword_cursor_position_block     osword_cursor_position_block;

struct osword_line_block
   {  short line;
      byte size;
      byte min_char;
      byte max_char;
   };

struct osword_timer_block
   {  byte b [5];
   };

struct osword_char_definition_block
   {  char c;
      byte definition [8];
   };

struct osword_palette_block
   {  os_gcol gcol;
      byte colour_number;
      byte r;
      byte g;
      byte b;
   };

struct osword_cursor_position_block
   {  short xprev;
      short yprev;
      short x;
      short y;
   };

#endif