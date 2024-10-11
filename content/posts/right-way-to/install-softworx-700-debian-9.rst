Install SoftWoRx 7.0.0 on Debian 9
##################################

:tags: microscopy; sysadmin;
:date: 2024-10-11

Softworx (stylised SoftWoRx) is the microscope control software for
the DeltaVision microscopes.  It is also the image analysis software
for DeltaVision and OMX, performing image deconvolution and SIM
reconstructions.  It is based on Priism/IVE which is also proprietary
software.

These are instructions to install Softworx 7.0.0 on Debian 9.

Currently, the last version of Softworx is 7.2.2, and the stable
version of Debian is 12.  These instructions were written back in 2017
when I managed systems with Softworx.  These instructions can be used
as the basis to install later Softworx versions (versions earlier than
7.0.0 are not fully x86_64 and will require a Debian i386 install or
multiarch properly configured), or to install on other Debian version
or on Debian-based distributions such as Ubuntu.


Before you start
----------------

License file
~~~~~~~~~~~~

Softworx requires a license file.  Get one before starting the
installation.  The license file is a text file named ``license.dat``
and lists the MAC address of the required ethernet card and the date
the license expires.

Nvidia graphics card and drivers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Softworx supposedly requires a Nvidia card and the official Nvidia
drivers.  Not the new, fancy, and expensive GPUs for AI.  Softworx is
software from the late 90s and is distributed with workstations with
very old Nvidia graphics cards.

My experience, however, is that since Debian 9 the free and open
source nouveau drivers work fine.  I've also seen it working on
machines without a Nvidia graphics card at all.


Download the installer
----------------------

Softworx has moved around a lot lately.  Originally distributed by API
(Applied Precision Inc), it moved to GE HealthCare, then to Cytiva,
and last to Leica.  Currently it is still available to download from
the Cytiva website.  The directory for version 7.0.0 is at
https://download.cytivalifesciences.com/cellanalysis/download_data/softWoRx/7.0.0/SoftWoRx.htm

::

    wget https://download.cytivalifesciences.com/cellanalysis/download_data/softWoRx/7.0.0/dv700_update_RC6.tar
    tar xf dv700_update_RC6.tar
    cd dv700_update
    cd bin
    md5sum --check md5sums
    cd ..

There is no directory with an index of all Softworx versions.
Previously, I have discovered new versions by experimenting higher
version numbers on the directory URL.


Extract the installer and move files in place
---------------------------------------------

Installers are provided as rpm packages.  Files on those packages can
be extracted with ``rpm2cpio`` and then moved to whichever location we
want.

::

    cd ../RPMS
    sudo apt install rpm2cpio
    for RPM_PACKAGE in softWoRx-Base-7.0.0-RC6.x86_64.rpm \
                       softWoRx-DV-Acquire-7.0.0-RC6.x86_64.rpm \
                       softWoRx-DV-Analyze-7.0.0-RC6.x86_64.rpm \
                       softWoRx-OTF-Library-2.0.0-13.x86_64.rpm; do
        rpm2cpio $RPM_PACKAGE | cpio -i --make-directories
    done

