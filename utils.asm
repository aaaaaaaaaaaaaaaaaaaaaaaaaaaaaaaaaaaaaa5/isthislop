global _strlen
global _revstr
global _itoa_impl
global _atoi_impl
global _print
global _trim_newline

; rsi: a ptr to the str that you want to know the length of
_strlen:
    xor rdx, rdx
_strlen_loop:
    cmp BYTE [rsi+rdx], 0x00
    je _strlen_exit
    inc rdx
    jmp _strlen_loop
_strlen_exit:
    ret

;this function is taken from the same webiste as the itoa function
;HURRAH THIS ACTUALLY WORKS OMG
; rsi: a ptr to the string to be reversed (must be null-terminated)
_revstr:
    push rcx
    push rax
    xor r11, r11
    ; rdx is 'end'
    call _strlen
    dec rdx
_revstr_loop:
    cmp r11, rdx
    jge _revstr_exit
    mov cl, BYTE [rsi+r11]
    mov al, BYTE [rsi+rdx]
    mov BYTE [rsi+rdx], cl
    mov BYTE [rsi+r11], al
    dec rdx
    inc r11
    jmp _revstr_loop

_revstr_exit:
    pop rax
    pop rcx
    ret



; rsi: a ptr to the str that will be printed
_print:
    push rax
    push rdi
    mov rax, 1
    mov rdi, 1
    call _strlen
    syscall
    pop rdi
    pop rax
    ret



; rsi: a ptr to a string that is big enough to fit the number inside of
; rbx: the number to convert into a string
; rcx: base of the number in rbx
; returns nothing in rax but modifies the rsi string directly
_itoa_impl: 
    cmp rbx, 0
    je _itoa_impl_numiszero
    jl _itoa_impl_negchk
    xor r10, r10 ; this is 'i'
    push r11
    xor r11, r11
_itoa_impl_loop:
    cmp rbx, 0
    je _itoa_impl_exit
    mov rdx, 0
    mov rax, rbx
    div rcx
    cmp rdx, 9
    jg _itoa_impl_alt
    ; str[i] = rdx + '0'
    add rdx, '0'
    mov BYTE [rsi+r10], dl
    inc r10
    ;num = num \ base
    mov rbx, rax
    jmp _itoa_impl_loop

_itoa_impl_alt:
    ; we do: str[i] = (rdx - 10) + 'a'
    
    sub rdx, 10
    add rdx, 'a'
    mov BYTE [rsi+r10], dl
    ;i++
    inc r10
    ; num = num / base
    mov rax, rbx
    xor rdx, rdx
    div rcx
    mov rbx, rax
    jmp _itoa_impl_loop

_itoa_impl_negchk:
    cmp rcx, 10
    je _itoa_set_negflag
    xor r10, r10
    jmp _itoa_impl_loop
_itoa_set_negflag:
    mov r11, 1
    imul rbx, -1
    xor r10, r10
    jmp _itoa_impl_loop

_itoa_impl_numiszero:
    mov BYTE [rsi], '0'
    mov BYTE [rsi+1], 0x00
    ret

_itoa_impl_exitalt:
    mov BYTE [rsi+r10], '-'
    inc r10
    jmp _itoa_impl_exit2

_itoa_impl_exit:
    cmp r11, 1
    je _itoa_impl_exitalt
_itoa_impl_exit2:
    mov BYTE [rsi+r10], 0x00
    call _revstr
    pop r11
    ret

; rsi: a ptr to the string that contains the number
; returns in rax the number
_atoi_impl:
    push rcx
    xor rcx, rcx
    xor r10, r10 ; this is i
    xor rax, rax ; this is our return value

_atoi_impl_loop:
    cmp BYTE [rsi+r10], 0x00
    je _atoi_impl_exit
    mov cl , BYTE [rsi+r10]
    sub cl, '0'
    mul rax, 10
    add rax, rcx
    inc r10
    jmp _atoi_impl_loop    


_atoi_impl_exit:
    pop rcx
    ret
