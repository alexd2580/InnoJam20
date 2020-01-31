local Body = require("components/physic/Body")
local Color = require("components/graphic/Color")
local DrawableCircle = require("components/graphic/DrawableCircle")

-- Systems
local DrawSystem = require("systems/draw/DrawSystem")
local CircleDrawSystem = require("systems/draw/CircleDrawSystem")

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

    local system = CircleDrawSystem()
    -- Draw systems
    self.engine:addSystem(system)

    -- Physic systems
end

function GameState:update(dt)
    self.engine:update(dt)
    self.world:update(dt)
end

function GameState:draw()
    self.engine:draw()
end

function GameState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end

return GameState
