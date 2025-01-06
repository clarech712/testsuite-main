# testsuite for Tufts HPC
Testsuite is a collection of tests that are used to validate a cluster before and after a maintenance. It produces a simple `PASS/FAIL` output for each test which 
is easier to interpret. Ideally all the tests in testsuite should `PASS` but sometimes tests may `FAIL` due to version changes or license issues. At a minimum, the
`testsuite` results after a maintenance should be no worse than the one before.

# Programs
## testapp: run a single test

### Syntax
```
Usage:  testapp [options] [tests ...] [-o sbatch_options ...]

Options:
  -l             list available tests
  -ll <test_name>                  
                 list module variables for test_name
  -v             verbose output (default)
  -q             quiet (no verbose output)
  -r             run tests on random, specifically-named nodes
  -k             keep raw output directories
  -t <path>      use path for temporary output directories

  -o             any additional SLURM sbatch options
                 (if present, must appear at the end of the command)

  -p 	       Use personal test definitions 
		       Personal tests are defined in ~/.testapps 

  --submit       dispatch asynchronous job
                 (prints <test_name> <job_id> <test_id>)
  --validate <test_name> <job_id> <test_id>
                 validate completed asynchronous job
  --status [ <test_name> | <job_id> ]              
                 you can leave out one or both of the options
                 check the status of a recently ran job

  Suggested usage:  testapp <testname>
```

### Available tests
By default, `testapp` will search for available tests stored in `/cluster/tufts/hpc/tools/testsuite/0.0.1/testapps/`.
```
$ testapp -l

amber
amdfftw
anaconda
aocc
blast
blast_short
boost
db12
fftw
gcc
gnuplot
gromacs
gsl
hdf5
hpcg_intel
hpcg_oneapi
iozone
linpack_intel
matlab
mpi4py
mvapich2_aocc
mvapich2_gcc
mvapich2_intel
netcdf_c
netcdf_fortran
nvhpc
octave
oneapi
oneapi_mpi
openblas
openmp_aocc
openmp_gcc
openmpi_aocc
openmpi_gcc
openmpi_intel
openmp_intel
openmp_oneapi
osu_allreduce
osu_alltoall
osu_bcast
osu_bibw
osu_bw
osu_latency
osu_scatter
parallel_netcdf
python
quantum_espresso
r
R_25
slurm_1core_4nodes
slurm_cpusets
slurm_exclusive
slurm_memhog
slurm_memlimit
stream
tensorflow
totalview
```

Every tests contains at least three files.
- `test.module`: Defines which modules are loaded
- `test.sub`: This is the bulk of the script where you tell how to run the application
- `test.out`: The expected output for the test
- `test.err`: Expected error file. Some applications print info in `stderr`
- (optional) `test.pre`: Some tests also include a pre-submission script, e.g. the `intel` test has a `test.pre` script where the binary is compiled. This happens *before* the job is submitted.

### Updating tests or developing new tests
To update testapp (matlab in the below example), the first step is to copy our matlab testapp to `$HOME/.testapps`. 
```
$ mkdir $HOME/.testapps && cp -r /cluster/tufts/hpc/tools/testsuite/0.0.1/testapps/matlab $HOME/.testapps
```
In most cases, we can need to edit `test.module`, `test.out` and `test.err`. 

To test the updated test app in `$HOME/.testapps`, use `-p`.
```
$ testapp -k -p matlab  # -k means keep output files
                        # -p means use personal test definitions.
```

If the modified test runs without error and you want the change deployed for everyone, then you can upload it to this github repo, and create a PR.

## tessuite
testsuite will automically many jobs to the cluster and periodically print the `PASS/FAIL` results as each test is run.
```
$ testsuite -h
Usage:  testsuite [options] [test profiles] [-o SLURM options]
Options:
         -l          list available tests
         -n          output any nodes which fail tests
         -k          keep testsuite/testapp output after tests have finished
                     (useful for seeing why they failed if working a problem)
         -t <path>   use <path> for temporary output directories (such as -k)
         -v          verbose output (default)
         -q          quiet (no verbose output)
         -r          force all tests to be run on random nodes
         -R          force all test to NOT run on random nodes
         -o          options to pass directly to SLURM (not testapp)
                      (this option must come last, after the profile names)
```

## Available profiles

All profiles are stored in `/cluster/tufts/hpc/tools/testsuite/0.0.1/profiles/`.
```
$ testsuite -l
testsuite: Warning! $CLUSTER_SCRATCH is undefined.
Will be creating temporary space in your home directory.
/cluster/home/yzhang85/testsuite_tmp/testsuite_login-prod-02.pax.tufts.edu_2482418
all_benchmarks_concurrent
apps
benchmarks
compilers
default
osu_benchmarks
parallel
slurm
```

