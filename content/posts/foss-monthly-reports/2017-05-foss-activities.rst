My Free software activities in May 2017
#######################################

:date: 2017-06-01

Octave
------

Bugs and patches:

- Fixed `(bug #47115) <https://savannah.gnu.org/bugs/?47115>`__ where
  ``label2rgb`` in the Image package would not work with labelled
  images of type uint32 and uint64.  Reason was that behind the scenes
  ``ind2rgb`` from the Octave core was being used, and Octave imitates
  Matlab in that labelled images can only be up to uint16.  That
  sounds like a silly limitation so I dropped it from core in
  ``ind2rgb`` and ``ind2gray``.  However, there's other places where
  that limitation is in place and needs to be lifted such as
  ``cmunique``, ``cmpermute``, and the display functions.

- Fixed ``hist3`` handling of special cases with NaN values on the
  rows that define the histogram edges and centring values in an
  histogram when there's only one value.  Started as side effect of
  fixing `(bug #51059) <https://savannah.gnu.org/bugs/?51059>`__.

- `(bug #44799) <https://savannah.gnu.org/bugs/?44799>`__ - document
  ``imrotate`` does not work with the spline method.

- Fix input check for ``fspecial`` `e65762ee9414
  <http://hg.code.sf.net/p/octave/image/rev/e65762ee9414>`_

- Review ``wiener2``, function for adaptive noise reduction, from
  Hartmut `(patch #9354) <https://savannah.gnu.org/patch/?9354>`__ and
  extended it for N dimensions.

- Fixed ``mean2`` Matlab incompatibilities for some weird cases `(bug
  #51144) <https://savannah.gnu.org/bugs/?51144>`__

- Make ``imcast`` support class logical.

- Review ``otsuthresh``, function to compute threshold value of an
  histogram via Otsu's method, by Avinoam Kalma `(patch #9360)
  <https://savannah.gnu.org/patch/?9360>`__

- Review affine2 and affine3, classes to represent 2d and 3d affine
  transforms, submitted by Motherboard and Avinoam `(patch #8824)
  <https://savannah.gnu.org/patch/?8824>`__.  Started generalising
  code to N dimensions to avoid code duplication.  Only one method
  missing (maybe you wanna help?).

As sysadmin:

- Finished updating the wiki for Octave, due to issues with pygments.

Debian
------

- Started packaging libsystem-info-perl, got stuck due to a `licensing
  issue <https://github.com/Tux/System-Info/issues/1>`_
