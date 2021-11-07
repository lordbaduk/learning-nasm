; ------------------------------------------------------------------------------
; int@rax slen(string-ptr@rdi)
; computes the length of the given string
; ------------------------------------------------------------------------------
slen:
    mov     rax, rdi

nextchar:
    cmp     byte [rax], 0
    jz      finished
    inc     rax
    jmp     nextchar

finished:
    sub     rax, rdi
    ret

; ------------------------------------------------------------------------------
; int@rax sprint(string@rdi)
; prints the given string to the screen
; ------------------------------------------------------------------------------
sprint:
    push    rdx
    push    rdi
    push    rsi

    call    slen
    mov     rdx, rax          ; arg3(rdx): number of bytes

    mov     rax, 0x02000004   ; sys_write
    mov     rsi, rdi          ; arg2(rsi): pointer to string
    mov     rdi, 1            ; arg1(rdi): file handle
    syscall

    pop     rsi
    pop     rdi
    pop     rdx

    xor     rax, rax          ; return 0, no errors
    ret

; ------------------------------------------------------------------------------
; void exit_no_errors()
; terminates the program with sys_exit
; ------------------------------------------------------------------------------
exit_no_errors:
    mov     rax, 0x02000001   ; syscall exit
    xor     rdi, rdi          ; arg1(rdi): retval=0 (no errors)
    syscall

; ------------------------------------------------------------------------------
; void exit_with_error()
; terminates the program with sys_exit
; ------------------------------------------------------------------------------
exit_with_error:
    mov     rax, 0x02000001   ; syscall exit
    mov     rdi, 1            ; arg1(rdi): retval=1 (some error has occurred)
    syscall
