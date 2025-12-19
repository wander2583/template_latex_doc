#!/usr/bin/env bash

# Uso: ./gerar_pdf.sh "Titulo do Poema" "Nome do Autor" arquivo_texto.txt

TITULO="$1"
AUTOR="$2"
ARQUIVO_TXT="$3"
TEMPLATE="template.tex"
BUILD_DIR="build"

# Verificações básicas
if [ -z "$ARQUIVO_TXT" ]; then
  echo "❌ Uso correto: ./gerar_pdf.sh \"Titulo\" \"Autor\" arquivo.txt"
  exit 1
fi

if [ ! -f "$TEMPLATE" ]; then
  echo "❌ Erro: Arquivo '$TEMPLATE' não encontrado."
  exit 1
fi

# Cria diretório de build para não sujar a pasta principal
mkdir -p $BUILD_DIR

# Nome do arquivo de saída (baseado no título, sem espaços)
NOME_SAIDA=$(echo "$TITULO" | iconv -t ascii//TRANSLIT | sed -r 's/[^a-zA-Z0-9]+/_/g' | tr '[:upper:]' '[:lower:]')

echo "🚀 Processando: $TITULO..."

# 1. Prepara o conteúdo do texto (substitui quebras de linha por \\ para o LaTeX)
# O comando sed aqui lê o arquivo txt e troca o fim de linha por " \\"
CONTEUDO_FORMATADO=$(sed ':a;N;$!ba;s/\\n\\n/\\n\\n\\\\par\\\\n\\n/g' "$ARQUIVO_TXT")

# 2. Cria o arquivo .tex final substituindo os placeholders
# Usamos perl para garantir que caracteres especiais não quebrem a substituição facilmente,
# mas aqui um sed robusto resolve para textos simples.
cp "$TEMPLATE" "$BUILD_DIR/$NOME_SAIDA.tex"

# Substituição via sed (usando | como delimitador para evitar conflito com barras)
sed -i "s|VAR_TITULO|$TITULO|g" "$BUILD_DIR/$NOME_SAIDA.tex"
sed -i "s|VAR_AUTOR|$AUTOR|g" "$BUILD_DIR/$NOME_SAIDA.tex"

# A injeção do conteúdo é mais delicada devido às quebras de linha.
# Vamos ler o template até a linha do CONTEUDO, inserir o texto, e ler o resto.
# (Método simplificado: usar um placeholder único que o sed substitui pelo arquivo pré-formatado)
# Nota: Para scripts complexos, Python seria melhor, mas vamos de Bash puro:
ESCAPED_CONTENT=$(echo "$CONTEUDO_FORMATADO" | sed 's/\\/\\\\/g' | sed 's/&/\\&/g')
# O comando acima é um escape básico. Se o poema tiver muitos símbolos, avise.

# Vamos usar awk para inserir o conteúdo de forma segura no lugar de VAR_CONTEUDO
awk -v r="$CONTEUDO_FORMATADO" '{gsub(/VAR_CONTEUDO/,r)}1' "$TEMPLATE" >"$BUILD_DIR/$NOME_SAIDA.tex"
# Re-aplicar título e autor no arquivo gerado pelo awk
sed -i "s|VAR_TITULO|$TITULO|g" "$BUILD_DIR/$NOME_SAIDA.tex"
sed -i "s|VAR_AUTOR|$AUTOR|g" "$BUILD_DIR/$NOME_SAIDA.tex"

# 3. Compilação
echo "⚙️  Compilando PDF..."
cd $BUILD_DIR
pdflatex -interaction=batchmode "$NOME_SAIDA.tex" >/dev/null

# Verifica se deu certo
if [ -f "$NOME_SAIDA.pdf" ]; then
  mv "$NOME_SAIDA.pdf" ../
  echo "✅ Sucesso! Arquivo gerado: $NOME_SAIDA.pdf"
  cd ..
  # Opcional: rm -rf $BUILD_DIR (se quiser limpar os temporários)
else
  echo "❌ Erro na compilação. Verifique o arquivo $BUILD_DIR/$NOME_SAIDA.log"
fi
