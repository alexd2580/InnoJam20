local system = require("src/lib/system")
local apiKeys = require("src/lib/apiKeys")

local weather = {}

function weather.queryLocationApi(apiKey)
    baseEndpoint = "https://api.ipgeolocation.io/ipgeo"
    apiKey = apiKeys.IP_LOCATION_API_KEY
    url = baseEndpoint .. "?apiKey=" .. apiKey
    res = system.queryUrl(url)
    if not res then
        return nil, nil, nil
    end
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
    if not city then
        return "Area 51", "Aliens"
    end
    currentWeather = weather.queryWeatherApi(lat, lon)
    return city, currentWeather
end

return weather
