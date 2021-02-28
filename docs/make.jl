using Documenter, StanQuap

makedocs(
    modules = [StanQuap],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Rob J Goedman",
    sitename = "StanQuap.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/goedman/StanQuap.jl.git",
    push_preview = true
)
