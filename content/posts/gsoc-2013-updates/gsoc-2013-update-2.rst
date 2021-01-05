GSoC 2013: imformats and filenames (update #2)
##############################################

:tags: image processing;
:date: 2013-07-11 17:01:54

Since my last post, I've been working on the image IO abilities of
Octave by implementing the missing function imformats().  The purpose
of this function is to control imread(), imwrite(), and imfinfo(), by
adding support for new image formats and/or changing how to act with
existing ones.

By default, Octave's image IO functions (imread(), imwrite(), and
imfinfo()) use the GraphicsMagick library for their operations.
Through GraphicsMagick, Octave can support a vast number of image
formats, a much larger number than the ones required for Matlab
compatibility.  However, because of the large ammount of image formats
in science and their commonly closed nature, this is still not enough
to support all image formats out of the box.

.. raw:: html

   <p style="text-align: center;"><em>Enter imformats()</em></p>

imformats() keeps an internal list of all the supported image formats,
and what functions should be used to deal with them.  What this mean
is that when a user calls, for example, imread(), that function only
needs to ask imformats() what function should be used to read the
file, and then pass all the arguments to it.

In my experience (mainly microscopy), the majority of the closed image
formats in science are works around TIFF.  For example, a lsm file is
just a TIFF file.  By default, Octave will recognize it as TIFF and
try to read it as such.  However it will fail because only half of the
images inside the file are the actual images that are meant to be
read.  The other half are thumbnails to them and should be skipped.
In another example, dv files are also just TIFF files but for some
weird reason the images are inverted.  Here's how to read such files::

 if (strcmpi (extension,".lsm"))
   image = imread (file, 1:2:nPages*2);
 elseif (strcmpi (extension,".dv"))
   image = imread (file, 1:nPages);
   image = rotdim (image, 2, [1 2]);
 else
   ## let imread decide
   image = imread (file, 1:nPages);
 endif

Note that the actual code is a bit more complicated that what I'm
showing in order to account for old versions of the formats which
can't be deduced by file extension alone.

As can be seen, most changes required to make Octave able to correctly
read other formats are small hacks around imread().  But we can't
simply add a new format to imformats instructing imread() to use a
function that makes use of imread() or we will get stuck in an endless
loop.  Since the actual function performing the action is now
separated, one must use the function handle returned by imformats().
imread() can now be configured to read the above formats with the
following code::

 function image = read_lsm (filename, varargin)
   tif = imformats ("tif");
   ## piece of code to figure nPages from varargin
   image = tif.read (filename, 1:2:nPages*2);
 endfunction
 function image = read_dv (filename, varargin)
   tif = imformats ("tif");
   ## piece of code to figure nPages from varargin
   image = tif.read (filename, 1:nPages);
   image = rotdim (image, 2, [1 2]);
 endfunction

 lsm = dv = imformats ("tif");

 lsm.read = @read_lsm;
 imformats ("add", "lsm", lsm);

 dv.read = @read_dv;
 imformats ("add", "dv", dv);

This is something not meant to be done in the main code.  It's
something that can be added to an .octaverc file, or even better, to
the PKG_ADD scripts of an Octave package mean to add support to other
image formats.

The end result is Octave consistent code that abstracts himself from
file formats.

Filename and Mathworks bashing
------------------------------

There's a tiny detail that complicated things a bit.  My understanding
of filename is that it includes the file extension.  However, someone
at Mathworks seems to think that is open to discussion and made
possible to define the extension as a separate argument.  As if that
was not weird enough, the extension is completely ignored if a file is
found without trying to add the extension.  Consider the following
situation where you have two images, with and without extension::

 >> ls
 test_img
 test_img.tif
 test_img2.jpg

 >> imread ("test_img");          # reads test_img
 >> imread ("test_img.tif");      # reads test_img.tif
 >> imread ("test_img2", "jpg");  # reads test_img2.jpg
 >> imread ("test_img", "tif");   # reads test_img! ????

So yeah!  Why would we pass the extension as a separate argument just
to have it ignored?  I may be wrong about the why of this API but my
guess is that it's required to support more arguments after the
extension::

 >> imread ("test_img.tif", "Index", 1:10, "PixelRegion", {[250 350] [100 200]})

If imread() can find a file without the extension, then whatever comes
next must be the reading options, and not the extension.  But then,
why does imwrite() does the same?  It certainly can't make that
decision based on whether the file already exists.  So we have to
check if we have an odd or even number of leftover arguments.

And why the possibility to not specify the file extension in the first
place?  Again, just my guess.  To cover the stupidity of people who
don't know about file extensions because their file managers hides
them.

Interestingly, the question whether file extension belongs to the
filename is only relevant with image files. Other functions such as
audioread(), csvread(), fopen(), or wavread() do not suffer of this.

For more Matlab bashing, go read the `abandon matlab blog
<http://abandonmatlab.wordpress.com/>`_.
