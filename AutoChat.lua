function love.load()
    image = love.graphics.newImage("example.png")

    shader = love.graphics.newShader[[
        extern number time;

        vec4 effect(vec4 color, Image texture, vec2 texCoord, vec2 screen_coords) {
            vec4 texColor = Texel(texture, texCoord);

            // Phản chiếu ánh sáng dựa theo tọa độ và thời gian
            float shine = sin((texCoord.x + texCoord.y + time) * 10.0) * 0.5 + 0.5;

            // Mô phỏng gương ánh sáng
            vec3 chromeColor = vec3(shine, shine * 0.9, shine * 1.0);
            chromeColor = mix(texColor.rgb, chromeColor, 0.8);

            return vec4(chromeColor * color.rgb, texColor.a);
        }
    ]]
end

function love.update(dt)
    shader:send("time", love.timer.getTime())
end

function love.draw()
    love.graphics.setShader(shader)
    love.graphics.draw(image, 100, 100)
    love.graphics.setShader()
end
