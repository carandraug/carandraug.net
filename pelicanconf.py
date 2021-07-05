#!/usr/bin/env python
# -*- coding: utf-8 -*- #

# The default pelican configuration files have different files for
# local testing and deployment, the difference being on SITEURL being
# defined, the use of relative urls, and whether to delete output
# directory.  This configuration does not do that.
#
#   1) SITEURL is not used if RELATIVE_URLS is set.  This means that
#   specifying an empty SITEURL makes no difference if testing also
#   means relative urls.
#
#   2) relative urls and delete output directory have their own
#   command line options, so we just use the Makefile to do that
#   instead of a separate configuration file.


SITEURL = "https://carandraug.net"
AUTHOR = "David Miguel Susano Pinto"
SITENAME = "CarandraugNet"

COPYRIGHT_YEAR = 2021
COPYRIGHT_HOLDER = AUTHOR


FEED_DOMAIN = SITEURL
FEED_ALL_ATOM = 'feeds/atom.xml'
CATEGORY_FEED_ATOM = 'feeds/{slug}.atom.xml'


PATH = "content"

STATIC_PATHS = [
    "static/.htaccess"
]
EXTRA_PATH_METADATA = {
    "static/.htaccess": {"path": ".htaccess"},
}


TIMEZONE = 'Europe/London'
DEFAULT_DATE_FORMAT = "%d %b %Y"

DEFAULT_LANG = 'en'

THEME = "./theme"
THEME_STATIC_DIR = "_static"

SUMMARY_MAX_LENGTH = 20
DEFAULT_PAGINATION = 5

USE_FOLDER_AS_CATEGORY = True
SLUGIFY_SOURCE = 'basename'

ARTICLE_URL = "posts/{date:%Y}/{date:%Y}-{date:%m}-{date:%d}-{slug}.html"
ARTICLE_SAVE_AS = "posts/{date:%Y}/{date:%Y}-{date:%m}-{date:%d}-{slug}.html"

# I'm the only author, so do not create a page for posts by author.
AUTHOR_URL = ""
AUTHOR_SAVE_AS = ""
AUTHORS_SAVE_AS = ""
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None


# Use the same source content's hierarchy for the output
PATH_METADATA = "(?P<path_no_ext>.*)\..*"
PAGE_URL = "{path_no_ext}.html"
PAGE_SAVE_AS = "{path_no_ext}.html"


MENU_ITEMS = [
    ("Home", ""),
    ("Archives", "archives.html"),
    # ("Projects", "pages/projects/index.html"),
    ("TipJar", "pages/thanks.html"),
    # ("About", "pages/about.html"),
    # Maybe some day add a Contact or Hire me page?
]


SOCIAL = [
    ("#CarandraugNet", "https://twitter.com/CarandraugNet"),
    ("carandraug", "https://github.com/carandraug/"),
    ("carandraug", "https://stackoverflow.com/users/1609556/carandraug"),
    # add linkedin, other stackexchange, debian dashboard
]

CATEGORY_TAGS = {
    "foss-monthly-reports": [
        "free software",
        "software",
    ],
    "gsoc-2013-updates": [
        "octave",
        "software",
    ],
    "right-way-to": [
    ],
    "octave": [
        "octave",
        "software",
    ],
}

##
## Plugins
##

PLUGIN_PATHS = ["./plugins"]
PLUGINS = ["category_tags"]
