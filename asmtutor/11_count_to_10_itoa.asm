; ------------------------------------------------------------------------------
; https://asmtutor.com/#lesson11 "Count to 10 (itoa)"
;
; assemble and link as follows:
;   $ nasm -f macho64 11_count_to_10_itoa.asm
;   $ ld -lSystem 11_count_to_10_itoa.o

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
    cmp         rbx, 0x20       ; .. to 32
    ja          done            ; JA = jump-above

    mov         rdi, rbx
    call        iprint
    cmp         rax, 0x0
    jne         done_errors

    inc         rbx             ; increment the current number
    jmp         counting_loop

done:
    call        exit_no_errors

done_errors:
    call        exit_with_error
