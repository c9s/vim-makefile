Vim-Makefile
============

A lightweight non-dependency Makefile for install, uninstall, bundle, distribute Vim plugin scripts.

DESCRIPTION
===========

I wrote this because I saw people using Rakefile to install plugin scripts. but
some people don't have rake on their system, and the Rakefile is not flexible
for users to extend rules and which can't bundle dependented scripts too.

GNU's `make` is ths most commonly used utility, which is almost in every system,
so it basically doesn't have other dependencies.

This Makefile provides features to install,uninstall,bundle,distribute vim plugin. it's simple 
, quick and lightweight. And you can also use vim-makefile to generate vimball distribution.
(More details of vimball, please see `:help vimball` section)

And I also appended a util `vim-makefile` to fetch the latest Makefile. you can
simply run `vim-makefile` to generate the Makefile.



The default behavior is, When installing vim scripts, your plugin name will be
current directory name, and will search files from all directories to
install. Files with .vim extension of current directory will be installed too.
(but please make sure you've added a comment like `"script type: plugin` in your script)


Then Makefile will use vim script to generate an installation record in JSON
format (also Vim dictionary format), which is located at
`$(VIMRUNTIME)/record/{plugin_name}`


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
{type}/ directories. for example:

	autoload/blah.vim
    plugin/aaa.vim
	ftplugin/bbb.vim
	snippets/xxxx.snippets


Or you can also just put a vim file in current directory:

    commenter.vim

But Please add a comment below to your script file:

    " script type: {type}

where {type} is your script type. just replace it with 'plugin' ,'ftplugin' or
something else.




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

**config.mk**

To customize makefile config , you can simply create a `config.mk` file , which
is optional , for example:

    $ make config

This will generate `config.mk`, now you can edit the file:

	NAME=hypergit.vim
	VIMRUNTIME=~/.vim
    VERSION=0.2

### To define dependencies

add `GIT_SOURCES` macro to your config.mk

    GIT_SOURCES= \
        git@github.com:c9s/html5.vim.git \
        git@github.com:c9s/perlomni.vim.git

    # dependency checkout path (optional)
    DEPEND_DIR=/tmp/vim-depes

**~/vimauthor.mk**

_TODO_

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

Then the {plugin\_name}.tar.gz will come out.


FREEBSD
=======

For users are using FreeBSD as platform. please execute `gmake` (GNU Makefile) instead of `make`.

And ensure your `gmake` is using bash shell.

Setup SHELL env in Makefile or config.mk to let Makefile work.

    SHELL = /opt/local/bin/bash

Then run:

    $ gmake install

