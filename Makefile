

build:
	make -f Makefile.andes
	make -f Makefile.sarah
	make -f Makefile.magical8bitplug2

dist:
	make -f Makefile.andes dist
	make -f Makefile.sarah dist
	make -f Makefile.magical8bitplug2 dist

