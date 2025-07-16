# Technology Stack

## Build System
- **Primary**: Make-based build system with Docker containerization
- **Docker Image**: `riscvintl/riscv-docs-base-container-image:latest`
- **Fallback**: Local builds without Docker (requires manual dependency installation)

## Documentation Tools
- **AsciiDoc**: Primary markup language for documentation source
- **Asciidoctor**: Ruby-based processor for AsciiDoc conversion
- **Required Gems**:
  - `asciidoctor-pdf` - PDF generation
  - `asciidoctor-bibtex` - Bibliography support
  - `asciidoctor-diagram` - Diagram generation
  - `asciidoctor-mathematical` - Mathematical notation
  - `asciidoctor-lists` - Enhanced list formatting
  - `asciidoctor-epub3` - EPUB generation

## Diagram and Graphics
- **WaveDrom**: Digital timing diagrams (requires Node.js)
- **Bytefield-SVG**: Register and instruction format diagrams
- **Graphviz**: Graph and flowchart generation
- **Mathematical**: LaTeX-style mathematical notation rendering

## Fonts and Themes
- **English**: Custom RISC-V PDF theme (`riscv-pdf.yml`)
- **Chinese**: Specialized theme with CJK font support (`riscv-pdf-zh.yml`)
- **Fonts**: Comprehensive font collection including Droid Sans Fallback, M+ fonts for CJK support

## Common Build Commands

### Standard Builds
```bash
# Build all English formats (PDF, HTML, EPUB)
make build

# Build all Chinese formats
make build-zh

# Build everything (English + Chinese)
make build-all
```

### Specific Format Builds
```bash
# PDF only
make build-pdf          # English
make build-pdf-zh       # Chinese

# HTML only  
make build-html         # English
make build-html-zh      # Chinese

# EPUB only
make build-epub         # English
make build-epub-zh      # Chinese
```

### Docker Management
```bash
# Update to latest build image
make docker-pull-latest

# Force container build
make build-container

# Build without Docker (requires local dependencies)
make build-no-container
```

### Maintenance
```bash
# Clean all build artifacts
make clean

# Check/update submodules
make submodule-check
```

## Build Configuration
- **Failure Level**: ERROR for English, FATAL for Chinese
- **Output Directory**: `build/`
- **Mathematical Format**: SVG for better scalability
- **Compression**: Enabled for all output formats