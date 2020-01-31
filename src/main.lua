local http = require("socket.http")

-- Main Lövetoys Library
lovetoys = require("lib/lovetoys")
lovetoys.initialize({globals = true, debug = true})

-- Require all components once to load them into the registry
require("components/graphic/Color")
require("components/graphic/Drawable")
require("components/graphic/DrawableCircle")
require("components/graphic/DrawableText")
require("components/particle/Particle")
require("components/physic/Accelerating")
require("components/physic/Body")
require("components/physic/CountingDown")


-- Framework Requirements
require("core/Stackhelper")
require("core/Resources")

local MenuState = require("states/MenuState")


function queryUrl(url)
    print("querying " .. url)
    response, err = http.request(url)
    print("response", response)
    print("error", err)
end


function queryLocationApi(apiKey)
    envVar = "IP_LOCATION_API_KEY"
    apiKey = os.getenv(envVar)

    baseEndpoint = "https://api.ipgeolocation.io/ipgeo"
    url = baseEndpoint .. "?apiKey=" .. apiKey
    print(queryUrl(url))
end

function queryWeatherApi(lat, lon)
    envVar = "WEATHER_API_KEY"
    apiKey = os.getenv(envVar)

    baseEndpoint = "http://api.openweathermap.org/data/2.5/weather"
    url = baseEndpoint .. "?lat=" .. lat .. "&lon=" .. lon .. "&APPID=" .. apiKey
    print(queryUrl(url))
end


function getLocalWeather()
    location = queryLocationApi()
    print(location)
    weather = queryWeatherApi()
    print(weather)
end

function setUsernameSeed()
    current_user = os.execute("whoami")
    math.randomseed(current_user)
end


function love.load()
    -- setUsernameSeed()
    -- getLocalWeather()

    resources = Resources()

    -- Add your resources here:
    resources:addImage("circle", "data/img/circle.png")

    resources:load()

    stack = StackHelper()
    stack:push(MenuState())
end

function love.update(dt)
    stack:current():update(dt)
end

function love.draw()
    stack:current():draw()
end

function love.keypressed(key, isrepeat)
    stack:current():keypressed(key, isrepeat)
end

function love.keyreleased(key, isrepeat)
    stack:current():keyreleased(key, isrepeat)
end

function love.mousepressed(x, y, button)
    stack:current():mousepressed(x, y, button)
end
