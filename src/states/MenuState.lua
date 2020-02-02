local weather = require("src/lib/weather")

local GameState = require("src/states/GameState")

local KeyPressed = require("src/events/KeyPressed")

-- State superclass
local State = require("src/core/State")
local MenuState = class("MenuState", State)

function MenuState:load()
    self.engine = Engine()
    self.eventmanager = EventManager()

    self.city, self.weather = weather.getLocalWeather()
end

function MenuState:update(dt)
    self.engine:update(dt)
end

function MenuState:draw()
    self.engine:draw()

    love.graphics.print("Press any button to start the game!", 10, 10)

    -- WE NEED THIS!
    love.graphics.push()
    love.graphics.scale(4)
    msg = "By the way, the current weather in " .. self.city .. " is... " .. self.weather
    love.graphics.print(msg, 50, 50)
    love.graphics.pop()
end

function MenuState:keypressed(key, isrepeat)
    if key == 'escape' then
       love.event.quit()
    end

    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))

    -- Start the game when any key is pressed
    stack:push(GameState())
end

return MenuState
