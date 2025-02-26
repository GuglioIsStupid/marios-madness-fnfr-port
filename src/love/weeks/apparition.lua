--[[----------------------------------------------------------------------------
This file is part of Friday Night Funkin' Rewritten

Copyright (C) 2021  HTV04

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
------------------------------------------------------------------------------]]

local song, difficulty

local stageBack, stageFront, curtains

return {
	enter = function(self, from, songNum, songAppend)
		weeks:enter()

		fading = 0
		redThingExists = true
		cameraZoom = 1
		redThingSize = 1

		weekNumber = "apparition"

		song = songNum
		difficulty = songAppend

		bg = love.filesystem.load("sprites/apparition/bg.lua")()
		bg.sizeX, bg.sizeY = 1.5, 1.5
		enemy = love.filesystem.load("sprites/apparition/wario.lua")()
		boyfriend = love.filesystem.load("sprites/apparition/boyfriend.lua")()
		bodyOne = love.filesystem.load("sprites/apparition/bodyOne.lua")()
		bodyTwo = love.filesystem.load("sprites/apparition/bodyTwo.lua")()
		redThing = love.filesystem.load("sprites/apparition/redThingIdk.lua")()
		--boyfriendTwo = love.filesystem.load("sprites/apparition/boyfriend.lua")()

		if simoc then -- for if you play as simoc
			fakeBoyfriend = love.filesystem.load("sprites/boyfriend.lua")() -- Used for game over
			boyfriend = love.filesystem.load("sprites/simoc.lua")()
		end
		
		--enemy.x, enemy.y = -380, -110
		--boyfriend.x, boyfriend.y = 260, 100

		bodyOne.y = 450
		bodyOne.x = -100
		boyfriend.x, boyfriend.y = -90, 280
		enemy.x, enemy.y = -130, 60

		bg.x, bg.y = -85, 110
		redThing.x, redThing.y = -105, 160
		redThing.sizeX = 1.2 redThing.sizeY = 1.2
		bg.sizeX = 1.5

		bodyTwo.x, bodyTwo.y = bodyOne.x, bodyOne.y -- ok fine guglio i will do it this way

		enemyIcon:animate("daddy dearest", false)
		bodyOne:animate("anim", true)
		bodyTwo:animate("anim", true)
		bg:animate("anim", true)
		redThing:animate("anim", true)

		self:load()
	end,

	load = function(self)
		weeks:load()

		inst = love.audio.newSource("music/apparition/inst.ogg", "stream")
		voices = love.audio.newSource("music/apparition/voices.ogg", "stream")

		self:initUI()

		weeks:setupCountdown()
	end,

	initUI = function(self)
		weeks:initUI()

		weeks:generateNotes(love.filesystem.load("charts/apparition/apparition.lua")())
	end,

	update = function(self, dt)
        weeks:update(dt)
        bodyOne:update(dt)
        bodyTwo:update(dt)
        bg:update(dt)
        redThing:update(dt)
       -- boyfriendTwo:update(dt)

       -- if boyfriend:getAnimName() == "left" then
        --    boyfriendTwo:animate("left", true)
       -- elseif boyfriend:getAnimName() == "left miss" then
       --     boyfriendTwo:animate("left", true)
       -- elseif boyfriend:getAnimName() == "right" then
      --      boyfriendTwo:animate("right", true)
      --  elseif boyfriend:getAnimName() == "right miss" then
         --   boyfriendTwo:animate("right", true)
      --  elseif boyfriend:getAnimName() == "down" then
       --     boyfriendTwo:animate("down", true)
      --  elseif boyfriend:getAnimName() == "down miss" then
        --    boyfriendTwo:animate("down", true)
       -- elseif boyfriend:getAnimName() == "up" then
        --    boyfriendTwo:animate("up", true)
       -- elseif boyfriend:getAnimName() == "up miss" then
       --     boyfriendTwo:animate("up", true)
       -- elseif boyfriend:getAnimName() == "idle" then
      --      boyfriendTwo:animate("idle", false)
      --  end

		if not (countingDown or graphics.isFading()) and not (inst:isPlaying() and voices:isPlaying()) then
			status.setLoading(true)

			graphics.fadeOut(
				0.5,
				function()
					Gamestate.switch(menu)

					status.setLoading(false)
				end
			)
		end

		weeks:updateUI(dt)
	end,

	draw = function(self)
		love.graphics.push()
			love.graphics.translate(graphics.getWidth() / 2, graphics.getHeight() / 2)
			love.graphics.scale(cam.sizeX, cam.sizeY)

			love.graphics.push()
				love.graphics.translate(cam.x * 0.9, cam.y * 0.9)

				bg:draw()

			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x, cam.y)

				enemy:draw()
				bodyOne:draw()
				bodyTwo:draw()
				boyfriend:draw()
				--redThing:draw()
			--	boyfriendTwo:draw()

				if musicTime >= 38709 then
					graphics.setColor(1, 1, 1, fading)
					fading = fading + 0.015
					redThingSize = redThingSize - 0.0004
				--	cameraZoom = cameraZoom + 0.0008

					cam.sizeX, cam.sizeY = cameraZoom, cameraZoom
					camScale.x, camScale.y = cameraZoom, cameraZoom

					if redThingExists then  -- I KNOW TRUE FALSE EXISTS BUT IT NEVER FUCKING WORKS SO I USE 0 AND 1
						redThing:draw() -- :trolleybus:  
						redThing.sizeX, redThing.sizeY = redThingSize, redThingSize
						cameraZoom = cameraZoom + (0.05 * love.timer.getDelta())  --fuck you guglio theres a reason i dont use true false but in this case it did work so i will leave it -- nah you just don't know how to use them lmao
					end
				end

				

				if musicTime > 49161 then
					redThingExists = false
				
					cam.sizeX, cam.sizeY = 1, 1
					camScale.x, camScale.y = 1, 1
				end

			love.graphics.pop()
			love.graphics.push()
				love.graphics.translate(cam.x * 1.1, cam.y * 1.1)

			love.graphics.pop()
			weeks:drawRating(0.9)
		love.graphics.pop()

		weeks:drawUI()
	end,

	leave = function(self)
		bodyOne = nil
		bodyTwo = nil
		bg = nil
		redThing = nil

		weeks:leave()
	end
}
