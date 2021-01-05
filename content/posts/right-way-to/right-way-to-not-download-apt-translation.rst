Not downloading translations files in Debian
############################################

:tags: sysadmin;
:date: 2013-01-08 00:49:00

Updating the APT's package cache on the testing version of Debian
(Wheezy) will show a lot of hits, related to translations. A bunch of
the following::

 Hit http://ftp.ie.debian.org wheezy/main Translation-hu
 Hit http://ftp.ie.debian.org wheezy/main Translation-fr
 Hit http://ftp.ie.debian.org wheezy/main Translation-vi
 Hit http://ftp.ie.debian.org wheezy/main Translation-zh
 Hit http://ftp.ie.debian.org wheezy/main Translation-ru

The quick answer
----------------

Run the commands::

 sudo rm /var/lib/apt/lists/*_i18n_Translation*
 echo 'Acquire::Languages "environment";' | sudo tee -a /etc/apt/apt.conf.d/99translations

This assumes that downloaded package lists are placed at
``/var/lib/apt/lists/``.  It is unlikely this default was changed but
if these two commands did not work, read the very long answer below.

The wrong way
-------------

Do not set up the Languages option to ``"none"``, you will lose the
long description for all package in all languages, including English.

Do not edit the ``apt.conf.d/70debconf`` file or create an
``apt.conf`` file.  This has been modularized.  The idea is that by
having multiple files, it's easier to maintain and write scripts that
will change the settings.

The right way (long answer)
---------------------------

These translations are the descriptions of packages in the APT cache
(what the guys from the `Debian Description Translation Project
<http://www.debian.org/international/l10n/ddtp>`_ do), and not related
to the actual translations of whatever packages you decide to install.
The files being downloaded are the long descriptions [1]_ for all
languages, and the short descriptions for all non-English languages.

These files will be located at ``/var/lib/apt/lists/`` [2]_ and have
the word Translation on their name.  Note that the English language is
also considered a translation (the file that ends in
``i18n_Translation-en``).

Downloading all this languages files takes up a lot of time (there's a
lot of small files which maybe comes from Debian Wheezy still being in
testing and will reduce once it goes stable) and extra space on the
disk (120MB at the moment).

Reading the man page of apt.conf shows a ``Language`` option to select
which translation files should be downloaded [3]_. This option should be
set to ``"environment"``.  Most advice out there is to set this option
to ``"none"``.  This will cause no translation to be downloaded at
all, including your own language, *even* if it is English.  Setting
this to ``"none"``, really means *no* package description *at all*
(except the short descriptions in English).

The option ``"environment"`` is translated into the ``LC_MESSAGES``
environment variable.  These variables are not actually exported but
their value can be inspected with the locale program (run ``sudo
dpkg-reconfigure locales`` to change locales)::

 ## display locale variables
 $ locale
 LANG=en_IE.utf8
 LANGUAGE=
 LC_CTYPE="en_IE.utf8"
 LC_NUMERIC="en_IE.utf8"
 LC_TIME="en_IE.utf8"
 LC_COLLATE="en_IE.utf8"
 LC_MONETARY="en_IE.utf8"
 LC_MESSAGES="en_IE.utf8"
 LC_PAPER="en_IE.utf8"
 LC_NAME="en_IE.utf8"
 LC_ADDRESS="en_IE.utf8"
 LC_TELEPHONE="en_IE.utf8"
 LC_MEASUREMENT="en_IE.utf8"
 LC_IDENTIFICATION="en_IE.utf8"
 LC_ALL=

 ## show available locales
 $ locale -a
 C
 C.UTF-8
 en_GB.utf8
 en_IE.utf8
 en_US.utf8
 POSIX
 pt_PT.utf8

Back to the translation, this is done in the files of
``/etc/apt/apt.conf.d``, the collection of which makes the
configuration of APT. Each of these files have the format of a two
digit number (the order in which they are read) followed by a word (a
reference to what they do)::

 $ ls /etc/apt/apt.conf.d/
 00aptitude      01autoremove   20packagekit
 00CDMountPoint  20dbus         50unattended-upgrades
 00trustcdrom    20listchanges  70debconf

The numbers make it easier to know which files are read first, thus
avoiding problems by having opposite settings in different files and
not knowing which setting is in effect.  In case of opposite settings,
it's the last one that counts.

These files are generated automatically by Debian and you shouldn't
edit them directly.  You never know when an update, or installing a new
package may change something.  But Debian will not touch files you
created.  The rule is, edit only your own files and leave to Debian,
the files that Debian creates.

So create a new file, with the number 99 (so that you know this
setting is loaded last) and give it some meaningful name.  A file
named ``99translations`` would be appropriate.  The following command
will create the file with the correct line (and in the case it already
exists, will append to it so make sure what you have in the end)::

 $ echo 'Acquire::Languages "environment";' | sudo tee -a /etc/apt/apt.conf.d/99translations

If later you wish to change some other setting, there is no problem in
using the 99 number again.  For example, there is no problem is using
a ``99proxies`` file (maybe to specify special proxies that should be
used to download packages) together with a ``99translations`` file.

When updating the package index, translations files found will also be
updated, even if not listed in the locales or the ``Language``
options.  So it is necessary to remove those files (also to retrieve
the disk space).  It is safe to remove all of them, they will be
downloaded again once ``aptitude`` update is ran::

 $ sudo rm /var/lib/apt/lists/*_i18n_Translation*

Note the the path for this files is configurable and they may be
located somewhere else [2]_.

.. [1] There are two types of description in a package. The short, 1
   line description (that is displayed with ``aptitude search``)
   and a longer one (that is added to it when using ``aptitude
   show``). Compare the following two for the scons package:

   short description
     replacement for make

   long description
     SCons is a make replacement providing a range of enhanced
     features such as automated dependency generation and built in
     compilation cache support.  SCons rule sets are Python scripts so
     as well as the features it provides itself SCons allows you to
     use the full power of Python to control compilation

.. [2] The translation files (downloaded from locations listed in
   ``sources.list``), are by default saved in ``/var/lib/apt/lists``
   but this is actually configurable.  The path used is set with the
   option ``Dir::State::Lists``. Use ``apt-config dump`` to inspect
   their values::

    $ apt-config dump
    ...
    Dir "/";
    Dir::State "var/lib/apt/";
    Dir::State::lists "lists/";
    ...

.. [3] apt.conf (5) manual page, section "The acquire group",
   subsection "Languages"::

   > The Languages subsection controls which Translation files are
   > downloaded and in which order APT tries to display the
   > description-translations. APT will try to display the first
   > available description in the language which is listed
   > first. Languages can be defined with their short or long language
   > codes. Note that not all archives provide Translation files for
   > every language - the long language codes are especially rare.
   >
   > The default list includes "environment" and "en". "environment"
   > has a special meaning here: it will be replaced at runtime with
   > the language codes extracted from the LC_MESSAGES environment
   > variable. It will also ensure that these codes are not included
   > twice in the list. If LC_MESSAGES is set to "C" only the
   > Translation-en file (if available) will be used. To force APT to
   > use no Translation file use the setting
   > Acquire::Languages=none. "none" is another special meaning code
   > which will stop the search for a suitable Translation file. This
   > tells APT to download these translations too, without actually
   > using them unless the environment specifies the languages. So the
   > following example configuration will result in the order "en, de"
   > in an English locale or "de, en" in a German one. Note that "fr"
   > is downloaded, but not used unless APT is used in a French locale
   > (where the order would be "fr, de, en").
   >
   >   Acquire::Languages { "environment"; "de"; "en"; "none"; "fr"; };
   >
   > Note: To prevent problems resulting from APT being executed in
   > different environments (e.g. by different users or by other
   > programs) all Translation files which are found in
   > /var/lib/apt/lists/ will be added to the end of the list (after
   > an implicit "none").
