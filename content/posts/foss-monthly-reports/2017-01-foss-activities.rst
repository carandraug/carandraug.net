My Free software activities in January 2017
###########################################

:date: 2017-02-01

Octave
------

After more than 5 years as leader of the Octave Forge project, `I have
stepped down
<https://lists.gnu.org/archive/html/octave-maintainers/2017-01/msg00255.html>`_.
That role is now handled by a team of three Octave Forge developers
Julien Bect, Olaf Till, and Oliver Heimlich.


Perl
----

I made a new release of `Pod::Weaver::Section::GenerateSection
<https://metacpan.org/pod/Pod::Weaver::Section::GenerateSection>`_ a
Pod::Weaver plugin that allows to add sections to a module
distribution from the weaver configuration.  I only meant to fix two
typos (caught by lintian) and ended up spending almost two days
writing its test suite.


Debian
------

I have got involved in Debian development by joining the `Debian Perl
group <https://pkg-perl.alioth.debian.org/>`_ and packaged:

- libdist-zilla-plugin-autometaresources-perl
- libdist-zilla-plugin-mojibaketests-perl
- libdist-zilla-plugin-readmefrompod-perl
- libdist-zilla-plugin-test-compile-perl
- libmoosex-types-email-perl
- libpod-weaver-plugin-ensureuniquesections-perl
- libpod-weaver-section-contributors-perl
- libtest-mojibake-perl

Fixed dh-make-perl to use ``DEBFULLNAME`` and ``DEBEMAIL`` in its git
commits (`Debian bug #852332
<https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=852332>`_).


BioPerl
-------

The packages I prepared for Debian are required by bioperl developers.
New bioperl distributions use Dist::Zilla and Pod::Weaver, and those
are the dependencies and dependencies dependencies, of `bioperl's dist
zilla plugin bundle
<https://metacpan.org/pod/Dist::Zilla::PluginBundle::BioPerl>`_.

The Debian med reported failure to package Bio::EUtilities because it
required internet connection.  I found this was due to the xml files
used for testing which had external DTDs and patched the Debian
package.  `Fixing this in Bio::EUtilities
<https://github.com/bioperl/Bio-EUtilities/issues/6>`_ will require
more work since it should involve reproducing the creation of the xml
files used in testing.


Microscope
----------

Finally started to work on `python-microscope
<https://github.com/MicronOxford/microscope>`_ although it's mainly
been reading what was done before, and planning for the testsuite.
