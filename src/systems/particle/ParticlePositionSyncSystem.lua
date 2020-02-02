local ParticlePositionSyncSystem = class("ParticlePositionSyncSystem", System)

function ParticlePositionSyncSystem:update()
    for k, entity in pairs(self.targets) do
        self:syncPosition(entity)
    end
end

function ParticlePositionSyncSystem:updatePosition(event)
    self:syncPosition(event.entity)
end

function ParticlePositionSyncSystem:syncPosition(entity)
    local particle = entity:get("Particle")
    local body = entity:get("Body")
    local radian = body.body:getAngle()
    local rotatedOffset = particle.offset:rotate(radian):add(body:getPositionVector())

    particle.particle:setPosition(rotatedOffset.x, rotatedOffset.y)
    particle.particle:setDirection(math.pi + radian)
end

function ParticlePositionSyncSystem:requires()
    return {"Particle", "Body"}
end

return ParticlePositionSyncSystem
