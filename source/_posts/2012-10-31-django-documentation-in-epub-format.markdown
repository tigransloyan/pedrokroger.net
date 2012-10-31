---
layout: post
title: "Django Documentation in ePub Format"
date: 2012-10-31 7:00
comments: true
categories: 
- python
- django
- sphinx
---

The [Django documentation] is now available in ePub format, thanks to [Read the Docs]. Because the Django documentation is written using [Sphinx], we can generate HTML, PDF, and ePub out of the box. However, it's necessary [some tweaking] to make Sphinx generate a better looking ePub. In this post I'll share some of the changes I did. You can check [this post] for more details.

<!-- more -->

By default Sphinx shows a navigation bar and spells out the urls in links. Also, by some crazy reason, I get an error when viewing the ePub file provided by the Django website (using iBooks). In the following images we can see the ePub from the Django website on the left and the one I generated on the right:

{% img /images/2012/10/31/navigation.png 384 %}
{% img /images/2012/10/31/no-navigation.png 384 %}

By default Sphinx adds a copyright footer after every chapter. Since I find it superfluous, I've removed it on the theme I use. Again, the ePub from the Django site is on the left and the one I generated on the right:

{% img /images/2012/10/31/footnote.png 384 %}
{% img /images/2012/10/31/no-footnote.png 384 %}

The biggest change I've made was excluding content. I found that reading technical documents on a tablet can be difficult because it's not as easy to jump around. Therefore, to make the ePub more manageable, I decided to exclude in the final file the glossary, the release notes, the index, and the deprecated and obsolete documentation. Naturally, I find all these documentation items relevant and important, but I find that I need to refer to them less often, making them available on the ePub less necessary (and I'm glad I can access them online anytime I want). Also, I changed the depth of items in the TOC from 3 to 2 to make it more manageable on a tablet:

{% img /images/2012/10/31/toc.png 384 %}

I used Anonymous Pro as the font of the code examples.

{% img /images/2012/10/31/code.png 384 %}

And finally, a quick cover to make it prettier ;-)

{% img /images/2012/10/31/cover.png 384 %}

You can download the ePub for the [1.4 version] and the upcoming [1.5 version]. Please keep in mind that these files are somewhat experimental; I generated them for my own use. Let me know in the comments if you find any problems. The code is on [github] on the branches `stable/1.4.x` and `stable/1.5.x`, respectively. 

[Django documentation]: https://docs.djangoproject.com/en/1.4/
[Read the Docs]: https://readthedocs.org
[Sphinx]: http://sphinx.pocoo.org
[some tweaking]: http://pedrokroger.net/2012/10/using-sphinx-to-write-books/
[this post]: http://pedrokroger.net/2012/10/using-sphinx-to-write-books/
[1.4 version]: https://s3.amazonaws.com/media.pedrokroger.net/docs/Django-1.4.epub
[1.5 version]: https://s3.amazonaws.com/media.pedrokroger.net/docs/Django-1.5.epub
[github]: https://github.com/kroger/django