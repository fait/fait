#!/bin/sh

if is-installing-package && [ ! -f ../../makefile ] ; then
	echo "⎆ installing fait bootstrap"
	cp bootstrap.mk ../../makefile
fi
