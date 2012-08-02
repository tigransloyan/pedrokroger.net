---
comments: true
date: 2010-08-31 15:55:59
layout: post
slug: sicp-in-python
title: SICP in Python
wordpress_id: 274
categories:
- python
- sicp
---

_Structure and Interpretation of Computer Programs_ (a.k.a SICP, or "The Wizard Book") is considered one of the [great computer science books](http://www.amazon.com/review/R3G05B1TQ5XGZP/ref=cm_cr_rdp_perm). [Some people](http://programming-musings.org/2007/01/31/a-scheme-bookshelf/) claim it will make you a [better programmer](http://lispy.wordpress.com/2007/10/13/how-studying-sicp-made-me-a-better-programmer/). It was the entry-level computer science subject at MIT and it's still used in universities like Berkeley. One of the great things about SICP is that it focus on computational processes and ideas, instead of just teaching syntax. We can find more about the book's goals in the [Preface to the First Edition](http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-7.html):


<!-- more -->

> Our design of this introductory computer-science subject reflects two major concerns. First, we want to establish the idea that a computer language is not just a way of getting a computer to perform operations but rather that it is a novel formal medium for expressing ideas about methodology. Thus, **programs must be written for people to read, and only incidentally for machines to execute**. Second, we believe that the essential material to be addressed by a subject at this level is not the syntax of particular programming-language constructs, nor clever algorithms for computing particular functions efficiently, nor even the mathematical analysis of algorithms and the foundations of computing, but rather the techniques used to control the intellectual complexity of large software systems. **Our goal is that students who complete this subject should have a good feel for the elements of style and the aesthetics of programming**.


The emphasis in bold is mine to show a couple of my favorite quotes (my favorite quote of all times must be Alan Perlis' "Syntactic sugar causes cancer of the semicolon", but I digress).

The whole book is [available for free](http://mitpress.mit.edu/sicp/full-text/book/book.html) and the book's page at MIT has lots of [extra material](http://mitpress.mit.edu/sicp/). Also, there are some highly recommended [video lectures](http://groups.csail.mit.edu/mac/classes/6.001/abelson-sussman-lectures/) by the authors of the book.

SICP uses the Lisp dialect [scheme](http://en.wikipedia.org/wiki/Scheme_(programming_language)), but since SICP concentrates on _programming ideas_ rather than languages, there are some efforts to translate the code in the book to [other programming languages](http://www.codepoetics.com/wiki/index.php?title=Topics:SICP_in_other_languages). I think this is a good thing, because even if scheme is a beautiful language (it really is) and I think everyone should learn it, it's good to see how the ideas presented in SICP can be translated to other languages.

I have read a good chunck of SICP and watched most video lectures before, but I didn't do the exercises. Now, I want to read it again and do as many exercises as I can. Since I've been programming a lot in Python these days, I am curious to see how the ideas in SICP will translate to Python. So, my plan is to read the book and do the exercises using Python instead of Scheme. There are good [notes](http://eli.thegreenplace.net/category/programming/lisp/sicp/) and [solutions](http://www.kendyck.com/solutions-to-sicp/) for the exercises on the web and I may consult those as needed (giving fully credit, of course).

I'll post my notes with the (Python) code. I'll try to capture the essence of each section, instead of trying to post every single thing and exercise, but we'll see how it works. I hope this will be a good resource for the Python community. Let me know in the comments what you think.

Why don't you go ahead and read the [post about section 1.1](http://pedrokroger.net/blog/2010/08/sicp-in-python-1-1-the-elements-of-programming/)?
