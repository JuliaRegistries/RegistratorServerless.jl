@inline function LocalRegistry.find_package_path(package::ClonedPackage)
    return package.path
end

@inline function LocalRegistry.find_registry_path(registry::ClonedRegistry)
    return registry.path
end
