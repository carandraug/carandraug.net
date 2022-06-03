minutes from OctConf2012: pkg - package system and structure
############################################################

:tags: octave; octave forge; octconf;
:date: 2012-11-06 16:11

There's an Octave code sprint planned for the weekend of 17-18 of
November with the purpose of improving the functionality of ``pkg()``.
Some of the improvements were discussed at OctConf2012 but more have
since been discussed on the mailing list.  At the time, I started
writing a long report (in the style of a meeting minutes) about
``pkg()`` and Agora, the things that had a bigger impact for Octave
Forge but only finished the part of ``pkg()``.  The comments I
received were that the text was too long and detailed so I ended up
writing a shorter text that covered both items.

But with the code sprint coming up soon, we do need a proper document
stating what ``pkg()`` should be doing.  When we looked at it during
OctConf, things were intertwined in such a way that any changes
required fixes everywhere else.  My guess is that if a bunch of people
start coding away on it at the same time, even if on different
problems, we will keep stepping on each other toes.  And if we do
create 1 branch for each sprinter, merging them back together might
not be so easy.  The ideal would be to have something like a `python's
PEP <http://www.python.org/dev/peps/pep-0001/>`__.

In the mean time, I'll post here the minutes of the ``pkg()``
discussion during OctConf2012.

----

These were first dicussed between Carnë Draug (CD), Juan Carbajal (JC)
and Carlo de Falco (CF) before being presented to the community
present at OctConf2012 on the morning of July 19 for further
discussion.  During the rest of the event CD, JC and CF continued
discussing the plans whose conclusions are now reported.

It was the opinion that the current problems with the pkg system are
caused by the code complexity of ``pkg()``, itself caused by the path
of its development, slow, as new features were added as they were
needed, one at a time on top of the previous ones.  Also, the nature
of the problem, mostly string processing and directories content, is
not solved with the Octave functions with clean code.  As such, a list
of problems with the current system and new desired features was made
to have a clear design of what the system should support.

It was proposed by CD to rewrite ``pkg()`` in Perl.  Despite the
language fame for being hard to read, it would allow for shorter and
fast code.  It would be much easier to maintain by someone familiar
with Perl than the current code is for Octave programmers.  Even for
someone unfamiliar with Perl, it should take less effort to fix bugs.
Plus, perl is already an Octave dependency so Octave users will
already have it installed on their systems.  CF pointed out it is just
a building dependency and therefore not necessarily present on the
user system.  While it is true that pretty much all Linux
distributions require perl, it does not hold for Windows.  ``pkg()``
is currently faulty on Windows so it wouldn't be a problem but the
hope is to make it work for them too.  The idea to use perl was then
rejected.

CD, CF and JC were of the opinion that the autoload option was not
good and that ``pkg()`` should not support it.  Packages can shadow
core Octave functions, and even other packages functions.  On the
later case, no warning is given.  Code meant to run with specific
packages, or even with no packages at all, may catch others by
surprise.  Also, some users are not aware that some functions they use
come from packages.  Forcing them to load a packages as needed will
make them know what they are doing.  No other programming language has
packages, modules or libraries loaded by default (with the exception
of special cases such as python implementations).  JC gave the example
of a practical class where the teacher gives commands for the students
in front of their pre-installed octave systems.  The first command
they should run should be ``pkg load`` and the professor should not
have installed the package with autoloading by default.  Any user
would still be free to configure his ``.octaverc`` file to load
packages at startup.  That is the objective of ``.octaverc`` not of a
package system, to configure startup of octave sessions.  CD pointed
that loading of packages is also not completely safe at the moment.
When loading a package, its dependencies are loaded at the same time.
However, these dependencies can be unloaded leaving those dependent on
them loaded and not issuing a warning.  The discussed options were:
unload all other packages at the same time, refuse to unload the
package, keep the current behaviour.  The verbosity level for
attempting to unload such package was also discussed but no conclusion
was reached.

