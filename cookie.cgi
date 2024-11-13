#!c:/Julia/bin/julia.exe

include("./CGI.jl")
using .CGI

# GET method
function on_GET()
  count = getCookie("count")
  if count == ""
    count = 1
  else
    count = parse(Int, count) + 1
  end
  cookies = setCookie("count", string(count))
  data = Dict{String, String}()
  data["count"] = string(count)
  sendHtml("./html/cookie.html", data, "200 OK", cookies)
end


# Start ...
on_GET()
