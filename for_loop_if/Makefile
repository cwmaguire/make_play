.PHONY: first_target revert

# Working out how to do shell for loops and if statements
# from within make

# look for all files that end in .config and if there exists
# a matching .config.override file then copy the override
# over the config file
overwrite:
	@for file in files/*.config ; do \
		if [ -f $${file}.override ] ; then \
			cp $${file}.override $${file} ; \
		fi ; \
	done

# Reverts the changes made by overwrite
revert:
	@for x in a b ; do \
		echo $${x} > files/$${x}.config ; \
	done ;

