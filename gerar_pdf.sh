#!/usr/bin/env bash
# =========================================================================
# Script para Geração de PDFs com o Template da ABARCLE
# Autor: Gemini
# Versão: 2.0
# Data: 20/12/2025
# =========================================================================

set -e # Encerra o script se um comando falhar

# --- VARIÁVEIS E ARGUMENTOS ---
TITULO="${1}"
AUTOR="${2}"
ARQUIVO_TXT="${3}"
TIPO_CONTEUDO="${4:-prosa}" # 'prosa' (padrão) ou 'poema'

TEMPLATE="template.tex"
BUILD_DIR="build"

# --- FUNÇÕES ---
function mostrar_uso() {
  echo "Uso: $0 \"Título\" \"Autor\" arquivo.txt [tipo]"
  echo "  [tipo] é opcional: 'prosa' (padrão) ou 'poema'."
  exit 1
}

function limpar_nome() {
  echo "$1" | iconv -t ascii//TRANSLIT | sed -r 's/[^a-zA-Z0-9]+/_/g' | tr '[:upper:]' '[:lower:]'
}

# --- VALIDAÇÕES ---
if [ -z "$TITULO" ] || [ -z "$AUTOR" ] || [ -z "$ARQUIVO_TXT" ]; then
  echo "❌ Erro: Argumentos faltando."
  mostrar_uso
fi

if [ ! -f "$ARQUIVO_TXT" ]; then
  echo "❌ Erro: O arquivo de texto '$ARQUIVO_TXT' não foi encontrado."
  exit 1
fi

if [ ! -f "$TEMPLATE" ]; then
  echo "❌ Erro: O arquivo de template '$TEMPLATE' não foi encontrado."
  exit 1
fi

# --- PREPARAÇÃO ---
NOME_SAIDA=$(limpar_nome "$TITULO")
ARQUIVO_TEX_BUILD="$BUILD_DIR/$NOME_SAIDA.tex"

mkdir -p "$BUILD_DIR"
echo "🚀 Processando '$TITULO' como um(a) '$TIPO_CONTEUDO'."

# --- PROCESSAMENTO DO CONTEÚDO ---
# Lê o conteúdo bruto do arquivo de texto
CONTEUDO_BRUTO=$(cat "$ARQUIVO_TXT")

# Formata o conteúdo com base no tipo
case "$TIPO_CONTEUDO" in
  "poema")
    # Para o ambiente 'verse', cada linha no arquivo de texto deve terminar com '\' no LaTeX.
    # O 'sed' abaixo adiciona '\' ao final de cada linha.
    CONTEUDO_FORMATADO=$(echo "$CONTEUDO_BRUTO" | sed 's/$/ \\/')
    # Envolve o conteúdo formatado no ambiente 'poema'
    CONTEUDO_FINAL="\begin{poema}
${CONTEUDO_FORMATADO}
\end{poema}"
    ;;
  "prosa"|*)
    # Para prosa, apenas envolvemos o conteúdo no ambiente. O LaTeX cuida do resto.
    # A primeira letra pode ser transformada em capitular com \lettrine
    # O comando abaixo tenta fazer isso de forma automática.
    PRIMEIRA_LETRA=$(echo "$CONTEUDO_BRUTO" | cut -c1)
    RESTO_TEXTO=$(echo "$CONTEUDO_BRUTO" | cut -c2-)
    CONTEUDO_COM_CAPITULAR="\lettrine{${PRIMEIRA_LETRA}}}{}${RESTO_TEXTO}"
    CONTEUDO_FINAL="\begin{prosa}
${CONTEUDO_COM_CAPITULAR}
\end{prosa}"
    ;;
esac

# --- MONTAGEM DO ARQUIVO .TEX ---
# Para evitar erros com caracteres especiais (como / & \), usaremos um método mais seguro
# para substituir o conteúdo, em vez de `sed` direto na linha de comando.
# Criamos um arquivo temporário com o conteúdo final e usamos `sed` para ler dele.
TEMP_CONTEUDO_FILE=$(mktemp)
echo "$CONTEUDO_FINAL" > "$TEMP_CONTEUDO_FILE"

# Substitui os placeholders no template
sed "s/VAR_TITULO/${TITULO}/g" "$TEMPLATE" | \
sed "s/VAR_AUTOR/${AUTOR}/g" | \
sed '/VAR_CONTEUDO/ {
  r '"$TEMP_CONTEUDO_FILE"'
  d
}' > "$ARQUIVO_TEX_BUILD"

rm "$TEMP_CONTEUDO_FILE"

echo "⚙️  Arquivo '$ARQUIVO_TEX_BUILD' criado. Compilando para PDF..."

# --- COMPILAÇÃO DO PDF ---
cd "$BUILD_DIR"
# Usamos lualatex ou xelatex se disponíveis, pdflatex como fallback.
# Para este template, pdflatex é suficiente.
pdflatex -interaction=batchmode "$NOME_SAIDA.tex" > /dev/null

# Segunda passagem para garantir referências (se houver)
pdflatex -interaction=batchmode "$NOME_SAIDA.tex" > /dev/null
cd ..

# --- FINALIZAÇÃO ---
if [ -f "$BUILD_DIR/$NOME_SAIDA.pdf" ]; then
  mv "$BUILD_DIR/$NOME_SAIDA.pdf" "./$NOME_SAIDA.pdf"
  echo "✅ Sucesso! PDF gerado: '$NOME_SAIDA.pdf'"
else
  echo "❌ Erro na compilação do LaTeX."
  echo "   Verifique o log para mais detalhes: '$BUILD_DIR/$NOME_SAIDA.log'"
  exit 1
fi

echo "✨ Processo concluído."