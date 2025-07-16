# Project Structure

## Root Directory Layout

```
riscv-isa-manual/
├── src/                    # English source files
├── src_zh/                 # Chinese source files  
├── 01/                     # Legacy English sources (being migrated)
├── 01_zh/                  # Legacy Chinese sources (being migrated)
├── docs-resources/         # Shared build resources (submodule)
├── build/                  # Generated output files
├── dependencies/           # Build dependency specifications
└── Makefile               # Build configuration
```

## Source Organization

### English Sources (`src/`)
- **Main Documents**: `riscv-privileged.adoc`, `riscv-unprivileged.adoc`
- **Images**: Technical diagrams, waveforms, and graphics
  - `images/bytefield/` - Register format diagrams
  - `images/wavedrom/` - Timing diagrams
  - `images/graphviz/` - Flow charts and graphs
- **Examples**: Assembly code examples
- **Resources**: Bibliography and shared resources

### Chinese Sources (`src_zh/`)
- **Mirror Structure**: Identical organization to English sources
- **Localized Content**: Full Chinese translations
- **Shared Resources**: References same image and diagram files

### Legacy Sources (`01/`, `01_zh/`)
- **Individual Chapters**: Separate `.adoc` files per chapter/extension
- **Modular Organization**: Each specification extension as standalone file
- **Migration Target**: Being consolidated into main source structure

## Build Resources (`docs-resources/`)

### Fonts
- **English**: Atkinson Hyperlegible, JetBrains Mono, Montserrat
- **Chinese**: Noto Sans CJK, Droid Sans Fallback, M+ fonts
- **Code**: Fira Code, JetBrains Mono for syntax highlighting

### Themes
- `riscv-pdf.yml` - English PDF styling
- `riscv-pdf-zh.yml` - Chinese PDF styling with CJK support

### Images
- RISC-V logos and branding
- Shared graphics and icons

## Output Structure (`build/`)

```
build/
├── riscv-privileged.pdf           # English privileged spec
├── riscv-privileged.html          # English privileged web
├── riscv-privileged.epub          # English privileged ebook
├── riscv-privileged-zh.pdf        # Chinese privileged spec
├── riscv-privileged-zh.html       # Chinese privileged web
├── riscv-privileged-zh.epub       # Chinese privileged ebook
├── riscv-unprivileged.pdf         # English unprivileged spec
├── riscv-unprivileged.html        # English unprivileged web
├── riscv-unprivileged.epub        # English unprivileged ebook
├── riscv-unprivileged-zh.pdf      # Chinese unprivileged spec
├── riscv-unprivileged-zh.html     # Chinese unprivileged web
└── riscv-unprivileged-zh.epub     # Chinese unprivileged ebook
```

## File Naming Conventions

### Source Files
- **Main Documents**: `riscv-{privileged|unprivileged}.adoc`
- **Chapters**: Descriptive names (e.g., `machine.adoc`, `supervisor.adoc`)
- **Extensions**: Extension name prefix (e.g., `zicsr.adoc`, `zabha.adoc`)

### Generated Files
- **English**: `{document-name}.{format}`
- **Chinese**: `{document-name}-zh.{format}`
- **Formats**: `pdf`, `html`, `epub`

## Working Directories
- **Build Process**: Uses temporary `.workdir` directories
- **Docker Mounts**: Source directories mounted read-only
- **Incremental Builds**: Supported via `UNRELIABLE_BUT_FASTER_INCREMENTAL_BUILDS`

## Key Configuration Files
- `Makefile` - Build orchestration and Docker configuration
- `docs-resources/global-config.adoc` - Shared AsciiDoc configuration
- `docs-resources/themes/*.yml` - PDF styling themes
- `dependencies/` - Package manager specifications (apt, gem, npm)