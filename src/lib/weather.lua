local system = require("lib/system")
local apiKeys = require("lib/apiKeys")

local weather = {}

function weather.queryLocationApi(apiKey)
    baseEndpoint = "https://api.ipgeolocation.io/ipgeo"
    apiKey = apiKeys.IP_LOCATION_API_KEY
    url = baseEndpoint .. "?apiKey=" .. apiKey
    res = system.queryUrl(url)
    return res.city, res.latitude, res.longitude
end

function weather.queryWeatherApi(lat, lon)
    baseEndpoint = "http://api.openweathermap.org/data/2.5/weather"
    apiKey = apiKeys.WEATHER_API_KEY
    url = baseEndpoint .. "?lat=" .. lat .. "&lon=" .. lon .. "&APPID=" .. apiKey
    res = system.queryUrl(url)
    firstWeather = res.weather[1].main
    return firstWeather
end

function weather.getLocalWeather()
    city, lat, lon = weather.queryLocationApi()
    currentWeather = weather.queryWeatherApi(lat, lon)
    return city, currentWeather
end

return weather
