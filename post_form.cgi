#!c:/Julia/bin/julia.exe

include("./CGI.jl")
using .CGI

# GET method
function on_GET()
  embed = Dict{String, String}()
  embed["message"] = ""
  sendHtml("./html/post_form.html", embed)
end

# POST method
function on_POST()
  params = parseQuery()
  text1 = getParam(params, "text1")
  check1 = getCheck(params, "check1")
  select1 = getParam(params, "select1")
  embed = Dict{String, String}()
  embed["message"] = "text1:'$text1', check1:$check1, select1:'$select1'"
  info(embed["message"])
  sendHtml("./html/post_form.html", embed)  
end

# Main
function main()
  if method() == "GET"
    on_GET()
  else
    on_POST()
  end
end

# Start ...
main()
