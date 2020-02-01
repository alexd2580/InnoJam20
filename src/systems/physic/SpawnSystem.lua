local Vector = require("helper/Vector")
local Body, SpawneMe = Component.load({"Body", "SpawnMe"})

local SpawnSystem = class("SpawnSystem", System)


function SpawnSystem:initialize()
    System.initialize(self)
end


function SpawnSystem:update(dt)
    local world = stack:current().world
    local engine = stack:current().engine

    for index, entity in pairs(self.targets) do
        local spawnMe = entity:get("SpawnMe")

        local x, y =  spawnMe.position.x, spawnMe.position.y
        local body = love.physics.newBody(world, x, y, "dynamic")

        local shape = love.physics.newCircleShape(spawnMe.size)
        local fixture = love.physics.newFixture(body, shape)
        fixture:setUserData(entity)
        entity:add(Body(body))


        -- Apply velocity in case when given.
        if spawnMe.motion then
            local mx, my = spawnMe.motion.x, spawnMe.motion.y
            body:setLinearVelocity(mx, my)
        end

        entity:remove("SpawnMe")
    end
end


function SpawnSystem:requires()
    return {"SpawnMe"}
end


return SpawnSystem
