@inline function find_project_file(package_path)
    for project_file in Base.project_names
        project_file_path = joinpath(package_path, project_file)
        pkg = Pkg.Types.read_project(project_file_path)
        if pkg.name !== nothing
            return project_file_path
        end
    end
    throw(ErrorException("Could not find project file in package at \"$(package_path)\""))
end
