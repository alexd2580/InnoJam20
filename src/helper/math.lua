function getSinCos(x, y, xt, yt)
    local akat, gkat
    akat = xt - x
    gkat = yt - y

    local hypo = math.sqrt(math.pow(gkat, 2) + math.pow(akat, 2))
    local sin = gkat/hypo
    local cos = akat/hypo
    return sin, cos
end

function getRadian(x, y, xt, yt)
    local akat, gkat
    akat = xt - x
    gkat = yt - y
    return math.atan2(akat, -gkat)-math.pi/2
end

function getAngle(x, y, xt, yt)
    return getRadian(x, y, xt, yt) * 180/math.pi
end
