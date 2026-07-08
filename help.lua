local manager = peripheral.find("inventoryManager")
local rsbridge = peripheral.find("rs_bridge")

local keepItems = {
  { name = "factoryblocks:factory", count = 27 * 64 }
}

local takeItems = {
  { name = "factoryblocks:sturdy", count = 27 * 64 }
}

local function countItem(itemName)
  local count = 0
  for _, item in ipairs(manager.getItems()) do
    if item.name == itemName then
      count = count + item.count
    end
  end
  print(count)
  return count
end

while true do
  for _, item in ipairs(keepItems) do
    local count = countItem(item.name)

    if count < item.count then
      local needed = item.count - count
      print("Need " .. needed .. " of " .. item.name)
      while needed > 0 do
        local transferCount = math.min(needed, 64)

        rsbridge.exportItem({ name = item.name, count = transferCount }, "down")
        manager.addItemToPlayer("up", { name = item.name, count = transferCount })
        needed = needed - transferCount
      end
    end
  end

  for _, item in ipairs(takeItems) do
    local count = countItem(item.name)
    if count > item.count then
      local excess = count - item.count
      print("Excess " .. excess .. " of " .. item.name)
      while excess > 0 do
        local transferCount = math.min(excess, 64)

        manager.removeItemFromPlayer("up", { name = item.name, count = transferCount })
        rsbridge.importItem({ name = item.name, count = transferCount }, "down")
        excess = excess - transferCount
      end
    end
  end
  os.sleep(0.5)
end
