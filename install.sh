#!/bin/sh

if is-installing-package && [ ! -f makefile ] ; then
	echo "⎆ installing fait bootstrap"
	cp node_modules/fait/bootstrap.mk makefile
fi
