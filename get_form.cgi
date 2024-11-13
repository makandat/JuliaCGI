#!c:/Julia/bin/julia.exe
#!/home/makandat/bin/julia-1.9.3/bin/julia

include("./CGI.jl")
using .CGI

# GET method
function on_GET()
  if isQuery()
    params = parseQuery()
    text1 = getParam(params, "text1")
    check1 = getCheck(params, "check1")
    select1 = getParam(params, "select1")
    embed = Dict{String, String}()
    embed["message"] = "text1:'$text1', check1:$check1, select1:'$select1'"
    sendHtml("./html/get_form.html", embed)  
  else
    embed = Dict{String, String}()
    embed["message"] = ""
    sendHtml("./html/get_form.html", embed)
  end
end

# Main
function main()
  #ENV["REQUEST_METHOD"] = "GET"
  #ENV["QUERY_STRING"] = "text1=TEXT&select1=SELECT"
  if method() == "GET"
    on_GET()
  end
end

# Start ...
main()
