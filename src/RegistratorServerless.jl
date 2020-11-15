module RegistratorServerless

import GitHub
import LocalRegistry
import Registrator

include("types.jl")

include("assert.jl")
include("branch-name.jl")
include("config.jl")
include("credentials.jl")
include("github.jl")
include("local-registry.jl")
include("parse-trigger-issue.jl")
include("pull-requests.jl")
include("register.jl")
include("utils.jl")

end # module RegistratorServerless
