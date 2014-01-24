GDAL_CXXFLAGS=$(shell gdal-config --cflags) -Wsign-compare
GDAL_LDFLAGS=$(shell gdal-config --libs)  $(shell gdal-config --ldflags) $(shell gdal-config --dep-libs)
COMMON_FLAGS=-Wall
RELEASE_FLAGS=$(COMMON_FLAGS) -DBOOST_DISABLE_ASSERTS -DNDEBUG -O3 -finline-functions
DEBUG_FLAGS=$(COMMON_FLAGS) -DDEBUG -O0
CXXFLAGS := $(CXXFLAGS) # inherit from env
LDFLAGS := $(LDFLAGS) # inherit from env

TEMPLATES="/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/Resources/templates/"

all: polygonize

polygonize: Makefile polygonize.cpp
	$(CXX) -o polygonize polygonize.cpp -F/ -framework CoreFoundation $(DEBUG_FLAGS) $(CXXFLAGS) $(LDFLAGS) $(GDAL_LDFLAGS)

clean:
	rm -f ./polygonize
	rm -rf profile-runs/

test:
	mkdir -p profile-runs/
	iprofiler -d profile-runs/ -timeprofiler ./polygonize
	open profile-runs/polygonize.dtps

.PHONY: test
