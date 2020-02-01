local screen_width = love.graphics.getWidth()
local scale = screen_width / 1920

-- Main Lövetoys Library
lovetoys = require("lib/lovetoys")
lovetoys.initialize({globals = true, debug = true})

-- Require all components once to load them into the registry
require("components/gameplay/Angel")
require("components/gameplay/Asteroid")
require("components/gameplay/Devil")
require("components/gameplay/Earth")
require("components/gameplay/JustSpawned")
require("components/gameplay/ReadyForCleanup")
require("components/graphic/Color")
require("components/graphic/Drawable")
require("components/graphic/DrawableCircle")
require("components/graphic/DrawableText")
require("components/particle/Particle")
require("components/physic/Accelerating")
require("components/physic/Body")
require("components/physic/CountingDown")
require("components/physic/SpawnMe")

-- Framework Requirements
require("core/Stackhelper")
require("core/Resources")

-- Helper includes
require("helper/tables")

local MenuState = require("states/MenuState")


function setUsernameSeed()
    current_user = execute("whoami")
    math.randomseed(current_user)
end


function love.load()
    -- setUsernameSeed()
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
    love.graphics.scale(scale, scale)
    stack:current():draw()
end

function love.keypressed(key, isrepeat)
    stack:current():keypressed(key, isrepeat)
end

function love.keyreleased(key, isrepeat)
    stack:current():keyreleased(key, isrepeat)
end

function love.mousepressed(x, y, button)
    stack:current():mousepressed(x, y, button)
end
