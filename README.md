# `testsuite` for Tufts HPC
Testsuite is a collection of tests that are used to validate a cluster before and after a maintenance. It produces a simple `PASS/FAIL` output for each test which 
is easier to interpret. Ideally all the tests in testsuite should `PASS` but sometimes tests may `FAIL` due to license issues or other changes. At a minimum, the
`testsuite` results after a maintenance should be no worse than the one before.

## Programs

These can all be found in the `bin` directory.

- [testapp](#testapp): Tests the default version of a module
- [testapp_forall](#testapp_forall): Tests all versions of a module
- [testsuite](#testsuite): Tests the default version of each module in a profile
- [testsuite_forall](#testsuite_forall): Tests all versions of each module in a profile

## `testapp`

This program runs a test of the default version of a single module.

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

By default, `./testapp` will search for available tests stored in the relative path `testsuite-main/testapps/`.
```
$ ./testapp -l
ImageMagick
NCAR
R
R_25
SAS
anaconda
ansys
bcftools
bedtools
binutils
blast
blast_short
boost
bowtie
bowtie2
bwa
cdo
cellprofiler
chimera
cmake
condaenv
curl
cutadapt
dos2unix
fastp
fastqc
fasttree
ffmpeg
fftw
fontconfig
freetype
fribidi
gcc
geneious
glib
gnu-parallel
gnuplot
graphviz
gsl
gurobi
harfbuzz
idl
imagemagick
jags
java
julia
libgcrypt
libgpg-error
libtiff
mafft
mathematica
matlab
mesa
miniconda
miniforge
multiqc
octave
openblas
openmpi
orca
orthofinder
pandoc
parallel
perl
proj
python
pytorchgpu
qiime2
r-bioinformatics
r-scrnaseq
r-shinyngs
rclone
root
rsync
singularity
sqlite
stata
sumo
swig
texlive
trim-galore
velvet
xerces
zip
```

Every tests contains at least three files.
- `test.module`: Defines which modules are loaded
- `test.sub`: This is the bulk of the script where you tell how to run the application
- `test.out`: The expected output for the test
- `test.err`: Expected error file. Some applications print info in `stderr`
- (optional) `test.pre`: Some tests also include a pre-submission script, e.g. the `intel` test has a `test.pre` script where the binary is compiled. This happens *before* the job is submitted.

There may be additional files such as input files or includes.

### Updating tests or developing new tests

To update testapp (`matlab` in the below example), the first step is to navigate to the `testapps` folder and locate the module directory. 
```
$ cd testsuite-main/testapps/matlab
```
In most cases, we can need to edit `test.module`, `test.out` and `test.err`. If the modified test runs without error and you want the
change deployed for everyone, then you can upload it to this github repo, and create a pull request.

## `testapp_forall`

This program runs a test of all versions of a single module.

It runs `testapp <module_name>` for each available version obtained with `module av <module_name>`.
The test executes for all versions regardless of whether it fails for some of them. The output to the terminal
is saved as two separate `.log` files in the test folder: one for stdout and one for stderr. Each `.log` file
is named using a timestamp of when the `testapp_forall` program began to execute.

### Syntax
```
Usage:  testapp_forall [module_name] [redhat_version]
```

This is available for each package that has a test written. Red Hat versions this has been tested on are 7 and 8.

## `testsuite`

This program will automatically send many jobs to the cluster and periodically print the `PASS/FAIL` results as each test is run.
The default version of each module will be used.

```
$ testsuite -h
Usage:  testsuite [options] [test profiles] [-o SLURM options]
Options:
         -l          list available tests
         -n          output any nodes which fail tests
         -k          keep testsuite/testapp output after tests have finished
                     (useful for seeing why they failed if working a problem)
         -v          verbose output (default)
         -q          quiet (no verbose output)
         -r          force all tests to be run on random nodes
         -R          force all test to NOT run on random nodes
         -o          options to pass directly to SLURM (not testapp)
                      (this option must come last, after the profile names)
```

### Available profiles

All profiles are stored in `testsuite-main/profiles/`.
```
$ ./testsuite -l
testsuite: Warning! $CLUSTER_SCRATCH is undefined.
Will be creating temporary space in your home directory.
/cluster/tufts/hpc/swtests/testsuite_tmp
/cluster/tufts/hpc/swtests/testsuite_tmp/testsuite_login-prod-03.pax.tufts.edu_19017
all
bio
data_sci
default
dev
file
hpc
lang
sci
viz
```

Below is an example of `default` profile, which covers the most popular cluster modules.
```
#
# Languages and Envs
#
C java 9 10
C python 9 10
#
# Data Sci and Stats
#
# C r-bioinformatics 9 10
# C r-scrnaseq 9 10
#
# Science
#
C fftw 9 10
#
# HPC and Parallel
#
C singularity 9 10
#
# Viz
#
C fontconfig 9 10
C freetype 9 10
C fribidi 9 10
C graphviz 9 10
C harfbuzz 9 10
C texlive 9 10
#
# Compilers and Dev Tools
#
C gcc 9 10
#
# File and Env Management
#
C anaconda 9 10
C curl 9 10
C proj 9 10
C rclone 9 10
C sqlite 9 10
```

### Basic `testsuite` run

The simplest way to launch `testsuite` is to run it with no arguments.
```
$ ./testsuite
testsuite: Warning! $CLUSTER_SCRATCH is undefined.
Will be creating temporary space in your home directory.
/cluster/tufts/hpc/swtests/testsuite_tmp
/cluster/tufts/hpc/swtests/testsuite_tmp/testsuite_login-prod-03.pax.tufts.edu_113404
No profiles named.  Running the 'default' profile.
Created working directory '/cluster/tufts/hpc/swtests/testsuite_tmp/testsuite_login-prod-03.pax.tufts.edu_113404'.
Launching tests....
Launching test: java without SLURM options and without testapp options
Launching test: python without SLURM options and without testapp options
Launching test: fftw without SLURM options and without testapp options
Launching test: singularity without SLURM options and without testapp options
Launching test: fontconfig without SLURM options and without testapp options
Launching test: freetype without SLURM options and without testapp options
Launching test: fribidi without SLURM options and without testapp options
Launching test: graphviz without SLURM options and without testapp options
Launching test: harfbuzz without SLURM options and without testapp options
Launching test: texlive without SLURM options and without testapp options
Launching test: gcc without SLURM options and without testapp options
Launching test: anaconda without SLURM options and without testapp options
Launching test: curl without SLURM options and without testapp options
Launching test: proj without SLURM options and without testapp options
Launching test: rclone without SLURM options and without testapp options
Launching test: sqlite without SLURM options and without testapp options

Status  Test                       Pass   Fail    Run  Total
PASS    java                         10      0      0     10
PASS    python                       10      0      0     10
PASS    fftw                         10      0      0     10
PASS    singularity                  10      0      0     10
PASS    fontconfig                   10      0      0     10
PASS    freetype                     10      0      0     10
PASS    fribidi                      10      0      0     10
PASS    graphviz                     10      0      0     10
PASS    harfbuzz                     10      0      0     10
PASS    texlive                      10      0      0     10
PASS    gcc                          10      0      0     10
PASS    anaconda                     10      0      0     10
PASS    curl                         10      0      0     10
PASS    proj                         10      0      0     10
PASS    rclone                       10      0      0     10
PASS    sqlite                       10      0      0     10

Status  Test                       Pass   Fail    Run  Total
PASS    java                         10      0      0     10
PASS    python                       10      0      0     10
PASS    fftw                         10      0      0     10
PASS    singularity                  10      0      0     10
PASS    fontconfig                   10      0      0     10
PASS    freetype                     10      0      0     10
PASS    fribidi                      10      0      0     10
PASS    graphviz                     10      0      0     10
PASS    harfbuzz                     10      0      0     10
PASS    texlive                      10      0      0     10
PASS    gcc                          10      0      0     10
PASS    anaconda                     10      0      0     10
PASS    curl                         10      0      0     10
PASS    proj                         10      0      0     10
PASS    rclone                       10      0      0     10
PASS    sqlite                       10      0      0     10
```

### Submit jobs with other options

By default, all tests will be submitted to `batch` partition, but we can use other partitions to submit jobs
by specifying the `-o` option in testsuite. `-o` allows you to add any slurm (sbatch/srun) options at the
end of the testsuite command. The following command submits `testsuite` jobs in the `preempt` partition.
```
$ ./testsuite -o -p preempt 
```

## `testsuite_forall`

This program runs a test of all versions of each module in a given profile.
`options` and `-o SLURM options` are currently unavailable for `testsuite_forall`.

Given that some modules on the HPC cluster have many versions, it may not be advisable
to run the below with the `all` profile.
```
Usage:  testsuite_forall [profile] [redhat_version]
```

This is available for each package that has a test written. Red Hat versions this has been tested on are 7 and 8.

## Acknowledgement
`testsuite` and `testapp` are modified from `testsuite` and `testpbs` developed by Rose Center for Advanced Computing ([RCAC](https://www.rcac.purdue.edu/)) at Purdue University. Many thanks to RCAC for developing such useful tools and sharing with us.
