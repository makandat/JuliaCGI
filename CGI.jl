# v1.0.2
module CGI
export method, sendText, sendHtml, sendJson, isQuery, parseQuery, getParam, getCheck, getCookie, setCookie, info # v1.0.1

# 簡易ログ v1.0.1
function info(message)
  io = open("./info.txt", "a")
  println(io, message)
  close(io)
end

# HTTP メソッドを返す。
function method()
  return ENV["REQUEST_METHOD"]
end

# クエリーパラメータがあるか？ v1.0.2
function isQuery()
  if haskey(ENV, "QUERY_STRING")
    n = length(ENV["QUERY_STRING"])
    return n > 0
  else
    return false
  end
end

# 文字列を応答として返す。
function sendText(text, mime="text/plain", status="200 OK", cookie="")
  buff = "Status: $status\n"
  buff *= "Content-Type: "
  buff *= mime
  buff *= "\n"
  if cookie != ""
    buff *= cookie
    buff *= "\n"
  end
  buff *= "\n"
  buff *= text
  print(buff)
end


# HTML ファイルを応答として返す。v1.0.2
function sendHtml(filepath, embed=nothing, status="200 OK", cookie="")
  io = open(filepath, "r")
  s = read(io, String)
  close(io)
  if embed != nothing
    for (key, value) in pairs(embed)
      s = replace(s, "{{$key}}" => value)
    end
  end
  sendText(s, "text/html", status, cookie)
end


# データを JSON で応答として返す。 v1.0.2
#   (注意) CGI ではユーザが異なるため JSON モジュールが使えない。
function sendJson(data)
  s = "{"
  for key in keys(data)
    value = data[key]
    s *= "\"$key\":\"$value\","
  end
  s = strip(s, [','])
  s *= "}"
  sendText(s, "application/json")
end

# 外部から来たデータを解析してハッシュを返す。
function parseQuery()
  data = ""
  if method() == "POST"
    #data = String(read(stdin::IO))
    data = readline()
  else
    data = ENV["QUERY_STRING"]
  end
  hash = Dict()
  parts = split(data, "&")
  for part in parts
    kv = split(part, "=")
    key = kv[1]
    value = kv[2]
    hash[key] = value
  end
  return hash
end

# パラメータを取得する。
function getParam(hash, name, default="")
  if haskey(hash, name)
   return hash[name]
  else
    return default
  end
end

# パラメータを取得する。(チェックボックス)
function getCheck(hash, name)
  return haskey(hash, name)
end

# リクエストクッキーを取得する。
function getCookie(name, default="")
  if haskey(ENV, "HTTP_COOKIE")
    cookie = ENV["HTTP_COOKIE"]
  else
    return default
  end
  parts = split(cookie, "; ")
  for e in parts
    kv = split(e, "=")
    if kv[1] == name
      return kv[2]
    end
  end
  return default
end

# レスポンスクッキーを設定する。
function setCookie(name, value, cookies = "")
  if cookies == ""
    cookies = "Set-Cookie: $name=$value\n"
  else
    cookies *= "Set-Cookie: $name=$value\n"
  end
  return cookies
end

end # module
