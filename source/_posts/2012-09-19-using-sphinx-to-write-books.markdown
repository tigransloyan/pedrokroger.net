---
layout: post
title: "Using Sphinx to Write Technical Books"
date: 2012-09-19 11:35
comments: true
categories:
- python
---

As I mentioned in a [previous blog post], I used [Sphinx] to write my book, [Music for Geeks and Nerds] and to generate the following formats: HTML, Epub, Mobi (for the Kindle), and two PDF versions (black-and-white and color). Sphinx was originally developed by Georg Brandl for the new Python documentation. It works quite nicelly out-of-the-box for documenting computer programs. However, I had to bend it a little to generate an output more suitable for a book.

<!-- more -->

I … while I was writing the book, and since my goal was to ship the damned thing, some of these solutions go from good to hacky, from ok to horrific.

## Themes

Sphinx comes with a few [themes] out-of-the-box and it's very easy to create [new themes].
I created three themes: a minimalist html theme for previewing the book
while I was writing (named 'book'), an Epub theme (named 'epub2'), and a
mobi theme ('mobi'). Here is a screenshot of the html theme:

![](/images/2012/09/19/sphinx-html.png "sphinx-html")

Besides removing things from the base theme such as the sidebar, I
used @font-face to define Anonymous Pro as the source code
examples font. I defined the following in my
`themes/book/static/default.css_t` (with similar code for for bold,
italic, and bold-italic):

    @font-face {
        font-family: AnonymousPro;
        font-weight: normal;
        font-style: normal;
        src: url("fonts/Anonymous Pro.ttf");
    }

In `themes/book/theme.conf` I defined Palatino as the body font:

    bodyfont = 'Palatino', serif
    headfont = Tahoma, Geneva, sans-serif;

The epub theme is very simple. Sphinx comes with a default theme, But it
has some rough edges. For instance, it shows a copyright notice at the
end of each chapter:

![](/images/2012/09/19/epub-copyright.png "epub-copyright")

