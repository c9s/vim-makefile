# vim:filetype=make:foldmethod=marker:fdl=0:
#
#
# 	Look at the stars, Look how they shine for you, And everything you do,
# 	Yeah they were all yellow, 
#
# 	I came along, I wrote a song for you, And all the things you do And it was
# 	called yellow.
#
# 	So then I took my turn.  Oh all the things I've done And it was all yellow 
#
# 														- Coldplay
#
#
# Makefile: install/uninstall/link vim plugin files.
# Author: Cornelius <cornelius.howl@gmail.com>
# Date:   一  3/15 22:49:26 2010
# Version:  1.0
#
# PLEASE DO NOT EDIT THIS FILE. THIS FILE IS AUTO-GENERATED FROM Makefile.tpl
# LICENSE {{{
# Copyright (c) 2010 <Cornelius (c9s)>
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# }}}
# VIM RECORD FORMAT: {{{
# {
#           version => 0.2,    # record spec version
#           generated_by => 'Vimana-' . $Vimana::VERSION,
#           install_type => 'auto',    # auto , make , rake ... etc
#           package => $self->package_name,
#           files => \@e,
# }
# }}}

# INTERNAL VARIABLES {{{

RECORD_FILE=.record
PWD=`pwd`
README_FILES=`find . -type f -iname "README*"`
README_FILES=`find . -type f -iname "README*"`
WGET_OPT=-c -nv
CURL_OPT=
RECORD_SCRIPT=.mkrecord
TAR=tar czvHf

# INTERNAL FUNCTIONS {{{
record_file = \
		PTYPE=`cat $(1) | perl -nle 'print $$1 if /^"\s*script\s*type:\s*(\S*)$$/i'` ;\
		echo $(VIMRUNTIME)/$$PTYPE/$(1) >> $(2)

# }}}

# PUBLIC FUNCTIONS {{{

# install file by inspecting content
install_file = \
		PTYPE=`cat $(1) | perl -nle 'print $$1 if /^"\s*script\s*type:\s*(\S*)$$/i'` ;\
		cp -v $(1) $(VIMRUNTIME)/$$PTYPE/$(1)

link_file = \
		PTYPE=`cat $(1) | perl -nle 'print $$1 if /^"\s*script\s*type:\s*(\S*)$$/i'` ;\
		cp -v $(1) $(VIMRUNTIME)/$$PTYPE/$(1)

unlink_file = \
		PTYPE=`cat $(1) | perl -nle 'print $$1 if /^"\s*script\s*type:\s*(\S*)$$/i'` ;\
		rm -fv $(VIMRUNTIME)/$$PTYPE/$(1)

# fetch script from an url
fetch_url = \
		@if [[ -e $(2) ]] ; then 				\
			exit								\
		; fi	 							    \
		; echo " => $(2)"						\
		; if [[ ! -z `which curl` ]] ; then   \
			curl $(CURL_OPT) $(1) -o $(2) ;					\
		; elif [[ ! -z `which wget` ]] ; then 	\
			wget $(WGET_OPT) $(1) -O $(2)  				    \
		; fi  									\
		; echo $(2) >> .bundlefiles

# fetch script from github
fetch_github = \
		@if [[ -e $(5) ]] ; then 				\
			exit								\
		; fi	 							    \
		; echo " => $(5)"						\
		; if [[ ! -z `which curl` ]] ; then                        	    \
			curl $(CURL_OPT) http://github.com/$(1)/$(2)/raw/$(3)/$(4) -o $(5)      \
		; elif [[ ! -z `which wget` ]] ; then                               \
			wget $(WGET_OPT) http://github.com/$(1)/$(2)/raw/$(3)/$(4) -O $(5)  \
		; fi									\
		; echo $(5) >> .bundlefiles

# fetch script from local file
fetch_local = @cp -v $(1) $(2) \
		; @echo $(2) >> .bundlefiles

# }}}
# }}}
# ======= DEFAULT CONFIG ======= {{{

# Default plugin name
NAME=`basename \`pwd\``
VERSION=0.1

# Files to add to tarball:
DIRS=`ls -1F | grep / | sed -e 's/\///'`

# Runtime path to install:
VIMRUNTIME=~/.vim

# Other Files to be added:
FILES=`ls -1 | grep '.vim$$'` Makefile `ls -1 | grep '.mk$$'`

# ======== USER CONFIG ======= {{{
#   please write config in config.mk
#   this will override default config
#
# Custom Name:
#
# 	NAME=[plugin name]
#
# Custom dir list:
#
# 	DIRS=autoload after doc syntax plugin 
#
# Files to add to tarball:
#
# 	FILES=
# 
# Bundle dependent scripts:
#
# 	bundle-deps:
# 	  $(call fetch_github,[account id],[project],[branch],[source path],[target path])
# 	  $(call fetch_url,[file url],[target path])
# 	  $(call fetch_local,[from],[to])


CONFIG_FILE=config.mk
-include ~/.vimauthor.mk
-include $(CONFIG_FILE)

# }}}
# }}}
# ======= SECTIONS ======= {{{
-include ext.mk

all: install


check-require:
	@if [[ -n `which wget` || -n `which curl` || -n `which fetch` ]]; then echo "wget|curl|fetch: OK" ; else echo "wget|curl|fetch: NOT OK" ; fi
	@if [[ -n `which vim` ]] ; then echo "vim: OK" ; else echo "vim: NOT OK" ; fi


