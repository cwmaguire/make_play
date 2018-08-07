b := $(shell test -e b)
$(shell echo $(b))

ifeq (0,$(shell test -e b))
	a := yes
else
	a := no
endif
$(info shell status: $(.SHELLSTATUS))
ifeq (0,$(.SHELLSTATUS))
	c := yes
else
	c := no
endif
$(shell test -e b)
$(info shell status: $(.SHELLSTATUS))

a:
	@echo $(a)
	@echo $(b)
	@echo $(c)
	@echo "Shell status:" $(.SHELLSTATUS)
	@echo "File exists: " $(shell if test -e b ; then echo yes ; fi)
