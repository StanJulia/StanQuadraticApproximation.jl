import StatsBase: stderror, sample

"""

QuapResult

$(FIELDS)

where:

coef                            : NamedTuple with parameter MAP estimates,
vcov                            : Covariance matric,
converged                       : Simple check that multiple chains converged,
distr                           : Distributike to sample from (Normal or MvNormal),
params                          : Vector of parameter symbols.

"""
struct QuapResult{
       N <: NamedTuple
} <: StatsBase.StatisticalModel
       coef :: N
       vcov :: Array{Float64, 2}
       converged :: Bool
       distr :: Union{Normal, MvNormal}
       params :: Array{Symbol, 1}
end


"""

Compute the quadratic approximation to the posterior distribution.

$(SIGNATURES)

### Required arguments
```julia
* `name::String`                : Name for SampleModel
* `model::String`               : Stan Language model
``` 

### Keyword arguments
```julia
* `data`                        : Data for model (NamedTuple or Duct)
* `init`                        : Initial values for parameters (NamedTuple or Dict)
``` 

### Reyrns
```julia
* `res::QuapResult`              : Returned object
```

In general using `init` results in better behavior.

"""
function stan_quap(
    name::AbstractString,
    model::AbstractString;
    kwargs...)


    om = OptimizeModel(name, model)
    rc = stan_optimize(om; kwargs...)

    if success(rc)
        tmp, cnames = read_optimize(om)
        optim = Dict()
        for key in keys(tmp)
            if !(key in ["lp__", :stan_version])
                optim[Symbol(key)] = tmp[key]
            end
        end
        sm = SampleModel(name, model; tmpdir=om.tmpdir)
        rc2 = stan_sample(sm; kwargs...)
    else
        return ((nothing, nothing, nothing))
    end

    if success(rc2)
        qm = quap(sm, optim, cnames)
        return((qm, sm, (optim=optim, cnames=cnames)))
    else
        return((nothing, sm, nothing))
    end
end

"""

Compute the quadratic approximation to the posterior distribution.

$(SIGNATURES)

Not exported
"""
function quap(
    sm_sam::SampleModel, 
    optim::Dict,
    cnames::Vector{String})

    samples = read_samples(sm_sam, :dataframe)
    
    n = Symbol.(names(samples))
    coefnames = tuple(n...,)
    c = [optim[Symbol(coefname)][1] for coefname in coefnames]
    cvals = reshape(c, 1, length(n))
    coefvalues = reshape(c, length(n))
    v = Statistics.covm(Array(samples[:, n]), cvals)

    distr = if length(coefnames) == 1
        Normal(coefvalues[1], √v[1])  # Normal expects stddev
    else
        MvNormal(coefvalues, v)       # MvNormal expects variance matrix
    end

    converged = true
    for coefname in coefnames
        o = optim[Symbol(coefname)]
        converged = abs(sum(o) - 4 * o[1]) < 0.001 * abs(o[1])
        !converged && break
    end

    ntcoef = namedtuple(coefnames, coefvalues)    
    return(QuapResult(ntcoef, v, converged, distr, n))
end

"""

Sample from a quadratic approximation to the posterior distribution.

$(SIGNATURES)

### Required arguments
```julia
* `qm`                          : QuapResult object (see: `?QuapResult`)
``` 

### Keyword arguments
```julia
* `nsamples = 4000`             : Number of smaples taken from distribution
``` 

"""
function sample(qm::QuapResult; nsamples=4000)
  df = DataFrame()
  p = Particles(nsamples, qm.distr)
  for (indx, coef) in enumerate(qm.params)
    if length(qm.params) == 1
      df[!, coef] = p.particles
    else
      df[!, coef] = p[indx].particles
    end
  end
  df
end

# TEMPORARILY:

# Used by Max. Need to check if this works in general
function sample(qr::QuapResult, count::Int)::DataFrame
    names = qr.params                 # StatsBase.coefnames(mode_result) in Turing
    means = values(qr.coef)           # StatsBase.coef(mode_result) in Turing
    sigmas = Diagonal(qr.vcov)        # StatsBase.stderr(mode_result) in Turing
    
    DataFrame([
        name => rand(Normal(μ, σ), count)
            for (name, μ, σ) ∈ zip(names, means, sigmas)
    ])
end

# Will be deprecated, use QuapResult object
function sample(qm::NamedTuple; nsamples=4000)
  df = DataFrame()
  p = Particles(nsamples, qm.distr)
  for (indx, coef) in enumerate(qm.params)
    if length(qm.params) == 1
      df[!, coef] = p.particles
    else
      df[!, coef] = p[indx].particles
    end
  end
  df
end



export
    QuapResult,
    stan_quap,
    sample
