local Class = require "class"
game = nil 

function love.load(arg)
	love.window.setMode(0, 0, {fullscreen = true, vsync = true})
	SCREEN_WIDTH = love.graphics.getWidth()
	SCREEN_HEIGHT = love.graphics.getHeight()

	love.window.setTitle("Ludum Dare 50 game")
	is_fullscreen = true
	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = true
	})

	-- enable key repeat so backspace can be held down to trigger love.keypressed multiple times.
  --love.keyboard.setKeyRepeat(true)
	
	-- Load fonts
	local font_regular = love.graphics.newFont("fonts/Poppins-Regular.ttf", 24)
	love.graphics.setFont(font_regular)
	
	game = Game:new(is_server)
end

function love.update(dt)
	game:update(dt)
end

function love.draw()
	game:draw()
end

function love.keypressed(key)
	if key == "f5" then
		if is_server then
			if love.keyboard.isDown("lshift") then
				love.event.quit("restart")
			end
		else
			love.event.quit("restart")
		end

	elseif key == "f4" then
		if is_server then
			if love.keyboard.isDown("lshift") then
				love.event.quit()
			end
		else
			love.event.quit()
		end

	elseif key == "f11" then
		is_fullscreen = not is_fullscreen
		love.window.setFullscreen(is_fullscreen)

	elseif key == "f12" then
		-- Restart as server mode
		is_server = true
		chat:clear()
		love.load("-server")
		
	end

	if game.keypressed then  game:keypressed(key)  end
end

function love.mousepressed(x, y, button, istouch, presses)
	game:mousepressed(x, y, button)
end

function love.quit()
	game:quit()
end

function love.resize(w, h)
	WINDOW_WIDTH = w
	WINDOW_HEIGHT = h
	if game.resize then   game:resize(w,h)   end
end

function love.textinput(text)
	game:textinput(text)
end

oldprint = print
function print(...)
	oldprint(...)
	local success, errormsg = love.filesystem.append("log.txt", concat(...).."\n")
end