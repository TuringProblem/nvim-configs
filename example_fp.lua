--- @param t table
--- @param patch table
--- @return table
local merge = function(t, patch)
  local out = {}
  for k, v in pairs(t) do out[k] = v end
  for k, v in pairs(patch or {}) do out[k] = v end
  return out
end

local function map(xs, f)
  local out = {}
  for i = 1, #xs do out[i] = f(xs[i], i) end
  return out
end



--- @type string[]
local TABS = { "Home", "Counter", "Modem" }

--- @class Model
--- @field tab number
--- @field count number
--- @field sides table
--- @field modems table<string, boolean>

--- @param sides table
--- @return Model
local init = function(sides)
  local modems = {}
  for _, s in ipairs(sides) do modems[s] = false end
  return { tab = 1, count = 0, sides = sides, modems = modems }
end

local function SelectTab(i) return { kind = "SelectTab", index = i } end
local function Increment() return { kind = "Increment" } end
local function PowerOnModem(side) return { kind = "PowerOnModem", side = side } end
local function PowerOffModem(side) return { kind = "PowerOffModem", side = side } end

-- TODO: figure out wtf the merge function does lmao.

--- @param msg table
--- @param model table
--- @return table
local function update(msg, model)
  if msg.kind == "SelectTab" then
    return merge(model, { tab = msg.index })
  elseif msg.kind == "Increment" then
    return merge(model, { count = model.count + 1 })
  elseif msg.kind == "PowerOnModem" then
    return merge(model, { modems = merge(model.modems, { [msg.side] = true }) })
  elseif msg.kind == "PowerOffModem" then
    return merge(model, { modems = merge(model.modems, { [msg.side] = false }) })
  end
  return model
end

---@class Component
---@field x number
---@field y number
---@field text string
---@field fg string
---@field bg string
---@field msg? table

--- @type Component
--- @return Component
local function label(x, y, text, fg, bg)
  return { x = x, y = y, text = text, fg = fg, bg = bg } -- no msg => not clickable
end

--- @type Component
--- @return Component
local function clickable(x, y, text, fg, bg, msg)
  return { x = x, y = y, text = text, fg = fg, bg = bg, msg = msg }
end

--- @param model table
local function viewTabs(model)
  local widgets, x = {}, 1
  for i = 1, #TABS do
    local text = " " .. TABS[i] .. " "
    local active = i == model.tab
    widgets[#widgets + 1] = clickable(
      x, 1, text,
      active and colors.black or colors.white,
      active and colors.white or colors.gray,
      SelectTab(i)
    )
    x = x + #text
  end
  return widgets
end


local findModems = function()
  local sides = {}
  for _, name in ipairs(peripheral.getNames()) do
    if peripheral.getType(name) == "modem" then
      sides[#sides + 1] = name
    end
  end
  return sides
end

local StartupModem = function(isOn, side)
  if isOn then
    rednet.open(side)
  else
    rednet.close(side)
  end
end


local ModemPage = function(model)
  local widgets = { label(2, 3, "Modem Status Page", colors.white) }

  if #model.sides == 0 then
    widgets[#widgets + 1] = label(2, 5, "No modems attached.", colors.red)
    return widgets
  end

  for i, side in ipairs(model.sides) do
    local y = 3 + i * 2
    local on = model.modems[side]

    widgets[#widgets + 1] = label(2, y, side .. ": " .. (on and "ON" or "OFF"), on and colors.lime or colors.red)
    widgets[#widgets + 1] = clickable(16, y, " ON ", colors.white, colors.green, PowerOnModem(side))
    widgets[#widgets + 1] = clickable(22, y, " OFF ", colors.white, colors.red, PowerOffModem(side))
  end
  return widgets
end


local function viewBody(model)
  if model.tab == 1 then
    return {
      label(2, 3, "Kevins Crib!", colors.white),
      label(2, 5, "Stats: ", colors.lightGray),
    }
  elseif model.tab == 2 then
    return {
      label(2, 3, "Count: " .. model.count, colors.white),
      clickable(2, 5, " Count + ", colors.white, colors.green, Increment()),
    }
  else
    return ModemPage(model)
  end
end

-- Concatenate tab bar + body into one widget list.
local function view(model)
  local widgets = viewTabs(model)
  for _, w in ipairs(viewBody(model)) do widgets[#widgets + 1] = w end
  return widgets
end
local function hitTest(widgets, x, y)
  for _, w in ipairs(widgets) do
    if w.msg and y == w.y and x >= w.x and x <= w.x + #w.text - 1 then
      return w.msg
    end
  end
  return nil
end

local function render(dev, widgets)
  dev.setBackgroundColor(colors.black)
  dev.clear()
  for _, w in ipairs(widgets) do
    dev.setBackgroundColor(w.bg or colors.black)
    dev.setTextColor(w.fg or colors.white)
    dev.setCursorPos(w.x, w.y)
    dev.write(w.text)
  end
end

local function runtime(dev)
  local model = init(findModems())
  local lastModems = merge(model.modems, {})
  while true do
    local widgets = view(model)
    render(dev, widgets)
    local _, _, x, y = os.pullEvent("monitor_touch")
    local msg = hitTest(widgets, x, y)
    if msg then
      model = update(msg, model)
      for side, on in pairs(model.modems) do
        if on ~= lastModems[side] then
          StartupModem(on, side)
          lastModems[side] = on
        end
      end
    end
  end
end


-- ---- Main  -----------------------------------------------------
local device = peripheral.find("monitor")
if not device then
  error("No monitor attached. Place an advanced monitor touching the computer.", 0)
end
device.setTextScale(0.5)
runtime(device)
