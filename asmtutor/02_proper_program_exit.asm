; --------------------------------------------------------------------------------
; https://asmtutor.com/#lesson2 "Proper program exit"
;
; assemble and link as follows:
;   $ nasm -f macho64 02_proper_program_exit.asm
;   $ ld -lSystem 02_proper_program_exit.o


; LABELS    INSTRUCTIONS    OPERANDS           COMMENTS

; --------------------------------------------------------------- global directive
            global          _main

; ------------------------------------------------------------------ section .text
            section         .text
_main:
            mov             rax, 0x02000004     ; opcode: system call for write
            mov             rdi, 1              ; arg1: file handle 1 is stdout
            mov             rsi, message        ; arg2: address of string to output
            mov             rdx, 13             ; arg3: number of bytes
            syscall                             ; invoke operating system to
                                                ; do the write
            mov             rax, 0x02000001     ; opcode: system call for exit
            xor             rdi, rdi            ; arg1: exit code 0
            syscall                             ; invoke operating system to exit

; -------------------------------------------------------------------------- .text
            section         .data
message:
            db              "Hello, World", 10  ; note the new line at the end
