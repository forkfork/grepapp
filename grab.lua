local hiredis = require "hiredis"
local JSON = require("JSON")
local inspect = require("inspect")



local conn = hiredis.connect("127.0.0.1", 6379)
local rep, err, err_code = conn:command("xread", "count", "100", "streams", "logs", "0-0")
local fps = {}
-- one stream - [1]
-- skip the stream name [1][2]
-- stream has multiple data items [1][2][i]
-- get the stream id [1][2][i][1].name
-- get the data key [1][2][i][2][1]
-- get the data val [1][2][i][2][2]
for i = 1, #rep[1][2] do
  local id = rep[1][2][i][1].name
  local host = rep[1][2][i][2][1]
  if not fps[host] then
    fps[host] = io.open(host .. ".log", "a")
  end
  fps[host]:write(rep[1][2][i][2][2])
end
--print(rep[1][2][1][2][2])

