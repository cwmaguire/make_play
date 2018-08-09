# make_play

This is me playing around with Make. I have exercises I did while reading "Manage Projects with GNU Make" (MPWGM) and "The GNU Make Book" (TGMB) as well as other exercises I did just to figure stuff out.

This repo has three different kinds of exercise:
- Makefile - a whole bunch of stuff in one Makefile from MPWGM
- Directories: Stuff I was goofing around with?
- tgmb_ex_*: exercises I created from TGMB

##### MPWGM Examples:

    `make a`<p>
    `make b`<p>
    `make 1.a`<p>

##### TGMB Examples:

    `make -f tgmb_ex_1.1`

See each individual tgmb_ex_* file for how to run it. Some require environment variables to be set.

##### Directory Examples:

    cd copy_file/
    make a

Some directories have a README explaining what the Makefile in that directory explores.

##### TGMB Example Index:
- tgmb_ex_1.1: relationship between environment, commandline and internal vars using $(origin)
- tgmb_ex_1.2: Precedence of environment, commandline and defaulting
  with ?=
- tgmb_ex_1.3: Exporting, re-exporting and overwriting environment variables
- tgmb_ex_1.4: .EXPORT_ALL_VARIABLES
- tgmb_ex_1.5: Using $(shell) and the visibility of commands and @-lines
- tgmb_ex_1.6: Overriding variables in targets and their dependencies
- tgmb_ex_1.7: Same as 1.6 but with 4 different rules on 1 line
- tgmb_ex_1.8: Same as 1.6 but with pattern matching rules
- tgmb_ex_1.9: Comment without tab within rule is invisible
- tgmb_ex_1.10: +=, spaces are optional around the operator and always added
- tgmb_ex_1.11: Built-in MAKE_VERSION and .FEATURES variables
- tgmb_ex_1.12: if and ifdef
- tgmb_ex_1.13: functions and $(call)
- tgmb_ex_1.14: Demonstrate that $(my_fun) works like $(call my_fun)
- tgmb_ex_1.15: Incorporating shell "which" command
- tgmb_ex_1.16: Use $() and ${} variable expansion syntax
- tgmb_ex_1.17: Create a simple variable that is lazily evaluated once
- tgmb_ex_1.18: List operators and a clumsy reverse function
