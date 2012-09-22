---
comments: true
date: 2011-04-10 22:35:15
layout: post
slug: printing-python-code-with-latex
title: Printing python code with LaTeX
wordpress_id: 434
categories:
- latex
- python
---

Call me old fashioned but I like to review my code by printing it.
Yes. Printing. On dead tree.

The advantage of reviewing code on paper instead of the monitor is
that I can give my eyes a break and I can annotate more freely,
connect things with arrows, draw boxes, etc. I don't print my code
everyday, after all this is not the 80's, but I like to print the code
when I feel it could benefit from some refactoring and re-structuring
and my brain could benefit from same change in the medium and even
location (I can grab the printouts and go to a park or cafe).

<!-- more -->

The best way I found to print code is by using the LaTaX [listings]
package (it should be included in any modern LaTeX distribution). This
package is intended to include code snippets in papers and books, but
it works to generate code listings as well.

These are the options I have in my LaTeX document header:

    \documentclass[10pt]{article}
    \usepackage[T1]{fontenc}
    \usepackage[scaled]{beramono}
    \renewcommand*\familydefault{\ttdefault}
    \usepackage{listings}

The [beramono] package is a version of Bitstream Vera Mono modified to
work with TeX. Without it we'll get the default LaTeX mono font:

![code-ugly.png](/images//2011/04/code-ugly.png)

But I like Bitstream Vera better (it looks even betten on paper):

![code-pretty.png](/images/2011/04/code-pretty.png)

Listings has support for Python out-of-the-box and has lots of options
and features (check the [manual] to see what listings can do). These
are the options I like to customize:
    
    \lstset{
      language=Python,
      showstringspaces=false,
      formfeed=\newpage,
      tabsize=4,
      commentstyle=\itshape,
      basicstyle=\ttfamily,
      morekeywords={models, lambda, forms}
    }


Options like tabsize and showstringspace are self-explanatory. The
option `formfeed=\newpage` will replace the formfeed character by the
LaTeX command `\newpage`, creating a new page at that point. Sometimes I
put some line feed characters in my code so I can do things like
[narrowing to a page] in Emacs. Emacs shows line feed characters as
`^L`, as you can see here:

![emacs-formfeed.png](/images/2011/04/emacs-formfeed.png)

The option morekeywords will add the keywords in the list of keywords
recognized by Listings. In my example I added lambda, models and forms
(I've been working a lot with Django lately), so these keywords will
be pretty-printed.

Finally, I use the command `\lstinputlisting` to include a source code
file in the LaTeX file (instead of having to type the whole thing in
the LaTeX file). I like to separate each section by a horizontal line
and add some space at the end. I define a command to abstract this:

    \newcommand{\code}[2]{
      \hrulefill
      \subsection*{#1}
      \lstinputlisting{#2}
      \vspace{2em}
    }

So in the end this is how I insert a Python file:
    
    \code{Models}{../testapp/models.py}

And this is the result:

![listings-model.png](/images/2011/04/listings-model.png)

Pretty neat huh? I believe that reviewing my code on paper has save me
hours of work and I find listings to be a very good option to print
source code. I added a full LaTeX template [here].

Do you print your source code? If so, what tool do you use? Let me
know in the comments.

<!-- Links -->

[listings]: http://www.ctan.org/tex-archive/macros/latex/contrib/listings/
[beramono]: http://www.tug.dk/FontCatalogue/beramono/
[manual]: http://mirrors.ctan.org/macros/latex/contrib/listings/listings.pdf
[narrowing to a page]: http://www.gnu.org/software/emacs/manual/html_node/emacs/Narrowing.html
[here]: : http://pastebin.com/RiGKvz0y
