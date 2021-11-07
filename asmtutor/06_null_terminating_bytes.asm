; ------------------------------------------------------------------------------
; https://asmtutor.com/#lesson5 "External include files"
;
; assemble and link as follows:
;   $ nasm -f macho64 05_external_include_files.asm
;   $ ld -lSystem 05_external_include_files.o

%include    'functions.asm'

    global      _main

; ---------------------------------------------------------------------- strings

    section     .data

message1:
    db          "Hello world!", 0Ah, 0h
message2:
    db          "Assembly is cool.", 0Ah, 0h

; ------------------------------------------------------------------------- code

    section     .text

_main:

    mov         rdi, message1
    call        sprint
    cmp         rax, 0
    jne         quit_error

    mov         rdi, message2
    call        sprint
    cmp         rax, 0
    jne         quit_error

    call        exit_no_errors

quit_error:
    call        exit_with_error