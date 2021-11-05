; --------------------------------------------------------------------------------
; https://asmtutor.com/#lesson1 "Hello, world!"
;
; assemble and link as follows:
;   $ nasm -f macho64 01_hello_world.asm
;   $ ld -lSystem 01_hello_world.o


; LABELS    INSTRUCTIONS    OPERANDS           COMMENTS

; --------------------------------------------------------------- global directive
            global          _main

; ------------------------------------------------------------------ section .text
            section         .text
_main:
            mov             rax, 0x02000004     ; system call for write
            mov             rdi, 1              ; file handle 1 is stdout
            mov             rsi, message        ; address of string to output
            mov             rdx, 13             ; number of bytes
            syscall                             ; invoke operating system to
                                                ; do the write

            ; will segfault here

; -------------------------------------------------------------------------- .text
            section         .data
message:
            db              "Hello, World", 10  ; note the new line at the end

