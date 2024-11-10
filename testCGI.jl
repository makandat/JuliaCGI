#!/usr/bin/env julia
include("./CGI.jl")
using .CGI

ENV["REQUEST_METHOD"] = "GET"
println(CGI.method())

sendText("Hello World!\n")
embed = Dict("data"=>"DATA", "message"=>"OK")
sendHtml("./html/index.html", embed)
sendJson(embed)
ENV["QUERY_STRING"] = "x=0&y=12"
hash = parseQuery()
println(hash)

a = getParam(hash, "x")
println(a)

ENV["HTTP_COOKIE"] = "a=A; b=B"
a = getCookie("a")
println(a)
a = setCookie("x", "X")
println(a)
