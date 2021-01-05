Octave object
#############

adding comments to source code, changing whitespace etc will trigger a
build in a build system fr data analysis.  If the code had to be
compiled there would be no problem, rebuilding is ligth copmared to
heavy data processing.

So have octave code being read and parsed, then save without comments
and whitespace etc.  Then use that to run at which point only if the
contents changed does the code run.