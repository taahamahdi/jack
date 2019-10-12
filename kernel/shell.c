#include "shell.h"

// Handles calls to shell subroutines and clean-up on exit
void shell_interrupt_handler(int arg) {
    uint8_t scancode = inb(0x60);
    if (scancode == CMD_ACK) {
        outb(pop_buf_to(), 0x60);
        return;
    }

    uint8_t char_index = scancode & 0b01111111;
    int character = scancode_table[char_index];
    int release = (scancode & 0b10000000) >> 7;

    if (release) {
        if (character >= 0x61 && character <= 0x7a) {
            handle_alphabetical_character(character);
        } else if (character >= 0x30 && character <= 0x39) {
            handle_symbol_character(character);
        } else {
            handle_alt_release(character);
        }
    } else {
        handle_alt_press(character);
    }
    
    return;
}
