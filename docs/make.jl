using Documenter, StanQuadraticApproximation

makedocs(
    modules = [StanQuadraticApproximation],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Rob J Goedman",
    sitename = "StanQuadraticApproximation.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/goedman/StanQuadraticApproximation.jl.git",
    push_preview = true
)
