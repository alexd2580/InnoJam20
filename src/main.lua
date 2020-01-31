-- Main Lövetoys Library
lovetoys = require("lib/lovetoys")
lovetoys.initialize({globals = true, debug = true})

-- Framework Requirements
require("core/Stackhelper")
require("core/Resources")

local MenuState = require("states/MenuState")


function love.load()

    -- current_user = os.execute("whoami")
    -- math.randomseed(current_user)

    resources = Resources()

    -- Add your resources here:
    resources:addImage("circle", "data/img/circle.png")

    resources:load()

    stack = StackHelper()
    stack:push(MenuState())
end

function love.update(dt)
    stack:current():update(dt)
end

function love.draw()
    stack:current():draw()
end

function love.keypressed(key, isrepeat)
   if key == 'escape' then
      love.event.quit()
   end
    stack:current():keypressed(key, isrepeat)
end

function love.keyreleased(key, isrepeat)
    stack:current():keyreleased(key, isrepeat)
end

function love.mousepressed(x, y, button)
    stack:current():mousepressed(x, y, button)
end