A frequently requested option is to automatically identify, download
and install all package dependencies.  All CD, CF and JC agreed that
this should be implemented.  It shouldn't be too much work since the
dependencies are already being identified and can be downloaded with
the ``-forge`` flag.  All code is already in place, it should only
require a few extra lines.  This is obviously only possible for
dependencies on other packages.  A check on the availability of
external libraries and software can be performed with Makefiles but
``pkg()`` can't solve them.

CF suggested to add two more options to the install option that would
allow installing a package given a URL and another to install the
development version of a package.  As with the option to automatically
solve dependencies, and for the same reasons, it should be easy to
implement the URL.  CD argueed that the dev option should not be
implemented because it would stop packages from being released as
users become more used to it and start installing possibly broken
packages.  CF said it would still be very useful for package
maintainers preparing a new release.  JC suggested to use
``releasePKG()`` on the admin section which already does it.  It
requires for a local clone of the repository which should already be
available if it is for a developer preparing and testing a new package
release.  It was agreed that the url, but not the dev option would be
added to ``pkg()``.

CF and JC were of the opinion that the package system should not
support both local and global installs and that all installations
performed by ``pkg()`` should be local.  CF reported that on Mac
systems global installs were made local even when running octave with
sudo.  CD mentioned that on Windows systems the opposite happens, and
all installs are global (such being checked with ``isppc()`` on the
code).  The two types of installations are exclusive to Linux systems.
CF and JC said that global installs should be kept for the
distribution maintainers and ``pkg()`` should deal with local installs
only.  CD argueed that this would mean that system administrators,
even the ones compiling the latest octave version, would be dependent
on their distro maintainers for obtaining the latest version of
packages.  CF and JC replied that supporting both types complicates
the system and that packages are more user specific.  It was agreed
that the option was then going to be removed.  After discussing this
option with Jordi Hermoso, it was discovered that at least the Debian
maintainers actually use ``pkg()`` to prepare the packages.  It was
then decided that ``pkg()`` would deal with both installation types.

All CD, CF and JC were of the opinion that the ``-local`` and
``-global`` install flags were still useless and should be removed
since the type of installation was already being decided based on
whether the user was root, this flags only useful to force the other
type.  CD proposed changing the default for a global installation if
there was write permissions rather than being root as to permit an
octave system user to make octave global installs.  This also allows
for a local installation of octave (a regular user compiling and
installing octave on its home directory for example), to make a global
package install.  Global relative to the local octave installation,
the packages on the octave tree rather than on a separate directory.
This should allow for a cleaner organization.  These two changes were
made and commit before the end of OctConf2012.

The current list of installed packages, local and global, is a simple
struct saved in the -text format.  CD was of the opinion this should
be made a binary format to discourage users from manually editing the
file and accidentally breaking the system.  CF argued the opposite,
that such editing may be necessary.  It was decided to simply leave a
warning on the file header.

CD noticed that it is not possible to use packages in a system that
has more than one octave version installed.  While .m functions will
work normally, .oct files compiled at installation time are version
specific and will therefore fail.  These are placed in API specific
directories to avoid their incorrect loading but reinstalling the
package removes them, forcing a reinstallation of the package
everytime a different octave version is to be used.  CF also pointed
out that a system to perform reinstalls should be made and the
packages source kept so as to reinstall packages with new octave
versions.  CD noted that this would also allow for use of %!test of
C++ functions after install.  Similarly, it was noted that currently
is not possible to have more than one version of the same package
installed.

List of conclusions:

* dependencies on other packages should be automatically solved

* ``pkg()`` will not load packages automatically

* an option to install packages given a URL will be added

* the source of installed packages will be kept in disk for times
  installations

* it will be possible to have multiple package lists that can be
  merged or replaced

* support for different packages version and different octave versions
  will be added

* ``pkg()`` will stay written in the Octave language

* the ``-local`` and ``-global`` options will be removed

* a header will be added to the octave list files warning that they
  should not be manually edited
