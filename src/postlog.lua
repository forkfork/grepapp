function postlog(redis, host, data)
  redis:xadd("logs", "*", host, data)
  ngx.log(ngx.ERR, data)
end

return postlog
