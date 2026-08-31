import os
import urllib.request
import zipfile
import subprocess
import sys
import glob

def download_nasm():
    if not os.path.exists("nasm.exe"):
        print("Baixando o NASM portátil...")
        url = "https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/win64/nasm-2.16.03-win64.zip"
        urllib.request.urlretrieve(url, "nasm.zip")
        with zipfile.ZipFile("nasm.zip", "r") as z:
            z.extract("nasm-2.16.03/nasm.exe")
        os.rename("nasm-2.16.03/nasm.exe", "nasm.exe")
        os.remove("nasm.zip")
        os.rmdir("nasm-2.16.03")
        print("NASM baixado com sucesso.")

def compile_all():
    download_nasm()
    
    asm_files = glob.glob("*.asm")
    if not asm_files:
        print("Nenhum arquivo .asm encontrado no diretório.")
        return

    for asm_file in asm_files:
        base_name = os.path.splitext(asm_file)[0]
        exe_file = base_name + ".exe"
        
        print(f"\n[{base_name}] Compilando {asm_file}...")
        try:
            subprocess.run(["nasm.exe", "-f", "bin", asm_file, "-o", exe_file], check=True)
        except subprocess.CalledProcessError as e:
            print(f"[{base_name}] Erro na compilação: {e}")
            continue
            
        print(f"[{base_name}] Compilação concluída.")
        size = os.path.getsize(exe_file)
        print(f"[{base_name}] Tamanho do executável: {size} bytes")
        
        print(f"[{base_name}] Executando {exe_file}...")
        result = subprocess.run([exe_file])
        exit_code = result.returncode
        
        print(f"[{base_name}] Código de saída (Exit Code): {exit_code} (0x{exit_code:X})")

if __name__ == "__main__":
    compile_all()
