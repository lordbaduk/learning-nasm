; ------------------------------------------------------------------------------
; https://asmtutor.com/#lesson9 "User input"
;
; assemble and link as follows:
;   $ nasm -f macho64 09_user_input.asm
;   $ ld -lSystem 09_user_input.o

%include    'functions.asm'

    global      _main

; --------------------------------------------------------------- reserved space

    section     .bss

user_input:     RESB    16           ; reserve 16 bytes for user input

; ---------------------------------------------------------------------- strings

    section     .data

user_prompt     db  "Please enter your name: ", 0x0
welcome_msg     db  "Welcome ", 0x0

; ------------------------------------------------------------------------- code

    section     .text

_main:

    ; print user prompt
    mov         rdi, user_prompt
    call        sprint

    ; read user input
    mov         rax, 0x02000003     ; system call for read
    mov         rdi, 0              ; arg1: fd, read from stdin
    mov         rsi, user_input     ; arg2: target buffer
    mov         rdx, 16             ; arg3: buffer size (bytes)
    syscall

    ; print personalized welcome message
    mov         rdi, welcome_msg
    call        sprint
    mov         rdi, user_input
    call        sprintln

    ; done
    call        exit_no_errors
