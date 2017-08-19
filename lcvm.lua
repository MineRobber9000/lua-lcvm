--LCVM functions

local function lcobject(value)
  local ret = {}
  if type(value)=="string" then ret.type = "YARN"
  elseif type(value)=="number" then ret.type = "NUMBAR"
  elseif type(value)=="boolean" then ret.type = "TROOF"
  elseif type(value)=="table" then ret.type = "BUKKIT"
  elseif type(value)=="function" then ret.type = "FUNKSHION"
  else ret.type = "NOOB" end
  ret.value = value
  ret.toLCValue = function()
    if ret.type=="YARN" then return ret.value end
    if ret.type=="NUMBAR" then return ret.value+0.0 end
    if ret.type=="TROOF" then return ret.value and "WIN" or "FAIL" end
    return ret.value
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

local function splitlines(str)
   local t = {}
   local function helper(line)
      table.insert(t, line)
      return ""
   end
   helper(((str.."\n"):gsub("(.-)\r?\n", helper)))
   return t
end

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

local isStatement = {}
local statementFunctions = {}
local function addStatement(stmt,func)
  isStatement[stmt] = true
  statementFunctions[stmt] = func
end

local function visible(tokens,i)
  table.remove(tokens,1)
  local obj = lcobject(table.concat(tokens," "):sub(2,-2))
  print(obj.value)
  return i
end
addStatement("VISIBLE",visible)

local default_env = {STDIO=lcobject(function() end)}
local function wrap(code,env,level)
  env = env and env or default_env
  level = level and level or 1
  function ret()
    local lines = split(code)
    if level==1 and lines[1]:sub(1,3)~="HAI" then
      return lcobject(false)
    end
    local i = 2
    while i<#lines do
      local tokens = split(lines[i],"%s")
      if isStatement[tokens[1]] then
        i = statementFunctions[tokens[1]](tokens,i)
      end
      i = i + 1
    end
    if level==1 and not lines[#lines]=="KTHXBYE" then
      return lcobject(false)
    end
  end
  --TODO: implement wrapping LOLCODE segments into Lua functions. will be used in execute.
  return ret
end

local function execute(code,env)
  return wrap(code,env)()
end

local api = {}
api.execute = execute
api.wrapcode = wrap
api.lcobject = lcobject
return api
