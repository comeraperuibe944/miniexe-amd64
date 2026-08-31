bits 64
;   DOS .EXE header
    db                          'MZ'                            ;   Magic number (DOS Signature)
    dw                          0                               ;   [UNUSED] Bytes on last page of file
_IMAGE_NT_HEADERS64:
    db                          'PE', 0, 0                      ;   [UNUSED] Pages in file & [UNUSED] Relocations | Signature
;   _IMAGE_FILE_HEADER
    dw                          0x8664                          ;   [UNUSED] Size of header in paragraphs | Machine (AMD64 (K8))
    dw                          0                               ;   [UNUSED] Minimum extra paragraphs needed | Number of sections
    dd                          0                               ;   [UNUSED] Maximum extra paragraphs needed & [UNUSED] Initial (relative) SS value | [UNUSED] Time date stamp (Optional)
    dd                          0                               ;   [UNUSED] Initial SP value & [UNUSED] Checksum | [UNUSED] Pointer to symbol table (no COFF symbol table)
    dd                          0                               ;   [UNUSED] Initial IP value & [UNUSED] Initial (relative) CS value | [UNUSED] Number of symbols (no COFF symbol table)
    dw                          0                               ;   [UNUSED] File address of relocation table | [UNUSED] Size of optional header
    dw                          0x22f                           ;   [UNUSED] Overlay number | Characteristics (Relocation info stripped from file | File is executable  (i.e. no unresolved external references) | Line nunbers stripped from file | Local symbols stripped from file | App can handle >2gb addresses | Debugging info stripped from file in .DBG file)
_IMAGE_OPTIONAL_HEADER64_STANDARD_FIELDS:
;   [UNUSED] Reserved words & [UNUSED] OEM identifier (for e_oeminfo) & [UNUSED] OEM information; e_oemid specific & [UNUSED] Reserved words | Magic Number (PE32+) & [UNUSED] Major linker version & [UNUSED] Minor linker version & [UNUSED] Size of code & [UNUSED] Size of initialized data (no data section) & [UNUSED] Size of uninitialized data (no bss section) & Address of entry point & [UNUSED] Base of code & Image base
    dw                          0x20b
    db                          0
    db                          0
    dd                          0
    dd                          0
    dd                          0
    dd                          ENTRY
    dd                          0
;   _IMAGE_OPTIONAL_HEADER64_WINDOWS_SPECIFIC_FIELDS
    dq                          0x10000
    dd                          _IMAGE_NT_HEADERS64             ;   File address of new exe header | Section alignment
    dd                          4                               ;   File alignment (SectionAlignment is less than the architecture's page size)
    dw                          0                               ;   [UNUSED] Major image version
    dw                          0                               ;   [UNUSED] Minor image version
    dw                          0                               ;   [UNUSED] Major Operating System version
    dw                          0                               ;   [UNUSED] Minor Operating System version
    dw                          4                               ;   Major subsystem version
    dw                          0                               ;   [UNUSED] Minor subsystem version
    dd                          0                               ;   [UNUSED] Win32 version value (Reserved, must be zero)
    dd                          FILE_SIZE                       ;   Size of image
    dd                          0                               ;   [UNUSED] Size of headers
    dd                          0                               ;   [UNUSED] CheckSum (no checksum)
    dw                          3                               ;   Subsystem (Image runs in the Windows character subsystem)
    dw                          0                               ;   [UNUSED] Dll characteristics (Image is NX compatible)
    dq                          0                               ;   [UNUSED] Size of stack reserve
    dq                          0                               ;   [UNUSED] Size of stack commit
    dq                          0                               ;   [UNUSED] Size of heap reserve
    dq                          0                               ;   [UNUSED] Size of heap commit
    dd                          0                               ;   [UNUSED] Loader flags (Reserved, must be zero)
    dd                          0                               ;   Number of virtual address and sizes
    times                       127 db 0
HEADER_SIZE                     equ $ - $$
ENTRY:
    ret                                                         ;   return value (rax) is current instruction pointer (rip) = Image Base (0x10000) + offset of ENTRY (0x10b) = 0x1010b (65536 + 267 = 65803)
FILE_SIZE                       equ $ - $$
