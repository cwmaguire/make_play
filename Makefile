# Even if the file b exists the b rule will fire
.PHONY: b error warning

# default rule
a:
	# a: This is printed as a shell comment

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
export B=1
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
