module CGI
export method, sendText, sendHtml, sendJson, isQuery, parseQuery, getParam, getCheck, getCookie, setCookie

# 簡易ログ
function info(message)
  io = open("./log.txt", "w+")
  writeline(io, message)
  close(io)
end

# HTTP メソッドを返す。
function method()
  return ENV["REQUEST_METHOD"]
end

# クエリーパラメータがあるか？
function isQuery()
  return ENV["QUERY_STRING"] != ""
end

# 文字列を応答として返す。
function sendText(text, mime="text/plain", status="200 OK", cookie="")
  buff = "Status: $status\n"
  buff *= "Content-Type: "
  buff *= mime
  if cookie != ""
    buff *= cookie * "\n"
  end
  buff *= "\n\n"
  buff *= text
  print(buff)
end


# HTML ファイルを応答として返す。
function sendHtml(filepath, embed=nothing)
  io = open(filepath, "r")
  s = read(io, String)
  close(io)
  if embed != nothing
    for (key, value) in pairs(embed)
      s = replace(s, "{{$key}}" => value)
    end
  end
  sendText(s, "text/html")
end


# データを JSON で応答として返す。
function sendJson(data)
  s = "{"
  for (key, value) in pairs(data)
    s *= "\"$key\":\"$value\","
  end
  s = rstrip(s, ',')
  s *= "}"
  sendText(s, "application/json")
end

# 外部から来たデータを解析してハッシュを返す。
function parseQuery()
  data = ""
  if method() == "POST"
    data = readline(stdin)
  else
    data = ENV["QUERY_STRING"]
  end
  info(data)
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
  cookie = ENV["HTTP_COOKIE"]
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
