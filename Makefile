EMPTY:=
SPACE:=$(EMPTY) $(EMPTY)

# Pandoc general command options
PANDOC_OPTIONS=--from markdown$(subst $(SPACE),,$(PANDOC_EXTENSIONS))
# Pandoc command options for PDF export
PANDOC_OPTIONS_PDF=-V geometry:a4paper \
                   -V geometry:margin=2cm \
                   --pdf-engine=pdflatex \
                   --to pdf
# Pandoc command options for HTML export
PANDOC_OPTIONS_HTML=--self-contained \
                    --to html

# File names
SOURCE_FILE=README.md
OUTPUT_BASENAME=UpdateOnePlusOneLineageOS

# The size of the images when exported to PDF/HTML via pandoc
PANDOC_OUTPUT_SCREENSHOT_SIZE=23%

# The whole image expression will be a group and can be referenced via for example "\1"
REGEX_FIND_MD_IMAGES=(\!\[\]\(res\/[^\.]+\.png\))
REGEX_FRIENDLY_PANDOC_IMG_SIZE=\{ width=$(PANDOC_OUTPUT_SCREENSHOT_SIZE) \}
# -E enables extended regular expressions for group recognition
REGEX_ADD_IMAGE_SIZE=-E "s/$(REGEX_FIND_MD_IMAGES)/\1$(REGEX_FRIENDLY_PANDOC_IMG_SIZE)/g"
REGEX_REMOVE_IMAGE_SIZE=-E "s/$(REGEX_FIND_MD_IMAGES)$(REGEX_FRIENDLY_PANDOC_IMG_SIZE)/\1/g"

.PHONY: clean html

all: pdf

clean:
	rm -f "$(OUTPUT_BASENAME).pdf"
	rm -f "$(OUTPUT_BASENAME).html"

pdf:
	sed -i $(REGEX_ADD_IMAGE_SIZE) "$(SOURCE_FILE)"
	pandoc "$(SOURCE_FILE)" -o "$(OUTPUT_BASENAME).pdf" $(PANDOC_OPTIONS) $(PANDOC_OPTIONS_PDF)
	sed -i $(REGEX_REMOVE_IMAGE_SIZE) "$(SOURCE_FILE)"

html:
	sed -i $(REGEX_ADD_IMAGE_SIZE) "$(SOURCE_FILE)"
	pandoc "$(SOURCE_FILE)" -o "$(OUTPUT_BASENAME).html" $(PANDOC_OPTIONS) $(PANDOC_OPTIONS_HTML)
	sed -i $(REGEX_REMOVE_IMAGE_SIZE) "$(SOURCE_FILE)"
