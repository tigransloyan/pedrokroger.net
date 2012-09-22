---
layout: post
title: "Using Sphinx to Write Books"
date: 2012-09-19 11:35
comments: true
categories:
- python
---

As I mentioned in a [previous blog post], I used [Sphinx] to write my
ebook, [Music for Geeks and Nerds]. Sphinx was originally developed by
Georg Brandl for the new Python documentation. I wanted to generate
the following formats: HTML, Epub, Mobi (for the Kindle), PDF, and
black & white PDF.

<!-- more -->

## Themes

I created three themes: a minimalist html theme for previewing the book
while I was writing (named 'book'), an epub theme (named 'epub2'), and a
mobi theme ('mobi'). Here is a screenshot of the html theme:

![](/images/2012/09/19/sphinx-html.png "sphinx-html")

Besides removing things  from the base theme such as the sidebar, I
used @font-face to define Anonymous Pro as the font of the source code
examples. I defined the following in my
`themes/book/static/default.css_t` (and repeated the code for bold,
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
file is very simple, I decided to create the layout.html from scratch.
As you can
see [here](https://gist.github.com/3212526 "layout.html for the epub version"),
it's super simple. In the css file I use the same @font-face trick I
used in the html theme. I also changed small things, like not showing
bullets in the Table of Contents:

![](/images/2012/09/19/epub-toc-original.png "epub-toc-original")

![](/images/2012/09/19/epub-toc-new.png "epub-toc-new")

In the following image you can see the difference between the out-of-the
box epub style and my style using pygments and AnonymousPro:

![](/images/2012/09/19/epub-code-original.png "epub-code-original")

![](/images/2012/09/19/epub-code-new.png "epub-code-new")

The mobi theme is very similar to the epub2 style, except it doesn't
use @font-face and the highlighted source code is in black and white.
However, there's a bug on iBooks that prevents it from showing the
right font when one uses the `span` tag, as pygments does to generate
thehighlighted source code. And kindle has similar restrictions.

## Extensions and Custom Builders

I created a few extensions to work productively.

### The epub Builder

The builder epub2 is a subclass of the epub2 and basically it disable
... visible links and replace the `span` tag with `samp`. By default
the builtin epub builder will generate links like this:

![](/images/2012/09/19/epub-link-default.png "epub-link-default")

but I prefer not to show the url,

![](/images/2012/09/19/epub-link-new.png "epub-link-new")

You can see the full builder [here](https://gist.github.com/3212745).

### The mobi Builder

### Code examples

### Autoimage

## Configuration

## Running

<!-- Links -->

[previous blog post]: http://pedrokroger.com/2012/07/music-for-geeks-and-nerds/ "My ebook: Music for Geeks and Nerds"
[Sphinx]: http://sphinx.pocoo.org/ "Sphinx"
[Music for Geeks and Nerds]: http://musicforgeeksandnerds.com/ "Music for Geeks and Nerds"

