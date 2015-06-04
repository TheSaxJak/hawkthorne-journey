local anim8 = require 'vendor/anim8'
local fonts = require 'fonts'

local Tooltip = {}
Tooltip.__index = Tooltip

function Tooltip.new() --TODO: include arguments?
  local tooltip = {}
  setmetatable(tooltip, Tooltip)
  
  tooltip.visible = false
  tooltip.background = love.graphics.newImage( 'images/inventory/tooltip.png' )
  return tooltip
end

-- opens the tooltip annex
function Tooltip:open()
  self.visible = true
end

-- shuts the tooltip annex
function Tooltip:shut()
  self.visible = false
end

function Tooltip:getItemStats( item )
  local itemStats = ""
  if item.subtype ~= nil and item.subtype ~= "item" then
    itemStats = itemStats .. "{{white}}\ntype: {{teal}}" .. item.subtype
  end
  if item.damage ~= nil and item.damage ~= "nil" then
    itemStats = itemStats .. "{{white}}\ndamage: {{red}}" .. tostring(item.damage)
  end
  if item.defense ~= nil and item.defense ~= "nil" then
    itemStats = itemStats .. "{{white}}\ndefense: {{blue_light}}" .. tostring(item.defense)
  end
  if item.special_damage ~= nil and item.special_damage ~= "nil" then
    itemStats = itemStats .. "{{white}}\nspecial: {{red}}" .. item.special_damage
  end
  return itemStats
end

function Tooltip:draw(x, y, selectedItem)
  if not self.visible then return end
  
  love.graphics.draw( self.background, x + 116, y - 32 )

--draws the tooltip information
  local textX = x + 130
  local textY = y - 24

  local itemInfo = selectedItem
  local name = itemInfo.name
  local item = itemInfo.item
  local lineHeight = love.graphics.getFont():getHeight("line height")

  local _, descriptionWrap = love.graphics.getFont():getWrap(item.description, 64)
  love.graphics.printf(item.description, textX, textY, 64, "left", 0, 0.9, 0.9)

  drawSeparator(textX, textY + (descriptionWrap * lineHeight), 64)
  local statWrap = 0

  -- Get additional item stats if they exist
  itemStats = self:getItemStats(item)
  if itemStats ~= "" then
    tastytext = fonts.tasty.new(itemStats, textX, textY + (descriptionWrap * lineHeight), 64, love.graphics.getFont(), fonts.colors, lineHeight)
    statWrap = tastytext.lines
    tastytext:draw()
      drawSeparator(textX, textY + (descriptionWrap + statWrap) * lineHeight, 64)
  end
  
  -- Lastly, insert our item information after everything else
  love.graphics.printf("\n" .. item.info, textX, textY + (descriptionWrap + statWrap) * lineHeight, 64, "left", 0, 0.9, 0.9)
  love.graphics.setColor(255, 255, 255)

end

function drawSeparator(x, y, width)
  y = y + 3 -- for padding around the text

  --draw dividing line
  love.graphics.setColor(112, 28, 114)
  love.graphics.line(x, y, x + width, y)
  
  --draw yellow squares on the ends of the dividing line
  love.graphics.setColor(219, 206, 98)
  love.graphics.rectangle("fill", x, y - 1, 2, 2)
  love.graphics.rectangle("fill", x + width, y - 1, 2, 2)

  -- set color back to white
  love.graphics.setColor(255, 255, 255)
end

return Tooltip
