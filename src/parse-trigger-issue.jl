@inline function parse_trigger_issue!(kwargs_dict::Dict, issue_number::Integer)
    return nothing
end

@inline function parse_trigger_issue!(::Dict, ::Nothing)
    return nothing
end
