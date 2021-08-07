"""

Compute the quadratic approximation to the posterior distribution.

$(SIGNATURES)

### Required arguments
```julia
* `name::String`                : Name for SampleModel
* `model::String`               : Stan Language model
``` 

### Optional arguments
```julia
* `data`                        : Data for model (NamedTuple or Duct)
* `init`                        : Initial values for parameters (NamedTuple or Dict)
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

### Required arguments
```julia
* `name::String`                : Name for SampleModel
* `model::String`               : Stan Language model
``` 

### Optional arguments
```julia
* `data`                        : Data for model (NamedTuple or Duct)
* `init`                        : Initial values for parameters (NamedTuple or Dict)
``` 

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
    dct = OrderedDict(
        :coef => ntcoef,
        :vcov => v,
        :converged => converged,
        :distr => distr,
        :params => n
    )
    
    (;dct...)
end

export
    stan_quap
