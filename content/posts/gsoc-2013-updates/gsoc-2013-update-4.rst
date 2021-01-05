GSoC 2013: GraphicsMagick (update #4)
#####################################

:tags: image processing; GraphicsMagick;
:date: 2013-07-30 16:11:06

Octave uses `GraphicsMagick <http://www.graphicsmagick.org/>`_ (GM)
for reading and writing of images, which gives us a unique interface
to read many different formats through a simple and unique interface.
We actually get support for `more image formats
<http://www.graphicsmagick.org/formats.html>`_ than Matlab.

However, I'm starting to think that GM may not be the best option, or
even an option at all, if we wish to be Matlab compatible. The reason
is that GM does not gives us methods to access information about the
actual image that is on file, only about how the image is being
stored. I'll be listing the problems I have faced during the last few
weeks while improving image IO in Octave.

Note that I'm not arguing that GM is bad. We can use it to read pretty
much any image, the problem is that what we read may be different from
what was in the file. Octave needs to get the original image values
and not one of the possible representations of that image. GM is doing
a great job at being smart but we may need something more stupid.

Quantum depth
-------------

It is well know among those that use Octave for reading images, that
we're dependent on the quantum depth used to build GM. The way it
works is that GM can be built with quantum 8, 16 and 32 and defines
the type it uses to store the image values (uint8, uint16, and uint32
respectively). Independently of the original image values, GM will
scale the values for the range of the type. If the file has 8 bit
depth, and GM was built with quantum 16, we will need to fix the range
(this seems to be one of the few cases where we can get the actual
image information using the depth() method). As long as the images
have their values as unsigned integers there is no problem but images
are not limited to those types. Images with values as floating point
become a problem (see {{< octave bug 39249 >}}) since we loose all
information about the range. Also, it appears that at least the JPEG
2000 format may use int16 instead of uint16 and I have no idea what to
do about that.

Image class
-----------

GM defines two `Image Class types
<http://www.graphicsmagick.org/api/types.html#classtype>`_: direct and
pseudo class.  Direct class is for a "normal" image where the image is
"*composed of pixels which represent literal color values*".  Pseudo
class if for indexed images where the image is "*composed of pixels
which specify an index in a color palette*", or colormap in Octave
vernacular.  The problem is that the class is not of the original
image but based on what GM guesses will increase performance.  This
leads to some JPEG (a format that has no support for indexed images at
all), being `reported as PseudoClass
<https://sourceforge.net/mailarchive/message.php?msg_id=31180507>`_
probably because they have few unique colors.  And
we can't make the decision based on the image format since some (such
as TIFF and PNG) support both.  If an image from that format reports
being pseudo class, we have no method to find if GM is choosing that
for performance or if it's the original file class.

Image type
----------

Similarly to the image class, GM also has `image types
<http://www.graphicsmagick.org/api/types.html#imagetype>`_.  There's
many more image types which define the image of any class as bilevel,
grayscale, RGB, or CMYK, with and without opacity (called matte in
GM). Just like it does for the image class, GM guesses which type is
better so a file with a RGB image that only uses one of the color
channels will report being grayscale, or even bilevel if it only has
two values on that channel (see `(bug #32986)
<https://savannah.gnu.org/bugs/?32986>`__ and `(bug #36820)
<https://savannah.gnu.org/bugs/?36820>`__).

----

For now, there's not much we can do. Adding methods to find
information about the actual image in file through GM is not trivial
and outside the scope of my project. I have already implemented the
options I proposed to, the ones that allow reading and writing of
multi-dimensional images.

Fixing the problems of indexed images and alpha channels was nor part
of the proposal but it makes sense to do it as I was going through the
code. We are now Matlab compatible but in some cases there is nothing
we can do, it's just the way GM works.

If we wish to be 100% Matlab compatible when reading images, some
other strategy is needed. Whether that means improving GM or replace
it with other libraries I don't know. What we need is a C++ library
for reading and writing of images in any formats and gives us access
to the original image values.
