local Angel, Body, Color, Devil, DrawableCircle = Component.load({"Angel", "Body", "Color", "Devil", "DrawableCircle"})

-- Draw Systems
local DrawSystem = require("systems/draw/DrawSystem")
local CircleDrawSystem = require("systems/draw/CircleDrawSystem")

-- Particle Systems
local AngelControlSystem = require("systems/game/AngelControlSystem")
local DevilControlSystem = require("systems/game/DevilControlSystem")
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

function GameState:spawnAngel()
    local angel = Entity()

    local startX, startY = 200, 200
    local body = love.physics.newBody(self.world, startX, startY, "dynamic")
    local shape = love.physics.newCircleShape(20)
    local fixture = love.physics.newFixture(body, shape)
    angel:add(Body(body))

    angel:add(Angel())
    angel:add(Color(0.8, 0.8, 0.8))
    angel:add(DrawableCircle(50, true))

    self.engine:addEntity(angel)
end

function GameState:spawnDevil()
    local devil = Entity()

    local startX, startY = 300, 300
    local body = love.physics.newBody(self.world, startX, startY, "dynamic")
    local shape = love.physics.newCircleShape(20)
    local fixture = love.physics.newFixture(body, shape)
    devil:add(Body(body))

    devil:add(Devil())
    devil:add(Color(0.8, 0.2, 0.2))
    devil:add(DrawableCircle(50, true))

    self.engine:addEntity(devil)
end

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
    self.engine:addSystem(AngelControlSystem(), "update")
    self.engine:addSystem(DevilControlSystem(), "update")
    self.engine:addSystem(AsteroidSpawnSystem(), "update")

    self:spawnAngel()
    self:spawnDevil()
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
