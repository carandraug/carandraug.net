My Free software activities in February 2017
############################################

:date: 2017-03-01

Perl
----

New release of `Pod::Weaver::Section::GenerateSection
<https://metacpan.org/pod/Pod::Weaver::Section::GenerateSection>`_ to
make it work in Windows and newer perl versions.

New release of `Pod::Weaver::Section::Legal::Complicated
<https://metacpan.org/pod/Pod::Weaver::Section::Legal::Complicated>`_
with a user testsuite.  Until now it was an author only test because
I'm afraid of changes in Dist::Zilla and Pod::Weaver but I think it's
more important to have the tests available to cpantesters.

New release of `Dist::Zilla::PluginBundle::BioPerl
<https://metacpan.org/pod/Dist::Zilla::PluginBundle::BioPerl>`_ which
drops deprecated plugins, adds a minimal testsuite, fixes an `indexing
problem in CPAN
<https://github.com/bioperl/dist-zilla-pluginbundle-bioperl/issues/5>`_,
and `broken links for the bugtrackers
<https://github.com/bioperl/dist-zilla-pluginbundle-bioperl/issues/6>`_.

Helped Pod::POM::View::Restructured use Dist::Zilla to handle their
`licence issues
<https://github.com/cuberat/Pod-POM-View-Restructured/pull/3/>`_ by
making use of own ``[Legal::Complicated]`` plugin.


Debian
------

As part of `Debian Perl group <https://pkg-perl.alioth.debian.org/>`_,
I have packaged::

- libpod-weaver-section-legal-complicated-perl (I am upstream)
- libpod-weaver-section-generatesection-perl (I am upstream)
- libdist-zilla-role-pluginbundle-pluginremover-perl
- libconfig-mvp-slicer-perl
- libdist-zilla-config-slicer-perl

Took over libbio-eutilities-perl from the debian-med team since I am
also upstream.  They packaged it when I requested at a time I didn't
know.
