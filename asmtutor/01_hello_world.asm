; --------------------------------------------------------------------------------
; https://asmtutor.com/#lesson1 "Hello, world!"
;
; assemble and link as follows:
;   $ nasm -f macho64 01_hello_world.asm
;   $ ld -lSystem 01_hello_world.o


; LABELS    INSTRUCTIONS    OPERANDS            LINE COMMENTS

; --------------------------------------------------------------- global directive
            global          _main               ; the macos linker looks for label
                                                ; '_main' as the main entry point.

; ------------------------------------------------------------------ section .text
            section         .text
_main:
            ; note in the following code how the registers for the system call
            ; arguments are different for x86-32 and x86-64 (see System V ABI
            ; conventions).
            mov             rax, 0x02000004     ; system call for write
            mov             rdi, 1              ; file handle 1 is stdout
            mov             rsi, message        ; address of string to output
            mov             rdx, 13             ; number of bytes
            syscall                             ; invoke operating system to
                                                ; do the write

            ; a segmentation fault will occur here because the program is not stopped
            ; and the program counter advances into an invalid memory region.

; -------------------------------------------------------------------------- .text
            section         .data
message:
            db              "Hello, World", 10  ; note the new line at the end

