Snapshot release of image package 2.1.1
#######################################

:tags: image package; image processing; octave forge;
:date: 2013-11-12 03:38:59

The image package has accumulated a lot of changes since its last
release and I'm hoping to make a new release soon (to match the
release of Octave 3.8.0).  I have prepared a snapshot tarball (version
2.1.1) with the current development status which can be installed
easily with ``pkg``.  Would be great if users of the image package
could give it a try and report any problems that the many changes may
have caused.

It is important to note that this is not a final release.  To make
this clear, and to avoid that this becomes distributed as if it was, I
made it dependent on an yet unreleased version of Octave (it is
dependent on the development version of Octave anyway), and made it
print a warning about it every time the package is loaded. After
reading this, download the tarball and install it with::

  pkg install -nodeps /path/to/tarball

I am partial to the changes in the new version, so these are the ones
that I paid more attention to:

- complete rewrite of ``imdilate`` and ``imerode`` with a performance
  improvement and many compatibility bugs fixed;
- implementation of the ``@strel`` class and support for it in the
  image package functions;
- support for N-dimensional matrices in several functions;
- rewrite of the block processing functions which in some cases
  performs 1000x faster.

There are also a lot of bug fixes and new functions.  Some will break
backwards compatibility really bad but needed to be done for the sake
of Matlab compatibility.  For example, ``bwconncomp`` was returning
indices for object perimeter but should have been returning indices
for all elements in the objects.  So do take a look at the NEWS file
or use ``news image`` after installing the package.

After this release, I plan to follow the Octave core release method of
keeping two development branches: a stable branch for minor releases
with small bug fixes and regressions, and a default branch for big
changes.  Hopefully that will allow for more frequent releases as
things of different levels get ready.

Please report any problems you have found either in Octave's `bug
<http://savannah.gnu.org/bugs/?func=additem&amp;group=octave>`__ or
`patch <https://savannah.gnu.org/patch/?group=octave>`__ trackers.
