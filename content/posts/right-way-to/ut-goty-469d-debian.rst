Install Unreal Tournament GOTY on Debian
########################################

:tags: games
:date: 2024-11-16

`Epic Games has approved downloading
<https://www.techdirt.com/2024/11/18/epic-allows-internet-archive-to-distribute-for-free-unreal-unreal-tournament-forever/>`__
of `Unreal Tournament (UT)
<https://en.wikipedia.org/wiki/Unreal_Tournament>`__ from the Internet
Archive.  The game is from 1999 but there is an online community named
`OldUnreal <https://www.oldunreal.com/>`__ still releasing patches for
it.  This is a special game for me.  I remember many hours playing it
with friends --- the original UT during high school and later, `UT
2004 <https://en.wikipedia.org/wiki/Unreal_Tournament_2004>`__ during
university.

With the OldUnreal patches, UT runs on amd64 Linux.  It does not
require `Wine <https://www.winehq.org/>`__.  OldUnreal provides easy
to use installers that download the game from Internet Archive and
applies the patches but only for Windows.  Here are instructions to
install it on Linux (tested in Debian 12 - bookworm).


Download the original game (from Internet Archive)
--------------------------------------------------

If you don't have the game, download it from the `Unreal Tournament:
Game of the Year Edition <https://archive.org/details/ut-goty>`__ page
on the Internet Archive.  They provide direct downloads for the two
ISO files as well as a torrent file.  Whatever way you download, you
will need two image files have this checksum::

    $ md5sum UT_GOTY_CD1.iso UT_GOTY_CD2.iso
    e5127537f44086f5ed36a9d29f992c00  UT_GOTY_CD1.iso
    b59a097bc6d899018ffbf65401b66231  UT_GOTY_CD2.iso


Download OldUnreal patches
--------------------------

There is no source released for the patches, only binary releases.
They are available from OldUnreal's `release page on Github
<https://github.com/OldUnreal/UnrealTournamentPatches/releases>`__.

v469d is the latest version and has Linux builds for amd64, arm64, and
x86.  Download it from Github and check its checksum::

  $ md5sum OldUnreal-UTPatch469d-Linux-amd64.tar.bz2
  d0e133165bf1630288583e52a40b90db  OldUnreal-UTPatch469d-Linux-amd64.tar.bz2


Installation
------------

The patches are supposed to be dropped on top of an existing
installation.  The wikipedia page for UT mentions a Linux installer
that was distributed on the Unreal website.  That website no longer
exists.  Copies of such installer can still be found online but I
can't confirm their authenticity.  The original will probably only
target x86 systems anyway.  Instead of an installer, it is possible to
just copy the files to the right places so that's why I'm doing here.

The game expects a structure with all games files under a single
directory.  Following the `Linux Filesystem Hierarchy Standard (FHS)
<https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html>`__, this
means it fits best under `/opt/<provider>/<package>`.  I'm installing
it there with `com.oldunreal` as the `<provider>` [1]_.

::

    # Create all directories and mount the disk images
    sudo mkdir -p /opt/com.oldunreal/ut-goty-v469d
    sudo mkdir /mnt/cd1 /mnt/cd2
    sudo mount -o loop,ro UT_GOTY_CD1.iso /mnt/cd1
    sudo mount -o loop,ro UT_GOTY_CD2.iso /mnt/cd2

    # Copy game asset files (but not maps)
    sudo rsync -r /mnt/cd1/Help \
                  /mnt/cd1/Music \
                  /mnt/cd1/Sounds \
                  /mnt/cd1/Textures \
                  /mnt/cd2/Help \
                  /mnt/cd2/Sounds \
                  /mnt/cd2/Textures \
                  /opt/com.oldunreal/ut-goty-v469d

    # Copy the uncompressed map files (the .unr.uz files are
    # compressed and will be uncompressed with the patched
    # programs later)
    sudo mkdir /opt/com.oldunreal/ut-goty-v469d/Maps/
    sudo cp /mnt/cd1/Maps/*unr /opt/com.oldunreal/ut-goty-v469d/Maps/

    # These files don't need executable permissions
    sudo chmod -R a-x+X /opt/com.oldunreal/ut-goty-v469d/

    # Copy system files (ignore warnings from CD1 files
    # duplicated in CD2)
    sudo mkdir /opt/com.oldunreal/ut-goty-v469d/System/
    sudo cp /mnt/cd1/System/*.u \
            /mnt/cd2/System/*.u \
            /mnt/cd1/System/*.int \
            /mnt/cd2/System/*.int \
            /opt/com.oldunreal/ut-goty-v469d/System/

    # Extract the v469d patches on top of the "installation"
    sudo tar xjf OldUnreal-UTPatch469d-Linux-amd64.tar.bz2 \
             -C /opt/com.oldunreal/ut-goty-v469d/

    # Uncompress the remaining maps and move them in place
    for UZ_FPATH in /mnt/cd1/Maps/*.uz /mnt/cd2/maps/*.uz; do
        /opt/com.oldunreal/ut-goty-v469d/System64/ucc-bin decompress $UZ_FPATH
        sudo mv ~/.utpg/System/`basename $UZ_FPATH | sed 's,.uz$,,'` \
                /opt/com.oldunreal/ut-goty-v469d/Maps
    done

    # Fix ownership of files
    sudo chown -R root:root /opt/com.oldunreal/ut-goty-v469d

    # Cleanup
    sudo umount /mnt/cd1
    sudo umount /mnt/cd2
    sudo rmdir /mnt/cd1 /mnt/cd2


Application Desktop entry
-------------------------

To get UT appear on the menus you need a `desktop entry file
<https://specifications.freedesktop.org/desktop-entry-spec/latest/>`__.
Place this file on
`/usr/local/share/applications/com.oldunreal.ut-goty.desktop` [2]_::

    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=Unreal Tournament (UT)
    Icon=/opt/com.oldunreal/ut-goty-v469d/Help/Unreal.ico
    Exec=/opt/com.oldunreal/ut-goty-v469d/System64/ut-bin-amd64
    Terminal=false
    Categories=Game;

and update the menu system::

    sudo update-desktop-database
    sudo xdg-desktop-menu forceupdate

.. image:: {static}/files/ut-goty-on-gnome-shell.jpg


.. [1] I guess a case can also be made to use `com.epicgames` as the
       provider.  I'm using OldUnreal because this is the version of
       the game distributed by them.

.. [2] It is not clear to me the best place to place desktop entries
       for stuff installed under `/opt`.  On one hand, the system-wide
       location for application desktop entries installed locally,
       i.e., not managed by the OS package-manager, is
       `/usr/local/share/applications`.  I feel that is a bit weird to
       place stuff from outside the `/usr/local` tree there but there
       isn't a better default place.

       1. Instead of seeing `/usr/local/share/applications` as the
          "place for desktop entries of stuff in the `/usr/local`
          tree", to see it as the "place for desktop entries of
          locally installed stuff" which maybe is closer to the
          intended reading of the FHS.

       2. Setup the system to read look for desktop entries in other
          directories by adding a shell script to `/etc/profile.d/`
          which sets `XDG_DATA_DIRS` accordingly.  See `this answer to
          the SuperUser question "Where should I place .desktop files
          for 3rd-party apps installed in /opt?"
          <https://superuser.com/questions/1782591/where-should-i-place-desktop-files-for-3rd-party-apps-installed-in-opt>`__.
