@inline function with_temp_dir(f)
    original_dir = pwd()
    temp_dir = mktempdir(; cleanup = true)
    cd(temp_dir)
    result = f(temp_dir)
    cd(original_dir)
    rm(temp_dir; force = true, recursive = true)
    return result
end

@inline function with_cloned_repo(f, url)
    result = with_temp_dir() do temp_dir
        cd(temp_dir)
        run(`git clone $(url) CLONED_REPO`)
        cd("CLONED_REPO")
        return f(pwd())
    end
    return result
end
