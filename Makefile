# Nome do arquivo principal (sem a extensão .tex)
DOC = template

# Compilador
CC = pdflatex

# Regra padrão (o que acontece quando você digita apenas 'make')
all: $(DOC).pdf

# Regra para gerar o PDF
$(DOC).pdf: $(DOC).tex
	@echo "Compilando $(DOC).tex..."
	$(CC) $(DOC).tex
	# Rodamos uma segunda vez para garantir alinhamentos e referências cruzadas, se houver
	$(CC) $(DOC).tex

# Regra para limpar arquivos temporários (aux, log, out)
clean:
	@echo "Limpando arquivos temporários..."
	rm -f *.aux *.log *.out *.toc *.fls *.fdb_latexmk *.synctex.gz

# Regra para limpar tudo, inclusive o PDF final
purge: clean
	@echo "Removendo PDF..."
	rm -f $(DOC).pdf

.PHONY: all clean purge
