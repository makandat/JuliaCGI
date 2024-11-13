#!c:/Julia/bin/julia.exe

include("./CGI.jl")
using .CGI
info("index.cgi")
embed = Dict{String, String}()
embed["message"] = ""
info("index.cgi: sendHtml")
sendHtml("./html/index.html", embed)
