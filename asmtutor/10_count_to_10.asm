; ------------------------------------------------------------------------------
; https://asmtutor.com/#lesson10 "Count to 10"
;
; assemble and link as follows:
;   $ nasm -f macho64 10_count_to_10.asm
;   $ ld -lSystem 10_count_to_10.o

%include    'functions.asm'

    global      _main

; ------------------------------------------------------------------------- code

    section     .data
newline         db  0x0A

; ------------------------------------------------------------------------- code

    section     .text

_main:
    mov         rbx, 0x0        ; count from 0 ..

counting_loop:
    cmp         rbx, 0x0A       ; .. to 10
    ja          done

    mov         rdi, rbx        ; put current number into rdi
    add         rdi, 0x30       ; add 48 to it to obtain ASCII encoding
    push        rdi             ; put character on stack
    mov         rdi, rsp        ; set pointer for sprintln parameter

    ; bug: sprintln expects NULL termination, but this is not guaranteed here!

    call        sprintln        ; print it
    pop         rdi             ; remove rsp/character from stack
    cmp         rax, 0x0
    jne         done_errors

    inc         rbx             ; increment the current number
    jmp         counting_loop

done:
    call        exit_no_errors

done_errors:
    call        exit_with_error
