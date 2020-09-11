# PEML: The Programming Exercise Markup Language

This tree contains the documentation, specification, and author's guide
for PEML.

The **Programming Exercise Markup Language (PEML)** is intended to be a
simple, easy format for CS and IT instructors of all kinds (college,
community college, high school, whatever) to describe programming
assignments and activities.
We want it to be so easy (and obvious) to use that instructors won't
see it as a technological or notational barrier to expressing their
assignments.

We intend for this format to be something that authors of automated
grading tools can adopt, so they can provide a very easy, low-energy
onboarding path for existing instructors to get programming activities
into such tools. As a result, this notation leans heavily on supporting
authors and streamlining common cases, even if this may require more
work on the part of tool developers--the goal is to make it super easy
for **authors** of programming activities, not to fit into a specific
auto-grader or simplify tasks for tool writers.


## Structure of This Subtree

The source for all documentation in this tree is stored in the `jekyll_src`
folder. These pages are part of the
[CSSPLICE project web pages](https://CSSPLICE.github.io/), which is
not yet jekyll-enabled. As a result, when updates are made to this
project, we hand-build the `jekyll_src` and copy `jekyll_src\_site` to
this folder to commit the changes, so that the statically genertated pages
are viewable through https://CSSPLICE.github.io/. Some day, we might fix
that extra bit of effort.

We've taken advantage of the fact that pages are statically generated offline
to add a jekyll plugin to provide rouge syntax highlighting for PEML examples
in these pages, so they currently are not configured for auto-jekyll-generation
on github.io anyway. we would need to issue a pull request against rouge to
get PEML officially supported to enable that ... eventually.


## The PEML Code

If you're looking for the PEML support code instead of the documentation,
look at the ruby gem called `peml` at https://github.com/CSSPLICE/peml/.


## Contributing

Bug reports and pull requests for this documentation site are welcome on
GitHub at https://github.com/CSSPLICE/CSSPLICE.github.io.

Project members can click directly on the edit icon to the right of the
title on any page on the github.io live site to go directly to the
corresponding source page, which can be directly edited on GitHub in-browser.


## License

[![CC BY-SA 4.0][cc-by-sa-shield]][cc-by-sa]

This work is licensed under the
[Creative Commons Attribution-ShareAlike 4.0 International License][cc-by-sa].

[![CC BY-SA 4.0][cc-by-sa-image]][cc-by-sa]

[cc-by-sa]: http://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/4.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg