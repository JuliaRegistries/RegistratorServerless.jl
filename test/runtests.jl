using RegistratorServerless
using Test

@testset "RegistratorServerless.jl" begin
    @testset "parse-trigger-issue.jl" begin
        @test RegistratorServerless.parse_trigger_issue_title("register MyOrganization/MyPackage.jl") == Dict(:repo => "MyOrganization/MyPackage.jl")
        @test RegistratorServerless.parse_trigger_issue_title("register MyOrganization/MyPackage.jl branch=my/custom-branch_name") == Dict(:repo => "MyOrganization/MyPackage.jl", :branch => "my/custom-branch_name")
    end
end
