## Copyright (C) 2021 David Miguel Susano Pinto
##
## Copying and distribution of this file, with or without modification,
## are permitted in any medium without royalty provided the copyright
## notice and this notice are preserved.  This file is offered as-is,
## without any warranty.

PELICAN ?= pelican
PELICAN_OPTS ?=

BASEDIR = $(CURDIR)
INPUTDIR = $(BASEDIR)/content
OUTPUTDIR = $(BASEDIR)/output
CONFFILE = $(BASEDIR)/pelicanconf.py

# This requires .ssh/config to be set with this host
SSH_HOST = carandraug-net
SSH_TARGET_DIR = ./www

DEBUG ?= 0
ifeq ($(DEBUG), 1)
  PELICAN_OPTS += -D
endif

PORT ?= 0
ifneq ($(PORT), 0)
  PELICAN_OPTS += -p $(PORT)
endif

PELICAN_BASE_CMD = \
    "$(PELICAN)" \
    --output "$(OUTPUTDIR)" \
    --settings "$(CONFFILE)" \
    $(PELICAN_OPTS)

PELICAN_LOCAL_CMD = \
    $(PELICAN_BASE_CMD) \
    --relative-urls

PELICAN_PUBLISH_CMD = \
    $(PELICAN_BASE_CMD) \
    --delete-output-directory


help:
	@echo 'Makefile for a pelican Web site'
	@echo ''
	@echo 'Usage:'
	@echo '   make html                   (re)generate the web site'
	@echo '   make clean                  remove the generated files'
	@echo '   make publish                generate for upload'
	@echo '   make serve [PORT=8000]      serve at http://localhost:8000'
	@echo '   make devserver [PORT=8000]  serve and regenerate together'
	@echo '   make upload                 upload the web site via rsync+ssh'
	@echo ''
	@echo 'Variables:'
	@echo '   DEBUG          set to 1 to enable debugging'
	@echo '   PORT           port number when serving locally'
	@echo '   PELICAN_OPTS   extra options to pass to pelican'
	@echo '   PELICAN        path for the pelian program'
	@echo ''

html:
	$(PELICAN_LOCAL_CMD) "$(INPUTDIR)"

clean:
	[ ! -d "$(OUTPUTDIR)" ] || $(RM) -r "$(OUTPUTDIR)"

serve:
	$(PELICAN_LOCAL_CMD) --listen "$(INPUTDIR)"

devserver:
	$(PELICAN_LOCAL_CMD) --listen --autoreload "$(INPUTDIR)"

publish:
	$(PELICAN_PUBLISH_CMD) "$(INPUTDIR)"

upload: publish
	rsync -e "ssh" \
	    --partial --progress \
	    --recursive \
	    --verbose \
	    --compress \
	    --checksum \
	    --include tags \
	    --cvs-exclude \
	    --delete \
	    "$(OUTPUTDIR)"/ "$(SSH_HOST):$(SSH_TARGET_DIR)"


.PHONY: \
  help \
  html \
  serve \
  devserver \
  publish \
  upload
