# See if I can use a variable holding nothing to check if another variable is empty

a =

a: b
# not equal
ifeq ("", $(a))
	@echo equal to \"\"
else
	@echo not equal to \"\"
endif

## equal
ifeq (,$(a))
	@echo equal to \"no string\"
else
	@echo not equal to \"no string\"
endif
