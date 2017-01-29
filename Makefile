#!/usr/bin/make

VPATH = src
vpath %.xsl script
vpath %.xq script

.PHONY : all
all : test.svg

test.svg: make.xsl makeA3P.xsl makeDistributionBoard.xsl rozvadec.xml comp.xml
	java net.sf.saxon.Transform -s:rozvadec.xml -xsl:make.xsl -o:test.svg
