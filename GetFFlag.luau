-- GetFFlag.lua
local Prefixes = {
    "DFString", "FString",
    "DFFloat",  "FFloat",
    "DFTime",   "FTime",
    "DFTest",   "FTest",
    "DFLog::",  "FLog::",
    "DFLog",    "FLog",
    "DFInt",    "FInt",
    "DFFlag",   "FFlag",
}

local function StripPrefix(Flag)
    for _, Prefix in ipairs(Prefixes) do
        if Flag:sub(1, #Prefix) == Prefix then
            return Flag:sub(#Prefix + 1)
        end
    end
    return Flag
end

return function(Flag)
    if type(Flag) ~= "string" or #Flag == 0 then
        return nil, "flag must be non-empty string"
    end

    local Bare = Bloxstrap.TouchEnabled and StripPrefix(Flag) or Flag
    local ok, Value = pcall(getfflag, Bare)
    
    if ok and Value ~= nil then
        return tostring(Value)
    end
    
    return nil, "FFlag not found: " .. Bare
end