Below is an example of `default` profile:
```
#
# SLURM Tests
#
C slurm_exclusive 4 5
C slurm_cpusets 9 10
C slurm_memlimit 9 10
C slurm_memhog 9 10
S slurm_1core_4nodes 9 10
#
# Compiler Tests
#
C gcc 9 10
C oneapi 9 10
#
# Parallel Library Tests
#
C openmpi_gcc 9 10
C openmpi_intel 9 10
# C mvapich2_aocc 9 10
C mvapich2_gcc 9 10
C mvapich2_intel 9 10
C oneapi_mpi 9 10
C openmp_gcc 9 10
C openmp_intel 9 10
C openmp_oneapi 9 10
#
# Specific Application Tests
#
C anaconda 9 10
C blast_short 9 10
C boost 9 10
C gromacs 9 10
C matlab 9 10
C netcdf_c 9 10
C netcdf_fortran 9 10
C r 9 10
C parallel_netcdf 9 10
C tensorflow 9 10
```

### Basic testsuite run
The simplest way to launch testsuite is to run it with no arguments. 
```
$ testsuite
testsuite: Warning! $CLUSTER_SCRATCH is undefined.
Will be creating temporary space in your home directory.
/cluster/home/yzhang85/testsuite_tmp/testsuite_login-prod-02.pax.tufts.edu_2482681
No profiles named.  Running the 'default' profile.
Created working directory '/cluster/home/yzhang85/testsuite_tmp/testsuite_login-prod-02.pax.tufts.edu_2482681'.
Launching tests....
Launching test: slurm_1core_4nodes without SLURM options and without testapp options
Launching test: slurm_exclusive without SLURM options and without testapp options
Launching test: slurm_cpusets without SLURM options and without testapp options
Launching test: slurm_memlimit without SLURM options and without testapp options
Launching test: slurm_memhog without SLURM options and without testapp options
Launching test: gcc without SLURM options and without testapp options
Launching test: oneapi without SLURM options and without testapp options
Launching test: openmpi_gcc without SLURM options and without testapp options
Launching test: openmpi_intel without SLURM options and without testapp options
Launching test: mvapich2_gcc without SLURM options and without testapp options
Launching test: mvapich2_intel without SLURM options and without testapp options
Launching test: oneapi_mpi without SLURM options and without testapp options
Launching test: openmp_gcc without SLURM options and without testapp options
Launching test: openmp_intel without SLURM options and without testapp options
Launching test: openmp_oneapi without SLURM options and without testapp options
Launching test: anaconda without SLURM options and without testapp options
Launching test: blast_short without SLURM options and without testapp options
Launching test: boost without SLURM options and without testapp options
Launching test: gromacs without SLURM options and without testapp options
Launching test: matlab without SLURM options and without testapp options
srun: error: PMK_KVS_Barrier duplicate request from task 0
Launching test: netcdf_c without SLURM options and without testapp options
srun: error: PMK_KVS_Barrier duplicate request from task 0
srun: error: PMK_KVS_Barrier duplicate request from task 0
srun: error: PMK_KVS_Barrier duplicate request from task 0
srun: error: PMK_KVS_Barrier duplicate request from task 0
Launching test: netcdf_fortran without SLURM options and without testapp options
Launching test: r without SLURM options and without testapp options
Launching test: parallel_netcdf without SLURM options and without testapp options
Launching test: tensorflow without SLURM options and without testapp options

Status  Test                       Pass   Fail    Run  Total
PASS    slurm_1core_4nodes           10      0      0     10
PASS    slurm_exclusive               5      0      0      5
PASS    slurm_cpusets                10      0      0     10
FAIL    slurm_memlimit                1      9      0     10
FAIL    slurm_memhog                  0     10      0     10
PASS    gcc                          10      0      0     10
PASS    oneapi                       10      0      0     10
PASS    openmpi_gcc                  10      0      0     10
FAIL    openmpi_intel                 0     10      0     10
FAIL    mvapich2_gcc                  0      9      1     10
FAIL    mvapich2_intel                0     10      0     10
FAIL    oneapi_mpi                    0     10      0     10
PASS    openmp_gcc                   10      0      0     10
FAIL    openmp_intel                  0     10      0     10
FAIL    openmp_oneapi                 0     10      0     10
PASS    anaconda                     10      0      0     10
PASS    blast_short                   9      1      0     10
FAIL    boost                         0     10      0     10
FAIL    gromacs                       0      4      6     10
PASS    matlab                       10      0      0     10
FAIL    netcdf_c                      0     10      0     10
FAIL    netcdf_fortran                0     10      0     10
PASS    r                            10      0      0     10
FAIL    parallel_netcdf               0     10      0     10
PASS    tensorflow                   10      0      0     10
```

### Submit jobs with other options
By default, all tests will be submitted to `batch` partition, but we can use other partitions to submit jobs by specifying the `-o` option in testsuite. `-o` allows you to add any slurm (sbatch/srun) options at the
end of the testsuite command. The following command submits `testsuite` jobs in the `preempt` partition.
```
$ testsuite -o -p preempt 
```


## Acknowledgement
`testsuite` and `testapp` are modified from `testsuite` and `testpbs` developed by Rose Center for Advanced Computing ([RCAC](https://www.rcac.purdue.edu/)) at Purdue University. Many thanks to RCAC for developing such useful tools and sharing with us.
