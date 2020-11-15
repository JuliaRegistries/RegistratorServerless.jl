using RegistratorServerless
using Documenter

makedocs(;
    modules=[RegistratorServerless],
    authors="JuliaRegistries contributors",
    repo="https://github.com/JuliaRegistries/RegistratorServerless.jl/blob/{commit}{path}#L{line}",
    sitename="RegistratorServerless.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaRegistries.github.io/RegistratorServerless.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaRegistries/RegistratorServerless.jl",
)
