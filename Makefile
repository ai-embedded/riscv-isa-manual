# Makefile for RISC-V ISA Manuals
#
# This work is licensed under the Creative Commons Attribution-ShareAlike 4.0
# International License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-sa/4.0/ or send a letter to
# Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
#
# SPDX-License-Identifier: CC-BY-SA-4.0
#
# Description:
#
# This Makefile is designed to automate the process of building and packaging
# the documentation for RISC-V ISA Manuals. It supports multiple build targets
# for generating documentation in various formats (PDF, HTML, EPUB).
#
# Building with a preinstalled docker container is recommended.
# Install by running:
#
#   docker pull riscvintl/riscv-docs-base-container-image:latest
#

DOCS := riscv-privileged riscv-unprivileged
DOCS_ZH := riscv-privileged riscv-unprivileged

DATE ?= $(shell date +%Y-%m-%d)
SKIP_DOCKER ?= $(shell if command -v docker >/dev/null 2>&1 ; then echo false; else echo true; fi)
DOCKER_IMG := riscvintl/riscv-docs-base-container-image:latest
ifneq ($(SKIP_DOCKER),true)
    DOCKER_IS_PODMAN = \
        $(shell ! docker -v | grep podman >/dev/null ; echo $$?)
    ifeq "$(DOCKER_IS_PODMAN)" "1"
        # Modify the SELinux label for the host directory to indicate
        # that it can be shared with multiple containers. This is apparently
        # only required for Podman, though it is also supported by Docker.
        DOCKER_VOL_SUFFIX = :z
    else
        DOCKER_IS_ROOTLESS = \
            $(shell ! docker info -f '{{println .SecurityOptions}}' | grep rootless >/dev/null ; echo $$?)
        ifneq "$(DOCKER_IS_ROOTLESS)" "1"
            # Rooted Docker requires this flag so that the files it creates are
            # owned by the current user instead of root. Rootless docker does not
            # require it, and Podman doesn't either since it is always rootless.
            DOCKER_USER_ARG := --user $(shell id -u)
        endif
    endif

    DOCKER_CMD = \
        docker run --rm \
            -v ${PWD}/$@.workdir:/build${DOCKER_VOL_SUFFIX} \
            -v ${PWD}/src:/src:ro \
            -v ${PWD}/src_zh:/src_zh:ro \
            -v ${PWD}/docs-resources:/docs-resources:ro \
            -w /build \
            $(DOCKER_USER_ARG) \
            ${DOCKER_IMG} \
            /bin/sh -c
    DOCKER_QUOTE := "
else
    DOCKER_CMD = \
        cd $@.workdir &&
endif

ifdef UNRELIABLE_BUT_FASTER_INCREMENTAL_BUILDS
WORKDIR_SETUP = mkdir -p $@.workdir && ln -sfn ../../src ../../src_zh ../../docs-resources $@.workdir/
WORKDIR_TEARDOWN = mv $@.workdir/$@ $@
else
WORKDIR_SETUP = \
    rm -rf $@.workdir && \
    mkdir -p $@.workdir && \
    ln -sfn ../../src ../../src_zh ../../docs-resources $@.workdir/

WORKDIR_TEARDOWN = \
    mv $@.workdir/$@ $@ && \
    rm -rf $@.workdir
endif

SRC_DIR := src
SRC_ZH_DIR := src_zh
BUILD_DIR := build

DOCS_PDF := $(addprefix $(BUILD_DIR)/, $(addsuffix .pdf, $(DOCS)))
DOCS_HTML := $(addprefix $(BUILD_DIR)/, $(addsuffix .html, $(DOCS)))
DOCS_EPUB := $(addprefix $(BUILD_DIR)/, $(addsuffix .epub, $(DOCS)))

DOCS_ZH_PDF := $(addprefix $(BUILD_DIR)/, $(addsuffix -zh.pdf, $(DOCS_ZH)))
DOCS_ZH_HTML := $(addprefix $(BUILD_DIR)/, $(addsuffix -zh.html, $(DOCS_ZH)))
DOCS_ZH_EPUB := $(addprefix $(BUILD_DIR)/, $(addsuffix -zh.epub, $(DOCS_ZH)))

ENV := LANG=C.utf8
XTRA_ADOC_OPTS :=
ASCIIDOCTOR_PDF := $(ENV) asciidoctor-pdf
ASCIIDOCTOR_HTML := $(ENV) asciidoctor
ASCIIDOCTOR_EPUB := $(ENV) asciidoctor-epub3
OPTIONS := --trace \
           -a compress \
           -a mathematical-format=svg \
           -a pdf-fontsdir=docs-resources/fonts \
           -a pdf-theme=docs-resources/themes/riscv-pdf.yml \
           $(XTRA_ADOC_OPTS) \
           -D build \
           --failure-level=ERROR
OPTIONS_ZH := --trace \
           -a compress \
           -a mathematical-format=svg \
           -a pdf-fontsdir=docs-resources/fonts \
           -a pdf-theme=docs-resources/themes/riscv-pdf-zh.yml \
           $(XTRA_ADOC_OPTS) \
           -D build \
           --failure-level=FATAL
REQUIRES := --require=asciidoctor-bibtex \
            --require=asciidoctor-diagram \
            --require=asciidoctor-lists \
            --require=asciidoctor-mathematical
