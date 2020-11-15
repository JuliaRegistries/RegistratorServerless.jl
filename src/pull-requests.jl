# This file is taken from BinaryBuilder.jl (license: MIT)
# https://github.com/JuliaPackaging/BinaryBuilder.jl

function create_or_update_pull_request(repo::GitHub.Repo, params; auth)
    try
        new_pr = GitHub.create_pull_request(repo; auth, params)
        @info("Created a new pull request: $(repo.full_name)#$(new_pr.number)")
        return new_pr
    catch ex
        # If it was already created, search for it so we can update it:
        if Registrator.CommentBot.is_pr_exists_exception(ex)
            prs, _ = GitHub.pull_requests(repo; auth=auth, params=Dict(
                "state" => "open",
                "base" => params["base"],
                "head" => string(split(repo.full_name, "/")[1], ":", params["head"]),
            ))
            existing_pr = GitHub.update_pull_request(repo, first(prs).number; auth, params)
            @info("Updated an existing pull request: $(repo.full_name)#$(existing_pr.number)")
            return existing_pr
        else
            rethrow(ex)
        end
    end
end
