/*
 * Test program for bbc-clib ROM target
 * This should be small and use ROM functions
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(void) {
    const char* test_string = "Hello ROM World!";
    char buffer[50];
    int len;
    
    printf("=== BBC-CLIB ROM Target Test ===\n");
    
    // Test ROM string functions
    len = strlen(test_string);
    printf("String: \"%s\" (length: %d)\n", test_string, len);
    
    // Test ROM string copy
    strcpy(buffer, test_string);
    printf("Copied: \"%s\"\n", buffer);
    
    // Test ROM string concatenation  
    strcat(buffer, " + More!");
    printf("Concatenated: \"%s\"\n", buffer);
    
    // Test ROM math functions
    printf("abs(-42) = %d\n", abs(-42));
    printf("atoi(\"123\") = %d\n", atoi("123"));
    
    printf("\nROM target test completed successfully!\n");
    return 0;
}
