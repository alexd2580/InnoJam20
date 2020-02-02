local screen_width = love.graphics.getWidth()
local scale = screen_width / 1920

-- Main Lövetoys Library
lovetoys = require("src/lib/lovetoys")
lovetoys.initialize({globals = true, debug = true})

-- Require all components once to load them into the registry
require("src/components/gameplay/Angel")
require("src/components/gameplay/Asteroid")
require("src/components/gameplay/Devil")
require("src/components/gameplay/Earth")
require("src/components/gameplay/JustSpawned")
require("src/components/gameplay/ReadyForCleanup")
require("src/components/graphic/Color")
require("src/components/graphic/Circle")
require("src/components/graphic/Drawable")
require("src/components/graphic/DrawableCircle")
require("src/components/graphic/DrawableText")
require("src/components/graphic/DrawableSprite")
require("src/components/graphic/ImagePosition")
require("src/components/graphic/Parallax")
require("src/components/particle/Particle")
require("src/components/physic/Accelerating")
require("src/components/physic/Body")
require("src/components/physic/CountingDown")
require("src/components/physic/SpawnMe")
require("src/components/physic/Caged")
require("src/components/physic/MaxVelocity")
require("src/components/physic/Attracting")

-- Framework Requirements
require("src/core/Stackhelper")
require("src/core/Resources")

-- Helper includes
require("src/helper/tables")

local MenuState = require("src/states/MenuState")


function setUsernameSeed()
    current_user = execute("whoami")
    math.randomseed(current_user)
end


function love.load()
    -- setUsernameSeed()
    resources = Resources()

    -- Add your resources here:
    resources:addImage("background", "data/img/deepfield.jpg")
    resources:addImage("stoneboi", "data/img/stone-asteroid.png")
    resources:addImage("waterboi", "data/img/water-asteroid.png")
    resources:addImage("explodyboi", "data/img/explody-boi.png")
    resources:addImage("explodyparticle", "data/img/explodyparticle.png")
    resources:addImage("deepfield", "data/img/bg.png")
    resources:addImage("planet", "data/img/planet.png")
    resources:addSprite("good", "data/img/good-player.png", 64, 64, 8)
    resources:addSprite("bad", "data/img/bad-player.png", 64, 64, 8)
    resources:addMusic("background", "data/sound/background.wav")
    resources:addSound("boom", "data/sound/boom.wav")
    resources:addSound("splash", "data/sound/splash.mp3")
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
