Vim-Makefile
============

輕量且無相依的 Makefile ，用於安裝、反安裝、包裝、發佈 Vim 的插件。

簡介
===========

我寫了這個 Makefile 是因為我看見有些人使用 Rakefile 來安裝 Vim 插件腳本，但是有些人們
沒有 rake 或 ruby 在他們的機器上，或是不知如何使用。 我之前甚至使用 Perl 寫了 VIM::Pacakger 
來做類似這樣的事情，但是相依太多模組，且需要時間設置工具。

GNU 的 `make` 是最廣泛被使用在各類的系統上的工具，在所有的電腦上都一定能找的到他。 (Windows 除外)

使用此 Makefile 你只需要有:

* vim
* wget | curl | fetch
* make

等工具即可。

此 Makefile 提供了安裝、反安裝、包裝、發佈 Vim 插件的功能，相當簡單、快速、容易使用。
您同時也可用於產生 Vimball 格式的發佈檔案，或是使用 tar 打包。

(關於 Vimball 的其他資訊，請參考 `:help vimball` 章節)

另外我也附上了一個腳本 `vim-makefile` 用以從 github 抓取最新的 Makefile 來
初始化插件的 Makefile。

安裝
============

請將 bin/vim-makefile 檔案放入你能找到執行檔的路徑內，譬如:

	$ cp bin/vim-makefile /usr/bin/

用法
=====

使用 vim-makefile 命令下載 Makefile:

	$ cd your_plugin
	$ vim-makefile   # will download fresh Makefile from github

附帶一題，您的腳本需要被放置在 {類型}/ 目錄底下，舉例來說:
    
	autoload/blah.vim
    plugin/aaa.vim
	ftplugin/bbb.vim
	snippets/xxxx.snippets

此 Makefile 預設的行為是，當在安裝 Vim
插件時，你的插件名稱預設會是目前目錄名稱，
且會搜尋目前目錄下，所有目錄內的檔案，來進行安裝。 然後 Makefile 會使用 vim
script 來產生安裝紀錄 (該紀錄為 JSON 格式)，會被放置在
`$(VIMRUNTIME)/record/{plugin_name}`

安裝插件:

    $ make install

移除插件:

    $ make uninstall

連結 (link) 插件檔案:

    $ make link

將相依的插件包裝進目前的插件:

	$ make bundle

清理乾淨:

	$ make clean

打包成 Tarball 檔:

	$ make dist

打包成 Vimball 檔:

    $ make vimball

如果你在建立 Vimball 時，想編輯檔案清單，可用:

    $ make vimball-edit

自訂
=========

要自訂 Makefile 的設置，你可以建立一個 `config.mk` 檔，加入如下幾行:

	NAME=hypergit.vim
	VIMRUNTIME=~/.vim
    VERSION=0.2


Makefile 函式
============

*fetch_github*

	$(call fetch_github,[account id],[project],[branch],[source path],[target path])

*fetch_url*

	$(call fetch_url,[file url],[target path])

*fetch_local*

	$(call fetch_local,[from],[to])

Examples:

	$(call fetch_github,c9s,treemenu.vim,master,plugin/treemenu.vim,plugin/treemenu.vim)

	$(call fetch_url,http://......,plugin/xxxx.vim)


打包相依腳本
==========================

你可以將相依的腳本打包至自己的插件內，你可將下列幾行加入你的 `config.mk` 檔

	bundle-deps:
		$(call fetch_github,c9s,treemenu.vim,master,plugin/treemenu.vim,plugin/treemenu.vim)
		$(call fetch_github,c9s,helper.vim,master,plugin/helper.vim,plugin/helper.vim)

然後你可以下此指令來進行打包相依腳本的動作:

	$ make bundle

接著如果你想要發佈你的插件，你可以使用下列命令:

	$ make dist

然後 [plugin\_name].tar.gz 就會被產生出來。
