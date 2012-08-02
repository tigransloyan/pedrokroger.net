---
comments: true
date: 2010-07-15 21:48:25
layout: post
slug: configuring-emacs-as-a-python-ide-2
title: Configuring Emacs as a Python IDE
wordpress_id: 81
categories:
- emacs
- python
---

Emacs is a huge beast. It can
[read email, play tetris, act as a file manager],
[display google maps], and even [edit videos]. It has support for
many, many programming languages and has many [features] [related] to
[programming]. Unfortunately, emacs doesn't have a full programming
environment for python out-of-the-box.

In this post I'll show how to configure emacs to write
Python programs. We want to have not only basics things like syntax
highlighting, but also code completion, easy access to Python's
documentation, ability to check for common mistakes, run unit tests,
debugging, and a good interactive programming environment.

<!-- more -->

This setup is based on [ipython] and [python-mode], but it's also
possible to use [rope], [ropemacs], and the [auto complete mode] as we
can see [here]. I didn't have much luck with ropemacs in the past but
I'll try it again in the future.


## Tools installation and configuration

First we should install the tools we need.

* **python-mode**. There are two python modes; `python.el` and
    `python-mode.el`. Although `python.el` comes with GNU Emacs 22, I
    recommend you use `python-mode.el` since it has support for
    ipython. (There's some [talk] about merging the two modes, but I
    don't know it's current status). Download and install
    [python-mode] and put the following in your `.emacs`:

        (require 'python-mode)
        (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))

