# Makefile: install/uninstall/link vim plugin files.
# Author: Cornelius <cornelius.howl@gmail.com>
# Date:   一  3/15 22:49:26 2010
#
#
# TODO: support vimball.

NAME=PLUGIN_NAME
DIRS=autoload \
	 after \
	 doc \
	 syntax \
	 plugin 

RECORD_FILE=.record
VIMRUNTIME=~/.vim
PWD=`pwd`

all: install

init-runtime:
	@find $(DIRS) -type d | while read dir ;  do \
			mkdir -p $(VIMRUNTIME)/$$dir ; done

pure-install:
	@echo "Installing"
	@find $(DIRS) -type f | while read file ; do \
			cp -v $$file $(VIMRUNTIME)/$$file ; done

install: init-runtime pure-install record

uninstall: rmrecord
	@echo "Uninstalling"
	@find $(DIRS) -type f | while read file ; do \
			rm -v $(VIMRUNTIME)/$$file ; done

link: init-runtime
	@echo "Linking"
	@find $(DIRS) -type f | while read file ; do \
			ln -sfv $(PWD)/$$file $(VIMRUNTIME)/$$file ; done

mkfilelist:
	@echo $(NAME) > $(RECORD_FILE)
	@find $(DIRS) -type f | while read file ; do \
			echo $(VIMRUNTIME)/$$file >> $(RECORD_FILE) ; done

mkrecordscript:
	@echo "Making Record Script (Vim)"
	@echo ""  > .record
	@echo "# vimana record format:"  >> .record
	@echo "# {"  >> .record
	@echo "#          version => 0.2,    # record spec version"  >> .record
	@echo "#          generated_by => 'Vimana-' . $Vimana::VERSION,"  >> .record
	@echo "#          install_type => 'auto',    # auto , make , rake ... etc"  >> .record
	@echo "#          package => $self->package_name,"  >> .record
	@echo "#          files => \@e,"  >> .record
	@echo "#  }"  >> .record
	@echo "fun! s:mkmd5(file)"  >> .record
	@echo "  if executable('md5')"  >> .record
	@echo "    return system('cat ' . a:file . ' | md5')"  >> .record
	@echo "  else"  >> .record
	@echo "    return \"\""  >> .record
	@echo "  endif"  >> .record
	@echo "endf"  >> .record
	@echo "let files = readfile('.record')"  >> .record
	@echo "let package_name = remove(files,0)"  >> .record
	@echo "let record = { 'version' : 0.3 , 'generated_by': 'Vim-Makefile' , 'install_type' : 'makefile' , 'package' : package_name , 'files': [  ] }"  >> .record
	@echo "for file in files "  >> .record
	@echo "  let md5 = s:mkmd5(file)"  >> .record
	@echo "  cal add( record.files , {  'checksum': md5 , 'file': file  } )"  >> .record
	@echo "endfor"  >> .record
	@echo "redir => output"  >> .record
	@echo "silent echon record"  >> .record
	@echo "redir END"  >> .record
	@echo "let content = join(split(output,\"\\n\"),'')"  >> .record
	@echo "let record_file = expand('~/.vim/record/' . package_name )"  >> .record
	@echo "cal writefile( [content] , record_file )"  >> .record
	@echo "echo \"Done\""  >> .record

record: mkfilelist mkrecordscript
	vim --noplugin -c "redir! > install.log" -c "so .record.vim" -c "q"
	@echo "Vim script record making log file: install.log"

rmrecord:
	rm -v $(VIMRUNTIME)/record/$(NAME)

clean:
	rm -v $(RECORD_FILE)
	rm install.log

#  vim record format:
#  {
#           version => 0.2,    # record spec version
#           generated_by => 'Vimana-' . $Vimana::VERSION,
#           install_type => 'auto',    # auto , make , rake ... etc
#           package => $self->package_name,
#           files => \@e,
#   }
