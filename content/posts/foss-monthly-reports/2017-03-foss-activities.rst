My Free software activities in March 2017
#########################################

:date: 2017-04-01

This month I finished my `PhD thesis
<https://github.com/carandraug/phd-thesis>`_

Octave
------

Attended `OctConf 2017 <http://wiki.octave.org/OctConf_2017>`_ at CERN
where I presented how I use Octave at `work
<http://www.micron.ox.ac.uk/>`_ for microscope image analysis.  The
`slides are online
<https://indico.cern.ch/event/609833/contributions/2514635/attachments/1430164/2196501/octave-image-processing.pdf>`_
although to be honest, I prefer to keep the slides with only a few
images and talk through them wile waving my arms.  I am unsure how
useful they are outside the context of me talking.

Also at OctConf 2017, I gave two workshops: one on preparing Octave
packages, and another on Autotools.  The workshop on preparing Octave
packages was a repeat of the same I gave at OctConf 2015.  The
workshop on Autotools was aimed to new Octave hackers and focused on
how Octave makes use of Autotools.

With the thesis writing out of the way, I have started to review the
pile of bug reports and patches to the Image package, submitted by
Hartmut Gimpel and Avinoam Kalma over the last year:

- fixed Image package to build against development Octave
  `(bug #50180) <https://savannah.gnu.org/bugs/?50180>`__
- fixed ``bwperim`` handling of dimensions of length 1
  `(bug #50153) <https://savannah.gnu.org/bugs/?50153>`__
