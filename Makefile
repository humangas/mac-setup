################################################################### 
# Installation tool for macOS setup"
#
# See also: https://github.com/humangas/mac-setup
################################################################### 
.DEFAULT_GOAL := help

.PHONY: all help install tags

all:

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
	@echo " make install TAGS=zsh,vim"

install:
	@ln -s ansible/ansible.cfg .
	@ln -s ansible/hosts .
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
