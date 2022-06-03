less holidays to code for Octave
################################

:tags: octave; octave forge;
:date: 2012-10-27 21:59

Octave Forge has many unmaintained packages.  Way more than the
official list.  Actually, the most unmaintained packages are listed as
maintained since no one has even bothered to even update their status.

Still, unmaintained packages receive the occasional bug report,
sometimes with a patch.  The latest was for ``holidays()`` from the
`financial package
<https://octave.sourceforge.io/financial/index.html>`__.  These are
the best.  It means that not only someone is using the code, but also
that they care enough to try and fix it.

On the opposite side of the spectrum there's things such as `this
commit <https://sourceforge.net/p/octave/code/9421/>`__ (I'm actually
a bit ashamed of it).  It introduced a huge bug that almost anyone
using ``xcorr2()`` should have noticed immediately.  But no one did.
I mean, it was not issuing an incorrect result or anything difficult
to notice, it was giving a very noticeable "error: invalid type of
scale none".  It made ``xcorr2()`` almost useless.  But it was
released with signal-1.1.2 (2012-01-18) and fixed only `8 months later
<https://sourceforge.net/p/octave/code/10897>`__ without anyone ever
complaining.

Anyway, back to the bug in ``holidays()``.  I applied the `second
patch
<http://octave.1599824.n4.nabble.com/bug-37616-holidays-result-incorrect-when-New-Year-s-Day-falls-on-Saturday-tp4645727p4645762.html>`__
from the reporter.  Even though I don't care about this function at
all and the patch did fix this problem, I spent some time looking at
the code.  Not that it was complicated, quite the opposite, but I had
never dealt with dates in Octave before.  And I learned something new.

This function, kind of returns the dates of holidays that close the
NYSE (New York Stock Exchange).  What I did not knew was that when a
holiday falls on a Saturday or Sunday they are shifted to Friday or
Monday respectively.  Thus I definitely did not knew the exception to
this rule.  When the shift would move the holiday to another year
there's no holiday at all (the only case of this is when New Year's
day falls on a Saturday).  And that was exactly the origin of the
problem.

A quite esoteric issue for someone like me.  It is fixed now.  Matlab
compatibility, documentation and performance were increased, new tests
were added, some of my hours were lost, and new useless knowledge was
gained.  Unfortunately, according to the fixed ``holidays()`` people
working at the NYSE now have less holidays to code for Octave.  I'm
sorry.  And I should probably be writing my thesis instead.
