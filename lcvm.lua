--LCVM functions

local function lcobject(value)
  local ret = {}
  if type(value)=="string" then ret.type = "YARN"
  elseif type(value)=="number" then ret.type = "NUMBAR"
  elseif type(value)=="boolean" then ret.type = "TROOF"
  elseif type(value)=="table" then ret.type = "BUKKIT"
  elseif type(value)=="function" then ret.type = "funkshion"
  else ret.type = "NOOB" end
  ret.value = value
  ret.toLCValue = function()
    if ret.type=="YARN" then return ret.value end
    if ret.type=="NUMBAR" then return ret.value+0.0 end
    if ret.type=="TROOF" then return ret.value and "WIN" or "FAIL" end
    return nil
  end
  ret.fromLCValue = function(lcval)
    if type(lcval)=="string" then if lcval=="WIN" or lcval=="FAIL" then ret.type = "TROOF" else ret.type = "YARN" end
    elseif type(lcval)=="number" then ret.type = "NUMBAR"
    elseif type(lcval)=="function" then ret.type = "FUNKSHION"
    else ret.type=="NOOB" end
    if lcval=="WIN" or lcval=="FAIL" then ret.value = (lcval=="WIN") else
    ret.value = value end
  end
end

local default_env = {STDIO=lcobject(function() end)}
local function wrap(code,env)
  env = env and env or default_env
  function ret()
    return lcobject(false)
  end
  --TODO: implement wrapping LOLCODE segments into Lua functions. will be used in execute.
  return ret
end

function execute(code,env)
  return wrap(code,env)()
end
