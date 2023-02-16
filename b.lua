-- Made for mochi. The Lua B Library.
local b, m = {}, {}
m.__newindex = rawset
m.__index = rawget
b = setmetatable(b, m)
return b