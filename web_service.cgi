#!c:/Julia/bin/julia.exe

include("./CGI.jl")
using .CGI

# GET method
function on_GET()
  data = Dict{String, String}()
  data["message"] = ""
  data["result"] = ""
  if isQuery()
    params = parseQuery()
    r = parse(Float32, params["r"])
    y = pi * r * r
    data["result"] = string(y)
    data["message"] = "OK: "
    sendJson(data)
  else
    sendHtml("./html/web_service.html")
  end
end


# Start ...
on_GET()
