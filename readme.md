### Reproducer for MOAB

#### build

Use `Makefile` directly. eg:

```
make MOAB_DIR=${MOAB_ROOT}/libs NETCDF_LIB_DIR=${TACC_NETCDF_LIB} HDF5_LIB_DIR=${TACC_HDF5_LIB}
```
The following variables are required.
* `MOAB_DIR`: The directory with Moab headers (in `$(MOAB_DIR)/include`) and libraries (in `$(MOAB_DIR)/lib`).
* `NETCDF_LIB_DIR`: The directory for NetCDF libraries.
* `HDF5_LIB_DIR`: The directory for HDF5 libraries.


#### run

The basic usage of the reproducer is 
```
./moab_reproducer ${mesh_file} [-o '${read_options}' ]
```
If the reading options are not provided, the default value is "PARALLEL=READ_PART;PARALLEL_RESOLVE_SHARED_ENTS;PARTITION=PARALLEL_PARTITION;".

Run with multiple ranks:
```
mpiexec.hydra -n 16 -ppn 16 ./moab_reproducer ./meshes/tet4_150_16.h5m
```
or
```
mpiexec.hydra -n 16 -ppn 16 ./moab_reproducer ./meshes/tet4_150_16.h5m -o 'PARALLEL=READ_PART;PARALLEL_RESOLVE_SHARED_ENTS;PARTITION=PARALLEL_PARTITION;CPUTIME;'
```

Run with a single rank:
```
./moab_reproducer ./meshes/tet4_150.h5m -o ';'
```

