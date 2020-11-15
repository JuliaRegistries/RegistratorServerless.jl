@inline function user_is_authorized_to_register(username, repo; auth)
    gh_user = GitHub.owner(username; auth)
    gh_repo = GitHub.repo(repo; auth)
    return user_is_authorized_to_register(gh_user, gh_repo; auth)
end

@inline function user_is_authorized_to_register(gh_user::GitHub.Owner, gh_repo::GitHub.Repo; auth)
    repo_owner = gh_repo.owner
    if repo_owner.login == gh_user.login
        return true
    end
    if repo_owner.typ == "Organization"
        if GitHub.check_membership(repo_owner, gh_user; auth)
            return true
        end
    end
    return false
end

@inline function _get_pr_title_and_body(commit_message::AbstractString)
    lines = split(strip(commit_message), '\n')
    first_line = lines[1]
    remaining_lines = lines[2:end]
    pr_title = strip(first_line)
    pr_body = strip(join(remaining_lines, "\n"))
    return pr_title, pr_body
end

"""
    register(; user, issue_title, kwargs...)

Register a new package or a new version of an existing package.
"""
@inline function register(; issue_title = nothing, kwargs...)
    kwargs_dict = Dict(kwargs)
    user = User!(kwargs_dict)
    config = Config!(kwargs_dict)
    parse_trigger_issue_title!(kwargs_dict, issue_title)
    new_kwargs = NamedTuple(kwargs_dict)
    registration_request = RegistrationRequest(; new_kwargs...)
    return register(config, user, registration_request)
end

@inline function register(config::Config, user::User, registration_request::RegistrationRequest)
    auth = GitHub.authenticate(config)
    if user_is_authorized_to_register(user.username, registration_request.repo; auth)
        whoami = GitHub.whoami(; auth)
        @info("Authenticated to GitHub as $(whoami.login)")
        @info("User is authorized to register", user, registration_request.repo)
        package_url_unauthenticated = "https://$(config.gh_hostname_for_clone)/$(registration_request.repo).git"
        registry_url_authenticated = "https://$(whoami.login):$(config.github_token[])@$(config.gh_hostname_for_clone)/$(config.registry).git"
        with_cloned_repo(package_url_unauthenticated) do cloned_package_path
            with_cloned_repo(registry_url_authenticated) do cloned_registry_path
                cd(cloned_package_path)
                if !isempty(strip(registration_request.branch))
                    run(`git checkout $(strip(registration_request.branch))`)
                end
                run(`git config user.name "JuliaRegistrator"`)
                run(`git config user.email "contact@julialang.org"`)
                cd(cloned_registry_path)
                run(`git checkout master`)
                pr_branch_name = get_pr_branch_name(cloned_package_path)
                run(`git checkout -B $(pr_branch_name)`)
                run(`git config user.name "Registrator"`)
                run(`git config user.email "ci@juliacomputing.com"`)

                cloned_registry = ClonedRegistry(cloned_registry_path)
                cloned_package = ClonedPackage(cloned_package_path)
                @info "" cloned_registry.path cloned_package.path
                cd(cloned_registry_path)
                foo = LocalRegistry.register(
                    cloned_package,
                    cloned_registry;
                    commit = true,
                    push = false,
                    repo = package_url_unauthenticated,
                )
                cd(cloned_registry_path)
                commit_message = read(`git log -1 --pretty=%B`, String)
                pr_title, pr_body = _get_pr_title_and_body(commit_message)
                pr_body *= "\nCreated by: @$(user.username)"
                registry_gh_repo = GitHub.repo(config.registry)
                pr_params = Dict()
                pr_params["head"] = pr_branch_name
                pr_params["base"] = "master"
                pr_params["body"] = pr_body
                pr_params["maintainer_can_modify"] = true
                pr_params["title"] = pr_title
                run(`git push -f -u origin $(pr_branch_name)`)
                pr = create_or_update_pull_request(registry_gh_repo, pr_params; auth)
            end
        end
    else
        msg = """
        The user is not authorized to make new releases of this package.

        In order to use the serverless Registrator, you need to either be the
        owner of the repository, or you need to be a member of the organization
        that owns the repository. (Please note: if you are a member of the organization,
        your membership must be public.)

        If you do not meet either of those criteria, you will need to use either
        the Registrator comment bot or the Registrator web interface.
        """
        throw(UserNotAuthorizedError(msg, user, registration_request.repo))
    end
    return nothing
end
