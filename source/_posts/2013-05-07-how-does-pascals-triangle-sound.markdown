---
layout: post
title: "How Does Pascal's Triangle Sound?"
date: 2013-05-07 15:47
comments: true
categories: 
---

The idea of transforming a mathematical sequence into sound may sound
(no pun intended, but I'll take it) strange at first, but people have
been doing it for ages. In this post we will generate some music
randomly to have and idea of how it sounds and then we will see how
sequences like Fibonacci and Pascal's triangle sound.

This post is taken from
[Music for Geeks and Nerds](http://musicforgeeksandnerds.com). You can
find all code and examples for free
[here](http://musicforgeeksandnerds.com/resources.html). I use the
open source [pyknon](https://github.com/kroger/pyknon) library to
generate the music examples. This
[free chapter](https://s3.amazonaws.com/musicforgeeksandnerds.com/Pyknon+from+Music+for+Geeks+and+Nerds.pdf)
explains how to use `pyknon`.

tl;dr: Random music sounds bad, Pascal's triangle sounds great!

<!-- more -->

The functions discussed in this section are in the file
`random_combination.py`. This file has a few utilities functions
such as `choice_if_list` and ``genmidi`` that we won’t see here
since they are simple and boring. You may explore them in the source
file.

The function `random_notes` generates a sequence of notes by
choosing a pitch randomly from a list of pitches. The second, third,
and fifth arguments define the octave, duration, and volume,
respectively. If any of these arguments is a list, `choice_if_list`
will pick one element randomly or return the argument itself if it's a
number. Finally, the argument `number_of_notes` contains how many
notes we want to generate.


``` python
def random_notes(pitch_list, octave, duration,
                 number_of_notes, volume=120):
    result = NoteSeq()
    for x in range(0, number_of_notes):
        pitch = choice(pitch_list)
        octave = choice_if_list(octave)
        dur = choice_if_list(duration)
        vol = choice_if_list(volume)
        result.append(Note(pitch, octave, dur, vol))
    return result
```


In the following example we want to generate five notes from the
[chromatic scale](http://en.wikipedia.org/wiki/Chromatic_scale), in
any octave from five to six, with quarter note, eighth note, or
sixteenth note durations:

``` python
>>> random_notes(range(0, 12), range(5, 7), [0.25, 0.5, 1], 5)
<Seq: [<A>, <B>, <C#>, <A#>, <F#>]>
```

In the following example we generate random notes from the
[pentatonic scale](http://en.wikipedia.org/wiki/Pentatonic_scale), in
the central octave, with a duration of an eighth note:

``` python
>>> random_notes([0, 2, 4, 7, 9], 5, 0.5, 5)
<Seq: [<C>, <A>, <D>, <A>, <G>]>
```

Let’s generate a hundred notes from the chromatic scale, in any octave
from 0 to 8 (that’s quite a range!), and using all basic
durations. (We're using `from __future__ import division`, so we can
type things like 1/4 instead of 0.25).

``` python
def random1():
    chromatic = range(0, 12)
    durations = [1/64, 1/32, 1/16, 1/8, 1/4, 1/2, 1]
    notes1 = random_notes(chromatic,
                          range(0, 9),
                          durations,
                          100,
                          range(0, 128, 20))
    gen_midi("random1.mid", notes1)
```

[[Play example]](http://media.pedrokroger.net/audio/02+random1.mp3)

Notice how this example sounds. Do you think it sounds similar to the
music you enjoy? There's no right answer here, but most people will
think this doesn't sound good. Even if you find it interesting at
first, it may get boring after a while (try it with a thousand
notes!). But I don't want to control your listening here; if you like
it, we'll still love you.


Now let's add some restrictions. We'll generate the same hundred
random notes from the chromatic scale, but this time within a smaller
range and with only two durations:

``` python
def random2():
    chromatic = range(0, 12)
    notes2 = random_notes(chromatic,
                          range(3, 7),
                          [1/16, 1/8],
                          100)
    gen_midi("random2.mid", notes2)
```

[[Play example]](http://media.pedrokroger.net/audio/03+random2.mp3)

What do you think? I imagine you'll agree that it sounds much more
familiar than the previous track. This is because we are using a more
restricted octave range and note values.

Now we’ll generate another hundred notes from the pentatonic scale,
in any octave from 5 to 6 (only two octaves), and with a duration of a
sixteenth note:

``` python
def random3():
    pentatonic = [0, 2, 4, 7, 9]
    notes = random_notes(pentatonic,
                         range(5, 7),
                         1/16,
                         100)
    gen_midi("random3.mid", notes)
```

[[Play example]](http://media.pedrokroger.net/audio/04+random3.mp3)

By having only one note value and a very recognizable scale, this
example may sound the most familiar to you.

Naturally, nobody can tell how you should listen to things. Maybe
`random1` was the example you liked the best. However, one important
point here is that random music almost never sounds good or
familiar. Repetition and constraints are important.



Music from Math
---------------

Often, beautiful mathematics doesn't make beautiful music
and vice versa, but sometimes it does.

Let’s define a function `play_list` that is similar to
`random_notes`, but instead of picking random notes from a list, it
receives a list of numbers and turn them into notes:

``` python
def play_list(pitch_list, octave_list, duration,
              volume=120):
    result = NoteSeq()
    for pitch in pitch_list:
        note = pitch % 12
        octave = choice_if_list(octave_list)
        dur = choice_if_list(duration)
        vol = choice_if_list(volume)
        result.append(Note(note, octave, dur, vol))
    return result
```

Now let’s see how Fibonacci’s sequence and Pascal’s triangle sound.
Pascal's triangle is an array of the binomial coefficients that has
all kinds of neat properties. Check
[Pascal's Triangle And Its Patterns](http://ptri1.tripod.com) for
more. Here are the first six rows:

          1
         1 1
        1 2 1
       1 3 3 1
      1 4 6 4 1
    1 5 10 10 5 1

The utility function `pascals_triangle` in
`random_combinations.py` will generate each row as a list. For
instance, to generate the first five rows:

``` python
>>> list(pascals_triangle(5))
>>> [[1], [1, 1], [1, 2, 1], [1, 3, 3, 1], [1, 4, 6, 4, 1]]
```

There's something funny about transforming the Fibonacci sequence into
music. Here are the first 25 numbers in the sequence: 0, 1, 1, 2,
3, 5, 8 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181,
6765, 10946, 17711, 28657. If we apply `mod12` on them we'll get the
following notes: 0, 1, 1, 2, 3, 5, 8, 1, 9, 10, 7, 5, 0, 5, 5, 10, 3,
1, 4, 5, 9, 2 11, 1. If we apply `mod12` on the next 25 numbers in
the Fibonacci sequence we will get the same list of notes: 0, 1, 1, 2,
3, 5 8, 1, 9, 10, 7, 5, 0, 5, 5, 10, 3, 1, 4, 5, 9, 2, 11, 1. That is,
the Fibonacci sequence mod 12 is cyclical! Try to listen to this
repetition in the sound example below.

In the following function we make one list with the first 55 Fibonacci
numbers and another with the first 30 rows in Pascal's triangle. We
use these numbers as input for the `play_list` function:

``` python
def random_fib():
    octave = range(5, 7)
    fib = fibonacci(100000000000)
    pascal = flatten(pascals_triangle(30))

    n1 = play_list(fib, octave, 1/16)
    n2 = play_list(pascal, 4, 1/16)
    n3 = play_list(pascal, octave, 1/16)

    gen_midi("fibonnacci.mid", n1)
    gen_midi("pascal.mid", n2)
    gen_midi("pascal_octaves.mid", n3)
```


[[Play the Fibonacci sequence]](http://media.pedrokroger.net/audio/05+fibonnacci.mp3)

[[Play Pascal's Triangle]](http://media.pedrokroger.net/audio/06+pascal.mp3)

[[Play Pascal's Triangle with octaves]](http://media.pedrokroger.net/audio/07+pascal_octaves.mp3)

To be honest, when I was writing the code I thought Pascal’s triangle
was going to sound boring due to the repetitions. But it turns out
that I like it very much! (Don’t hold that against me). One more proof
that repetition is good.


Input your favorite integer sequence in `play_list` and see how it
sounds. If you don’t have a favorite integer sequence, go to The
[On-Line Encyclopedia of Integer Sequences](https://oeis.org/) and
pick one.
