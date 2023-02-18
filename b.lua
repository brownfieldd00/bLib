-- Made for mochi. The Lua B Library.
local b, m = {}, {}
m.__newindex = rawset
m.__index = rawget
b = setmetatable(b, m)

-- Most used functions
function b.resolveLua(self, str)
    return loadstring(('return %s'):format())()
end
function b.resolve(self, str)
    local s = ('').split
    local path = s(str, '.')
    local obj;
    if path[1] == 'game' or path[1] == 'Game' then
        obj = game
    elseif path[1] == 'Workspace' or path[1] == 'workspace' then
        obj = workspace
    end
    table.remove(path, 1)
    for i, v in next, path do
        obj = obj[v]
    end
    return obj
end
b.cache = game.GetDescendants(game)
function b.Get(self, class, name, parent)
    for i, v in next, shared.instances[class] do
        if parent then
            if v.Parent == parent and v.Name == name then
                return v
            end
        else
            if v.Name == name then
                return v
            end
        end
    end
    return nil
end
function b.GetRemoteEvent(self, event_name, parent)
    return self:Get('RemoteEvent', event_name, parent)
end
function b.GetRemoteFunction(self, function_name, parent)
    return self:Get('RemoteFunction', function_name, parent)
end

local hex, unhex = function(input)
	local out = table.create(#input, '')
	for i = 1, #input do
		local c = input:sub(i,i)
		out[#out+1] = string.format('%x', c:byte())
	end
	return table.concat(out, '')
end, function(hex)
	if #hex % 2 ~= 0 then return 0 end
	local data = ''
	for i = 1, #hex, 2 do
		data = data .. string.char(tonumber(('0x%s'):format(hex:sub(i, i+1))))
	end
	return data
end
b.hex = hex
b.unhex = unhex
local function clone(t)
	local function dive(tb)
		local out = {}
		for i, v in next, tb do
			if typeof(v) == 'table' then
				out[i] = dive(v)
			else
				out[i] = v
			end
		end
		return out
	end
	return dive(t)
end
b.clonetable = clone

-- Deep scan
b.instances = {}
local deep_scan = (function()
    shared.instances = {}
    game.DescendantAdded:Connect(function(desc)
        if not rawget(shared.instances, desc.ClassName) then
            shared.instances[desc.ClassName] = {}
        end
        local Class = shared.instances[desc.ClassName]
        Class[#Class + 1] = desc
    end)
    for i, v in next, game:GetDescendants() do
        if not rawget(shared.instances, v.ClassName) then
            shared.instances[v.ClassName] = {}
        end
        local Class = shared.instances[v.ClassName]
        Class[#Class + 1] = v
    end
    return true
end)()

return b