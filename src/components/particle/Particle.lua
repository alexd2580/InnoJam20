local Particle = Component.create("Particle")

-- If this is set, the image will be emited as particles from the entity
function Particle:initialize(image, maxParticles, offset, particlelife, emitterlife)
    self.particle = love.graphics.newParticleSystem(image, maxParticles)
    self.particle:setParticleLifetime(particlelife[1], particlelife[2])
    self.particle:setEmissionRate(60)
    -- self.particle:setLinearAcceleration(0, 100, 0, 100)
    self.particle:setSpeed(0, 100)
    self.particle:setSpin(1, 10)
    self.particle:setSpinVariation(1)
    self.particle:setEmissionArea("uniform", 15, 15)

    self.particle:start()

    self.offset = offset

    self.particlelife = particlelife[2]
    if emitterlife then
        self.particle:setEmitterLifetime(emitterlife)
        self.emitterlife = emitterlife
    end
end

return Particle
