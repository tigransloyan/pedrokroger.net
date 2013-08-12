---
layout: post
title: "Converting MIDI Files to MP3 on the Mac OS"
date: 2013-08-12 15:02
comments: true
categories:
- music
- mac
---

I often need to convert a bunch of MIDI files to MP3 for teaching and
lecturing. I used to use the venerable Timidity++ on Linux, but since
switching to the Mac I could never quite get it to work. There are a
few commercial graphical apps for the Mac and you can even use
Garageband, but I always wanted to be able to convert MIDI files using
the command line since it's easier and I can automate the whole
process.

<!-- more -->

The easiest way to generate a MP3 from a MIDI on the Mac is by using
[fluidsynth](https://sourceforge.net/apps/trac/fluidsynth/). You can
install it easily with [homebrew](http://brew.sh):

    brew install libsndfile lame
    brew install --with-libsndfile fluidsynth

If everything is working properly, when you run `fluidsynth -T help`
you should see something like the following:

    kroger@orestes $ fluidsynth -T help
    FluidSynth version 1.1.6
    Copyright (C) 2000-2012 Peter Hanappe and others.
    Distributed under the LGPL license.
    SoundFont(R) is a registered trademark of E-mu Systems, Inc.

    -T options (audio file type):
    'aiff','au','auto','avr','caf','htk','iff','mat','mpc','paf','pvf','raw','rf64','sd2','sds','sf','voc','w64','wav','wve','xi'

    auto: Determine type from file name extension, defaults to "wav"


With `fluidsynth` working, the conversion is simple. Just pass a
[SoundFont](http://en.wikipedia.org/wiki/SoundFont) and a MIDI file as
parameters and you should be good to go:

    fluidsynth -F output.wav ~/Soundfonts/my-soundfont.sf2 myfile.midi
    lame output.wav


If you are lazy, check this
[bash script](https://gist.github.com/kroger/6211862). It accepts
multiple MIDI files and removes the intermediate WAV file.
