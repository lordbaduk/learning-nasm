; ------------------------------------------------------------------------------
; int@rax slen(string-ptr@rdi)
; computes the length of the given string
; ------------------------------------------------------------------------------
slen:
    mov     rax, rdi

slen_nextchar:
    cmp     byte [rax], 0   ; is this the NULL byte terminating the string?
    jz      slen_done
    inc     rax             ; no, so try the next one.
    jmp     slen_nextchar

slen_done:
    sub     rax, rdi        ; string length = pointer to terminating \0 minus
                            ; pointer to string start
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
; int@rax iprint(integer@rdi)
; converts the given decimal number to a string stored on the stack and prints
; it to the screen
; ------------------------------------------------------------------------------
iprint:
    push    rbx               ; backup rbx
    mov     rbx, rsp          ; backup (aligned) stack pointer

    dec     rsp               ; add one byte to stack (stack is misaligned!)
    mov     byte [rsp], 0x0   ; move NULL character (1 byte) to stack, this
                              ; will mark the end of the string to be printed.

    mov     rax, rdi          ; dividend in rax
    mov     rsi, 0x0A         ; divisor=10 (64 bits) as argument to idiv

iprint_divloop:
    xor     rdx, rdx          ; clear high bits of rdx:rax 128 bits dividend
    idiv    rsi               ; signed division: quotient in rax, remainder in rdx

    add     rdx, 0x30         ; add 48 to remainder to obtain ASCII encoding
    dec     rsp               ; add one byte to stack
    mov     byte [rsp], dl    ; nb: dl is the 0-byte in rdx

    cmp     rax, 0x0          ; if quotient is not null, do next loop
    jne     iprint_divloop

iprint_done:
    mov     rdi, rsp          ; the complete string starts at the stack pointer
    call    sprintln

    mov     rsp, rbx          ; restore stack pointer
    pop     rbx               ; restore rbx value
    ret

; ------------------------------------------------------------------------------
; int@rax iprint_signed(integer@rdi)
; prints integers from rdi including a '-' character for negative numbers.
; ------------------------------------------------------------------------------
iprint_signed:
    push    rdi                     ; some back-ups
    push    rbx
    mov     rbx, rdi                ; keep a copy of the input number

    test    rdi, rdi
    jge     iprint_signed_absnum    ; zero or a positive number can be printed "as-is"

iprint_signed_sign:
    mov     rax, 0x2D
    push    rax
    mov     rax, 0x02000004  ; sys_write
    mov     rdi, 1           ; arg1(rdi): file handle
    mov     rsi, rsp         ; arg2(rsi): character
    mov     rdx, 1           ; arg3(rdx): number of bytes
    syscall
    pop     rax

    ; mov     byte [rsp-1], 0x00
    ; mov     byte [rsp-2], 0x2D
    ; mov     rdi, rsp
    ; sub     rdi, 0x2

    mov     rdi, rbx
    call    twos_complement
    mov     rdi, rax

iprint_signed_absnum:
    call    iprint

    pop     rbx
    pop     rdi
    ret

; ------------------------------------------------------------------------------
; rax twos_complement(rdi)
; create the two's complement of the number in rdi
; ------------------------------------------------------------------------------
twos_complement:
    call    flip_bits
    add     rax, 0x1
    ret

; ------------------------------------------------------------------------------
; rax flip_bits(rdi)
; flips all bits in rdi (result in rdi)
; ------------------------------------------------------------------------------
flip_bits:
    mov     rax, -1     ; create a bitmask of all ones in rax (two's complement
                        ; of -1 is all ones)
    xor     rax, rdi    ; invert
    ret

; ------------------------------------------------------------------------------
; int@rax sprintln(string@rdi)
; prints the given string to the screen plus a terminating line feed (LF)
; ------------------------------------------------------------------------------
sprintln:
    call    sprint
    cmp     rax, 0
    jne     sprintln_done     ; error during sprint

    push    rsi               ; backup rsi
    mov     rsi, 0Ah          ; store LF in register
    push    rsi               ; push it to stack

    mov     rax, 0x02000004   ; sys_write
    mov     rdi, 1            ; arg1(rdi): file handle
    mov     rsi, rsp          ; arg2(rsi): stack pointer points to LF character
    mov     rdx, 1            ; arg3(rdx): number of bytes
    syscall

    pop     rsi               ; remove LF from stack
    pop     rsi               ; restore original rsi value
    xor     rax, rax          ; return 0, no errors

sprintln_done:
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
