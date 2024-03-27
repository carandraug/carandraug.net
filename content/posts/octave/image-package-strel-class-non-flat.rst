image package: strel class, non-flat morphology and spatial transformations
###########################################################################

:tags: octave; image package; image processing;
:date: 2013-01-08 06:45

There's been a lot of development on the image package lately, spurred
by contributions from `Pantxo Diribarne
<mailto:pantxo.diribarne@gmail.com>`__ and `Roberto Metere
<mailto:roberto@metere.it>`__.  While these have not been tested
enough for a release, they're on a state where we could welcome some
testing.  If you can't get development version from subversion, please
give `this tarball
<http://carandraug.no-ip.org/octave/image-2.1.0.tar.gz>`__ a try
(prepared from revision 11551).

strel class
-----------

The ``strel`` class was something that I wanted to implement a long
time ago but had never found the time. The name strel comes from
*str*\ ucturing *el*\ ement (SE), the shapes used in morphological
operations such as dilation and erosion.  I have only seen it as a
standard way to create SEs, but is actually much more.  Specially, SE
decomposition can have a really nice increase in performance.

Roberto Metere submitted his own implementation of the class last
month and we have been working on it, slowly adding it to the other
functions of the package.  It started as a single .m function, no OOP
at all, but he managed to implement ``@strel`` with the old ``@class``
style while keeping matlab compatibility.  All the basic methods have
been implemented: the object constructor, ``getnhood``, ``getheight``
and ``reflect``.

The idea behind SE decomposition is that morphology operations take as
much space as the number of pixels in a SE.  The bigger the SE, the
slower it will be.  However, some SE can be replaced by a sequence of
smaller ones so it's in our best interest to use them.  For an example
on performance, see how the use of a square compares to use of 1 row
and 1 column of the same size::

 octave> im1 = im2 = randp (5, 2000) > 15;
 octave> t = cputime ();
 octave> im1 = conv2 (im1, true (20), "same") > 0; # dilation by 1 square
 octave> cputime () - t
 ans =  2.6402
 octave> t = cputime ();
 octave> im2 = conv2 (im2, true (20, 1), "same") > 0; # dilation by 1 column
 octave> im2 = conv2 (im2, true (1, 20), "same") > 0; # dilation by 1 row
 octave> cputime () - t
 ans =  0.52803
 octave> isequal (im1, im2)
 ans =  1

At the moment, decomposition is only being done for rectangular,
square and cube shapes but other will come with time.  Functions that
can gain from SE decomposition, are written so that it does not matter
if it has been implemented for a specific shape.  This means that when
it is implemented for another shape, its effect will be immediate
across the whole image package.  The only file where this is done is
``inst/@strel/getsequence.m`` so send us patches.

Going through ``imdilate()`` and ``imerode()`` to make them use
``strel``, brought up a bunch of other matlab incompatibilities that I
hope are now fixed, as well as other improvements.  I'm a bit
interested in morphology of volumes so one of the changes made was
making them work for N-dimensional images (think MRI scans).

On top of the matlab shapes for ``strel``, I implemented the cube as
an optional shape.  I also wanted to implement ball as a volume but
unfortunately, matlab has already done it wrong as a non-flat
ellipsoid.  Note that non-flat is unrelated to volumes.

Non-flat morphology
-------------------

This has confused me for a very long time.  Because of the name
(non-flat), and because 3D images are the norm for me, I have always
assumed that a non-flat SE was one used for volumes.  The fact that
the only non-flat standard shape in matlat is named ball, which
immediately brings up the idea of volume, also helped to the
confusion.

Actually, non-flat morphology is something that only makes sense for
grayscale operations.  A non-flat SE is defined by two different
matrices, one defining the neighbourhood (same as a flat SE) and
another defining the height of each neighbour.  These heights are
added to the image pixels values before the erosion and dilation, in
the same way as the variable *S* in ``ordfiltn``.

Basically, not useful for volumes at all but the image package can do
this now.  To create a non-flat SE, use the arbitrary shape of ``strel``.

Spatial transformations
-----------------------

`Pantxo Diribarne <mailto:pantxo.diribarne@gmail.com>`__ has also
submitted a set of functions for spatial transformations:
``maketform``, ``cp2tform``, ``tformfwd``, and ``tforminv``.  These
are still not completely implemented and generally restricted to 2D
transforms.  Adding the missing options should now be much easier.
