# StanQuap.jl

| **Project Status**          |  **Build Status** |
|:---------------------------:|:-----------------:|
|![][project-status-img] | ![][CI-build] |

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://stanjulia.github.io/StanQuap.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://stanjulia.github.io/StanQuap.jl/stable

[CI-build]: https://github.com/stanjulia/StanQuap.jl/workflows/CI/badge.svg?branch=master

[issues-url]: https://github.com/stanjulia/StanQuap.jl/issues

[project-status-img]: https://img.shields.io/badge/lifecycle-wip-orange.svg

## Purpose of package

This package is created to simplify the usage of quadratic approximations in [StatisticalRethinking.jl](https://github.com/StatisticalRethinkingJulia).

As such, it is intended for initial learning purposes.

Many better (and certainly more efficient!) ways of obtaining a quadratic approximation to the posterior distribution are available in Julia (and demonstrated in the project StatisticalRethinkingStan.jl) but none used a vanilla Stan Language program as used in Statistical Rethinking.

## Installation

Once this package is registered, install with

```julia
pkg> add StanQuap.jl
```

You need a working [Stan's cmdstan](https://mc-stan.org/users/interfaces/cmdstan.html) installation, the path of which you should specify either in `CMDSTAN` or `JULIA_CMDSTAN_HOME`, eg in your `~/.julia/config/startup.jl` have a line like
```julia
# CmdStan setup
ENV["CMDSTAN"] = expanduser("~/src/cmdstan-2.28.2/") # replace with your path
```

It is recommended that you start your Julia process with multiple worker processes to take advantage of parallel sampling, eg

```sh
julia -p auto
```
