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
		@echo ""  > .record.vim
		@echo "fun! s:mkmd5(file)"  >> .record.vim
		@echo "  if executable('md5')"  >> .record.vim
		@echo "    return system('cat ' . a:file . ' | md5')"  >> .record.vim
		@echo "  else"  >> .record.vim
		@echo "    return \"\""  >> .record.vim
		@echo "  endif"  >> .record.vim
		@echo "endf"  >> .record.vim
		@echo "let files = readfile('.record')"  >> .record.vim
		@echo "let package_name = remove(files,0)"  >> .record.vim
		@echo "let record = { 'version' : 0.3 , 'generated_by': 'Vim-Makefile' , 'install_type' : 'makefile' , 'package' : package_name , 'files': [  ] }"  >> .record.vim
		@echo "for file in files "  >> .record.vim
		@echo "  let md5 = s:mkmd5(file)"  >> .record.vim
		@echo "  cal add( record.files , {  'checksum': md5 , 'file': file  } )"  >> .record.vim
		@echo "endfor"  >> .record.vim
		@echo "redir => output"  >> .record.vim
		@echo "silent echon record"  >> .record.vim
		@echo "redir END"  >> .record.vim
		@echo "let content = join(split(output,\"\\n\"),'')"  >> .record.vim
		@echo "let record_file = expand('~/.vim/record/' . package_name )"  >> .record.vim
		@echo "cal writefile( [content] , record_file )"  >> .record.vim
		@echo "echo \"Done\""  >> .record.vim


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
