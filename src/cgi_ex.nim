import cgi, httpcore, strtabs, strutils
export httpcore.HttpMethod

proc getQueryParam*(): StringTableRef =
  return readData(getQueryString())

proc getRequestMethodAll*(): HttpMethod =
  let reqMethod = getRequestMethod()
  case reqMethod:
    of "GET": result = HttpGet
    of "POST": result = HttpPost
    of "HEAD": result = HttpHead
    of "PUT": result = HttpPut
    of "DELETE": result = HttpDelete
    of "PATCH": result = HttpPatch
    of "OPTIONS": result = HttpOptions
    of "CONNECT": result = HttpConnect
    of "TRACE": result = HttpTrace
    else: cgiError("'REQUEST_METHOD' is invalid")

proc getBody*(): string =
  let reqMethod = getRequestMethodAll()
  if reqMethod in {HttpPost, HttpPut, HttpDelete, HttpPatch}:
    let L = try: parseInt(getContentLength())
            except: 0
    if L == 0:
      return ""
    result = newString(L)
    if readBuffer(stdin, addr(result[0]), L) != L:
      cgiError("cannot read from stdin")
  else:
    return ""