Softworx expects to be placed on ``/usr/local/softWoRx`` but that
doesn't conform to the `Linux Filesystem Hierarchy Standard (FHS)
<https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html>`__.
Softworx's directory structure with all files under a single
application directory fit better under ``/opt``.

::

    sudo mv usr/local/softWoRx /opt/
    sudo mv usr/sbin/dvqd /opt/softWoRx/bin/x86_64/
    sudo mv usr/local/otf/ /opt/softWoRx/
    sudo mv usr/lib/X11/app-defaults/softWoRx /etc/X11/app-defaults/
    sudo mkdir -p /var/opt/softWoRx

    sudo chown root:root /etc/X11/app-defaults/softWoRx
    sudo chown -R root:root /opt/softWoRx

    ## /opt/bin and /opt/sbin for things that should be on the PATH
    sudo mkdir -p /opt/bin
    for PROGRAM in BasicInfo DVExit runDV DVview ; do
        sudo ln -s /opt/softWoRx/bin/x86_64/$PROGRAM /opt/bin/$PROGRAM
    done
    sudo mkdir -p /opt/sbin
    sudo ln -s /opt/softWoRx/bin/x86_64/dvqd /opt/sbin/dvqd

So that Softworx can be upgraded without losing the configuration,
place it on ``/etc/opt/`` and link to ``/opt/softWoRx/config``.

::

    sudo mv /opt/softWoRx/config /etc/opt/softWoRx
    sudo ln -s /etc/opt/softWoRx /opt/softWoRx/config


Softworx configuration
~~~~~~~~~~~~~~~~~~~~~~

Because we have placed Softworx under ``/opt/softWoRx`` instead of
``/usr/local/softWoRx``, we need to edit the default configuration::

    sudo sed -i 's,^DV_BASE .*,DV_BASE /opt/softWoRx,' \
        /etc/opt/softWoRx/system.swrc

    sudo sed -i 's,^DV_DATA .*,DV_DATA ./,' \
        /etc/opt/softWoRx/system.swrc

    sudo sed -i 's,^DV_OTF .*,DV_OTF /opt/softWoRx/otf,' \
        /etc/opt/softWoRx/system.swrc

License file
~~~~~~~~~~~~

Softworx needs a license file.  Place it at
``/etc/opt/softWoRx/license.dat``.


Dependencies
------------

::

    sudo apt install libxm4 csh

building libXp from source
~~~~~~~~~~~~~~~~~~~~~~~~~~

libXp is not packaged on Debian 9 (there are libxp packages for Debian
8 and 10 though) so it needs to be built from source.

::

    sudo apt install xorg-dev make gcc x11proto-print-dev
    wget https://www.x.org/releases/individual/lib/libXp-1.0.3.tar.gz
    tar xzf libXp-1.0.3.tar.gz
    cd libXp-1.0.3/
    ./configure
    make
    sudo make install
    sudo ldconfig
    cd ..
    rm libXp-1.0.3.tar.gz
    rm -r libXp-1.0.3/

``libtiff.so.3``
~~~~~~~~~~~~~~~~

Softworx links against ``libtiff.so.3`` but Debian 9 only has
``libtiff.so.5``.  It is possible to build libtiff from source but
creating a symlink named ``libtiff.so.3`` is enough for Softworx to
start.  There may be issues later but if you're using Softworx you
will mainly be using dv files and not tiff.


Fix shell scripts
-----------------

::

    SHELL_SCRIPTS=$(file /opt/softWoRx/bin/x86_64/* | grep shell |cut -f1 -d ':')

    ## uname -p is not portable
    sudo sed -i 's,uname -p,uname -m,g' $SHELL_SCRIPTS

    ## re-hardcode SW_BASE path
    sudo sed -i 's,/usr/local/,/opt/,g' $SHELL_SCRIPTS

    ## This program just does not work
    echo '#!/bin/bash
    xdg-open $1 &
    sleep 1
    exit 1' | sudo tee /opt/softWoRx/bin/x86_64/DVShowDir
    sudo chmod a+x /opt/softWoRx/bin/x86_64/DVShowDir


Force ethernet card to be named ``eth0``
----------------------------------------

Softworx licensing is tied to the Mac address of the network device
named ``eth0``.  Debian 9 will, by default, use predictable, stable
network interface names which are named like ``ens32``.  The old-style,
upredictable names, like ``eth0``, can be forced with udev rules.

::

    ## Get the MAC address from the license file
    HWADDR=$(grep -Po -m 1 '(?<=HOST ")[0-9A-F:]{17}(?=")' \
              /etc/opt/softWoRx/license.dat \
           | tr '[:upper:]' '[:lower:]')

    echo \
        'SUBSYSTEM=="net",'\
        'ACTION=="add",'\
        'DRIVERS=="?*",'\
        'ATTR{address}=="'$HWADDR'",'\
        'ATTR{type}=="1",'\
        'NAME="eth0"' \
      | sudo tee /etc/udev/rules.d/70-persistent-net.rules > /dev/null

The new name will only be applied after restarting.


Configure dvqd daemon
---------------------

The DeltaVision processing queue manager (``dvqd``) is a system
service and starts automatically.  A SysV init file is provided but
Debian 9 has moved to systemd.  We have placed Softworx under ``/opt``
so need to update the paths for that.

::

    sudo ln -s /opt/softWoRx/bin/x86_64/dvqd /opt/sbin/dvqd
    sudo mv /opt/softWoRx/bin/x86_64/dvqd.init_DEBIAN /etc/init.d/dvqd
    sudo chmod 755 /etc/init.d/dvqd
    sudo sed -i 's,/usr/sbin/,/opt/sbin/,g' /etc/init.d/dvqd
    sudo sed -i 's,/var/\(run\|lock\)/,/var/opt/softWoRx/,g' /etc/init.d/dvqd
    sudo systemctl daemon-reload
    sudo systemctl enable dvqd.service
    sudo systemctl start dvqd.service


Desktop shortcuts
-----------------

::

    sudo mkdir -p /usr/local/share/pixmaps
    sudo mkdir -p /usr/local/share/mime
    sudo mkdir -p /usr/local/share/mime/packages
    sudo mkdir -p /usr/local/share/applications

    ## Shortcut to start SoftWoRx
    echo "\
    [Desktop Entry]
    Version=1.1
    Type=Application
    Name=Start softWoRx
    Comment=softWoRx
    Exec=/opt/softWoRx/bin/x86_64/runDV
    Icon=sw_app_icon.xpm
    Terminal=false
    Categories=Science;ImageProcessing;Motif" \
    | sudo tee /usr/local/share/applications/swstart.desktop > /dev/null

    ## Shortcut to exit SoftWoRx
    echo "\
    [Desktop Entry]
    Version=1.1
    Type=Application
    Name=Quit softWoRx
    Comment=Shut Down and Clean Up softWoRx
    Exec=/opt/softWoRx/bin/x86_64/DVExit
    Icon=sw_stop_icon.xpm
    Terminal=false
    Categories=Science;ImageProcessing;Motif;" \
    | sudo tee /usr/local/share/applications/swexit.desktop > /dev/null

    ## Application to view DV files
    echo "\
    [Desktop Entry]
    Version=1.1
    Type=Application
    Name=DVview
    NoDisplay=true
    Comment=View dv file in softWoRx
    Exec=/opt/softWoRx/bin/x86_64/DVview %f
    Icon=sw_app_icon.xpm
    Terminal=false
    StartupWMClass=softWoRx
    MimeType=image/deltavision;" \
    | sudo tee /usr/local/share/applications/dvview.desktop > /dev/null

    ## Register mime type for dv files (so viewer opens when opening them)
    echo '<?xml version="1.0" encoding="UTF-8"?>
    <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
      <mime-type type="image/deltavision">
        <icon name="image-deltavision"/>
        <comment>Deltavision Image</comment>
        <glob pattern="*.dv"/>
        <glob pattern="*.mrc"/>
        <glob pattern="*.otf"/>
        <glob pattern="*.psf"/>
        <magic priority="100">
          <match value="0xc0a0" type="big16" offset="96"/>
          <match value="0xa0c0" type="big16" offset="96"/>
        </magic>
      </mime-type>
    </mime-info>' \
    | sudo tee /usr/local/share/mime/packages/softworx.xml > /dev/null

    for FNAME in deltavision-image.png sw_app_icon.xpm sw_stop_icon.xpm ; do
        sudo ln -s /etc/opt/softWoRx/desktop/$FNAME \
            /usr/local/share/pixmaps/$FNAME
    done

    sudo update-mime-database /usr/local/share/mime
    sudo update-desktop-database /usr/local/share/applications
