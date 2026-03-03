-- ToggleFFlag.lua
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

return function(Flag, Value)
    if type(Flag) ~= "string" or #Flag == 0 then
        return false, "flag must be non-empty string"
    end
    
    if Flag:find("[^%w_]") then
        return false, "flag contains invalid characters"
    end
    
    if type(Value) ~= "string" then
        return false, "value must be string"
    end

    local Bare = Bloxstrap.TouchEnabled and StripPrefix(Flag) or Flag
    
    if not pcall(getfflag, Bare) or getfflag(Bare) == nil then
        local Message = "FFlag not found: " .. Bare
        local LogPath = getgenv().errorlog
        
        if LogPath then
            local Previous = (isfile and isfile(LogPath) and readfile(LogPath)) or ""
            pcall(writefile, LogPath, Previous .. "\n" .. os.date("[%c] ") .. Message)
        end
        
        return false, Message
    end

    return pcall(setfflag, Bare, tostring(Value))
end