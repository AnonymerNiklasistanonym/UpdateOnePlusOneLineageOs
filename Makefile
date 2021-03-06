EMPTY:=
SPACE:=$(EMPTY) $(EMPTY)

# File names
SOURCE_FILE=README.md
OUTPUT_BASENAME=UpdateOnePlusOneLineageOS
OUTPUT_DIR=bin

# Pandoc general command options
PANDOC_OPTIONS=--from markdown$(subst $(SPACE),,$(PANDOC_EXTENSIONS)) \
               --metadata title="Update OnePlus One LineageOs" \
               --metadata date=$(shell date --reference=$(SOURCE_FILE) +"%Y.%m.%d")
# Pandoc command options for PDF export
PANDOC_OPTIONS_PDF=-V geometry:a4paper \
                   -V geometry:margin=2cm \
                   -V urlcolor=cyan \
                   -V links-as-notes=true \
                   --toc \
                   --pdf-engine=pdflatex \
                   --to pdf
# Pandoc command options for HTML export
PANDOC_OPTIONS_HTML=--css html/pandoc_style.css \
                    --include-in-header html/pandoc_open_image_on_click.html \
                    --toc \
                    --self-contained \
                    --to html
# Pandoc command options for html web page export
PANDOC_OPTIONS_HTML_WEB_PAGE=--include-in-header html/pandoc_add_download_pdf_button.html \
                             $(PANDOC_OPTIONS_HTML)

# The size of the images when exported to PDF/HTML via pandoc
PANDOC_OUTPUT_SCREENSHOT_SIZE=23%

# The whole image expression will be a group and can be referenced via for example "\1"
REGEX_FIND_MD_IMAGES=(\!\[\]\(res\/[^\.]+\.png\))
REGEX_FRIENDLY_PANDOC_IMG_SIZE=\{ width=$(PANDOC_OUTPUT_SCREENSHOT_SIZE) \}
# -E enables extended regular expressions for group recognition
REGEX_ADD_IMAGE_SIZE=-E "s/$(REGEX_FIND_MD_IMAGES)/\1$(REGEX_FRIENDLY_PANDOC_IMG_SIZE)/g"
REGEX_REMOVE_IMAGE_SIZE=-E "s/$(REGEX_FIND_MD_IMAGES)$(REGEX_FRIENDLY_PANDOC_IMG_SIZE)/\1/g"
REGEX_TITLE=\\\# UpdateOnePlusOneLineageOs
REGEX_COMMENTED_TITLE=\[\/\/\]: \\\# \(UpdateOnePlusOneLineageOs\)
REGEX_COMMENT_TITLE=-E "s/$(REGEX_TITLE)/\$(REGEX_COMMENTED_TITLE)/g"
REGEX_UNCOMMENT_TITLE=-E "s/$(REGEX_COMMENTED_TITLE)/\$(REGEX_TITLE)/g"

# Disable parallel execution of jobs
.NOTPARALLEL:

# Ignore these jobs
.PHONY: clean html web_page

# Run these jobs per default
all: pdf

clean:
	rm -rf "$(OUTPUT_DIR)"

pdf:
	mkdir -p "$(OUTPUT_DIR)"
	sed -i $(REGEX_ADD_IMAGE_SIZE) "$(SOURCE_FILE)"
	sed -i $(REGEX_COMMENT_TITLE) "$(SOURCE_FILE)"
	pandoc "$(SOURCE_FILE)" -o "$(OUTPUT_DIR)/$(OUTPUT_BASENAME).pdf" $(PANDOC_OPTIONS) $(PANDOC_OPTIONS_PDF)
	sed -i $(REGEX_UNCOMMENT_TITLE) "$(SOURCE_FILE)"
	sed -i $(REGEX_REMOVE_IMAGE_SIZE) "$(SOURCE_FILE)"

html:
	mkdir -p "$(OUTPUT_DIR)"
	sed -i $(REGEX_COMMENT_TITLE) "$(SOURCE_FILE)"
	pandoc "$(SOURCE_FILE)" -o "$(OUTPUT_DIR)/$(OUTPUT_BASENAME).html" $(PANDOC_OPTIONS) $(PANDOC_OPTIONS_HTML)
	sed -i $(REGEX_UNCOMMENT_TITLE) "$(SOURCE_FILE)"

web_page: pdf
	mkdir -p "$(OUTPUT_DIR)"
	sed -i $(REGEX_COMMENT_TITLE) "$(SOURCE_FILE)"
	pandoc "$(SOURCE_FILE)" -o "$(OUTPUT_DIR)/index.html" $(PANDOC_OPTIONS) $(PANDOC_OPTIONS_HTML_WEB_PAGE)
	sed -i $(REGEX_UNCOMMENT_TITLE) "$(SOURCE_FILE)"
