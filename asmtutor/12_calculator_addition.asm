; ------------------------------------------------------------------------------
; https://asmtutor.com/#lesson12 "Calculator - addition"
;
; assemble and link as follows:
;   $ nasm -f macho64 12_calculator_addition.asm
;   $ ld -lSystem 12_calculator_addition.o

%include    'functions.asm'

    global      _main

; ------------------------------------------------------------------------- code

    section     .text

_main:

    mov         rax, 0x10
    mov         rbx, 0x10
    add         rax, rbx
    mov         rdi, rax

    call        iprint
    cmp         rax, 0x0
    jne         done_errors

done:
    call        exit_no_errors

done_errors:
    call        exit_with_error
