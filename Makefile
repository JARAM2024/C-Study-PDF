SRC_FILES=$(shell find C-Study -name "*.md")
TEX_FILES=$(SRC_FILES:%.md=%.latex)

INDEX_DIRS=$(shell find C-Study -type d)
INDEX_FILES=$(INDEX_DIRS:%=%.tex)

OUT=main.pdf

all: ${OUT}

${OUT}: ${TEX_FILES} ${INDEX_FILES}
	xelatex main.latex $@

%.latex: %.md
	pandoc \
		--from=markdown \
		--variable mainfont='Nanum Myeongjo' \
		--variable sansfont='Nanum Myeongjo' \
		--highlight-style espresso \
		--listings \
		-t latex \
		--output=$@ \
		$<

%.tex: %
	touch $@
	$(eval MD_FILES := $(shell find $<  -maxdepth 1 -name "*.latex"))
	$(eval DIRS := $(shell find $< -maxdepth 1 -mindepth 1 -type d))
	echo '\\graphicspath{{$<}}' >> $@
	echo ${MD_FILES} | xargs -n 1 basename | sort | xargs -t -I % sh -c '{ echo \\input{$</%} >> $@; echo \\\\newpage >> $@; }'
	echo ${DIRS} | xargs -n 1 basename | sort | xargs -t -I % sh -c '{ echo \\input{$</%.tex} >> $@; }'

.PHONY: clean

clean:
	rm -rf ${TEX_FILES} ${INDEX_FILES} ${OUT}
