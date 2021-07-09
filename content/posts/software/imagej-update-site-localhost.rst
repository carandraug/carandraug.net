Manage ImageJ update site on localhost with git
###############################################

:date: 2021-01-22
:tags: imagej; sysadmin

Summary
=======

I've discovered that one can use the ``file:`` "protocol" to manage
ImageJ update sites that are actually a git repository on the local
filesystem.  This means that I can then have the update site *pull*
the changes from somewhere rather than have ImageJ *push* the changes
to the remote update site.  This reduces the need for direct access to
the server with the overall goal being automating its deployment.

Why?
====

To make a new release of `SIMcheck
<https://www.micron.ox.ac.uk/software/SIMcheck/>`__, an ImageJ plugin,
I do the following dance:

1. build new release of SIMcheck;
2. install it on a fresh local copy of Fiji;
3. use the ImageJ updater to update the remote update site.

While most projects have their update site on `sites.imagej.net
<https://sites.imagej.net/>`__, we host the SIMcheck update site on
one of our own servers — the Micron downloads site — together with
some mirrors for other ImageJ update sites.  I like to own my
infrastructure and I like it distributed [1]_.

Anyway, I was never very happy with step 3 of this dance, namely the
part where ImageJ pushes changes directly to the public website.  This
is in large part because I'm not happy with our the current setup.  I
don't like having to access the downloads server to upload files.  I
would much rather have them somewhere else and then configure the
server to fetch/mount the files from that somewhere else.  I also want
to have the downloads site under version control and integrity checks.
My plan is to use `git-annex <https://git-annex.branchable.com/>`__
but there's always a lot of work to do and since infrastructure work
is never urgent it never gets done.


How?
====

While restructuring our servers is not going to happen overnight, I'm
doing it one step at a time.  For starters, I created a git repository
with the `SIMcheck update site
<https://github.com/MicronOxford/SIMcheck-update-site>`__.  The plan
now is to set up the downloads site to serve that git repository and
only have to specify the git hash to deploy on the ansible playbook.

But the ImageJ updater only makes changes on remote servers.  From its
`"documentation"
<https://imagej.net/How_to_set_up_and_populate_an_update_site>`__:

    If you have an own server or web space with WebDAV, SFTP or SSH
    access, you can create a directory in that web space and
    initialize it as an update site, too.

I could set one of those services locally but seems too much work when
the things are already local.  So despite the documentation I tried to
use ``file:`` as "host" and it worked just fine.  This is how it looks
like on the ImageJ update site manager:

.. image:: {static}/files/simcheck-local-update-site.png
   :alt: How the configuration looks like on the ImageJ update site
         manager.
   :width: 100%

So my dance now is as follow:

1. download a fresh copy of ImageJ;

2. configure the updater with a SIMcheck update site that is the local
   git clone;

3. install new version of SIMcheck;

4. update the SIMcheck update site (local git clone) with the new
   version with the ImageJ updater;

5. commit and push the changes to the SIMcheck update site;

6. pull the changes on the public server.

Which at the command line, roughly translate into::

    $ wget https://downloads.imagej.net/fiji/latest/fiji-linux64.zip
    $ unzip fiji-linux64.zip
    $ cd Fiji.app
    $ ./ImageJ-linux64 --update update
    $ ./ImageJ-linux64 --update add-update-site SIMcheck-local \
          file:/home/carandraug/src/SIMcheck-update-site/ \
          file: \
          /home/carandraug/src/SIMcheck-update-site/
    $ ./ImageJ-linux64 --update update
    $ mv PATH-TO-SIMCheck-REPO/target/SIMcheck_-1.3.jar plugins/
    $ rm plugins/SIMcheck_-1.2.jar
    $ ./ImageJ-linux64 --update upload \
          --update-site SIMcheck-local \
          plugins/SIMcheck_-1.3.jar
    $ cd ~/src/SIMcheck-update-site
    $ git add plugins/SIMcheck_-1.3.jar-20210121203119
    $ git add db.xml.gz
    $ git commit -m "SIMcheck release 1.3"

Future Ideas
============

I think it might be interesting to have something like this for
automating releases.  An automation server can be triggered to build
new releases and push them to a git repository for each update site.
A site that serves those update sites can be configured to pull and
serve a specific commit for each update site.

.. [1] It's not only me.  The ImageJ project itself seems interested
       in having mirrors of its resources.  If you can set a mirror,
       checkout the image.sc thread `Who can mirror ImageJ online
       resources?
       <https://forum.image.sc/t/who-can-mirror-imagej-online-resources/42451>`__
