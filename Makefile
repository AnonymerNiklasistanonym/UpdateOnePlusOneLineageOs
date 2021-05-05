EMPTY:=
SPACE:=$(EMPTY) $(EMPTY)
PANDOC_OPTIONS=-V geometry:a4paper \
               -V geometry:margin=2cm \
               --pdf-engine=pdflatex \
               --from markdown$(subst $(SPACE),,$(PANDOC_EXTENSIONS))
PANDOC_OPTIONS_PDF=--to pdf
PANDOC_OPTIONS_HTML=--self-contained \
                    --katex \
                    --to html

OUTPUT_BASENAME=UpdateOnePlusOneLineageOS

.PHONY: clean html

all: pdf

clean:
	rm -f "$(OUTPUT_BASENAME).pdf"
	rm -f "$(OUTPUT_BASENAME).html"

pdf:
	pandoc "README.md" -o "$(OUTPUT_BASENAME).pdf" $(PANDOC_OPTIONS) $(PANDOC_OPTIONS_PDF)

html:
	pandoc "README.md" -o "$(OUTPUT_BASENAME).html" $(PANDOC_OPTIONS) $(PANDOC_OPTIONS_HTML)
