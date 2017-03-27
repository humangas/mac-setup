################################################################### 
# Installation tool for macOS setup"
#
# See also: https://github.com/humangas/mac-setup
################################################################### 
all:
	@make help

help:
	@echo "Usage: make target [args]"
	@echo ""
	@echo "target:"
	@echo " - install [TAGS=<tag>]:   Install, If you specify a role for tag, you can only install that role."
	@echo " - tags:                   Show role name and corresponding tag name."
	@echo ""
	@echo "Examples:"
	@echo " make install"
	@echo " make install TAGS=zsh"

install:
	@if [ -z "$(TAGS)" ]; then\
		/bin/bash install;\
	else\
		/bin/bash install --tags $(TAGS);\
	fi
	
tags:
	@echo "Usage: make install [TAGS=<tag>]"
	@echo ""
	@echo "Examples:"
	@echo " make install TAGS=zsh"
	@echo ""
	@grep -ve '.*#.*' ansible/site.yml | grep -oe '- { role:.*}*'

.PHONY: all help install tags
