; ------------------------------------------------------------------------------
; https://asmtutor.com/#lesson13 "Calculator - subtraction"
;
; assemble and link as follows:
;   $ nasm -f macho64 13_calculator_subtraction.asm
;   $ ld -lSystem 13_calculator_subtraction.o

%include    'functions.asm'

    global      _main

; ------------------------------------------------------------------------- code

    section     .text

_main:
    mov         rdi, 0x10
    sub         rdi, 0x11
    call        iprint_signed
    cmp         rax, 0x0
    jne         done_errors

done:
    call        exit_no_errors

done_errors:
    call        exit_with_error
