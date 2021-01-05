GSoC 2013: rewriting imerode and imdilate (update #3)
#####################################################

:tags: image processing; matlab bashing;
:date: 2013-07-25 01:50:45

I pride myself in writing heavily commented code. That's not
necessarily a good thing, maybe it shows that I need an explanation
for things that others consider too trivial to comment, parts were the
code comments itself.

Still, sometimes I take a specific approach to a problem, find a
problem with it and change it. At the start I thought it to be the
best solution, I was unable to foresee the problem. Someone coming
later may have the same initial idea as me, and attempt to implement
it just to find the same problem. Provided the problem is found early
enough, such things are never committed so one can't simply look into
the logs. That's why I have a fair amount of comments on why code was
not written in some other way.

The following is a comment block that I wrote for the imdilate
function (currently a m file) that will never be commited since I
ended up rewriting the whole thing in C++. But at least I can reuse it
for the blog post since it explains a long standing problem with the
morphology functions of the image package. Oh! And the comment was so
long that I actually thought it deserved its own title on the source
code::

      The problem of even sized and non-symmetric Structuring Elements

  Using convn() to perform dilation and erosion of binary images is a
  a *lot* faster than using __spatial_filtering__(). While that is
  probably an indication that __spatial_filtering__ could be improved,
  we still use convn() for both simplicity and performance.

  Erosion is simpler to understand because it's a simple spatial filter,
  not unlike stamping on the image. Now, dilation is the erosion of the
  image complement. This explains how for grayscale images, erosion and
  dilation are minimum and maximum filters respectively. The concept is
  quite simple as long as the SE is symmetric. If not, then there's the
  small detail of having to translate it, i.e., rotate around its center.
  But convn() already performs the translation so we don't do it for
  dilation (the one that would need it), but do it for erosion (because
  convn() will undo it by retranslating it).

  A second problem are even sized SE. When one of the sides has an even
  length, then we have more than one possible center. For Matlab
  compatibility, the center coordinates is defined as
        floor ([size(SE)/2] + 1)
  That's also what convn() uses which is good, but since we also need to
  do translation of the SE, small bugs creep in which are hard to track
  down.

  The solution for non-symmetric is simple, the problem arises with the
  even sizes. So we expand the SE with zeros (no effect on the filter)
  and cut the extra region in the output image.

  Note: we could use cross correlation since it's like convolution without
  translation of the SE but: 1) there is no xcorrn(), only xcorr() and
  xcorr2(); 2) even xcorr2() is just a wrapper around conv2() with a
  translated SE.

After spending an entire day playing with the translation of `SE
<http://en.wikipedia.org/wiki/Structuring_element>`__'s and padding of
images, I decided to rewrite imdilate and imerode.  Once you
understand what these are actually doing you'll see why.

Consider erosion of a logical image as the simplest example. This is
basically sliding the SE over the image, and check the values of the
image under the true elements of the SE. If any of them is false, then
the value at those coordinates on the output matrix will be
false. There's not even need to check the value of all elements under
the SE, we can move to the next as soon as we find one that does not
match.

Convolution however, needs to multiply the value of the SE with the
values on the image, and then sum them all together to get the value
for the output matrix. And all of that in double precision. And still,
it was performing faster. Just take a look at the following::

  octave> im = rand (1000) > 0.3;
  octave> se = logical ([0 1 0; 1 1 1; 0 1 0]);

  octave> t = cputime (); a = convn (im, se, "valid") == nnz (se); cputime() - t
  ans =  0.12001
  octave> t = cputime (); c = __spatial_filtering__ (im, se, "min", zeros (3), 0); cputime() - t
  ans =  2.3641

There's a couple of reasons why ``__spatial_filtering__`` is slower,
but I think the main reason is that it was written to be of a more
general tool. It has a lot of conditions that makes it quite useful
for all the other functions while working nicely with images with any
number of dimensions. But it's 20 times slower, performing something
that should be a lot simpler. Since dilation and erosion are at the
core of most morphology operators, they are among the ones that should
be optimized the most.

So I wrote my own code for dilation in C++ and managed to make it a
lot faster than __spatial_filtering__.  Since my implementation does
not actually evaluate all of the values its performance on the
distribution of true elements in the input matrix.  And while it's a
lot faster than __spatial_filtering__, it's still not faster than
convn::

  octave> im1 = rand (1000) > 0.3;
  octave> im2 = rand (1000) > 0.95;
  octave> t = cputime (); a = convn (im1, se, "valid") == nnz (se); cputime() - t
  ans =  0.11601
  octave> t = cputime (); b = imerode (im1, se, "valid"); cputime() -t
  ans =  0.21601
  octave> t = cputime (); c = __spatial_filtering__ (bb, se, "min", zeros (3), 0); cputime() -t
  ans =  2.3681

  octave> t = cputime (); a = convn (im2, se, "valid") == nnz (se); cputime() - t
  ans =  0.12001
  octave> t = cputime (); b = imerode (im2, se, "valid"); cputime() -t
  ans =  0.16001
  octave> t = cputime (); c = __spatial_filtering__ (im2, se, "min", zeros (3), 0); cputime() -t
  ans =  2.3681

As can be seen, even under optimal conditions (when most of the input
matrix is false, my implementation still performs slower than convn).
But I'm not done with it yet.
