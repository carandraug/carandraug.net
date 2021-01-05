GSoC 2013: imerode and imdilate (update #6)
###########################################

:tags: image processing;
:date: 2013-09-27 00:23:23

Since I deviated so much from the original project while `fixing the
image IO functions in Octave core
<{filename}./gsoc-2013-update-5.rst>`__, I decided to only focus on
optimizing the imerode and imdilate in the final phase of GSoC.  The
reason is that these are at the core of many functions in the image
package.

On the `original project
<http://www.google-melange.com/gsoc/project/google/gsoc2013/carandraug/17001>`__
it was planned to do all the work by expanding the
__spatial_filtering__ function and that's where I `previously started
<{filename}./gsoc-2013-update-3.rst>`__.  While doing so, it became
evident that a complete rewrite was necessary. The convn() which could
be used in most cases of binary images was performing much faster even
though it was performing a more complex operation.  As such,
performing at least as fast as convn() became the target which was
achieved::

  octave> se = [0 1 0; 1 1 1; 0 1 0];
  octave> im = rand (1000) > 0.5;
  octave> t = cputime (); for i = 1:100, a = imerode (im, se, "same"); endfor; cputime() - t
  ans = 2.1281
  octave> t = cputime (); for i = 1:100, a = convn (im, se, "same") == nnz (se); endfor; cputime() - t
  ans = 2.7802

This implementation could be reused in __spatial_filtering__ to also
speed up functions such as medfilt2, ordfilt2, and ordfiltn but there
are specific algorithms for those cases which should be used instead.

I have tested the new implementation of imerode against the last
release (version 2.0.0) and the last development version that was
still making use of __spatial_filtering__ (cset 6db5e3c6759b). The
tests are very simple (`test imerode
<{static}/files/gsoc-2013-test.m>`__), just random matrices with
different number of dimensions.  The new implementation seems to
perform much faster in all cases, and shows a performance increase
between 1.5-30x (`output of test imerode
<{static}/files/gsoc-2013-test-output.txt>`__).  The differences are
bigger for grayscale images (since imerode was already using convn for
binary cases), and larger structuring elements (SE) with multiple
dimensions.

A couple of things:

- in the latest release of the image package (version 2.0.0), there
  was no erosion for multidimensional binary images (only grayscale);
- both development versions make use of the new strel class.  One of
  the things that it does, its to decompose structuring elements
  automatically, hence why the tests use a cross rather than a square
  for SE;
- I'm only testing with the shape "same" since version 2.0.0 only had
  that one;
- when using binary images I test with different percentages of true
  values since the new implementation is sensitive to it;
- I do not compare the results since I know the new implementations
  also fix some bugs, specially related to the border pixels.
- imdilate uses exactly the same code and so I'm assuming that the
  differences from imerode are the same.

===============================  ===================  =======================  ========================  ===================  ===================
             ---                 version 2.0.0 (old)  cset 6db5e3c6759b (dev)  latest development (new)  Performance old/new  Performance dev/new
===============================  ===================  =======================  ========================  ===================  ===================
2D binary image (90%)            0.009081             0.024602                 0.006240                  1.4551               3.9423
2D binary image (10%)            0.007360             0.022881                 0.004160                  1.7692               5.5000
3D binary image with 2D SE       NO!                  0.481470                 0.079125                  n/a                  6.0849
3D binary image with 3D SE       NO!                  0.518032                 0.075605                  n/a                  6.8519
7D binary image with 5D SE       NO!                  13.940071                0.463229                  n/a                  30.093
2D uint8 image                   0.062324             0.043403                 0.029322                  2.1255               1.4802
3D uint8 image with 2D SE        NO                   NO                       0.430347                  n/a                  n/a
3D uint8 image with 3D SE        3.061951             1.725628                 0.791569                  3.8682               2.1800
7D uint8 image with 3D SE        NO                   NO                       2.005325                  n/a                  n/a
7D uint8 image with 7D SE        4.091456             2.940984                 0.541634                  7.5539               5.4298
2D uint8 image with a larger SE  0.610678             0.305579                 0.087445                  6.9835               3.4945
===============================  ===================  =======================  ========================  ===================  ===================
