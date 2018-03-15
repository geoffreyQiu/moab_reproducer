#include "moab/Core.hpp"
#include "moab/ParallelComm.hpp"
#include "MBParallelConventions.h"
#include "mpi.h"
#include <cassert>
#include <string>
#include <iostream>
#include <fstream>

//#define MOAB_LOAD_FILE "meshes/can4/tet4_10_2048.h5m"
//#define MOAB_LOAD_OPT  "PARALLEL=READ_PART;PARALLEL_RESOLVE_SHARED_ENTS;PARTITION=PARALLEL_PARTITION;CPUTIME;"
//#define MOAB_LOAD_OPT  "PARALLEL=READ_PART;PARTITION=PARALLEL_PARTITION;CPUTIME;"

//#define MOAB_LOAD_FILE "./meshes/tet4_75.h5m"
//#define MOAB_LOAD_OPT  ";"

int main(int argc, char **argv) {

  if ( (argc != 2) && (argc != 4) ) {
    std::cout << "Usage: " << argv[0] << " {mesh_file} [ -o {read_options} ]" << std::endl;
    exit(-1);
  } else if ( (std::string(argv[1]) == "-h") || (std::string(argv[1]) == "--help") ) {
    std::cout << "Usage: " << argv[0] << " {mesh_file} [ -o {read_options} ]" << std::endl;
    exit(-1);
  } else if ( (argc == 4) && (std::string(argv[2]) != "-o") ) {
    std::cout << "Usage: " << argv[0] << " {mesh_file} [ -o {read_options} ]" << std::endl;
    exit(-1);
  }
  std::ifstream l_infile(argv[1]);
  if (l_infile.good()) {
    l_infile.close();
  } else {
    std::cout << "Error: File does not exist." << std::endl;
    exit(-1);
  }

  MPI_Init(&argc, &argv);
  int world_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

  std::string l_meshFile(argv[1]);
  std::string l_readOpt(";");
  if (argc == 2) {
    l_readOpt = std::string("PARALLEL=READ_PART;PARALLEL_RESOLVE_SHARED_ENTS;PARTITION=PARALLEL_PARTITION;");
  } else {
    l_readOpt = std::string(argv[3]);
  }

  moab::Interface *l_core = new moab::Core();
  moab::ParallelComm l_pcomm(l_core, MPI_COMM_WORLD);
  double l_start = MPI_Wtime();
  moab::ErrorCode l_err = l_core->load_file( l_meshFile.c_str(), 0, l_readOpt.c_str() );
  double l_end = MPI_Wtime();
  assert( l_err == moab::MB_SUCCESS );
  double l_time = l_end - l_start;
  double l_elapsedTime;
  MPI_Reduce(&l_time, &l_elapsedTime, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);


  int l_nElmts;
  l_err = l_core->get_number_entities_by_type( 0, moab::MBTET, l_nElmts);
  assert( l_err == moab::MB_SUCCESS );
  int l_totalNumElmts;
  MPI_Reduce(&l_nElmts, &l_totalNumElmts, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
  if (world_rank == 0) {
    std::cout << "Mesh file: " << l_meshFile << std::endl;
    std::cout << "Number of tets: " << l_totalNumElmts << std::endl;
    std::cout << "Elapsed time: " << l_elapsedTime << " s." << std::endl;
  }

  MPI_Barrier(MPI_COMM_WORLD);
  //if (l_core != nullptr) delete l_core;


  MPI_Finalize();
 

  return 0;
}
