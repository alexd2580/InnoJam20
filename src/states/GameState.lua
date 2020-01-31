local Body, Color, DrawableCircle = Component.load({"Body", "Color", "DrawableCircle"})

-- Draw Systems
local DrawSystem = require("systems/draw/DrawSystem")
local CircleDrawSystem = require("systems/draw/CircleDrawSystem")

-- Particle Systems
local ParticleDrawSystem = require("systems/particle/ParticleDrawSystem")
local ParticleUpdateSystem = require("systems/particle/ParticleUpdateSystem")
local ParticlePositionSyncSystem = require("systems/particle/ParticlePositionSyncSystem")

-- Game Systems
local AsteroidSpawnSystem = require("systems/game/AsteroidSpawnSystem")

-- Events
local KeyPressed = require("events/KeyPressed")

-- State superclass
local State = require("core/State")
local GameState = class("GameState", State)
function GameState:load()
    self.world = love.physics.newWorld(0, 0, true)
    local thing = love.physics.newBody(self.world, 100, 100, "dynamic")

    self.engine = Engine()
    self.eventmanager = EventManager()

    -- Draw systems
    self.engine:addSystem(DrawSystem())
    self.engine:addSystem(CircleDrawSystem())
    self.engine:addSystem(ParticleDrawSystem())

    -- Logic systems
    self.engine:addSystem(ParticleUpdateSystem())
    self.engine:addSystem(ParticlePositionSyncSystem())

    -- Game systems
    self.engine:addSystem(AsteroidSpawnSystem(), "update")
end

function GameState:update(dt)
    self.world:update(dt)
    self.engine:update(dt)
end

function GameState:draw()
    self.engine:draw()
end

function GameState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end

return GameState
