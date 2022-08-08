Missing documentation:
* [suites]
* [src]
* [environment]
* [systems]
* {options}

Build-out needed:
* writing test cases
* YAML literals in unquoted CSV
  * add renderer settings for structured data fields
    (assume YAML-inline for any field value starting
    with a ", ', [, or {) (renderers can be unified
    names that are defined separately for each supported
    prog lang, maybe with a standard set)
  * add per-system template support? Then include
    rendering directly in the template instead of
    externally?
    * maybe need a *.to_s, *.to_map, *.to_array,
      etc, as suffixes for mustache expressions
      in templates, with system-defined renderers?

Ensuring compatibility:
* Really need to take a look at GradeScope's info
  for packaging to make sure we can generate that for
  stock Java and Python coding questions
* Really need to take a look at PrairieLearns's info
  for packaging to make sure we can generate that for
  stock Java and Python coding questions
* Also that other grader I can't remember the name of
* What about this new CodeGrade thing?

Ideas:
* maybe, like in src and elsewhere, simplify
  environment.* to allow specification of
  environment keys directly, with the expectation
  that those values apply in all environments
  (to simplify, like for systems and elsewhere)
* Do we need a "getting started" guide? Or is the
  tutorial enough?
* Peter is pushing connection with ProFormA, which
  also tries to cover submissions and results,
  not just assignment description/setup?