config:
	@rm -f $(CONFIG_FILE)
	@echo "NAME="                                                                                      >> $(CONFIG_FILE)
	@echo "VERSION="                                                                                           >> $(CONFIG_FILE)
	@echo "#DIRS="
	@echo "#FILES="
	@echo ""                                                                                           >> $(CONFIG_FILE)
	@echo "bundle-deps:"                                                                               >> $(CONFIG_FILE)
	@echo "\t\t\$$(call fetch_github,ID,REPOSITORY,BRANCH,PATH,TARGET_PATH)" >> $(CONFIG_FILE)
	@echo "\t\t\$$(call fetch_url,FILE_URL,TARGET_PATH)"                                           >> $(CONFIG_FILE)


init-author:
	@echo "AUTHOR=" > ~/.vimauthor.mk

bundle-deps:

bundle: bundle-deps

dist: bundle mkfilelist
	@$(TAR) $(NAME)-$(VERSION).tar.gz --exclude '*.svn' --exclude '.git' $(DIRS) $(README_FILES) $(FILES)
	@echo "$(NAME)-$(VERSION).tar.gz is ready."

init-runtime:
	@mkdir -vp $(VIMRUNTIME)
	@mkdir -vp $(VIMRUNTIME)/record
	@if [[ -n "$(DIRS)" ]] ; then find $(DIRS) -type d | while read dir ;  do \
			mkdir -vp $(VIMRUNTIME)/$$dir ; done ; fi

release:
	if [[ -n `which vimup` ]] ; then \
	fi

pure-install:
	@echo "Installing"
	@if [[ -n "$(DIRS)" ]] ; then find $(DIRS) -type f | while read file ; do \
			cp -v $$file $(VIMRUNTIME)/$$file ; done ; fi
	@echo "$(FILES)" | while read vimfile ; do \
		if [[ -n $$vimfile ]] ; then \
			$(call install_file,$$vimfile) ; fi ; done

install: init-runtime bundle pure-install record


uninstall-files:
	@echo "Uninstalling"
	@if [[ -n "$(DIRS)" ]] ; then find $(DIRS) -type f | while read file ; do \
			rm -fv $(VIMRUNTIME)/$$file ; done ; fi
	@echo "$(FILES)" | while read vimfile ; do \
		if [[ -n $$vimfile ]] ; then \
			$(call unlink_file,$$vimfile) ; fi ; done

uninstall: uninstall-files rmrecord

link: init-runtime
	@echo "Linking"
	@if [[ -n "$(DIRS)" ]]; then find $(DIRS) -type f | while read file ; do \
			ln -sfv $(PWD)/$$file $(VIMRUNTIME)/$$file ; done ; fi
	@echo "$(FILES)" | while read vimfile ; do \
		if [[ -n $$vimfile ]] ; then \
			$(call link_file,$$vimfile) ; fi ; done

mkfilelist:
	@echo $(NAME) > $(RECORD_FILE)
	@echo $(VERSION) >> $(RECORD_FILE)
	@if [[ -n "$(DIRS)" ]] ; then find $(DIRS) -type f | while read file ; do \
			echo $(VIMRUNTIME)/$$file >> $(RECORD_FILE) ; done ; fi
	@echo "$(FILES)" | while read vimfile ; do \
		if [[ -n $$vimfile ]] ; then \
			$(call record_file,$$vimfile,$(RECORD_FILE)) ; fi ; done

vimball-edit:
	find $(DIRS) -type f > .tmp_list
	vim .tmp_list
	vim .tmp_list -c ":MkVimball $(NAME)-$(VERSION)" -c "q"
	@rm -vf .tmp_list
	@echo "$(NAME)-$(VERSION).vba is ready."

vimball:
	find $(DIRS) -type f > .tmp_list
	vim .tmp_list -c ":MkVimball $(NAME)-$(VERSION)" -c "q"
	@rm -vf .tmp_list
	@echo "$(NAME)-$(VERSION).vba is ready."

mkrecordscript:
{{Script}}

record: mkfilelist mkrecordscript
	vim --noplugin -V10install.log -c "so $(RECORD_SCRIPT)" -c "q"
	@echo "Vim script record making log: install.log"

rmrecord:
	@echo "Removing Record"
	@rm -vf $(VIMRUNTIME)/record/$(NAME)

clean: clean-bundle-deps
	@rm -vf $(RECORD_FILE)
	@rm -vf $(RECORD_SCRIPT)
	@rm -vf install.log
	@rm -vf *.tar.gz

clean-bundle-deps:
	@echo "Removing Bundled scripts..."
	@if [[ -e .bundlefiles ]] ; then \
		rm -fv `echo \`cat .bundlefiles\``; \
	fi
	@rm -fv .bundlefiles

update:
	@echo "Updating Makefile..."
	@URL=http://github.com/c9s/vim-makefile/raw/master/Makefile ; \
	if [[ -n `which curl` ]]; then \
		curl $$URL -o Makefile ; \
	if [[ -n `which wget` ]]; then \
		wget -c $$URL ; \
	elif [[ -n `which fetch` ]]; then \
		fetch $$URL ; \
	fi

version:
	@echo version - $(MAKEFILE_VERSION)

# }}}
