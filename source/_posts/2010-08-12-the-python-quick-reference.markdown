---
comments: true
date: 2010-08-12 14:52:42
layout: post
slug: the-python-quick-reference
title: The Python Quick Reference
wordpress_id: 249
categories:
- latex
- python
---

I uploaded a new version of my [Python Quick Reference]. You can
access it by clicking on the top menu. The Python cheat sheets I found
on the internet were either too long, not too pretty, or didn't have
the source available so I could change it to fit my taste.

<!-- more -->

![python-quick-ref.png](/images/2010/08/python-quick-ref.png)

I designed the Python Quick Reference using LaTeX. I used common
packages like _color_, _multicol_, and _graphicx_ to have colored
text, four columns, and to insert the python logo. I used [beramono]
--- a "version of Bitstream Vera Mono slightly enhanced for use with
TeX" --- and [utopia] to have better looking fonts. I used the [tikz]
package to create the round boxes that separate each section.

The box creation is abstracted in the `\header` macro:

    \newcommand{\header}[1]{
      \begin{tikzpicture}
        \node [fill=shade,rounded corners=5pt]
        {
          \parbox{.95\linewidth}{
            \large
            \textcolor{blue}{\sf \textbf{\raisebox{-15pt}{#1}}}
            \vspace*{1ex}
          }
        };
      \end{tikzpicture}
      \par
    }

With this macro I can create each section with a command like
`\header{Built-in functions}`. Simple and easy ;-)

Finally, I used the [dirtree package] to display the built-in
exceptions hierarchy as a tree:

![Built-in exceptions as a tree](/images/2010/08/ex-built-in-exceptions.png)

I like using something like LaTeX and dirtree because I can copy the
exception hierarchy from the Python documentation and have LaTeX
display it for me. If the list changes, it's easier to update it than
if I was using a graphical program. On the other hand I'm not 100%
satisfied with the result, so I'm looking for another tree package for
LaTeX. If you know one that might be good, let me know in the
comments.

If you want something more substantial (and yet short), maybe the
[Python Pocket Reference] is what you're looking for. In addition to
paper, it's available in pdf, epub, and kindle (mobi) formats.
(Disclaimer: I don't have any affiliation with O'reilly and the above
link it's **not** an affiliate link.)

That's it, a simple and good looking cheat sheet in minutes, courtesy
of LaTeX. I may include a third page in the future with some useful
functions from the standard library. There are also things that I
didn't figure out how to display in a short space, like data
structures, iterators and generators. Please let me know in the
comments if you have any ideas or suggestions.

**UPDATE:** Sarabander implemented some fixes and improvements
(Thanks!). Go grab the [new version].

<!-- Links -->

[Python Quick Reference]: /pages/python-quick-reference/
[beramono]: http://www.tug.dk/FontCatalogue/beramono/
[utopia]: http://www.tug.dk/FontCatalogue/utopia/
[tikz]: http://www.texample.net/tikz/
[dirtree package]: http://www.ctan.org/tex-archive/macros/generic/dirtree/
[Python Pocket Reference]: http://oreilly.com/catalog/9780596158095
[new version]: https://github.com/downloads/kroger/python-quick-ref/python-quick-ref.pdf