* **ipython**. Ipython is a powerful python shell with advanced
    features and nice code completion. Check [ipython's website]for
    documentation and screencasts. If you're using debian or ubuntu,
    install it with:

        sudo apt-get install ipython

To configure ipython, edit `~/.ipython/ipy_user_conf.py` and add your
options. I like to use `ipy_greedycompleter` so it will complete
things like "foo".TAB.


* **ipython.el**. It allows you to use python-mode with ipython.
    Download and install [ipython.el] and put the following in your
    `.emacs`:

        (require 'ipython)

* **lambda-mode**. This is only for aesthetics. When you install
`lambda-mode.el` it will display a lambda character (λ) when you type
`lambda`:

![Lambda mode in emacs](/images/2010/07/emacs-python-lambda-mode.png)


The full name "lambda" will still be there, emacs is only displaying
it differently. I like lambda-mode because it makes the code look
shorter, neater, and cooler. Download and install [lambda-mode.el] and
put the following in your `.emacs`:

    (require 'lambda-mode)
    (add-hook 'python-mode-hook #'lambda-mode 1)

I had to set the variable `lambda-symbol` to the following, but YMMV:

    (setq lambda-symbol (string (make-char 'greek-iso8859-7 107)))

There are other ways to have pretty lambdas and pretty symbols in
emacs, check the [Emacs Wiki] page to see which one you prefer.


* **anything**. We will use [anything] for code completion. Download
  and install [anything.el], [anything-ipython.el], and
  [anything-show-completion.el], and add the following to your
  `.emacs`:

        (require 'anything) (require 'anything-ipython)
        (when (require 'anything-show-completion nil t)
           (use-anything-show-completion 'anything-ipython-complete
                                         '(length initial-pattern)))

* **Change comint keys**. Comint is a minor-mode to deal with
    interpreter commands in an emacs buffer. It's used by many modes,
    including ipython. Comint uses M-p and M-nto cycle backwards and
    forward through input history. I prefer to use the up and
    down arrow keys:

        (require 'comint)
        (define-key comint-mode-map (kbd "M-") 'comint-next-input)
        (define-key comint-mode-map (kbd "M-") 'comint-previous-input)
        (define-key comint-mode-map [down] 'comint-next-matching-input-from-input)
        (define-key comint-mode-map [up] 'comint-previous-matching-input-from-input)

* **pylookup**. We will use [pylookup] to search python's
  documentation within emacs. First install the python documentation
  locally. If you use debian or ubuntu you can install it with one
  command:

        apt-get install python2.6-doc

If the python documentation is not available as a package for your
system, download it from the [python website] and unzip it somewhere
in your computer. Then download [pylookup] and follow the instructions
in the README file. Run pylookup.py to index the database by running:

    ./pylookup.py -u file:///usr/share/doc/python2.6-doc/html

This command will generate a database file (`pylookup.db`). Naturally,
you need to put the correct path for the python documentation. Next
you need to add the following to your `.emacs`. Again, replace the
values to match your system.

    (autoload 'pylookup-lookup "pylookup")
    (autoload 'pylookup-update "pylookup")
    (setq pylookup-program "~/.emacs.d/pylookup/pylookup.py")
    (setq pylookup-db-file "~/.emacs.d/pylookup/pylookup.db")
    (global-set-key "\C-ch" 'pylookup-lookup)

* **autopair**. A common feature in modern editors is to insert pairs
    of matching elements such as parenthesis, quotes, and braces.
    There are many ways to do this in emacs and installing
    [autopair.el] is probably the easiest one. You can configure it to
    work in all modes and exclude the modes you don't to have it
    activated. For instance, I have it configured to work globally,
    except in the lisp-mode, where I use [paredit]:

        (autoload 'autopair-global-mode "autopair" nil t)
        (autopair-global-mode)
        (add-hook 'lisp-mode-hook #'(lambda () (setq autopair-dont-activate t)))

I also have the following to in my `.emacs` to make autopair work with
python single and triple quotes:


    (add-hook 'python-mode-hook
              #'(lambda () (push '(?' . ?')
                                  (getf autopair-extra-pairs :code))
     (setq autopair-handle-action-fns
          (list #'autopair-default-handle-action
                #'autopair-python-triple-quote-action))))

* **pep8 and pylint**. These scripts are good to check your program
    for style errors and common mistakes. Install pylint and pep8:

    apt-get install pylint pep8

and download and install [python-pep8.el] and [python-pylint.el] to
integrate them with emacs and add the following to your `.emacs`:

    (require 'python-pep8)
    (require 'python-pylint)

* **delete trailing space**. When you type the return key in
    python-mode it'll invoke `py-newline-and-indent`. As the manual
    says, it "deletes the whitespace before point, inserts a newline,
    and takes an educated guess as to how you want the new line
    indented." This is great and I love this feature, but one
    unintended consequence is that you may end up with blank lines
    with trailing spaces. Python doesn't care, but the pep8 tool will
    complain. Put the following in your `.emacs` to delete the
    trailing spaces when saving a file:

        (add-hook 'before-save-hook 'delete-trailing-whitespace)

* **ipdb package**. The [ipdb package] makes it easy to set
  breakpoints in the ipdb debugger. It's easy to install it using
  `easy_install` (duh :-P):

        easy_install ipdb

* **reimport package**. [reimport] is a replacement for Python's
    `reload` function that reloads all modules and sub-modules
    consistently. It's useful for long-running programs and
    interactive development. Install it with `easy_install`:

        sudo easy_install reimport

* **Templates.** [Yasnippet] is a textmate-like templates for emacs.
  [Download Yasnippet] and pet the following in your `.emacs`:

        (require 'yasnippet-bundle)
        (yas/initialize)
        (yas/load-directory "~/.emacs.d/my-snippets/")

You can also install [flymake] to check the syntax on the fly. I find
it distracting, so I don't use it.

All right, these are the tools we need! Now we can go on and use these
features.


## Using python-mode


So now we're ready to go. Open a python file, say `test.py`, type `C-c
!` (`py-shell`) to start the python interpreter. Go back to `test.py`
(with `C-x o`) and type `C-c C-c` (`py-execute-buffer`) to send the
whole buffer to the interpreter. In the following picture we can see
how it works; it's neat to be able to write code in one file and test
it in the interpreter without the whole edit-compile-run-test cycle:

![ipython inside emacs](/images/2010/07/emacs-ipyhon.png)


## Code completion


Code completion is very useful and I find a must to be able to
complete methods for both built-in and user-defined classes. For
instance, if you type "os.path." and `M-tab` emacs will show all
methods available in os.path:

![Python code completion in emacs](/images/2010/07/emacs-python-code-completion-1.png)

This completion method uses [anything] and you can use `C-n` and `C-p`
to navigate through the completion items (when you're done type
return). This works for used-defined methods and functions too:

![Python code completion in emacs](/images/2010/07/emacs-python-code-completion-2.png)


## Access to documentation


Python has excellent documentation and it's a huge bust in
productivity to be able to access the documentation without leaving
the editor. By using pylookup we can type `C-c h` to search any term
in the python documentation. For instance, if we type
"os.path.basename" and then `C-c h` to invoke the documentation,
pylookup will open the documentation page for `os.path.basename` using
the default browser configured in emacs (usually firefox):

![Python documentation in emacs](/images/2010/07/emacs-python-documentation-1.png)

However, many people prefer to use [w3m inside emacs] to browse
technical documentation. With w3m we can read the documentation
without leaving emacs, making it easy to copy code snippets and not
needing to switch to an external program (to much switching can kill
focus). Here's the same documentation in the above picture but using
w3m this time:

![Python documentation inside emacs](/images/2010/07/emacs-python-documentation-2.png)

If you search for something with more than one possible answer,
pylookup will ask you to choose among some possibilities, for
instance, if I search for "print" I'll get many options to choose
from:

![Python documentation in emacs](/images/2010/07/emacs-python-documentation-3.png)


## Code quality


The [pep8 script] checks if your code follow the [PEP8 style guide].
You can run it inside emacs by typing `M-x pep8`. The key M-x ` will
jump to the place in the source code where the next error occurs:

![Pep8 in emacs](/images/2010/07/emacs-pep8.png)

You can run pylint inside emacs with `M-x pylint`, it behaves in a
similar way to pep8:

![Pylint in emacs](/images/2010/07/emacs-pylint.png)


## Unit tests


It's possible to run unit tests inside emacs if we use the
[compilation mode]. Type M-x compile and replace what will appear
(most likely "make -k") with your favorite python program to run unit
tests. As with pep8 and pylint (they both use the compilation mode),
you can type M-x ` to navigate to the next error. In the following
screenshot we can see that `test_square_of_100_is_1000` is not
correct:

![Run unit tests inside emacs](/images/2010/07/emacs-python-nose.png)


## Debugging


There are [many ways] to debug python code. I like to use ipdb,
ipython's debugger, because it has advanced features like code
completion and syntax highlighting. With the `-pdb` flag Ipython will
go directly to the debugger when an exception is raised, instead of
just printing a stack trace. (you may want to edit
`~/.ipython/ipythonrc` to make the change permanent).

To set breakpoints in the regular python debugger, you need to add the
following lines to your code:

    import pdb; pdb.set_trace()

With the [ipdb package] we can set breakpoints in a similar way if
using ipdb:

    import ipdb; ipdb.set_trace()

I like to make emacs highlight the lines that set breakpoints, so I
can easily visualize where the breakpoints are and remember to remove
them from the code after I'm done debugging. I use the following code
to accomplish that:

    (defun annotate-pdb ()
      (interactive)
      (highlight-lines-matching-regexp "import pdb")
      (highlight-lines-matching-regexp "pdb.set_trace()"))

    (add-hook 'python-mode-hook 'annotate-pdb)

Notice in the following screenshot how the line that sets the
breakpoint is highlighted and the program execution stopped at the
breakpoint. I used the command **n** (next) to advance to the next
statement:

![Debugging python with ipdb and emacs](/images/2010/07/debugging-ipdb-emacs.png)

I have a function to add breakpoints mapped to `C-c C-t` so I can set
breakpoints easily:

    (defun python-add-breakpoint ()
      (interactive)
      (py-newline-and-indent)
      (insert "import ipdb; ipdb.set_trace()")
      (highlight-lines-matching-regexp "^[ ]*import ipdb; ipdb.set_trace()"))

    (define-key py-mode-map (kbd "C-c C-t") 'python-add-breakpoint)


## Templates


For textmate-like templates I use [Yasnippet] (be sure to watch its
[demo]). With it you can define templates easily and quickly to fill
things for you, like a new-style class with documentation and an
`__init__` method. Python doesn't have much boilerplate, but using
yasnippet can help you to write code even faster.


## Finding your way in the source code


Emacs allows us to navigate through source code by using [tags]. When
you see a function call you can jump to its definition with `M-.`
(`find-tag`) and jump back with `M-*` (`pop-tag-mark`). Another useful
command is `tags-query-replace`, to rename functions, methods, etc. To
use it we need to generate a TAGS file. Emacs comes with the `etags`
command but I recommend [exuberant tags]:

    sudo apt-get install exuberant-ctags

Usually I put the following code in a Makefile to generate a TAGS file
for a project:

    ctags-exuberant -e -R --languages=python --exclude="__init__.py"


## Dealing with multiple files


As we have seen, we can program in an interactive style in python-mode
by sending the buffer to the python interpreter with `C-c C-c`. This
works well for single file scripts and libraries, but no so well for
more complex modules with sub-modules. For instance, if you open
`file4.py` in the `mainmodule` bellow and execute it with `C-c C-c`
it'll fail if it depends on other submodules.

    mainmodule
    |--- __init__.py
    |--- submodule1
         |--- __init__.py
         |--- file1.py
         |--- file2.py
    |--- submodule2
         |--- __init__.py
         |--- file3.py
         |--- file4.py

We can define a master file using the `py-master-file` variable;
python-mode will execute the file set in the variable instead of the
current buffer's file. This variable can be set as a [file variable],
but I prefer not to pollute every single freaking .py file in a module
with a file variable, so I use a [directory variable] instead. Another
advantage of using directory variables in this case is that each
member of a team can set the `py-master-file` to reflect their file
system layout. Create a file called `.dir-locals.el` in `mainmodule`'s
root with the following content:

    ((python-mode . ((py-master-file . "/path/to/interactivetest.py")
     (tags-file-name . "/path/to/TAGS"))))

(Note that I also define the tags' filename, so emacs'll automatically
load it when I read a python file located in this directory.)

To make this work I use a master file called `interactivetest.py` in
the module's root to re-import the module with the [reimport] package.
This file is not really part of the module and I don't even check it
under version control. Now, every time we hit `C-c C-c`, regardless of
what file we are changing, python-mode will execute
`interactivetest.py` again, and update the whole module. For instance,
this is what I have in the `interactivetest.py` for my aristoxenus
library:

    import reimport
    import aristoxenus
    reimport.reimport(aristoxenus)

But I may add a few things in the `interactivetest.py` file to make
testing things interactively easier and to be able to save it between
coding sessions:

    from aristoxenus.parse import humdrum
    foo = humdrum.parse_string("**kern\n4C")

Of course this is not a substitute for unit tests, but it's nice to
have `foo` available in the REPL so I can inspect it and quickly see
what's going on.


## Conclusion


As you can see, we can have a nice programming environment for python
in emacs. It may look like a lot of work, but in reality we only need
to download and configure already existing packages. However, it would
be nice to have a full-fledged development environment for python like
[slime].

I didn't mention many things like the [emacs code browser], the
[git interface], and the [window session manager]. They are not
particularly specific to python, but they contribute to turn emacs
into a powerful tool for development. Maybe I'll mention then in
another post.

I intend to make a screencast in the future showing these features, so
stay tuned. Meanwhile, what do you use to develop python code?


<!-- Links -->

[Download Yasnippet]: (http://yasnippet.googlecode.com/files/yasnippet-bundle-0.6.1c.el.tgz)
[Emacs Wiki]: (http://www.emacswiki.org/emacs/PrettySymbol)
[PEP8 style guide]: (http://www.python.org/dev/peps/pep-0008/)
[Yasnippet]: (http://code.google.com/p/yasnippet/)
[anything-ipython.el]: (http://www.emacswiki.org/emacs/download/anything-ipython.el)
[anything-show-completion.el]: (http://www.emacswiki.org/cgi-bin/emacs/download/anything-show-completion.el)
[anything.el]: (http://www.emacswiki.org/emacs/download/anything.el)
[anything]: (http://www.emacswiki.org/emacs/Anything)
[auto complete mode]: (http://cx4a.org/software/auto-complete/)
[autopair.el]: (http://autopair.googlecode.com/svn/trunk/autopair.el)
[compilation mode]: (http://www.gnu.org/software/emacs/manual/html_node/emacs/Compilation-Mode.html)
[demo]: (http://www.youtube.com/watch?v=76Ygeg9miao)
[directory variable]: (http://www.gnu.org/software/emacs/manual/html_node/emacs/Directory-Variables.html)
[display google maps]: (http://julien.danjou.info/blog/2010.html)
[edit videos]: (http://1010.co.uk/gneve.html)
[emacs code browser]: (http://ecb.sourceforge.net/)
[exuberant tags]: (http://ctags.sourceforge.net/)
[features]: (http://www.gnu.org/software/emacs/manual/html_node/emacs/Programs.html)
[file variable]: (http://www.gnu.org/software/emacs/manual/html_node/emacs/Specifying-File-Variables.html#Specifying-File-Variables)
[flymake]: (http://www.emacswiki.org/emacs/FlyMake)
[git interface]: (http://philjackson.github.com/magit/)
[here]: (http://www.saltycrane.com/blog/2010/05/my-emacs-python-environment/)
[ipdb package]: (http://pypi.python.org/pypi/ipdb)
[ipython's website]: (http://ipython.scipy.org/moin/Documentation)
[ipython.el]: (http://ipython.scipy.org/dist/ipython.el)
[ipython]: (http://ipython.scipy.org/moin/Documentation)
[lambda-mode.el]: (http://dishevelled.net/elisp/lambda-mode.el)
[many ways]: (http://aymanh.com/python-debugging-techniques)
[paredit]: (http://www.emacswiki.org/emacs/ParEdit)
[pep8 script]: (http://github.com/jcrocholl/pep8)
[programming]: (http://www.gnu.org/software/emacs/manual/html_node/emacs/Maintaining.html)
[pylookup]: (http://taesoo.org/Opensource/Pylookup)
[python website]: (http://docs.python.org/download.html)
[python-mode]: (https://launchpad.net/python-mode)
[python-pep8.el]: (http://gist.github.com/raw/302847/3331473995b55cc578e7d63dd82474749367c29c/python-pep8.el)
[python-pylint.el]: (http://gist.github.com/raw/302848/60961ad1134e7bec5d836857fb67109245548dad/python-pylint.el)
[read email, play tetris, act as a file manager]: (http://www.gnu.org/software/emacs/tour/)
[reimport]: (http://code.google.com/p/reimport/)
[related]: (http://www.gnu.org/software/emacs/manual/html_node/emacs/Building.html)
[rope]: (http://rope.sourceforge.net/)
[ropemacs]: (http://rope.sourceforge.net/ropemacs.html)
[slime]: (http://common-lisp.net/project/slime/)
[tags]: (http://www.gnu.org/software/emacs/manual/html_node/emacs/Tags.html)
[talk]: (http://mail.python.org/pipermail/python-mode/2009-January/000514.html)
[w3m inside emacs]: (http://emacs-w3m.namazu.org/)
[window session manager]: (http://www.emacswiki.org/emacs/EmacsLispScreen)
