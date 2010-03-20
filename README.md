Vim-Makefile
============

Makefile for installing, uninstalling Vim plugin scripts.


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

You can write your bundle script in bundle section in your Makefile, for example:

	bundle:
		$(call fetch_github,c9s,treemenu.vim,master,plugin/treemenu.vim,plugin/treemenu.vim)

So if you want to make a distribution , you can just type:

	$ make dist

or just bundle scripts from elsewhere:

	$ make bundle

USAGE
=====

Put this Makefile to your plugin directory, and edit plugin name in Makefile.
your scripts should be put in {type}/ direcotry. for example:
    
    plugin/util.vim
    plugin/
	autoload/blah.vim


To install scripts:

    $ make install

To uninstall scripts:

    $ make uninstall

To link scripts:

    $ make link

To create dist tarball:

	$ make dist


