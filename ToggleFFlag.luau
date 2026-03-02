-- ToggleFFlag.lua

local cloneref = cloneref or function(...) return ... end
local HttpService = cloneref(game:GetService("HttpService"))

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

local function ValidateFlagName(Flag)
    if type(Flag) ~= "string" or #Flag == 0 then
        return false, "flag must be a non-empty string, got " .. type(Flag)
    end
    if Flag:find("[^%w_]") then
        return false, "flag name contains illegal characters: " .. Flag
    end
    return true
end

return function(Flag, Value)
    local FlagOk, FlagErr = ValidateFlagName(Flag)
    if not FlagOk then
        return false, FlagErr
    end
    if type(Value) ~= "string" then
        local Message = "value must be a string, got " .. type(Value)
        return false, Message
    end

    local Bare = Bloxstrap.TouchEnabled and StripPrefix(Flag) or Flag

    local Exists = pcall(getfflag, Bare)
    if not Exists or getfflag(Bare) == nil then
        local Message = "FFlag not found: " .. Bare .. " (original: " .. Flag .. ")"
        local LogPath = getgenv().errorlog
        if LogPath then
            local Prior = (isfile and isfile(LogPath) and readfile(LogPath)) or ""
            pcall(writefile, LogPath, Prior .. "\n" .. os.date("[%c] ") .. Message)
        end
        return false, Message
    end

    local SetOk, SetErr = pcall(setfflag, Bare, tostring(Value))
    if not SetOk then
        return false, tostring(SetErr)
    end

    return true
end