REQUIRES_ZH := --require=asciidoctor-lists

.PHONY: all build clean build-container build-no-container build-docs build-pdf build-html build-epub build-zh build-pdf-zh build-html-zh build-epub-zh build-all submodule-check

all: build

# Check if the docs-resources/global-config.adoc file exists. If not, the user forgot to check out submodules.
submodule-check:
	if [ ! -e docs-resources/global-config.adoc ]; then \
	  echo "WARNING: You must clone with --recurse-submodules to automatically populate the submodule 'docs-resources'." 1>&2; \
	  echo "Checking out submodules for you via 'git submodule update --init --recurse'..."; \
	  git submodule update --init --recursive; \
	fi

build-docs: $(DOCS_PDF) $(DOCS_HTML) $(DOCS_EPUB)
build-pdf: $(DOCS_PDF)
build-html: $(DOCS_HTML)
build-epub: $(DOCS_EPUB)

build-zh: $(DOCS_ZH_PDF) $(DOCS_ZH_HTML) $(DOCS_ZH_EPUB)
build-pdf-zh: $(DOCS_ZH_PDF)
build-html-zh: $(DOCS_ZH_HTML)
build-epub-zh: $(DOCS_ZH_EPUB)

build-all: $(DOCS_PDF) $(DOCS_HTML) $(DOCS_EPUB) $(DOCS_ZH_PDF) $(DOCS_ZH_HTML) $(DOCS_ZH_EPUB)

ALL_SRCS := $(shell git ls-files $(SRC_DIR))
ALL_ZH_SRCS := $(shell git ls-files $(SRC_ZH_DIR))

$(BUILD_DIR)/%.pdf: $(SRC_DIR)/%.adoc $(ALL_SRCS)
	$(WORKDIR_SETUP)
	$(DOCKER_CMD) $(DOCKER_QUOTE) $(ASCIIDOCTOR_PDF) $(OPTIONS) $(REQUIRES) $< $(DOCKER_QUOTE)
	$(WORKDIR_TEARDOWN)

$(BUILD_DIR)/%.html: $(SRC_DIR)/%.adoc $(ALL_SRCS)
	$(WORKDIR_SETUP)
	$(DOCKER_CMD) $(DOCKER_QUOTE) $(ASCIIDOCTOR_HTML) $(OPTIONS) $(REQUIRES) $< $(DOCKER_QUOTE)
	$(WORKDIR_TEARDOWN)

$(BUILD_DIR)/%.epub: $(SRC_DIR)/%.adoc $(ALL_SRCS)
	$(WORKDIR_SETUP)
	$(DOCKER_CMD) $(DOCKER_QUOTE) $(ASCIIDOCTOR_EPUB) $(OPTIONS) $(REQUIRES) $< $(DOCKER_QUOTE)
	$(WORKDIR_TEARDOWN)

# Chinese build rules
$(BUILD_DIR)/%-zh.pdf: $(SRC_ZH_DIR)/%.adoc $(ALL_ZH_SRCS)
	$(WORKDIR_SETUP)
	$(DOCKER_CMD) $(DOCKER_QUOTE) $(ASCIIDOCTOR_PDF) $(OPTIONS_ZH) $(REQUIRES_ZH) $< -o $(notdir $*)-zh.pdf $(DOCKER_QUOTE)
	$(WORKDIR_TEARDOWN)

$(BUILD_DIR)/%-zh.html: $(SRC_ZH_DIR)/%.adoc $(ALL_ZH_SRCS)
	$(WORKDIR_SETUP)
	$(DOCKER_CMD) $(DOCKER_QUOTE) $(ASCIIDOCTOR_HTML) $(OPTIONS_ZH) $(REQUIRES_ZH) $< -o $(notdir $*)-zh.html $(DOCKER_QUOTE)
	$(WORKDIR_TEARDOWN)

$(BUILD_DIR)/%-zh.epub: $(SRC_ZH_DIR)/%.adoc $(ALL_ZH_SRCS)
	$(WORKDIR_SETUP)
	$(DOCKER_CMD) $(DOCKER_QUOTE) $(ASCIIDOCTOR_EPUB) $(OPTIONS_ZH) $(REQUIRES_ZH) $< -o $(notdir $*)-zh.epub $(DOCKER_QUOTE)
	$(WORKDIR_TEARDOWN)

build: submodule-check
	@echo "Checking if Docker is available..."
	@if command -v docker >/dev/null 2>&1 ; then \
		echo "Docker is available, building inside Docker container..."; \
		$(MAKE) build-container; \
	else \
		echo "Docker is not available, building without Docker..."; \
		$(MAKE) build-no-container; \
	fi

build-container: submodule-check
	@echo "Starting build inside Docker container..."
	$(MAKE) SKIP_DOCKER=false build-docs
	@echo "Build completed successfully inside Docker container."

build-no-container: submodule-check
	@echo "Starting build..."
	$(MAKE) SKIP_DOCKER=true build-docs
	@echo "Build completed successfully."

# Update docker image to latest
docker-pull-latest:
	docker pull ${DOCKER_IMG}

clean:
	@echo "Cleaning up generated files..."
	rm -rf $(BUILD_DIR)
	@echo "Cleanup completed."
