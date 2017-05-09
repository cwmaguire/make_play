# Even if the file b exists the b rule will fire
.PHONY: b

# default rule
a:
	# a: This is printed as a shell comment
# This comment does not start with a tab and won't show up

b:
	@echo b: This is printed by echo

c: d e
	# c: The 1st prereq is printed with $$<: $<

d: e
	# d: The target is printed with $$@: $@

e: f g h h
	# e: All prereqs printed with $$^: $^
	# e: All prereqs printed, dupes included, with $$+: $+
	# e: Newer prereqs printed with $$?: $?

f.c:
	#f.c: The target stem is printed with $$*: $*

# create each a from the matching b
# Call with: make 1.a
%.a: %.b
	# cat $$< >> $$@
	cat $< >> $@
	# touch $$<: $<
	touch $<

# Have a matching rule line to set a variable
i: A = 1
i:
	# $$A = $A

# Double-expand
j: A = 1
j: B = A
j:
	# $$(A) = $(A)
	# $$(B) = $(B)
	# $$($$(B)) : $($(B))
	# Double expansion requires parenthesis:
	#   $$$$B = $$B
	#   $$$$(B) = $$(B)
	# Separate the $$'s:
	#   $$($$B) = $($B)

empty_rule: ;
# won't do anything

splitrule: A =1
dummy: Z = 1; # can't use "B" because it's defined later on
splitrule:
	# $$(A) = $(A)
# Z has not been defined in this rule even though dummy comes
# in between the two splitrule clauses
	# $$(Z) = $(Z)

# words function: counts words
words: words = a b c
words:
	# There are $(words $(words)) words in $(words)

wordn: words = a b c
wordn:
	# $$(word 1,$$(words)) = $(word 1,$(words))
	# $$(word 2,$$(words)) = $(word 2,$(words))
	# $$(word 3,$$(words)) = $(word 3,$(words))

firstword: words = a b c
firstword:
	# $$(firstword $$(words)) = $$(firstword $(words)) = $(firstword $(words))

wordlist: words = a b c d e
wordlist:
	# $$(wordlist 1,2,$$(words)) = $$(wordlist 1,2,$(words)) = $(wordlist 1,2,$(words))
	# $$(wordlist 2,3,$$(words)) = $$(wordlist 2,3,$(words)) = $(wordlist 2,3,$(words))
	# $$(wordlist 3,5,$$(words)) = $$(wordlist 3,5,$(words)) = $(wordlist 3,5,$(words))
	# $$(wordlist 5,3,$$(words)) = $$(wordlist 5,3,$(words)) = $(wordlist 5,3,$(words))
	# $$(wordlist 3,1000,$$(words)) = $$(wordlist 3,1000,$(words)) = $(wordlist 3,1000,$(words))

filterout: words = aa ab ac ad
filterout:
	# $$(filter-out %b,$$(words)) = $$(filter-out %b,$(words)) = $(filter-out %b,$(words))

findstring: string = abc
findstring:
	# Result of $$(findstring ab,$$(string)): $(findstring ab,$(string))
	# Result of $$(findstring abc,$$(string)): $(findstring abc,$(string))
	# Result of $$(findstring ac,$$(string)): $(findstring ac,$(string))
	# Result of $$(findstring ab%,$$(string)): $(findstring ab%,$(string)) (% is literal)

# I was thrown off by the missing 'r'
subst: string = abc
subst:
	# Result of $$(subst b,c,$$(string)): $(subst b,c,$(string))

sort: words = c d b a e
sort:
	# $$(sort $$(words)) = $$(sort $(words)) = $(sort $(words))

shell: command = ls -al
shell: path = a b c
shell:
	@echo $(shell ls)
	@echo $(shell $(command))
	@echo $(shell [[ -e $(path) ]] || echo nope )

filter: words = aa ab bb
filter:
	# $$(filter a%,$$(words)) : $$(filter a%,$(words)) : $(filter a%,$(words)) should equal aa ab

# Relative path
wildcard:
	# $$(wildcard *.a *.b) : $(wildcard *.a *.b)
	# $$(wildcard *.c) : $(wildcard *.c)

dir:
	# $$(dir a b c) : $(dir a b c)

