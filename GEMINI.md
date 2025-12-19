# Directory Overview

This directory contains a LaTeX template for creating documents for the "Academia Barcarenense de Letras". It includes a shell script to automate the process of generating PDFs from text files.

# Key Files

*   `template.tex`: The main LaTeX template file. It defines the document structure and includes placeholders for the title, content, and author.
*   `gerar_pdf.sh`: A shell script that takes a title, author, and a text file as input, and generates a PDF using the `template.tex` file.
*   `Makefile`: Provides commands for compiling the LaTeX template and cleaning up temporary files.
*   `poema.txt`: An example text file to be used with the `gerar_pdf.sh` script.
*   `exemplo.pdf`: An example of the final PDF output.

# Usage

There are two main ways to use this template:

## 1. Using the `gerar_pdf.sh` script (Recommended)

This method is ideal for creating documents from plain text files.

1.  Make sure the script is executable:
    ```bash
    chmod +x gerar_pdf.sh
    ```
2.  Run the script with the title, author, and the path to your text file:
    ```bash
    ./gerar_pdf.sh "Your Title" "Your Name" "path/to/your/textfile.txt"
    ```
    For example:
    ```bash
    ./gerar_pdf.sh "Meu Poema" "Sebastião" "poema.txt"
    ```
3.  The script will generate a PDF in the root directory.

## 2. Using the `Makefile`

This method is for compiling the `template.tex` file directly. You will need to manually edit the `.tex` file to add your content.

*   To compile the `template.tex` file and generate `template.pdf`:
    ```bash
    make
    ```
*   To remove temporary files (`.aux`, `.log`, `.out`, etc.):
    ```bash
    make clean
    ```
*   To remove temporary files and the generated PDF:
    ```bash
    make purge
    ```
