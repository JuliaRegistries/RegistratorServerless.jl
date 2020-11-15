# RegistratorServerless

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaRegistries.github.io/RegistratorServerless.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaRegistries.github.io/RegistratorServerless.jl/dev)
[![Build Status](https://github.com/JuliaRegistries/RegistratorServerless.jl/workflows/CI/badge.svg)](https://github.com/JuliaRegistries/RegistratorServerless.jl/actions)

## Usage

Open a new issue on your registry where the title of the issue is something like this:
- `register MyUsername/MyPackage.jl`
- `register MyUsername/MyPackage.jl branch=some-branch-name`
- `register SomeOrganization/MyPackage.jl`
- `register SomeOrganization/MyPackage.jl branch=some-branch-name`

Please note: in order to register, you must be either:
1. The owner of the repository
2. A member of the organization that owns the repository

If you are a member of the organization, please make sure that your membership is public. For more details, please see [these instructions for publicizing your organization membership](https://docs.github.com/en/free-pro-team@latest/github/setting-up-and-managing-your-github-user-account/publicizing-or-hiding-organization-membership).

## Installing 

In your registry, create a new file named `.github/workflows/registrator_issues.yml` with the following contents:
```yml
name: registrator_issues
on:
  issues:
    types: [opened, reopened]
jobs:
  registrator_issues:
    runs-on: ubuntu-latest
    steps:
      - uses: julia-actions/setup-julia@4469f5b9da960ff174efa528fea5889f8e873609 # v1.2.2
        with:
          version: 'nightly'
      - run: julia -e 'using Pkg; Pkg.add(Pkg.PackageSpec(url = "https://github.com/JuliaRegistries/RegistratorServerless.jl.git", rev = "master"))'
      - run: julia -e 'using RegistratorServerless; user = "${{ github.actor }}"; issue_title = "${{ github.event.issue.title }}"; @info("", issue_title, user); RegistratorServerless.register(; user=user, issue_title=issue_title)'
        env:
          REGISTRATOR_GITHUB_TOKEN: ${{ secrets.DILUMALUTHGEBOT_TOKEN }}
          REGISTRATOR_REGISTRY: 'JuliaRegistries/General'
          REGISTRATOR_SERVERLESS_REPO: 'JuliaRegistries/General'
```
