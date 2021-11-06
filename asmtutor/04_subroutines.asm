; --------------------------------------------------------------------------------------------------
; https://asmtutor.com/#lesson4 "Subroutines"
;
; assemble and link as follows:
;   $ nasm -f macho64 04_subroutines.asm
;   $ ld -lSystem 04_subroutines.o

; LABELS    INSTRUCTIONS    OPERANDS           COMMENTS

; --------------------------------------------------------------------------- entry point definition
            global          _main

; --------------------------------------------------------------------------------------------- code
            section         .text

_main:

            mov             rdi, message        ; argument to strlen
            call            strlen
            mov             rdx, rax            ; arg3: string length argument for write system call

            mov             rax, 0x02000004     ; opcode: system call for write
            mov             rdi, 1              ; arg1: file handle 1 is stdout
            mov             rsi, message        ; arg2: address of string to output
            syscall

            mov             rax, 0x02000001     ; syscall exit
            mov             rdi, 0              ; no errors
            syscall

; ---------------------------------------------------------------------------------- function strlen
; Takes as input a pointer to the start of a string (rdi) and computes its length (rax).
strlen:
            push            rbx                 ; back up rbx
            mov             rbx, rdi            ; initialize rbx for local use: increment until
                                                ; reaching null character. rax could also be used
                                                ; directly, but this code should also demo the
                                                ; push/pop stack usage.

nextchar:
            cmp             byte [rbx], 0       ; end of string?
            jz              finished            ; yes: break from loop
            inc             rbx                 ; no: increment by one byte and loop
            jmp             nextchar

finished:
            sub             rbx, rdi            ; compute string length
            mov             rax, rbx            ; store it in return register
            pop             rbx                 ; pop stack value back into rbx
            ret                                 ; return from function 'strlen'


; --------------------------------------------------------------------------------------------- data
            section         .data

message:
            db              "Hello Assembly!", 0Ah
