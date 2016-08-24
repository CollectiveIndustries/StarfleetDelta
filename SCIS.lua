local component = require("component")
local event = require("event")
local os = require("os")
 
local ol = component.openlight
local cb = component.chat_box
local door = component.os_door
local char_space = string.byte(" ")
local running = true
local char_pause = string.byte("p")
 
cb.setName("Dave")
 
function unknownEvent()
end
 
local myEventHandlers = setmetatable({}, { __index = function() return unknownEvent end })
 
function myEventHandlers.key_up(adress, char, code, playerName)
  if (char == char_space) then
  running = false
  --[[elseif (char == char_pause) then
  cardMenu()
  doChoice()  ]]--
  end
  end
 
local function openDoor()
  door.toggle()
  os.sleep(5)
  door.toggle()
  return
end
 
local function cardMenu()
term.clear()
term.setCursor(1,1)
print("Do you wish to add or remove a UUID? (A/r)")
choice = io.read()
if choice and (choice == "" or choice:sub(1,1):lower() == "a") then
choice = "a" -- I have no idea where I was going with this
else choice = "r"
end
return choice
end
 
local messages = {
 
  ["lights"] = {
    --Syntax: ["keyword"] = {function, all, other, arguments}
    ["on"] = {},
    ["off"] = {}
  },
 
 ["door"] = {
    ["open"] = {openDoor}
  },
 
 ["lamp"] = {
    ["on"] = {ol.setColor, 0x00FF00},
    ["off"] = {ol.setColor, 0xFF0000}
  },
 
  ["core"] = {
    ["current"] = {cb.say, "Herpderp"},
    ["max"] = {cb.say, "Herpderp"}
  },
 
  ["reactor"] = {
  ["fuel"] = {}
  },
 
  ["awesome"] = {
    ["you're"] = {cb.say, "No, you're awesome."}
  }
 
}
 
local function getFunction(tbl, msg)
  if tbl[1] then
    return tbl
  end
  for i,j in pairs(tbl) do
    if type(i) == "string" then
      -- print(i)
      if msg:find(i) and type(j) == "table" then
        return getFunction(j, msg)
      end
    end
  end
end
 
local function parseMessage(msg)
  local fnc = getFunction(messages, msg)
  if not fnc then return false, "no command found" end
  return pcall(table.unpack(fnc))
end
 
function myEventHandlers.chat_message(adr,playerName,message)
if message:find("^%Dave, .+") then
local result, response = parseMessage(message:lower())
end
end
 
 
local function doChoice()
end
 
local function authorized()
  local env = {}
  local config = loadfile("/etc/auth.dat", nil, env)
  if config then
    pcall(config)
  end
  return env.authorized
end
 
local authorized = authorized() -- This one?
 
function myEventHandlers.magData(addr, playerName, data, UUID, locked)
for i = 1,#authorized do
print("Checking index #" .. i .. " for a match against: " .. UUID)
if UUID == authorized[i] then
print("Door opening for " .. playerName .. ".")
openDoor()
break
elseif UUID ~= authorized[i] then
print("Unauthorized Access attempt from " .. playerName .. "!")
end
end
end
 
function handleEvent(eventID, ...)
  if (eventID) then -- can be nil if no event was pulled for some time
    myEventHandlers[eventID](...) -- call the appropriate event handler with all remaining arguments
  end
end
 
--[[function myEventHandlers.chat_message(addr,playerName,msg)
if playerName == "Kodos" and msg == "Open sesame" then
openDoor()
end
end ]]--
 
while running do
handleEvent(event.pull())
end
