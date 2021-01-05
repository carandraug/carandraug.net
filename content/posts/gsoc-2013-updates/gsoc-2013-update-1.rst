GSoC 2013: image processing of ND images (update #1)
####################################################

:tags: image processing;
:date: 2013-06-05 19:26:05

My project proposal for `image processing of ND images in GNU Octave
<http://www.google-melange.com/gsoc/project/google/gsoc2013/carandraug/17001>`__
was accepted for Google Summer of Code 2013.  If all goes as planned,
not only will it be a very nice improvement to the image package but
also a chapter on my PhD thesis.

I decided to warm up by implementing ``montage()`` which basically
displays all pages (or frames) of an ND image as a single 2D image.
It is not part of the proposal but the coding period hasn't started
anyway, and it will be really useful for the rest of the project.  So
useful indeed, I had wrote my own version of it last year, completely
unaware of Matlab's implementation and of course, completely
incompatible.  So I had to do it all over again.

Following the trend of changing 20000 other small things first, my
first contribution ended up being a `fix for `ind2rgb()
<http://hg.savannah.gnu.org/hgweb/octave/rev/4c11e9bcb796>`__ causing
a `complaint
<http://octave.1599824.n4.nabble.com/ind2rgb-problem-tp4653534.html>`__
in just two hours.  Never had I made a commit with such immediate
repercussions.  Still, I'm taking it positively because:

1. means I'm changing code that people use and care about;
2. my fix was actually correct :)

I guess the main problem users will have is understanding ND images.
While images can have many dimensions, the standard is to have them as
a 4D matrix, the multiple images concatenated into the 4th dimension,
and the 3rd being reserved for the colorspace.  Expect a new section
for the Octave manual.

To implement ``montage()``, the most difficult part was dealing with a
cell array of filepaths for images.  Handling all different
possibilities wasn't trivial, trying to think of all possible
combinations to create a correct image with all of them.  In special,
multipage indexed images are troublesome because I have never seen
one.  And because ``imread()`` seems to always return a single
colormap, a possible Octave bug may exist when reading multipage
indexed image where each page has different colormaps.  Reading the
`TIFF6 file specifications
<http://partners.adobe.com/public/developer/en/tiff/TIFF6.pdf>`__ such
file could in theory exist.  However, I don't think they actually do.

In the end, ``montage()`` is finished and added to the image package
(csets `98903291ef63
<http://hg.code.sf.net/p/octave/image/rev/98903291ef63>`__ and
`307eee5730bf
<http://hg.code.sf.net/p/octave/image/rev/307eee5730bf>`__.  In
addition to Matlab's API, I included options to add margins between
panels, and configure the colour for both margins and panel
background.  It's far from being the smartest piece of code I ever
wrote, but smart code would use a lot of ``permute()``, ``reshape()``,
and indexing trickery, turning it into a maintenance problem.

It took me 4 times longer than originally planned.  I'm blaming the
Irish weather.

.. figure:: https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-frc3/296173_656350884380264_1662719601_n.jpg
   :alt: Unreal Irish weather

   Ireland being famous for its non stop rain, has had amazingly sunny
   weather for 2 weeks now.  Galway has been the world procrastination
   central as everyone's out getting as much sun as possible.
