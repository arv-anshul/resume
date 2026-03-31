@_default:
    just -l

# Shared variables
ROOT := "."
FONTS := "assets/fonts/"

[private]
compile_pdf template output:
    typst compile \
        --root={{ROOT}} \
        --format=pdf \
        --ignore-system-fonts \
        --font-path={{FONTS}} \
        {{template}} \
        {{output}}

[private]
compile_png template output:
    typst compile \
        --root={{ROOT}} \
        --format=png \
        --ppi=300 \
        --ignore-system-fonts \
        --font-path={{FONTS}} \
        {{template}} \
        {{output}}

# Generate PDF from templates/basic.typ
@pdf-basic:
    just compile_pdf templates/basic.typ pdf/basic.pdf

# Generate image from templates/basic.typ
@img-basic:
    just compile_png templates/basic.typ images/basic.png

# Generate PDF from templates/vantage.typ
@pdf-vantage:
    just compile_pdf templates/vantage.typ pdf/vantage.pdf

# Generate image from templates/vantage.typ
@img-vantage:
    just compile_png templates/vantage.typ images/vantage.png

# Build all PDFs and Images
@all:
    just pdf-basic
    just img-basic
    just pdf-vantage
    just img-vantage
