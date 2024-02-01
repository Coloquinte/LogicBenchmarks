# Benchmarks for logic optimization

This repository provides a single downloadable file with common benchmarks for logic optimization.
At the moment this includes ISCAS, MCNC and LGSynth benchmarks.
It can be downloaded from the [Github releases](https://github.com/Coloquinte/LogicBenchmarks/releases).

## Organization

All benchmarks are organized in two directories, depending on format: `bench` and `blif`.
All bench benchmarks have been converted to blif.
Each directory contains benchmark files, prefixed by their origin (iscas85, iscas89, iscas99, lgsynth91, mcnc, ...).

## Curation

The benchmarks were downloaded where I could find them on the web: [this page](https://pld.ttu.ee/~maksim/benchmarks/) for ISCAS benchmarks, [the official repository](https://github.com/lsils/benchmarks) for EPFL benchmarks and [this page](https://ddd.fit.cvut.cz/www/prj/Benchmarks/) for others.
Benchmarks are cleaned up so they can be read from Yosys: unsupported constructs are removed, such as external don't care (.exdc) and delay annotations.
