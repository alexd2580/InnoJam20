local Body, Color, DrawableCircle = Component.load({"Body", "Color", "DrawableCircle"})

-- Draw Systems
local DrawSystem = require("systems/draw/DrawSystem")
local CircleDrawSystem = require("systems/draw/CircleDrawSystem")

-- Particle Systems
local ParticleDrawSystem = require("systems/particle/ParticleDrawSystem")
local ParticleUpdateSystem = require("systems/particle/ParticleUpdateSystem")
local ParticlePositionSyncSystem = require("systems/particle/ParticlePositionSyncSystem")

-- Events
local KeyPressed = require("events/KeyPressed")

-- State superclass
local State = require("core/State")
local GameState = class("GameState", State)
function GameState:load()
    self.world = love.physics.newWorld(0, 0, true)
    local thing = love.physics.newBody(self.world, 100, 100, "dynamic")

    local entity = Entity()
    local body = Body(thing)
    entity:add(body)
    entity:add(DrawableCircle(50, true))
    entity:add(Color(255, 255, 0))

    self.engine = Engine()
    self.eventmanager = EventManager()

    self.engine:addEntity(entity)

    -- Draw systems
    self.engine:addSystem(DrawSystem())
    self.engine:addSystem(CircleDrawSystem())
    self.engine:addSystem(ParticleDrawSystem())

    -- Logic systems
    self.engine:addSystem(ParticleUpdateSystem())
    self.engine:addSystem(ParticlePositionSyncSystem())

    -- Physic systems
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
