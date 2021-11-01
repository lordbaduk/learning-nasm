; --------------------------------------------------------------------------------
; basic hello world example in NASM
;
; list of system calls on macos: /usr/include/sys/syscall.h
; /System/Volumes/Data/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/sys/syscall.h
;
; assemble and link as follows:
;    $ nasm -f macho64 hello_world.asm
;    $ ld -lSystem hello_world.o
; 


; LABELS    INSTRUCTIONS    OPERANDS    COMMENTS


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
            mov             rax, 0x02000001     ; system call for exit
            xor             rdi, rdi            ; exit code 0
            syscall                             ; invoke operating system to exit

; -------------------------------------------------------------------------- .text
            section         .data
message:
            db              "Hello, World", 10  ; note the new line at the end

