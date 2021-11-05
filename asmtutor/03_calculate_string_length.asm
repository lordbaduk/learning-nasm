; --------------------------------------------------------------------------------
; https://asmtutor.com/#lesson3 "Calculate string length"
;
; assemble and link as follows:
;   $ nasm -f macho64 03_calculate_string_length.asm
;   $ ld -lSystem 03_calculate_string_length.o

; LABELS    INSTRUCTIONS    OPERANDS           COMMENTS

; --------------------------------------------------------- entry point definition
            global          _main

; --------------------------------------------------------------------------- code
            section         .text

_main:
            mov             rax, 0x02000004     ; opcode: system call for write
            mov             rdi, 1              ; arg1: file handle 1 is stdout
            mov             rsi, message        ; arg2: address of string to output
            mov             rdx, rsi            ; pointer to be incremented for
                                                ; calculating the string length

nextchar:
            cmp             byte [rdx], 0       ; is the byte at rax equal to zero?
            jz              finished            ; yes: jump to finish
            inc             rdx                 ; no:  increment rdx by one byte ..
            jmp             nextchar            ;      .. and jump to nextchar

finished:
            sub             rdx, rsi            ; arg3: number of bytes (here computed by
                                                ; subtracting the pointer to the string start
                                                ; from the pointer to the string end, computed
                                                ; by the loop above and stored in rdi)
            syscall

            mov             rax, 0x02000001     ; syscall exit
            mov             rdi, 0              ; no errors
            syscall

; --------------------------------------------------------------------------- data
            section         .data

message:
            db              "Hello Assembly!", 0Ah
