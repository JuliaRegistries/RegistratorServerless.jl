@inline function get_pr_branch_name(package_path)
    project_file_path = find_project_file(package_path)
    pkg = Pkg.Types.read_project(project_file_path)
    return RegistryTools.registration_branch(pkg)
end
