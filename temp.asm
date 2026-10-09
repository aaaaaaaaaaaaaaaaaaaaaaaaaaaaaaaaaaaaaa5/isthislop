section .text
global _start
extern _atoi_impl
extern _itoa_impl
extern _print
extern _trim_newline

_start:
    mov rax, 0
    mov rdi, 0
    lea rsi, str
    mov rdx, 1024
    syscall
    call _atoi_impl

    call _print
    
    mov rbx, rax
    mov rcx, 10
    call _itoa_impl

    call _print
    jmp _exit
	


_exit:
	mov rax, 60
	mov rdi, 0
	syscall



section .data
    str2: db "Hello world!", 0x0A, 0x00 ; just for testing the _revstr subroutine
    ;\n!dlrow olleH\0"
    temp: db 0x0A, 0x00

section .bss
    str: resb 1024
    