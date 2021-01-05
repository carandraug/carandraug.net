Function help text in scripts and command line
##############################################

:date: 2017-06-06

I guess I'm one of the few [[citation needed]] that writes Octave
programs instead of only things meant to run from the Octave console.
You end up with a few hundred lines of Octave and tens of functions in
a single file.  For debugging you just source the whole thing.

I always thought that Octave's ``help`` function only handled
functions in their own m files, the help text being the first or
second block of comments that does not start with Author or Copyright.
But I was wrong.  You can document functions in the Octave command
line and you can also document functions in a script.  Octave seems to
pick a block of comments before a function definition as that function
help text.  Like so::

  octave-cli:1> ## This is the help text of the foo function.
  octave-cli:1> function x = foo (y, z), x = y+z; endfunction
  octave-cli:2> ## This is the help text of the bar function.
  octave-cli:2> ##
  octave-cli:2> ## Multi-line help text are not really a problem,
  octave-cli:2> ## just carry on.
  octave-cli:2> function x = bar (y, z), x = y+z; endfunction
  octave-cli:3> man foo
   'foo' is a command-line function

   This is the help text of the foo function.

  octave-cli:4> man bar
   'bar' is a command-line function

   This is the help text of the bar function.

   Multi-line help text are not really a problem,
   just carry on.

It also works in script file with one exception: the first function of
the file which picks the first comment which will be the shebang
line::

  $ cat > an-octave-script << END
  > #!/usr/bin/env octave
  >
  > ## This is the help text of the foo function.
  > function x = foo (y, z)
  >    x = y+z;
  > endfunction
  >
  > ## This is the help text of the bar function.
  > ##
  > ## Multi-line help text are not really a problem,
  > ## just carry on.
  > function x = bar (y, z)
  >   x = y+z;
  > endfunction
  > END
  $ octave-cli
  octave-cli:1> source ("an-octave-script")
  octave-cli:2> man bar
  'bar' is a command-line function

  This is the help text of the bar function.

  Multi-line help text are not really a problem,
  just carry on.

  octave-cli:3> man foo
  'foo' is a command-line function

  !/usr/bin/env octave

I reported `bug #51191 <https://savannah.gnu.org/bugs/?51191>`__ about
it but I was pleasantly surprised that functions help text were being
identified at all.
