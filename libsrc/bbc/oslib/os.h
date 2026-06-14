#ifndef os_H
#define os_H

void OSWRCH(char);
void OSASCI(char);

#ifndef types_H
#include "oslib/types.h"
#endif

#define EVNTV_ESCAPE                            6

typedef int os_t;
typedef byte os_f;
typedef bits os_fw;
typedef byte os_gcol;
typedef byte os_tint;
typedef byte os_action;
typedef bits os_colour;
typedef int os_colour_number;

struct os_colour_pair
   {  os_colour on;
      os_colour off;
   };

struct os_error
   {  byte errnum;
      char errmess [254];
   };

#endif