# Even if the file b exists the b rule will fire
.PHONY: b

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

# words function: counts words
words: words = a b c
words:
	# There are $(words $(words)) words in $(words)

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
