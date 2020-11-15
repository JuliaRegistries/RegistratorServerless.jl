@inline function parse_trigger_issue_title(issue_title::AbstractString)
    _issue_title = strip(issue_title)
    data = Dict{Symbol, String}()
    words = strip.(split(_issue_title))
    if length(words) < 2
        throw(IssueTitleError("Could not parse issue title", _issue_title))
    end
    if lowercase(words[1]) != "register"
        throw(IssueTitleError("Could not parse issue title", _issue_title))
    end
    data[:repo] = words[2]
    accepted_parameters = ["branch", "subdir"]
    parameter_regex = r"^([\w]*?)=([\w\-\/\_]*?)$"
    for word in words[3:end]
        m = match(parameter_regex, word)
        if m === nothing
            throw(IssueTitleError("Could not parse issue title", _issue_title))
        else
            param_name = m[1]
            param_value = m[2]
            if param_name in accepted_parameters
                data[Symbol(param_name)] = param_value
            else
                throw(IssueTitleError("The \"\" parameter is not allowed", _issue_title))
            end
        end
    end
    return data
end

@inline function parse_trigger_issue_title!(kwargs_dict::Dict, issue_title::AbstractString)
    for (k, v) in pairs(parse_trigger_issue_title(issue_title))
        if !haskey(kwargs_dict, k)
            kwargs_dict[k] = v
        end
    end
    return nothing
end

@inline function parse_trigger_issue_title!(kwargs_dict::Dict, issue_title::Nothing)
    return nothing
end
