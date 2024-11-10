#!C:\Apps\Julia\bin\julia.exe
#!/home/makandat/bin/julia-1.9.3/bin/julia
#!/usr/bin/env julia

include("./CGI.jl")
using .CGI

embed = Dict{String, String}()
embed["message"] = ""
sendHtml("./html/index.html", embed)
