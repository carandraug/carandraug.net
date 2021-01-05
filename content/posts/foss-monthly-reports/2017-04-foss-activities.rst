My Free software activities in April 2017
#########################################

:date: 2017-05-01

Octave
------

Still reviewing the pending bugs and patches for the Image package:

- fixed ``graythresh`` Otsu method when images have all the same value
  `(bug #545333) <https://savannah.gnu.org/bugs/?45333>`__ by Avinoam Kalma.

- new function ``imsharpen`` `(patch #9281)
  <https://savannah.gnu.org/patch/?9281>`__ by Avinoam Kalma.

- fixed ``normxcorr2`` returning 0 for regions where image has all the
  same value `(bug #50122) <https://savannah.gnu.org/bugs/?50122>`__
  by Hartmut Gimpel.

- fixed computation of ellipse properties `(bug #49613)
  <https://savannah.gnu.org/bugs/?49613>`__ by Avinoam Kalma.

- imreconstruct should clip marker values higher than mask instead of
  throwing an error `(bug #48794)
  <https://savannah.gnu.org/bugs/?48794>`__

Somehow got myself responsible for more things.  Now also have access
to Octave's server where the repos, wiki, and planet is hosted, to
help out when needed.

Debian
------

Start packaging `Algorithm::SVM
<https://metacpan.org/pod/Algorithm::SVM>`__ (libalgorithm-svm-perl)
which debian-med required to package psrtb.

Changed libbio-eutilities-perl package to remove unnecessary
dependencies so it can be easily ported to older versions of Debian.


GtkSourceView
-------------

Fixed `bug #781538
<https://bugzilla.gnome.org/show_bug.cgi?id=781538>`__ for correct
highlighting of include type of LaTeX commands.
