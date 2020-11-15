module RegistratorServerless

import GitHub
import LocalRegistry
import Pkg
import Registrator
import RegistryTools

include("types.jl")

include("assert.jl")
include("branch-name.jl")
include("config.jl")
include("credentials.jl")
include("github.jl")
include("local-registry.jl")
include("parse-trigger-issue.jl")
include("project.jl")
include("pull-requests.jl")
include("register.jl")
include("user.jl")
include("utils.jl")

end # module RegistratorServerless
