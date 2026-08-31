bits 64

db 'MZ'
dw 0

_IMAGE_NT_HEADERS64:
db 'PE', 0, 0

dw 0x8664
dw 0
dd 0
dd 0
dd 0
dw 0
dw 0x22f

_IMAGE_OPTIONAL_HEADER64_STANDARD_FIELDS:
dw 0x20b
db 0
db 0
dd 0
dd 0
dd 0
dd ENTRY
dd 0

_IMAGE_OPTIONAL_HEADER64_WINDOWS_SPECIFIC_FIELDS:
dq 0x10000
dd _IMAGE_NT_HEADERS64
dd 4
dw 0
dw 0
dw 0
dw 0
dw 4
dw 0
dd 0
dd FILE_SIZE
dd 0
dd 0
dw 3
dw 0
dq 0
dq 0
dq 0
dq 0
dd 0
dd 0

times 127 db 0

ENTRY:
    sub rsp, 104            ; Aloca espaço na pilha

    ;#exemplo de comentario
    ; *** INSIRA SUAS LINHAS DE CODIGO AQUI ***
    mov rax, 666
    add rax, 669
    ; *****************************************

    mov [rsp+48], rax       ; salva o resultado da soma para retorno

    ; Localizar o PEB e a base do kernel32.dll (3º módulo na lista)
    mov rax, gs:[0x60]      ; PEB
    mov rax, [rax+0x18]     ; Ldr
    mov rax, [rax+0x20]     ; InMemoryOrderModuleList
    mov rax, [rax]          ; 1 (exe)
    mov rax, [rax]          ; 2 (ntdll.dll)
    mov rbp, [rax+0x20]     ; 3 (kernel32.dll base em RBP)

    ; Acessar o Export Directory do kernel32.dll
    mov eax, dword [rbp+0x3C]
    mov eax, dword [rbp+rax+0x88]
    add rax, rbp            
    
    mov r12d, dword [rax+0x18] ; R12D = NumberOfNames
    mov r13d, dword [rax+0x20] 
    add r13, rbp               ; R13 = AddressOfNames
    mov r14d, dword [rax+0x24]
    add r14, rbp               ; R14 = AddressOfNameOrdinals
    mov r15d, dword [rax+0x1C]
    add r15, rbp               ; R15 = AddressOfFunctions

    ; Loop para achar GetStdHandle
    mov r8d, r12d
find_getstdhandle:
    dec r8d
    jl exit                 
    mov esi, dword [r13+r8*4]
    add rsi, rbp            
    lea rdi, [rel get_std_handle_str]
    mov rcx, 13
    repe cmpsb
    jne find_getstdhandle

    ; GetStdHandle resolvido
    movzx r8d, word [r14+r8*2] 
    mov eax, dword [r15+r8*4]
    add rax, rbp            

    ; Chama GetStdHandle(-11)
    mov rcx, -11
    call rax
    mov [rsp+56], rax       ; Salva Handle do Terminal

    ; Loop para achar WriteFile
    mov r8d, r12d
find_writefile:
    dec r8d
    jl exit
    mov esi, dword [r13+r8*4]
    add rsi, rbp
    lea rdi, [rel write_file_str]
    mov rcx, 10
    repe cmpsb
    jne find_writefile

    ; WriteFile resolvido
    movzx r8d, word [r14+r8*2]
    mov eax, dword [r15+r8*4]
    add rax, rbp            
    mov [rsp+64], rax       ; Salva WriteFile

    ; Converter o número armazenado em [rsp+48] para string ascii
    mov rax, [rsp+48]
    mov rbx, 10
    lea rdi, [rel number_buffer + 15]
    mov byte [rdi], 10      ; Quebra de linha (\n)
    dec rdi
convert_loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz convert_loop

    inc rdi                 ; RDI aponta para o inicio da string
    
    ; Calcular tamanho
    lea r8, [rel number_buffer + 16]
    sub r8, rdi             ; R8 = Tamanho em bytes da string

    ; Chamar WriteFile
    ; RCX = hConsole, RDX = buffer, R8 = bytesToWrite, R9 = &bytesWritten
    mov rcx, [rsp+56]
    mov rdx, rdi
    lea r9, [rsp+80]
    mov qword [rsp+32], 0   ; lpOverlapped = NULL
    call qword [rsp+64]

exit:
    mov rax, [rsp+48]       ; Retorna a soma no Exit Code também
    add rsp, 104
    ret

get_std_handle_str db "GetStdHandle", 0
write_file_str db "WriteFile", 0
number_buffer times 16 db 0

ALIGN 4, db 0
FILE_SIZE equ $ - $$
