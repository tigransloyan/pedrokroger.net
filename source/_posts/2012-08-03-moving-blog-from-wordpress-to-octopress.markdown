---
layout: post
title: "Moving Blog from Wordpress to Octopress"
date: 2012-08-03 11:19
comments: true
categories: blog
---

I decided to move my blog from [Wordpress] to [Octopress]. I actually
like Wordpress; it has lots of useful plugins and professional themes.
The main reason I decided to move was because my posts have a fair
amount of code and images and it's inconvenient to type and edit them
using the Wordpress editor.

<!-- more -->

Yes, there are Wordpress plugins to highlight code snippets and The
WYSIWYG editor is nice, but very often you need to switch to the HTML
editor to enter tags such as `pre` (to type the `brush` class) and
even `tt`. Also, you don't have control of how the HTML code looks
because the editor keeps reformatting it. The main advantage of using
Octopress is that I can use any editor I want. And although there are
hacks to use external editors with Wordpress and ways to write in
[Markdown], I never found a work flow that I liked.

In the next images you can see how the same blog post looks on the
Wordpress editor and on Emacs:

![](/images/2012/08/03/code-wordpress.png)

![](/images/2012/08/03/code-octopress.png)

The syntax highlighting is much better and helpful on Emacs and we
don't need to replace characters by entities in the code block such as
`&lt;`.

So far I'm very happy with the result. I've used [exitwp] to convert
my posts from Wordpress to Markdown and I imported the comments to
[Disqus]. For some odd reason the comments are not showing in my page,
even if I can see them on Disqus' dashboard. I hope I can fix that in
the following days. I apologize in advance for any other breakage.

If you have suggestions, please leave a comment!

<!-- Links -->

[Wordpress]: http://wordpress.org
[Octopress]: http://octopress.org
[Markdown]: http://daringfireball.net/projects/markdown/
[exitwp]: https://github.com/thomasf/exitwp
[Disqus]: http://disqus.com
