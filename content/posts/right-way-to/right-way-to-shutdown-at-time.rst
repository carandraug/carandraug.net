Shutdown system at a specific time
##################################

:tags: sysadmin;
:date: 2015-09-07 18:21:00

I need to shutdown a server at a specific hour a few days from now.
The command ```shutdown`` <https://linux.die.net/man/8/shutdown>`_
allows to specify the hour but not the day so that can't be used.  It
also allows to specify a number of minutes from "now" which implies
computing that value.  So the following can be used::

 sudo shutdown -h +$(($(($(date -d 'yyyy-mm-dd hh:mm:ss' +"%s") - $(date +"%s"))) / 60))

I guess there is also the ```at`` <https://linux.die.net/man/1/at>`_
command, though.
