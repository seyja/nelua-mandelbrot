require "raylib"

--------------------------------------------------------------------------------------

local SCREEN_WIDTH: uint16 <const> = 1000;
local SCREEN_HEIGHT: uint16 <const> = 1000;

rl.setTargetFPS(60);
rl.initWindow(SCREEN_WIDTH,SCREEN_HEIGHT, "mandle deez nuts");

--------------------------------------------------------------------------------------

local minRe = -2.0
local maxRe = 1.0
local minIm = -1.2
local maxIm = minIm + (maxRe - minRe) * SCREEN_HEIGHT / SCREEN_WIDTH
local factor = math.max((maxRe - minRe) / SCREEN_WIDTH, (maxIm - minIm) / SCREEN_HEIGHT)
local zoomFactor = 1.1

--------------------------------------------------------------------------------------

while not rl.windowShouldClose() do
    rl.drawing(function()
        rl.clearBackground({0,0,0,255})
        for y = 0, SCREEN_HEIGHT - 1 do
            for x = 0, SCREEN_WIDTH - 1 do
                local cRe = minRe + x * factor
                local cIm = maxIm - y * factor
                local zRe = cRe
                local zIm = cIm
                local isInside = true

                for i = 0,255 do
                    local zRe2 = zRe * zRe
                    local zIm2 = zIm * zIm

                    if zRe2 + zIm2 > 2 then
                        isInside = false
                        break
                    end
                    --mess with shape 
                    zRe = zRe2 - zIm2 + cRe
                    zIm = 2 * zRe * zIm + cIm
                end

                if isInside then
                    
                    rl.drawPixel(x, y, {70+math.abs(zIm*zRe)*170,0,0,255})
                        
                end
            end
        end
    rl.drawRectangleLines( 10, 10, 105, 95, rl.BLUE)

    rl.drawText("controls:", 30, 20, 14, rl.WHITE)
    rl.drawText("WASD to move", 15, 40, 14, rl.LIGHTGRAY)
     rl.drawText("+ to zoom in", 15, 60, 14, rl.LIGHTGRAY)
    rl.drawText("- to zoom out", 15, 80, 14, rl.LIGHTGRAY)

    end)
    -- point of no return
    if rl.isKeyPressed(rl.keyboardKey.KP_ADD) or rl.isKeyPressed(rl.keyboardKey.EQUAL) then
        local newWidth = (maxRe - minRe) / zoomFactor
        local newHeight = (maxIm - minIm) / zoomFactor
        local mousePos = rl.getMousePosition()
        local mouseRe = minRe + mousePos.x * factor
        local mouseIm = maxIm - mousePos.y * factor
        minRe = mouseRe - newWidth / 2
        maxRe = mouseRe + newWidth / 2
        minIm = mouseIm - newHeight / 2
        maxIm = mouseIm + newHeight / 2
        factor = math.max((maxRe - minRe) / SCREEN_WIDTH, (maxIm - minIm) / SCREEN_HEIGHT)
    elseif rl.isKeyPressed(rl.keyboardKey.KP_SUBTRACT) or rl.isKeyPressed(rl.keyboardKey.MINUS) then
        local newWidth = (maxRe - minRe) * zoomFactor
        local newHeight = (maxIm - minIm) * zoomFactor
        local mousePos = rl.getMousePosition()
        local mouseRe = minRe + mousePos.x * factor
        local mouseIm = maxIm - mousePos.y * factor
        minRe = mouseRe - newWidth / 2
        maxRe = mouseRe + newWidth / 2
        minIm = mouseIm - newHeight / 2
        maxIm = mouseIm + newHeight / 2
        factor = math.max((maxRe - minRe) / SCREEN_WIDTH, (maxIm - minIm) / SCREEN_HEIGHT)
    elseif rl.isKeyDown(rl.keyboardKey.A) then
        minRe = minRe - (maxRe - minRe) / 10
        maxRe = maxRe - (maxRe - minRe) / 10
    elseif rl.isKeyDown(rl.keyboardKey.D) then
        minRe = minRe + (maxRe - minRe) / 10
        maxRe = maxRe + (maxRe - minRe) / 10
    elseif rl.isKeyDown(rl.keyboardKey.S) then
        minIm = minIm - (maxIm - minIm) / 10
        maxIm = maxIm - (maxIm - minIm) / 10
    elseif rl.isKeyDown(rl.keyboardKey.W) then
        minIm = minIm + (maxIm - minIm) / 10
        maxIm = maxIm + (maxIm - minIm) / 10
    end
end
