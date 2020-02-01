Resources = class("Resources")

function Resources:initialize()
    self.imageQueue = {}
    self.musicQueue = {}
    self.soundQueue = {}
    self.fontQueue= {}
    self.spriteQueue= {}

    self.images = {}
    self.music = {}
    self.sounds = {}
    self.fonts = {}
    self.sprites = {}
end

function Resources:addImage(name, src)
    self.imageQueue[name] = src
end

function Resources:addMusic(name, src)
    self.musicQueue[name] = src
end

function Resources:addSound(name, src)
    self.soundQueue[name] = src
end

function Resources:addFont(name, src, size)
    self.fontQueue[name] = {src, size}
end

function Resources:addSprite(name, src, width, height, duration)
    self.spriteQueue[name] = {
        path = "data/img/good-player.png",
        width = 64,
        height = 64,
        duration = 3,
    }
end

function Resources:load(threaded)
    for name, pair in pairs(self.fontQueue) do
        self.fonts[name] = love.graphics.newFont(pair[1], pair[2])
        self.fontQueue[name] = nil
    end
    for name, src in pairs(self.musicQueue) do
        self.music[name] = love.audio.newSource(src)
        self.musicQueue[name] = nil
    end

    for name, src in pairs(self.soundQueue) do
        self.sounds[name] = love.audio.newSource(src)
        self.soundQueue[name] = nil
    end

    for name, src in pairs(self.imageQueue) do
        self.images[name] = love.graphics.newImage(src)
        self.imageQueue[name] = nil
    end

    for name, data in pairs(self.spriteQueue) do
        local spriteImage = love.graphics.newImage(data.path)
        self.sprites[name] = {
            quads = loadSprite(
            spriteImage,
            data.width,
            data.height,
            data.duration
        ),
        spriteSheet = spriteImage,
        height = data.height,
        width = data.width
        }

        self.spriteQueue[name] = nil
    end
end

function loadSprite(image, width, height, duration)
    local quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    return quads
end

