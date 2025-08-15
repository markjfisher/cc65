/*
 * Simple test program to demonstrate ROM detection
 */

#include <stdio.h>

// Declare our ROM detection functions
extern unsigned char clib_rom_available;
extern int strlen_rom_demo(const char* str);

int main(void) {
    const char* test_string = "Hello, ROM world!";
    int length;
    
    printf("cc65 BBC ROM Detection Test\n");
    printf("===========================\n");
    
    if (clib_rom_available) {
        printf("cc65 CLIB ROM detected!\n");
        printf("Using ROM-based string functions.\n");
    } else {
        printf("No ROM detected.\n");
        printf("Using local implementations.\n");
    }
    
    printf("\nTesting strlen_rom_demo:\n");
    printf("String: \"%s\"\n", test_string);
    
    length = strlen_rom_demo(test_string);
    printf("Length: %d\n", length);
    
    return 0;
}
