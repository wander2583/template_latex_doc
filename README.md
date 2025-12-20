# Template LaTeX para Documentação de textos.

## Descrição

Este repositório contém um template LaTeX modular e profissional, desenvolvido para facilitar a criação de documentos acadêmicos, técnicos e científicos. O sistema oferece uma estrutura organizada, com separação clara entre conteúdo, configurações e recursos visuais, permitindo a manutenção e expansão eficiente de documentos complexos.

## Estrutura do Repositório

```
template_latex_doc/
├── build/              # Arquivos gerados durante a compilação
├── img/                # Recursos visuais e imagens
├── textos/             # Módulos de conteúdo separados
├── Makefile            # Automação do processo de compilação
├── gerar_pdf.sh        # Script de geração do PDF
├── template.tex        # Arquivo principal do template
├── template.pdf        # Documento compilado (exemplo)
├── poema.txt           # Arquivo de texto auxiliar
└── README.md           # Documentação do projeto
```

### Componentes Principais

- **`template.tex`**: Arquivo principal que integra todos os módulos e define a estrutura do documento
- **`textos/`**: Diretório contendo seções modulares do conteúdo, facilitando a organização de documentos extensos
- **`img/`**: Repositório centralizado de imagens, gráficos e elementos visuais
- **`build/`**: Diretório para arquivos temporários e auxiliares gerados durante a compilação
- **`Makefile`**: Sistema de automação para compilação e limpeza do projeto
- **`gerar_pdf.sh`**: Script shell para geração automatizada do documento final

## Requisitos do Sistema

### Dependências Obrigatórias

- **TeX Live** (versão completa recomendada) ou **MiKTeX**
- **pdflatex** ou **XeLaTeX** para compilação
- **make** (para utilização do Makefile)
- **bash** (para execução do script de geração)

### Pacotes LaTeX Essenciais

O template requer os seguintes pacotes LaTeX (geralmente incluídos em distribuições completas):

- `babel` (suporte multilíngue)
- `inputenc` e `fontenc` (codificação de caracteres)
- `graphicx` (manipulação de imagens)
- `geometry` (configuração de margens)
- `hyperref` (links e referências)
- Pacotes adicionais conforme especificado em `template.tex`

## Instalação e Configuração

### 1. Clonagem do Repositório

```bash
git clone https://github.com/wander2583/template_latex_doc.git
cd template_latex_doc
```

### 2. Verificação de Dependências

Certifique-se de que o LaTeX está instalado corretamente:

```bash
pdflatex --version
```

### 3. Configuração de Permissões

Conceda permissão de execução ao script de geração:

```bash
chmod +x gerar_pdf.sh
```

## Utilização

### Método 1: Makefile (Recomendado)

O Makefile oferece comandos otimizados para o gerenciamento do projeto:

```bash
# Compilar o documento
make

# Compilar e visualizar o PDF
make view

# Limpar arquivos auxiliares
make clean

# Limpar todos os arquivos gerados (incluindo PDF)
make cleanall
```

### Método 2: Script de Geração

Utilize o script bash para compilação automatizada:

```bash
./gerar_pdf.sh
```

Este script executa a sequência completa de compilação, incluindo múltiplas passagens para resolução de referências cruzadas.

### Método 3: Compilação Manual

Para controle detalhado do processo de compilação:

```bash
pdflatex template.tex
bibtex template    # Se utilizar bibliografia
pdflatex template.tex
pdflatex template.tex
```

**Nota**: A tripla compilação é necessária para resolver referências cruzadas, índices e bibliografia corretamente.

## Personalização do Template

### Modificação de Conteúdo

1. **Editar arquivo principal**: Modifique `template.tex` para ajustar a estrutura global do documento
2. **Adicionar seções**: Crie novos arquivos `.tex` no diretório `textos/` e inclua-os no documento principal
3. **Inserir imagens**: Coloque arquivos de imagem no diretório `img/` e referencie-os usando `\includegraphics{img/nome_arquivo}`

### Configuração de Formatação

O template permite ajustes de:

- Margens e dimensões da página (pacote `geometry`)
- Família tipográfica e tamanho de fonte
- Espaçamento entre linhas e parágrafos
- Estilo de cabeçalhos e rodapés
- Configuração de cores e temas visuais

### Organização Modular

Para documentos extensos, organize o conteúdo em módulos separados:

```latex
% Em template.tex
\input{textos/introducao}
\input{textos/metodologia}
\input{textos/resultados}
\input{textos/conclusao}
```

## Boas Práticas

### Organização de Arquivos

- Mantenha um arquivo `.tex` por seção principal
- Utilize nomenclatura descritiva para imagens (ex: `fig_metodologia_fluxograma.png`)
- Documente alterações significativas no histórico de commits

### Controle de Versão

- Adicione `build/` ao `.gitignore` para evitar versionamento de arquivos temporários
- Versione apenas arquivos fonte (`.tex`, `.bib`, imagens)
- Utilize mensagens de commit descritivas

### Compilação Eficiente

- Execute `make clean` regularmente para remover arquivos obsoletos
- Utilize compilação incremental durante o desenvolvimento
- Reserve compilação completa para versões finais

## Resolução de Problemas

### Erros Comuns

**Erro: "File not found"**

- Verifique os caminhos relativos para imagens e arquivos incluídos
- Certifique-se de que todos os arquivos `.tex` referenciados existem

**Erro: "Undefined control sequence"**

- Confirme que todos os pacotes necessários estão instalados
- Verifique a sintaxe dos comandos LaTeX utilizados

**PDF desatualizado**

- Execute `make cleanall` seguido de `make` para recompilação completa
- Verifique se o processo de compilação completou sem erros

### Suporte e Documentação

Para questões relacionadas ao LaTeX:

- [Wikibooks LaTeX](https://en.wikibooks.org/wiki/LaTeX)
- [TeX Stack Exchange](https://tex.stackexchange.com/)
- [Overleaf Documentation](https://www.overleaf.com/learn)

## Contribuição

Contribuições para melhoria do template são bem-vindas. Para contribuir:

1. Realize um fork do repositório
2. Crie uma branch para sua funcionalidade (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas alterações com mensagens descritivas
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request detalhando as modificações

## Licença

Este projeto está disponível como template de código aberto. Sinta-se livre para utilizar, modificar e distribuir conforme suas necessidades acadêmicas e profissionais.

---

**Última atualização**: Dezembro 2025
