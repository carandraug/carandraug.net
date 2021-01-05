GSoC 2013: done with ImageIO - please test (update #5)
######################################################

:tags: image processing; graphicsmagick;
:date: 2013-09-04 06:56:45

The imageIO section of the original project was much shorter than
this.  Originally it was limited to `implement imformats
<https://hg.savannah.gnu.org/hgweb/octave/rev/861516dcad19>`__, and
then expand it to do the writing and reading of multipage images in a
Matlab compatible way which is just implementing the options `Index
and Frames in imread
<https://hg.savannah.gnu.org/hgweb/octave/rev/997efb8d0b19>`__, and
`WriteMode in imwrite
<https://hg.savannah.gnu.org/hgweb/octave/rev/54b75bed4bc7>`__.  The
date of that last commit was 16th of July.  However, I didn't stop
there and tried to fix other incompatibilities with Matlab and add new
options.

Here's a list of the main changes:

- dealing with transparency: alpha channel is now returned as the
  third output of imread and only accepted with the Alpha option of
  imwrite. Previously, the alpha channel would be considered the 2nd
  or 4th element on the 3rd dimension for grayscale and RGB images
  respectively. This prevented the distinction between a RGB with
  transparency and a CMYK image. Also, since GraphicsMagick has the
  transparency values inverted from most other applications (Matlab
  inclusive), we were doing the same. This has been fixed.

- CMYK images: implemented reading and writing of images in the CMYK
  colorspace.

- imread options: in addition to Index and Frames, also implemented
  PixelRegion, which may speedup reading when only parts of the image
  are of interest, and Info, for compatibility only, which doesn't
  have any effect at the moment.

- imwrite options: in addition to WriteMode, implemented Alpha (as
  mentioned above).

- indexed images: implement writing of indexed images. Previously,
  indexed images would be converted to RGB which would then be
  saved. An indexed image will now always return indexes independently
  if a colormap was requested as output (previously, a raster image
  would be returned in such cases).

- floating point and int32 images: GraphicsMagick is integer
  exclusively and we can't differentiate between an image saved with
  int32 or floating point. Since the latter are far more common Octave
  will now return a floating point image when GraphicsMagick reports a
  bitdepth of 32. Previously, images with more than a reported
  bitdepth of 16 would not be read at all (note that this is dependent
  on the GM build options. If GM's quantum depth was 16 or 8, the most
  common, GM would report a file with 32 bitdepth with the quantum
  depth it was built with so it would read files with a bitdepth of 32
  as long as it was not built with quantum depth 32).

- bitdepth: imread now returns the actual bitdepth of the image in the
  file rather than trying to optimize it. This is still not perfect
  but we're making a better guess at it than before (this should be
  very simple but with GraphicsMagick it's not).

- imfinfo: some new fields, specially reading of Exif and GPS data
  which allowed to deprecate readexif in the image package.

In the end, I recognize that there's some incompatibilities left to
fix but I don't know how anymore.  As I mentioned on my `previous post
<{filename}./gsoc-2013-update-4.rst>`__, GraphicsMagick is too smart
for our use.  I predict that we will eventually have to move to
something different, if for nothing else, to read and write floating
point images without trouble.  I only had a quick glance on
alternatives but `FreeImage <http://freeimage.sourceforge.net/>`__
would seem like a good bet.  Of course, there's also the possibility
to write our library wrapper around the format specific libraries.

Would be nice if users could throw some images to imread and imwrite
and report any bugs. I'm specially afraid of regressions since there
was so much stuff changed and we don't really have tests for these
functions yet.
