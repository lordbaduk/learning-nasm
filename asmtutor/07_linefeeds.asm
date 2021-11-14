; ------------------------------------------------------------------------------
; https://asmtutor.com/#lesson7 "Linefeeds"
;
; assemble and link as follows:
;   $ nasm -f macho64 07_linefeeds.asm
;   $ ld -lSystem 07_linefeeds.o

%include    'functions.asm'

    global      _main

; ---------------------------------------------------------------------- strings

    section     .data

message1:
    db          "Hello world!", 0h
message2:
    db          "Assembly is cool.", 0h

; ------------------------------------------------------------------------- code

    section     .text

_main:

    mov         rdi, message1
    call        sprintln
    cmp         rax, 0
    jne         quit_error

    mov         rdi, message2
    call        sprintln
    cmp         rax, 0
    jne         quit_error

    call        exit_no_errors

quit_error:
    call        exit_with_error
