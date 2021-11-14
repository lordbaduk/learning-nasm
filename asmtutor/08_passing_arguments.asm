; ------------------------------------------------------------------------------
; https://asmtutor.com/#lesson8 "Passing arguments"
;
; assemble and link as follows:
;   $ nasm -f macho64 08_passing_arguments.asm
;   $ ld -lSystem 08_passing_arguments.o

%include    'functions.asm'

    global      _main

; ------------------------------------------------------------------------- code

    section     .text

_main:

    mov         rbx, rdi              ; use rbx for decrementing argc

next_arg:
    cmp         rbx, 0x0              ; any args left?
    je          done

    dec         rbx                   ; adjust offset multiplier
    mov         rdi, [rsi + 8 * rbx]  ; move argv[i] pointer from memory to rdi
    call        sprintln              ; print argv[i]

    cmp         rax, 0x0
    jnz         done_errors
    jmp         next_arg

done_errors:
    call        exit_with_error

done:
    call        exit_no_errors
