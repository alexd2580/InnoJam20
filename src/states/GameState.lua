local Angel, Asteroid, Body, Color, Devil, Earth, DrawableCircle, DrawableAnimation = Component.load(
    {"Angel", "Asteroid", "Body", "Color", "Devil", "Earth", "DrawableCircle", "DrawableAnimation"}
)

-- Draw Systems
local DrawSystem = require("systems/draw/DrawSystem")
local CircleDrawSystem = require("systems/draw/CircleDrawSystem")
local SpriteSystem = require("systems/draw/SpriteSystem")
-- Particle Systems
local ParticleDrawSystem = require("systems/particle/ParticleDrawSystem")
local ParticleUpdateSystem = require("systems/particle/ParticleUpdateSystem")
local ParticlePositionSyncSystem = require("systems/particle/ParticlePositionSyncSystem")

-- Game Systems
local AngelControlSystem = require("systems/gameplay/AngelControlSystem")
local DevilControlSystem = require("systems/gameplay/DevilControlSystem")
local AsteroidSpawnSystem = require("systems/gameplay/AsteroidSpawnSystem")
local CleanupSystem = require("systems/gameplay/CleanupSystem")

-- Events
local KeyPressed = require("events/KeyPressed")

-- State superclass
local State = require("core/State")
local GameState = class("GameState", State)


function GameState:spawnEarth()
    local earth = Entity()

    local earthSize = 150
    local startX, startY = 1920 / 2, 1080 / 2
    local body = love.physics.newBody(self.world, startX, startY, "dynamic")
    local shape = love.physics.newCircleShape(earthSize)
    local fixture = love.physics.newFixture(body, shape)
    fixture:setUserData(earth)
    earth:add(Body(body))

    earth:add(Color(0.2, 0.5, 0.2))
    earth:add(DrawableCircle(earthSize, true))
    earth:add(Earth())

    self.engine:addEntity(earth)
end


function GameState:buildBasePlayer(startX, startY, r, g, b)
    local player = Entity()

    local playerSize = 40
    local body = love.physics.newBody(self.world, startX, startY, "dynamic")
    local shape = love.physics.newCircleShape(playerSize)
    local fixture = love.physics.newFixture(body, shape)
    player:add(Body(body))

    player:add(Color(r, g, b))
    local playerSprite = resources.animations.circle
    player:add(DrawableAnimation(playerSprite.quads, playerSprite.spriteSheets, 2))

    return player
end


function GameState:spawnAngel()
    local startX, startY = 200, 200
    local angel = self:buildBasePlayer(startX, startY, 0.8, 0.8, 0.8)
    angel:add(Angel())
    self.engine:addEntity(angel)
end


function GameState:spawnDevil()
    local startX, startY = 300, 300
    local devil = self:buildBasePlayer(startX, startY, 0.8, 0.2, 0.2)
    devil:add(Devil())
    self.engine:addEntity(devil)
end


function GameState.handleEarthAsteroidCollision(earth, asteroid, contact, normal, tangent)
    asteroid:get("Body").body:destroy()
    stack:current().engine:removeEntity(asteroid)
end


function GameState.onCollide(a, b, contact, normal, tangent)
    local aEntity, bEntity = a:getUserData(), b:getUserData()
    if not aEntity or not bEntity then
        return
    end
    if aEntity:has("Earth") and bEntity:has("Asteroid") then
        GameState.handleEarthAsteroidCollision(aEntity, bEntity, contact, normal, tangent)
    elseif bEntity:has("Earth") and aEntity:has("Asteroid") then
        -- TODO reverse tangent and normal?
        GameState.handleEarthAsteroidCollision(bEntity, aEntity, contact, normal, tangent)
    end
end


function GameState:load()
    self.world = love.physics.newWorld(0, 0, true)
    self.world:setCallbacks(nil, nil, nil, self.onCollide)

    self.engine = Engine()
    self.eventmanager = EventManager()

    -- Draw systems
    self.engine:addSystem(DrawSystem())
    self.engine:addSystem(CircleDrawSystem())
    self.engine:addSystem(ParticleDrawSystem())
    self.engine:addSystem(SpriteSystem(), "draw")

    -- Logic systems
    self.engine:addSystem(ParticleUpdateSystem())
    self.engine:addSystem(ParticlePositionSyncSystem())

    -- Game systems
    self.engine:addSystem(SpriteSystem(), "update")
    self.engine:addSystem(AngelControlSystem(), "update")
    self.engine:addSystem(DevilControlSystem(), "update")
    self.engine:addSystem(AsteroidSpawnSystem(), "update")
    self.engine:addSystem(CleanupSystem(), "update")

    self:spawnEarth()
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
    if key == 'escape' then
        stack:pop()
    end

    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end

return GameState
