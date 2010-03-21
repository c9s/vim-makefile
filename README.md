Vim-Makefile
============

A lightweight non-dependency Makefile for install, uninstall, bundle, distribute Vim plugin scripts.

DESCRIPTION
===========

I wrote this because I saw people using Rakefile to install plugin scripts. but some people doesn't have 
rake on their system.

GNU `make` is ths most commonly used utility, which is almost in every system,
so it basically doesn't have other dependencies.

This Makefile provides features to install,uninstall,bundle,distribute vim plugin. it's simple 
, quick and lightweight. And you can also use vim-makefile to generate vimball distribution.
(More details of vimball, please see `:help vimball` section)

And I also appended a util `vim-makefile` to fetch the latest Makefile. you can
simply run `vim-makefile` to generate the Makefile.

INSTALLATION
============

Put bin/vim-makefile to your PATH, e.g.



	$ cp bin/vim-makefile /usr/bin/



USAGE
=====

To initialize a Makefile for plugin:


	$ cd your_plugin
	$ vim-makefile   # will download fresh Makefile from github


And your scripts should be put in
{type}/ direcotry. for example:

    
	autoload/blah.vim
    plugin/aaa.vim
	ftplugin/bbb.vim
	snippets/xxxx.snippets


The default behavior is, When installing vim scripts, your plugin name will be
the current directory name, and will search files from all directories to
install. And will use vim script to generate an installation record in JSON
format (also Vim dictionary format), which is located at
`$(VIMRUNTIME)/record/{plugin_name}`

**To install scripts:**

    $ make install

**To uninstall scripts:**

    $ make uninstall

**To link scripts:**

    $ make link

**To import dependented scripts:**

	$ make bundle

**To clean up stuff:**

	$ make clean

**To create dist tarball:**

	$ make dist

**To create vimball distribution:**

    $ make vimball

**If you want to edit the filelist of vimball:**

    $ make vimball-edit

**To update Makefile:**

    $ make update

**To install plugins to other runtime path:**

    $ make install VIMRUNTIME=~/.testing-vim

CUSTOMIZE
=========

To customize makefile config , you can simply create a `config.mk` file , which
is optional , for example:

	NAME=hypergit.vim
	VIMRUNTIME=~/.vim
    VERSION=0.2


FUNCTIONS
=========

*fetch_github*

	$(call fetch_github,[account id],[project],[branch],[source path],[target path])

*fetch_url*

	$(call fetch_url,[file url],[target path])

*fetch_local*

	$(call fetch_local,[from],[to])

Examples:

	$(call fetch_github,c9s,treemenu.vim,master,plugin/treemenu.vim,plugin/treemenu.vim)

	$(call fetch_url,http://......,plugin/xxxx.vim)


BUNDLE DEPENDENTED SCRIPTS
==========================

You can bundle dependented scripts when making a distribution ,add these
lines below to your `config.mk` file:

	bundle-deps:
		$(call fetch_github,c9s,treemenu.vim,master,plugin/treemenu.vim,plugin/treemenu.vim)
		$(call fetch_github,c9s,helper.vim,master,plugin/helper.vim,plugin/helper.vim)

Then you can just bundle scripts from elsewhere:

	$ make bundle

So if you want to make a distribution , you can just type:

	$ make dist

Then the {plugin_name}.tar.gz will come out.