notdir: path = $(shell pwd)
notdir: paths = $(path)/a $(path)/b $(path)/c
notdir:
	# $$(paths): $(paths)
	# $$(notdir $$(paths)) : $(notdir $(paths))

# returns last dot-extension
suffix:
	# $$(suffix abc.def ghi.jkl, mno.pqr.stu)
	# becomes
	# $(suffix abc.def ghi.jkl, mno.pqr.stu)

# keeps path elements
basename: path = $(shell pwd)
basename: paths = $(path)/a.x $(path)/b.x $(path)/c.x
basename:
	# $$(paths): $(paths)
	# $$(basename $$(paths)) : $(basename $(paths))

addsuffix:
	# $$(addsuffix .txt,a b c) : $(addsuffix .txt,a b c)

addprefix:
	# $$(addprefix ___,a b c) : $(addprefix ___,a b c)

join:
	# $$(join a b c, .x .y .w) : $(join a b c, .x .y .w)

if: false :=
if: true := 1
if:
	# $$(if $$(false),yup,nope) : $$(if $(false),yup,nope) : $(if $(false),yup,nope)
	# $$(if $$(true),yup,nope) : $$(if $(true),yup,nope) : $(if $(true),yup,nope)

error:
	$(error 'An error')

warning:
	$(warning 'A warning')

foreach:
	# $$(foreach a,a b c d,$$(addprefix -,$$(addsuffix -,$$(a)))) :
	# $(foreach a,a b c d,$(addprefix -,$(addsuffix -,$(a))))

strip:
	# $$(foreach a,a,  $$(a)  ) -->$(foreach a,a,  $(a)  )<--
	# $$(strip $$(foreach a,a,  $$(a)  ) -->$(strip $(foreach a,a,  $(a)  ))<--

# use command-line or environment values for C & D
# e.g. C=1 make origin D=1
export B=1 # warning: this will show up in all rules!
# Use --print-data-base (--no-builtin-rules is nice too) to see that
# B=1 comes from this line.
origin: A := 1
origin:
	# A is 'file' even when -e / --environment-overrides is on
	# A: $(origin A)
	# @: $(origin @)
	# B: $(origin B)
	# C: $(origin C)
	# D: $(origin D)

# a can be used with:
# $(call a,arg1,arg2,...)
# or
# $(a) ... which returns 0 unless a outside call has set
#          the $1, $2, etc. params
define a
  $(words $1 $2 $3 $4 $5 $6 $7 $8)
endef

calla:
	# Function that references 8 arguments counts its
	# arguments with $$(words ...)
	# $$(call a,1,2,3) : $(call a,1,2,3)

eval:
	# eval rule processed

# eval takes it's arguments and internalizes them as
# part of the Makefile rules databse.
$(eval eval2: eval)
# We can now call "make eval2"

# Make will expand all arguments to eval before
# eval internalizes them
EVAL3=eval3 : eval
$(eval $(EVAL3))

# On page 46 of "Managing Projects with GNU Make" we see that
# "macros" (multi-line variables made with "define...endef"
# have tabs prepended to each line when used in the context
# of a command script.
# (The "command script" is the list of commands run for a rule)
eval4a = 1
define EVAL4
eval4:
	# $$$$(eval4a) : $(eval4a)
endef
$(eval $(EVAL4))
# We can now call "make eval4"
# Why the $$$$?
# Because make will expand the arguments to eval,
# namely:
#   $(eval4a) -> 1
#   $$$$(eval4a) -> $$(eval4)
# ... and then once eval is finished
# make will expand any restulting code:
#   $$(eval4) -> $(eval4)
# ... so $$$$(eval4a) becomes $$(eval4a) and then
# finally $(eval4a).

# Here I was trying to use the nested eval to simply
# expand a variable four times and I just couldn't make it happen.
# I suspect it's because the eval call has to eval to something
# that make can internalize as a make instruction
# eval5a = 1
# define EVAL5
# eval5:
# 	# $$(eval 1)
# endef
# $(eval $(EVAL5))

  # $$(eval 1)

# Call macro by name from argument

define hook_a
  $(call $(1),hook_a)
endef

define hook_b
  @echo hook_b called from $(1)
endef

hook: hook_fun := hook_b
hook:
	$(call hook_a,$(hook_fun))
