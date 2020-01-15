#
# Makefile for shellrc
#

# Set this to anything other than production to do tests in the
# current directory.
MODE=production


default: build


#
# Lists of file extensions to be incorporated into the RCs for various
# shells.
#

profile-list:
	find . -name "*.sh" \
	| sed -e 's|^./||g' \
	| sort -t/ -k2 \
	> $@
TO_CLEAN += profile-list


bashrc-list:
	find . -name "*.sh" -o -name "*.bash" \
	| sed -e 's|^./||g' \
	| sort -t/ -k2 \
	> $@
TO_CLEAN += bashrc-list


cshrc-list:
	find . -name "*.csh" \
	| sed -e 's|^./||g' \
	| sort -t/ -k2 \
	> $@
TO_CLEAN += cshrc-list


tcshrc-list: cshrc-list
	find . -name "*.tcsh" \
	| sed -e 's|^./||g' \
	| cat "$<" - \
	| sort -t/ -k2 \
	> $@
TO_CLEAN += tcshrc-list


%: %-list
	printf "#\n# %s Generated %s\n#\n\n" "$@" "$$(date)" > $@
	< "$<" xargs awk \
	    'BEGIN { LAST="" } \
             FILENAME != LAST { \
	         printf "\n\n# %s\n\n", FILENAME; LAST=FILENAME \
             } \
             { print }' \
	>> $@


#
# Build
#

RCS := bashrc cshrc tcshrc profile
build: update clean $(RCS)
TO_CLEAN += $(RCS)


#
# Installation and Removal
#

ifeq ($(MODE),production)
INSTALL_DIR=$(HOME)
DOT := .
else
INSTALL_DIR := .
DOT := INSTALLED-.
endif

INSTALLED := $(RCS:%=$(INSTALL_DIR)/$(DOT)%)
ifneq ($(MODE),production)
TO_CLEAN += $(INSTALLED)
endif

$(INSTALL_DIR)/$(DOT)%: %
	rm -f "$@"
	install -m 440 "$<" "$@"


install: build $(INSTALLED)



uninstall remove:
	rm -rf $(INSTALLED)


#
# Everything Else
#

# Update any Git submodules that are present
update:
	@if [ -e ".git" ] ; then \
	    echo git submodule update --remote --recursive ; \
	    git submodule update --remote --recursive ; \
	fi

clean:
	(echo && find . -name "*~") | xargs rm -rf
	rm -rf $(TO_CLEAN)
