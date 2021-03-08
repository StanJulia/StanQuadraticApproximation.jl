# StanQuap.jl

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://github.com/stanjulia/StanQuap.jl/workflows/CI/badge.svg?branch=master)](https://github.com/stanjulia/StanQuap.jl)

<!--
[![Documentation](https://img.shields.io/badge/docs-stable-blue.svg)](https://StanJulia.github.io/StanQuap.jl/stable)
[![Documentation](https://img.shields.io/badge/docs-master-blue.svg)](https://StanJulia.github.io/StanQuap.jl/dev)
-->

## Purpose of package

This package is created to simplify the usage of quadratic approximations in [StatisticalRethinking.jl](https://github.com/StatisticalRethinkingJulia).

As such, it is intended for initial learning purposes.

Many better (and certainly more efficient!) ways of obtaining a quadratic approximation to the posterior distribution are available in Julia (and demonstrated in the project StatisticalRethinkingStan.jl) but none used a vanilla Stan Language program as used in Statistical Rethinking.

## Installation

Once this package is registered, install with

```julia
pkg> add StanQuap.jl
```

You need a working [Stan's cmdstan](https://mc-stan.org/users/interfaces/cmdstan.html) installation, the path of which you should specify in `JULIA_CMDSTAN_HOME`, eg in your `~/.julia/config/startup.jl` have a line like
```julia
# CmdStan setup
ENV["JULIA_CMDSTAN_HOME"] = expanduser("~/src/cmdstan-2.19.1/") # replace with your path
```

It is recommended that you start your Julia process with multiple worker processes to take advantage of parallel sampling, eg

```sh
julia -p auto
```
