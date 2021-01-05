Install Bioformats in Debian and Ubuntu
#######################################

:tags: bioformats; sysadmin;
:date: 2015-07-22 12:19:00

Bioformats is not packaged in Debian and therefore, not in Ubuntu
either.  To install it in a way that will make it play best with the
rest of the system, following the expected standards, use the
following (adjusting the download URL for the `bioformats version you
want <http://downloads.openmicroscopy.org/bio-formats/>`_)::

 sudo mkdir /usr/local/share/java/
 sudo wget http://downloads.openmicroscopy.org/bio-formats/5.1.3/artifacts/bioformats_package.jar \
  -O /usr/local/share/java/bioformats_package-5.1.3.jar
 sudo ln -s bioformats_package-5.1.3.jar \
   /usr/local/share/java/bioformats_package.jar

This mimics how java packages are installed by Debian.  The actual jar
has the version on the filename, while the unversioned filename is a
symbolic link to a specific version.  This allows you to have multiple
versions installed while keeping one (usually the latest) as the
default.

apt would install those files in ``/usr/share/java/`` so we place them
in ``/usr/local/share/java/`` instead.  Remember that the whole
``/usr/`` hierarchy should be considered off-limits, only the package
manager should change things there.  The exception is ``/usr/local/``.
You can think of ``/usr/local/`` being the equivalent as ``/usr/``
that is managed by the system administrator instead of the package
manager.  From the `Linux Filesystem Hierarchy Standard
<http://refspecs.linuxfoundation.org/fhs.shtml>`_::

> The /usr/local hierarchy is for use by the system administrator when
> installing software locally.
> [...]
> Locally installed software must be placed within /usr/local rather
> than /usr unless it is being installed to replace or upgrade
> software in /usr.
