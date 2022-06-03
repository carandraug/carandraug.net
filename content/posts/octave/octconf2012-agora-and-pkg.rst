OctConf2012 - Agora and pkg()
#############################

:tags: octave; octave forge; octconf;
:date: 2012-08-02 18:03

Two subjects were discussed at OctConf 2012 with direct impact on the
Octave-Forge project: Octave's package system, and Agora.  While very
little code was written for any of these two, there was plenty of
design and discussion as different ideas and visions clashed.

Most of the Agora design, current package system and possible package
structures were presented on the morning of July 19.  However, the
intended changes to ``pkg()`` were not, and neither was how they would
affect Agora.  These were discussed after, mostly between Carnë Draug,
Carlo de Falco and Juan Carbajal, and until the very last minute of
OctConf.

Agora
-----

`Agora <http://agora.octave.org/>`__ is a project meant for rapid
collaboration of Octave code which has been under very slow
development under the last 2 years.  Its name refers to the `ancient
Greek Agora <http://en.wikipedia.org/wiki/Agora>`__, a cross between
place for social gathering and marketplace.  Would that we had more
web developers in our community.  It is currently available at
`agora.octave.org <http://agora.octave.org/>`__ but is still only a
pastebin with syntax highlight for Octave.

The presented design would split Agora in 3 different sections:
single, bundle and Forge, the later absorbing Octave-Forge which would
cease to exist.  Single and bundle (these are development titles) are
very similar in nature, a cross between MatLab's FileExchange and
`arXiv <http://arxiv.org/>`__.  The Forge section, not unlike what is
currently Octave Forge, would hopefully become smaller and easier to
maintain as some of its code moves into the 2 other sections.

Single and Bundle
^^^^^^^^^^^^^^^^^

These can be used by anyone to make their code available to others,
their only difference the upload method.  While single is meant for
single function files, and will present the user with a text box to
paste the code, bundle will upload an archived file.

Each of them will have its own page with a download count and where
users can rate, leave the comments, and contact the author.  They can
also be organized with multiple tags (e.g., statistics,
bioinformatics).  To avoid spam and copyright infringement, there will
be a flag button to bring the attention of moderators.  Other than
that, there should be no moderator interaction needed.

They will be associated with a specific user, the uploader, who is
able to release new versions.  Versioning will be automatic and the
simplest possible: a single number incrementing with each new upload.
Old versions will be made available for download in the same style as
arXiv (see the submission history on `an entry
<http://arxiv.org/abs/1206.1440>`__ for an example).

Bundles can either be a simple collection of files or a properly
structured Octave package.  If a package is meant to be uploaded, a
simple structure check can be optionally requested by the uploader.
This would be made by a script and there will be no guarantee that it
actually installs, only that it looks correct.  There will be no
moderator interaction.

Problems, bugs and comments on the single and bundle sections are
encouraged to be submitted to the uploader, not to the Forge or octave
help mailing list.

Forge
^^^^^

This section would be what is currently Octave-Forge.  The hope is
that by dropping the Octave name there will be less confusion between
the Octave and Octave-Forge projects.  This section will aggregate
packages that are actively maintained and developed by the community.

There will be a single bug tracker, each package being a bug category,
a single mailing list, but a mercurial repository for each package.
The Forge repository will be another mercurial repository where each
package is a subrepository.

Packages in this section will comply with the following:

* have at least one package maintainer;
* install and work with the latest Octave release;
* released under a GPL compatible license;
* not dependent on a non-GPL compatible libraries or applications;
* all functions (except private) must be documented in TexInfo;
* if a doc section exists it must be written in TexInfo;
* a NEWS file must exist listing changes for each release.

It is also recommended that they comply with:

* no shadowing of Octave core functions;
* no direct inclusion of external dependencies.

Once this system is in place, new code submissions will be directed to
the single and bundle sections.  As these are rated and improved over
time, if a forge maintainer wishes to include it on its own package he
can do so.

Snippets
^^^^^^^^

The current function of Agora as pastebin will be also be kept as its
actually pretty useful.

pkg()
-----

Some problems with the current pkg system were discussed as well as
desired new features.  Also other features were decided more harmful
than useful and will be removed.  These are:

* removal of the autoload option.  No package will be able to
  automatically load itself and its value on the DESCRIPTION file will
  be ignored.  This prevents users from inadvertently shadowing
  functions (even from other packages) and will increase aware on the
  role of packages.

* implementation of a new flag, ``-url``, to specify URLs for a
  package tarball.

* automatic download and install of dependencies if those are part of
  Forge.

* keep the source of installed packages.  This will allow to reinstall
  a package when Octave is updated as well as run the tests on C++
  code.

* implementing an option to run the integrated function tests when
  installing a new package.

* a new organization for the installed packages on the system.  This
  will include the removal of --global and --local flags (which will
  be handled automatically) and is meant to to allow:

  * different versions of the same package

  * different versions of Octave using the same packages

  * global package installs in relation to the Octave installation,
    not to the system.

* automatic build of a package documentation in HTML, PDF and info
  format from TexInfo formats, similarly to what happens when building
  Octave.

Implementation of all of these will include a major overhaul of the
whole ``pkg()`` code, as many of this options are connected between
them.  It is not possible to implement all of them independently and
each change is likely to break ``pkg()``.  As such, it was decided
that their development would happen in a remote repository and merged
into default once ready.
