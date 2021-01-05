Google Scholar Bibtex authors
#############################

:tags: academia;
:date: 2017-02-14 16:48
:status: draft

I use Google Scholar and their Firefox plugin to search for papers and
get references in the Bibtex format.  However, seem that recently they
changed their format so that list of authors is automatically reduced
to "and others" after a number of authors.

Example, it now returns this::

  @article{stajich2002bioperl,
    title={The Bioperl toolkit: Perl modules for the life sciences},
    author={Stajich, Jason E and Block, David and Boulez, Kris and Brenner, Steven E and Chervitz, Stephen A and Dagdigian, Chris and Fuellen, Georg and Gilbert, James GR and Korf, Ian and Lapp, Hilmar and others},
    journal={Genome research},
    volume={12},
    number={10},
    pages={1611--1618},
    year={2002},
    publisher={Cold Spring Harbor Lab}
  }

This shortening of author list from complete list of names to "and
others" is the responsability of the bibliography style.  The
reference information does not change.  By doing this, it prevents

I already retrned feedback about the issue
https://support.google.com/scholar/contact/general

If the list of authors is too long, the reference imported into
citation managers does not include the full author list. Instead, it
ends with "and others".  This is a change that is up to the
bibliography style used only.

How to reproduce:

1. search for a paper with a large number of authors, example "The Bioperl Toolkit: Perl Modules for the Life Sciences", which has 21 authors
2. click the "cite" button of that reference
3. note how the pre-formated styles handle large number of authors differently.
4. click on the bibtex button to retrieve the actual reference
5. note that the list of authors only lists the first 10 authors an ends with "and others"

A bibliography manager software needs the full list of authors to
handle other styles which require the last author.  The current
behaviour is not even able to reproduce what is provided by google
scholar which lists the first 11 authors in Harvard style while the
reference only has the first 10 authors.
