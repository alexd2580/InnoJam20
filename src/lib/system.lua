local json = require("lib/JSON")
local system = {}

function system.queryUrl(url)
    res, err = system.execute("curl -s \"" .. url .. "\"")
    return json:decode(res)
end

function system.execute(cmd)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    return s
end

return system
