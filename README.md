# ⚙️ MiniEXE-AMD64 — Handcrafted Minimal Windows PE64 Executable

<p align="center">
  <img src="https://img.shields.io/badge/Architecture-x86--64%20%2F%20AMD64-ED1C24?style=for-the-badge&logo=amd&logoColor=white" />
  <img src="https://img.shields.io/badge/Assembler-NASM-6E4C13?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Format-PE32%2B%20(PE64)-0078D7?style=for-the-badge&logo=windows&logoColor=white" />
</p>

A hand-crafted 64-bit Windows executable (`PE32+`) built byte-by-byte in pure NASM assembly, completely omitting CRT libraries and external linkers to demonstrate deep low-level binary layout understanding.

## 🔬 Technical Overview
- **DOS Stub:** Overlapped MZ signature header with direct entry into NT headers.
- **PE32+ Header (`_IMAGE_NT_HEADERS64`):** Hand-aligned optional header fields, machine type `0x8664` (AMD64 / x86-64), section alignment, and custom image base (`0x10000`).
- **Entry Point & Return:** Direct CPU register manipulation and return code via `rax`.

## 🛠️ Building
Assemble directly using NASM:
```bash
nasm -f bin -o main.exe main.asm
```
Or run the Python build script:
```bash
python compilar.py
```