Most Sphinx themes extends a basic theme. Since the html for the epub
file is very simple, I decided to create the `layout.html` file from scratch,
without inheriting from the base layout.
As you can see [here](https://gist.github.com/3212526 "layout.html for the epub version"),
my Epub theme is super simple. In the css file I use the same `@font-face` trick I
used in the html theme. I also changed small things, like not showing
bullets in the Table of Contents:

![](/images/2012/09/19/epub-toc-original.png "epub-toc-original")

![](/images/2012/09/19/epub-toc-new.png "epub-toc-new")

In the following image you can see the difference between the out-of-the
box epub style and my style using pygments and AnonymousPro:

![](/images/2012/09/19/epub-code-original.png "epub-code-original")

![](/images/2012/09/19/epub-code-new.png "epub-code-new")

The mobi theme is very similar to the epub2 style, except it doesn't
use `@font-face` and the highlighted source code is black and white, since
most kindle readers don't support these features.
However, there's a bug in iBooks that prevents it from showing the
right font when one uses the `span` tag, as pygments does to generate
the highlighted source code. Kindle seems to have similar restrictions.
To fix this I need to create a custom builder.

## Extensions and Custom Builders

I created a few extensions to work productively.

### The epub Builder

The builder `epub2` is a subclass of the epub builder that comes with Sphinx and it disables visible links and replaces the `span` tag with `samp`. By default
the builtin epub builder will generate links like this:

![](/images/2012/09/19/epub-link-default.png "epub-link-default")

but I prefer not to show the url:

![](/images/2012/09/19/epub-link-new.png "epub-link-new")

You can see the full builder [here](https://gist.github.com/3212745).

### The mobi Builder

I created a mobi builder by copying the epub builder from Sphinx and making the necessary changes. Maybe I could have subclassed it (I've seen a mobi builder on github that did that), but I wanted to have separate configuration options for the mobi file.

### Code examples

Sphinx makes it realy easy to show [code examples] with `literalinclude`, specially with the `:pyobject:` option, which shows only a selected Python class, function, or method. in the following example I want to show the definition of the function `note_name` defined in `pyknon/simplemusic.py`:

 
```
.. literalinclude:: pyknon/simplemusic.py
   :pyobject: note_name
```

This is very simple and straightforward, but I also wanted an easy way to show examples displaying the usage of a function and the result of its computation, like in the following image:

![](/images/2012/09/19/note-name.png "note name example")

I could just type the code on the python REPL and copy and paste the result, but if the function changes I might need to update the examples manually, which could lead to some examples being outdated or wrong. And wrong examples is a big source of frustation in programming books.

So solve this I hacked an extension called `code-example` that behaves like `literalinclude`, but it adds the code and the result of its invocation in a Python REPL. Its usage is the same as `literalinclude`:

```
.. code-example:: note_name.py
```

Following is the content of `note_name.py`. Notice it calls `note_name` four times, but it doesn't have the result of the function calls. The result will be computed by `code-example`. Also, `import` lines won't show in the result:

``` python
from pyknon.simplemusic import note_name

note_name(0)
note_name(1)
note_name(13)
note_name(3)
```

You can find [code-example here]. It's a very hackish solution, but it saved a lot of time checking if my code examples where updated and gave more confidence in the result.

### Autoimage

One of the most anoying things about working with a source file that is intended to have multiple outputs such as PDF and HTML is how to deal with images. Often images will have to be scaled differently depending on the medium. For instance, I used to have code like the following:


```
.. only:: not latex

   .. image:: figs/notation3.png
      :scale: 40

.. only:: latex

   .. image:: figs/notation3.png
      :scale: 80
```

It has quite a bit of repetition since the filename is the same, and since Sphinx is fastidious about spacing and blank lines (for instance, it needs the blank like after the line with `..only`), I'd ……

I wrote the extension [autoimage] to simplify this. With it the previous code becomes:

```
.. autoimage:: notation3.png
   :scale-html: 40
   :scale-latex: 80
```

It's somewhat smart. It tries to use a pdf image if it's available and the backend is LaTeX, and looks for a black-and-white image if the configuration option `black_and_white` is true.

After I finished the extension and converted the whole book I discovered that Sphinx caches  things and share values among builds. It means that, in the previous example, if I built a pdf and a html version of my book in that order, `notation3.png` would be scaled 80% in both cases, instead of 80 and 40 percent. To solve this I just run `sphinx-build` with the `-E` option.


## Configuration

My [Sphinx configuration] file is the most boring part of this blog post, but I'm including it here in case you're curious. I unset a few LaTeX options since I use a separate [LaTeX style]:

```
latex_elements = {
     'papersize': '',
     'fontpkg': '',
     'fncychap': '',
     'maketitle': '\\cover',
     'pointsize': '',
     'preamble': '',
     'releasename': "",
     'babel': '',
     'printindex': '',
     'fontenc': '',
     'inputenc': '',
     'classoptions': '',
     'utf8extra': '',
}

latex_additional_files = ["mfgan-bw.sty", "mfgan.sty", "_static/cover.png"]
```

I also map a few unicode characters to their LaTeX equivalents:

```
def setup(app):
     from sphinx.util.texescape import tex_replacements
     tex_replacements += [(u'♮', u'$\\natural$'),
                          (u'ē', u'\=e'),
                          (u'♩', u'\quarternote'),
                          (u'↑', u'$\\uparrow$'),
                          ]
```


## Running

Finally, I use a custom [Makefile] to run Sphinx. It manages to be even more boring than my configuration file, but it's what allows me to generate multiple outputs. The secret is to use the `-D` option in `sphinx-build` to set or override a setting in the configuration file. For instance, these are the options I use to generate a black and white PDF to be printed and a color PDF to be read on the screen:

```
PAPEROPTS = -D latex_elements.pointsize=11pt -D latex_elements.preamble=\\usepackage{mfgan-bw} -D pygments_style=bw -D black_and_white=True -D code_example_wrap=67 -D latex_show_pagerefs=True

SCREENOPTS = -D latex_elements.pointsize=12pt -D latex_elements.classoptions=,openany,oneside -D latex_elements.preamble=\\usepackage{mfgan} -D pygments_style=my_pygment_style.BookStyle -D code_example_wrap=67
```

## Conclusion


<!-- Links -->

[previous blog post]: http://pedrokroger.com/2012/07/music-for-geeks-and-nerds/ "My ebook: Music for Geeks and Nerds"
[Sphinx]: http://sphinx.pocoo.org/ "Sphinx"
[Music for Geeks and Nerds]: http://musicforgeeksandnerds.com/ "Music for Geeks and Nerds"
[themes]: http://sphinx.pocoo.org/theming.html
[new themes]: http://sphinx.pocoo.org/templating.html
[code examples]: http://sphinx.pocoo.org/markup/code.html#includes
[code-example here]: https://gist.github.com/3856749
[autoimage]: https://gist.github.com/3856821
[Sphinx configuration]: https://gist.github.com/3856835
[LaTeX style]: https://gist.github.com/3856845
[Makefile]: https://gist.github.com/3856862