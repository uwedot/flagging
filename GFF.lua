-- getflags.lua
-- Returns value and error message

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
        local Message = "flag must be a non-empty string, got " .. type(Flag)
        print("[GetFFlag] " .. Message)
        return nil, Message
    end

    local Bare = Bloxstrap.TouchEnabled and StripPrefix(Flag) or Flag

    local Ok, Result = pcall(getfflag, Bare)
    if Ok and Result ~= nil then
        return tostring(Result)
    end

    local Message = "FFlag not found: " .. Bare .. " (original: " .. Flag .. ")"
    print("[GetFFlag] " .. Message)
    return nil, Message
end