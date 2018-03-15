
SRCDIR = .
OBJDIR = ./build
BUILDDIR ?= $(OBJDIR)

CSRC = $(wildcard *.c)
CXXSRC = $(wildcard *.cpp)
SRC = $(CSRC) $(CPPSRC)
OBJ = $(CSRC:.c=.o) $(CPPSRC:.cpp=.o)
DEP = $(wildcard *.h *.hpp)
EXE = moab_reproducer

CC  = mpiicc
CXX = mpiicpc

MOAB_DIR ?=
PNETCDF_LIB_DIR ?=
NETCDF_LIB_DIR ?=
HDF5_LIB_DIR ?=

ifneq ($(MAKECMDGOALS),clean)
ifeq ($(MOAB_DIR),)
$(error MOAB_DIR invalid!)
endif

ifeq ($(NETCDF_LIB_DIR),)
$(error NETCDF_LIB_DIR invalid!)
endif

ifeq ($(HDF5_LIB_DIR),)
$(error HDF5_LIB_DIR invalid!)
endif
endif

CFLAGS = -mkl -Wall -I${MOAB_DIR}/include
LDFLAGS = -mkl -Wall -Wl,--as-needed -L${MOAB_DIR}/lib -lMOAB  -L${NETCDF_LIB_DIR} -lnetcdf -L${HDF5_LIB_DIR} -lhdf5_hl -lhdf5 -lz
ifneq ($(PNETCDF_LIB_DIR),)
LDFLAGS += -L${PNETCDF_LIB_DIR} -lpnetcdf
endif


.PHONY: all
all: $(EXE)

moab_reproducer: $(BUILDDIR)/moab_reproducer.o
	$(CC) -o $@ $^ $(LDFLAGS)

$(BUILDDIR)/%.o: $(SRCDIR)/%.cpp $(DEP)
	@mkdir -p $(BUILDDIR)
	$(CC) $(CFLAGS) -o $@ -c $<

.PHONY: clean
clean:
	rm -f $(BUILDDIR)/*
	rm -f $(EXE)

