require("globals")

local bkgLines = {}
local bkgAnimAngle = 0
local selectedAIs = {0,0}
local clickedAI = {0,0}
local clickedName = 0
local hoveredStart, clickedStart = false, false
local hoveredBack, clickedBack = false, false
local boxScroll = {1,1}
local bannerAnim = 0
local teamNames = {"StandardAI","StandardAI"}
local teamColors = {1,2}
local bkgLines = {}
local bkgAnimAngle = 0
local ssAnim = 0

-- color box
local itemSize, spaceX, spaceY = 48, 32, 24

local fadingBlack = false
local fadingData = {}
local fadeSoundData = {}

function updateUIMousePressed(x,y,button)
	if fadingBlack then return end
	local w,h = love.graphics.getDimensions()

	if gameMode == PREMENU then
		-- check for ai selection box
		local x1,y1,w1,h1 = 10, h-aiSelectionBoxDimensions[2]-10, aiSelectionBoxDimensions[1], aiSelectionBoxDimensions[2]
		local x2,y2,w2,h2 = w-aiSelectionBoxDimensions[1]-10, h-aiSelectionBoxDimensions[2]-10, aiSelectionBoxDimensions[1], aiSelectionBoxDimensions[2]
		-- check for color change
		local tx1,ty1,tw1,th1 = w/2 - love.graphics.getFont():getWidth(teamNames[1])/2, h-aiSelectionBoxDimensions[2]-10+20, love.graphics.getFont():getWidth(teamNames[1]), love.graphics.getFont():getHeight(teamNames[1])
		local tx2,ty2,tw2,th2 = w/2 - love.graphics.getFont():getWidth(teamNames[2])/2, h-aiSelectionBoxDimensions[2]-10+220, love.graphics.getFont():getWidth(teamNames[2]), love.graphics.getFont():getHeight(teamNames[2])
		-- time chooser
		local string = playtimeValueToString(gameLength)
		local tw3,th3 = love.graphics.getFont():getWidth(string),love.graphics.getFont():getHeight(string)
		local tcx,tcy = w/2-tw3/2, h-aiSelectionBoxDimensions[2]-10-50-th3

		local i = 0
		if x > x1 and y > y1 and x < x1 + w1 and y < y1 + h1 then
			i = 1
		elseif x > x2 and y > y2 and x < x2 + w2 and y < y2 + h2 then
			i = 2
		elseif x > tx1 and y > ty1 and x < tx1 + tw1 and y < ty1 + th1 then
			i = 3
		elseif x > tx2 and y > ty2 and x < tx2 + tw2 and y < ty2 + th2 then
			i = 4
		elseif x > tcx and y > tcy and x < tcx + tw3 and y < tcy + th3 then
			i = 5
		end

		-- check color box
		if clickedName > 0 then
			local bw, bh = #colors*itemSize + #colors*spaceX + spaceX, spaceY*2 + itemSize
			local cnx,cny = w/2 - bw/2 + spaceX, h-aiSelectionBoxDimensions[2]-10-60+200*(clickedName-1) - bh/2 + spaceY
			for k=0,#colors-1 do
				if x > cnx and y > cny and x < cnx + itemSize and y < cny + itemSize then
					i = 10 + k
				end
				cnx = cnx + itemSize + spaceX
			end
		end

		if button == "wu" then
			if i > 0 and i < 3 then
				boxScroll[i] = boxScroll[i] - 1
				if boxScroll[i] < 1 then boxScroll[i] = 1 end
			elseif i >= 3 and i <= 4 then
				repeat
					teamColors[i-2] = (teamColors[i-2]+1) % #colors + 1
				until teamColors[i-2] ~= teamColors[i%2+1]
			elseif i == 5 then
				gameLength = gameLength + 10
				if gameLength > 600 then
					gameLength = 600
				end
			end
		elseif button == "wd" then
			if i > 0 and i < 3 then
				boxScroll[i] = boxScroll[i] + 1
				if boxScroll[i] > (#aiFiles - aiSelectionBoxMaxVisibleItems) then boxScroll[i] = boxScroll[i] - 1 end
			elseif i >= 3 and i <= 4 then
				repeat
					teamColors[i-2] = (teamColors[i-2]+1) % #colors + 1
				until teamColors[i-2] ~= teamColors[i%2+1]
			elseif i == 5 then
				gameLength = gameLength - 10
				if gameLength < 10 then
					gameLength = 10
				end
			end
		elseif button == "l" then
			aiSelectionBoxHoverColor = aiSelectionBoxClickColor
			if i > 0 and i < 3 then
				clickedAI = selectedAIs
			elseif hoveredStart then
				clickedStart = true
			end

			if i >= 3 and i <= 4 then
				clickedName = i-2
			elseif i >= 10 then
				if teamColors[clickedName%2+1] ~= i-9 then
					teamColors[clickedName] = i - 9
				end
				clickedName = 0
			else
				clickedName = 0
			end

		end
	end
	if (playtime or isGameOver) and button  == "l" then
		aiSelectionBoxHoverColor = aiSelectionBoxClickColor
		if hoveredBack then
			clickedBack = true
		end
	end
end

function updateUIMouseReleased(x,y,button)
	if fadingBlack then return end
	if gameMode == STARTSCREEN then
		fadeBlack(function() gameMode=PREMENU end, 1)
	elseif gameMode == PREMENU then
		if button == "l" then
			aiSelectionBoxHoverColor = aiSelectionBoxHoverColorBk
			if clickedAI[1] ~= 0 then
				teamNames[1] = string.sub(aiFiles[clickedAI[1]], 1, string.len(aiFiles[clickedAI[1]])-4)
			elseif clickedAI[2] ~= 0 then
				teamNames[2] = string.sub(aiFiles[clickedAI[2]], 1, string.len(aiFiles[clickedAI[2]])-4)
			end
			clickedAI = {0,0}
			if clickedStart and hoveredStart then
				clickedStart = false
				fadeInSound(ambienceSound,2)
				fadeOffSound(menuMusic,2)
				fadeBlack(newGame, 1, {teamNames[1], teamNames[2], teamColors[1], teamColors[2]})
			end
		end
	end
	if (playtime or isGameOver) and button  == "l" then
		aiSelectionBoxHoverColor = aiSelectionBoxHoverColorBk
		if hoveredBack and clickedBack then
			fadeOffSound(ambienceSound,1)
			fadeInSound(menuMusic,1)
			clickedBack = false
			fadeBlack(resetGame, 1)
		end
	end
end

function updateUI(dt)
	--updateBackground(dt)
	ssAnim = ssAnim + dt
	bannerAnim = bannerAnim + dt
	bkgAnimAngle = bkgAnimAngle + dt
	if bkgAnimAngle > 360 then
		bkgAnimAngle = 0
	end

	-- handle black fade
	if fadingBlack then
		fadingData.currentTime = fadingData.currentTime + dt
		if (not fadingData.called and fadingData.currentTime > fadingData.length/2 and fadingData.fnToCall) then
			fadingData.called = true
			if fadingData.arguments ~= nil then
				fadingData.fnToCall(unpack(fadingData.arguments))
			else
				fadingData.fnToCall()
			end
		end
		if (fadingData.currentTime >= fadingData.length) then
			fadingBlack = false
		end
	end

	-- handle sound fades
	for k,v in pairs(fadeSoundData) do
		v.length = v.length + v.fadeDirection * dt
		v.sound:setVolume(v.startVolume*v.length/v.startLength)
		if (v.length <= 0) then
			v.sound:stop()
			v.sound:rewind()
			v.sound:setVolume(v.startVolume)
		elseif (v.length > v.startLength) then
			v.sound:setVolume(v.startVolume)
		end
	end
	for k,v in pairs(fadeSoundData) do
		if (v.length <= 0 or v.length > v.startLength) then
			fadeSoundData[k] = nil
		end
	end
end

function fadeBlack(fnToCall, length, args)
	fadingBlack = true
	fadingData.called = false
	fadingData.fnToCall = fnToCall
	fadingData.arguments = args
	fadingData.length = length
	fadingData.currentTime = 0
end

function fadeOffSound(sound, length)
	local fosd = {}
	fosd.fadeDirection = -1
	fosd.startVolume = sound:getVolume()
	fosd.sound = sound
	fosd.startLength = length
	fosd.length = length
	table.insert(fadeSoundData, fosd)
end

function fadeInSound(sound, length)
	local fosd = {}
	fosd.fadeDirection = 1
	fosd.startVolume = sound:getVolume()
	fosd.sound = sound
	fosd.startLength = length
	fosd.length = 0
	fosd.sound:setVolume(0)
	fosd.sound:play()
	table.insert(fadeSoundData, fosd)
end

function drawUI()
	local w,h = love.graphics.getDimensions()
	if gameMode == STARTSCREEN then
		drawStartScreen()
	elseif gameMode == PREMENU then
		drawBanner()
		drawAISelectBox(1, 10, h-aiSelectionBoxDimensions[2]-10, aiSelectionBoxDimensions[1], aiSelectionBoxDimensions[2])
		drawAISelectBox(2, w-aiSelectionBoxDimensions[1]-10, h-aiSelectionBoxDimensions[2]-10, aiSelectionBoxDimensions[1], aiSelectionBoxDimensions[2])
		drawTeamNames()
		drawStartButton()
		drawPlayingTimeChooser()
		if clickedName > 0 then drawColorSelectBox(w/2, h-aiSelectionBoxDimensions[2]-10-60+200*(clickedName-1)) end
	elseif gameMode == INGAME then
		drawChatWindow()
		drawIngameUI()
		if (playtime or isGameOver) then
			drawBackButton()
		end
	end
	drawFadeBlack()
end

function drawStartScreen()
	local w,h = love.graphics.getDimensions()
	love.graphics.setColor(127, math.sin(bannerAnim) * 128 + 127, math.cos(bannerAnim) * 128 + 127, 255)
	love.graphics.setFont(startScreenFont)
	local tw,th = love.graphics.getFont():getWidth("BOTSOCCER"),love.graphics.getFont():getHeight("BOTSOCCER")
	love.graphics.print("BOTSOCCER", w/2-tw/2, h/2-th/2)
	love.graphics.setFont(mainFont)
	love.graphics.setColor(255,255,255,127+math.sin(ssAnim)*128)
	local tw,th = love.graphics.getFont():getWidth("Press a key"),love.graphics.getFont():getHeight("Press a key")
	love.graphics.print("Press a key", w/2-tw/2, 3*h/4-th/2)
	love.graphics.setFont(chatFont)
	love.graphics.setColor(255,255,255,255)
	local string = "Version " .. tostring(VERSION_MAJOR) .. "." .. tostring(VERSION_MINOR)
	tw, th = love.graphics.getFont():getWidth(string),love.graphics.getFont():getHeight(string)
	love.graphics.print(string, w-tw-3, h-th-3)
	love.graphics.setFont(mainFont)
end

function drawFadeBlack()
	if not fadingBlack then return end
	local alpha = (-255/(fadingData.length*fadingData.length/4)) * (fadingData.currentTime-fadingData.length/2) * (fadingData.currentTime-fadingData.length/2) + 255
	love.graphics.setColor(0, 0, 0, alpha)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
end

function drawBanner()
	local w,h = love.graphics.getDimensions()
	love.graphics.setColor(127, math.sin(bannerAnim) * 128 + 127, math.cos(bannerAnim) * 128 + 127, 255)
	love.graphics.setFont(goalFontBig)
	local tw = love.graphics.getFont():getWidth("BOTSOCCER")
	love.graphics.print("BOTSOCCER", w/2-tw/2, 100)
	love.graphics.setFont(mainFont)
end

function drawPlayingTimeChooser()
	local w,h = love.graphics.getDimensions()
	love.graphics.setFont(mainFont)
	local string = playtimeValueToString(gameLength)
	local tw,th = love.graphics.getFont():getWidth(string),love.graphics.getFont():getHeight(string)
	local x,y = w/2-tw/2, h-aiSelectionBoxDimensions[2]-10-50-th
	local mx,my = love.mouse.getPosition()
	if (x < mx and mx < x+tw and y < my and my < y+th) then
		love.graphics.setColor(100,100,100)
		love.graphics.print(string, w/2-tw/2+2, h-aiSelectionBoxDimensions[2]-10-50-th+2)
	end
	love.graphics.setColor(180,180,180)
	love.graphics.print(string, w/2-tw/2, h-aiSelectionBoxDimensions[2]-10-50-th)
	local tw2,th2 = love.graphics.getFont():getWidth("Time"),love.graphics.getFont():getHeight("Time")
	love.graphics.print("Time", w/2-tw2/2, h-aiSelectionBoxDimensions[2]-10-50-th-10-th2)
end

function drawBackground()
	--for k,v in pairs(bkgLines) do
		--local x = 1-v.lifetime/v.maxlifetime
		--love.graphics.setColor(20,20,20, -1020*(x - 0.5)*(x - 0.5) + 255)
		--love.graphics.rectangle("fill",v.position[1], v.position[2], v.length, 3)
	--end
	local w,h = love.graphics.getDimensions()
	local bw,bh = backgroundTexture:getDimensions()
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(backgroundTexture, w/2,h/2,math.rad(bkgAnimAngle), 1,1, bw/2,bh/2)
	--love.graphics.draw(overlayTexture, 0,0)
end

function drawStartButton()
	local w,h = love.graphics.getDimensions()
	local mx,my = love.mouse.getPosition()
	local x,y = w/2-startButtonSize[1]/2,h-100
	if mx > x and mx < x+startButtonSize[1] and my > y and my < y+startButtonSize[2] then
		love.graphics.setColor(aiSelectionBoxHoverColor)
		hoveredStart = true
	else
		love.graphics.setColor(100,100,100,35)
		hoveredStart = false
	end
	love.graphics.rectangle("fill", x, y, startButtonSize[1], startButtonSize[2])
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("line", x, y, startButtonSize[1], startButtonSize[2])
	local tw,th = love.graphics.getFont():getWidth("Start"), love.graphics.getFont():getHeight("Start")
	love.graphics.setColor(200,200,200,200)
	love.graphics.print("Start", x+startButtonSize[1]/2-tw/2, y+startButtonSize[2]/2-th/2)
end

function drawBackButton()
	local w,h = love.graphics.getDimensions()
	local mx,my = love.mouse.getPosition()
	local x,y = 10,h-10-backButtonSize[2]
	if mx > x and mx < x+backButtonSize[1] and my > y and my < y+backButtonSize[2] then
		love.graphics.setColor(aiSelectionBoxHoverColor)
		hoveredBack = true
	else
		love.graphics.setColor(100,100,100,35)
		hoveredBack = false
	end
	love.graphics.rectangle("fill", x, y, backButtonSize[1], backButtonSize[2])
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("line", x, y, backButtonSize[1], backButtonSize[2])
	local tw,th = love.graphics.getFont():getWidth("Back"), love.graphics.getFont():getHeight("Back")
	love.graphics.setColor(200,200,200,200)
	love.graphics.print("Back", x+backButtonSize[1]/2-tw/2, y+backButtonSize[2]/2-th/2)
end

function drawTeamNames()
	love.graphics.setFont(mainFont)
	local w,h = love.graphics.getDimensions()
	local x,y = w/2 - love.graphics.getFont():getWidth(teamNames[1])/2, h-aiSelectionBoxDimensions[2]-10+20
	love.graphics.setColor(0,0,0,255)
	love.graphics.print(teamNames[1],x+2,y+2)
	--love.graphics.setColor(200,200,200,200)
	love.graphics.setColor(colors[teamColors[1]])
	love.graphics.print(teamNames[1],x,y)
	x,y = w/2 - love.graphics.getFont():getWidth("vs")/2, h-aiSelectionBoxDimensions[2]-10+120
	love.graphics.setColor(0,0,0,255)
	love.graphics.print("vs",x+2,y+2)
	love.graphics.setColor(200,200,200,200)
	love.graphics.print("vs",x,y)
	x,y = w/2 - love.graphics.getFont():getWidth(teamNames[2])/2, h-aiSelectionBoxDimensions[2]-10+220
	love.graphics.setColor(0,0,0,255)
	love.graphics.print(teamNames[2],x+2,y+2)
	--love.graphics.setColor(200,200,200,200)
	love.graphics.setColor(colors[teamColors[2]])
	love.graphics.print(teamNames[2],x,y)
	love.graphics.setFont(mainFont)
end

function updateBackground(dt)
	for k,v in pairs(bkgLines) do
		v.position = {v.position[1]+v.velocity[1]*dt, v.position[2]+v.velocity[2]*dt}
		v.lifetime = v.lifetime - dt
		if v.lifetime <= 0 then
			bkgLines[k] = nil
		end
	end
end

function addBackgroundLine()
	local line = {}
	local w,h = love.graphics.getDimensions()
	line.position = {w*math.random(),h*math.random()}
	line.length = 300 * math.random()
	line.lifetime = math.random(4,10)
	line.maxlifetime = line.lifetime
	line.velocity = {math.random(-8,8),math.random(-8,8)}
	table.insert(bkgLines, line)
end

function initializeUI()
	--addTimer(0.3, addBackgroundLine, true, true)
	teamNames[1] = string.sub(aiFiles[1], 1, string.len(aiFiles[1])-4)
	teamNames[2] = teamNames[1]
end

function drawChatWindow()
	local w,h = love.graphics.getDimensions()
	local x,y = w/2-fieldWidth/2, h/2+fieldHeight/2+goalDepth+20
	local nummsgs = #messages
	local chatstart = nummsgs-math.floor((h-10-y)/18)
	if chatstart <= 0 then chatstart = 1 end

	love.graphics.setColor(100,100,100,35)
	love.graphics.rectangle("fill", x-1, y, fieldWidth+2, h-10-y)
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("line", x-1, y, fieldWidth+2, h-10-y)
	love.graphics.setFont(chatFont)
	for i=chatstart, nummsgs do
		love.graphics.setColor(10,10,10,255)
		love.graphics.print(messages[i].team.name .. ": " .. messages[i].message, 2 + x + 5, 2 + y + 5 + 16 * (i-chatstart))
		love.graphics.setColor(messages[i].team.color)
		love.graphics.print(messages[i].team.name .. ": " .. messages[i].message, x + 5, y + 5 + 16 * (i-chatstart))
	end
	love.graphics.setFont(mainFont)
end

function drawColorSelectBox(x,y)
	local w,h = love.graphics.getDimensions()
	local bw, bh = #colors*itemSize + #colors*spaceX + spaceX, spaceY*2 + itemSize
	local mx,my = love.mouse.getPosition()
	x,y = x-bw/2, y-bh/2
	love.graphics.setColor(0,0,0,70)
	love.graphics.rectangle("fill",x,y,bw,bh)
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("line",x,y,bw,bh)
	local currX,currY = x+spaceX, y+spaceY
	for i=0,#colors-1 do
		love.graphics.setColor(colors[i+1])
		love.graphics.rectangle("fill", currX, currY, itemSize, itemSize)
		if mx > currX and mx < currX + itemSize and my > currY and my < currY + itemSize then
			love.graphics.setColor(255,255,255,255)
		else
			love.graphics.setColor(0,0,0,255)
		end
		love.graphics.rectangle("line", currX, currY, itemSize, itemSize)
		currX = currX+itemSize+spaceX
	end
end

function drawAISelectBox(n,x,y,w,h)
	love.graphics.setColor(20,20,20,100)
	love.graphics.rectangle("fill", x, y, w, h)
	love.graphics.setColor(0,0,0,255)
	--love.graphics.setColor(0, math.sin(bannerAnim) * 128 + 127, 0, 255)
	love.graphics.rectangle("line", x, y, w, h)
	local i = 0
	love.graphics.setFont(chatFont)
	selectedAIs[n] = 0
	for i=boxScroll[n], #aiFiles do
		v = aiFiles[i]
		local ainame = string.sub(v, 1, string.len(v)-4)
		local mx,my = love.mouse.getPosition()
		if mx > x and mx < x + w and my > y + (i-boxScroll[n])*aiSelectionBoxItemHeight and my < y + (i+1-boxScroll[n])*aiSelectionBoxItemHeight then
			--if love.mouse.isDown("l") then
			--	love.graphics.setColor(aiSelectionBoxClickColor)
			--else
				love.graphics.setColor(aiSelectionBoxHoverColor)
			--end
			love.graphics.rectangle("fill", x+1, y+(i-boxScroll[n])*aiSelectionBoxItemHeight+1, w-2, aiSelectionBoxItemHeight-1)
			selectedAIs[n] = i
		end
		local th = love.graphics.getFont():getHeight(ainame)
		love.graphics.setColor(200,200,200,255)
		love.graphics.print(ainame, x + 10, y + (aiSelectionBoxItemHeight/2-th/2) + (i-boxScroll[n]) * aiSelectionBoxItemHeight)
	end
end

function playtimeValueToString(v)
	local string = tostring(math.floor(v/60)) .. ":"
	if v % 60 < 10 then string = string .. "0" ..  tostring(math.floor(v % 60))
	elseif v % 60 == 0 then string = string .. "00"
	else string = string .. tostring(math.floor(v % 60))
	end
	return string
end

function drawIngameUI()
	local w,h  = love.graphics.getDimensions()

	love.graphics.setFont(mainFont)
	local tw = love.graphics.getFont():getWidth(teams[1].score .. " - " .. teams[2].score)
	love.graphics.setColor(40,40,40,255)
	love.graphics.print(teams[1].score .. " - " .. teams[2].score, w/2-tw/2+2, 80+2)
	love.graphics.setColor(200,200,200)
	love.graphics.print(teams[1].score .. " - " .. teams[2].score, w/2-tw/2, 80)

	local tw2 = love.graphics.getFont():getWidth(teams[1].name)
	local margin = 50
	love.graphics.setColor(40,40,40,255)
	love.graphics.print(teams[1].name, w/2-tw/2+2-margin-tw2, 80+2)
	love.graphics.setColor(200,200,200)
	love.graphics.print(teams[1].name, w/2-tw/2-margin-tw2, 80)

	love.graphics.setColor(40,40,40,255)
	love.graphics.print(teams[2].name, w/2+tw/2+2+margin, 80+2)
	love.graphics.setColor(200,200,200)
	love.graphics.print(teams[2].name, w/2+tw/2+margin, 80)

	local string = playtimeValueToString(getRemainingTime(gameTimer))

	tw = mainFont:getWidth(string)
	love.graphics.setColor(40,40,40,255)
	love.graphics.print(string, w/2-tw/2+2, 20+2)
	love.graphics.setColor(200,200,200)
	love.graphics.print(string, w/2-tw/2, 20)

	if isTimerEnabled(countdownTimer) then
		love.graphics.setFont(goalFont)
		string = tostring(math.floor(getRemainingTime(countdownTimer)+1))
		tw = goalFont:getWidth(string)
		local th = goalFont:getHeight(string)
		love.graphics.setColor(255,255,255, 255*((getRemainingTime(countdownTimer)-math.floor(getRemainingTime(countdownTimer)))))
		love.graphics.print(string, w/2-tw/2, h/2-th/2)
		love.graphics.setFont(mainFont)
	end

	if isTimerEnabled(goalTimer) then
		love.graphics.setFont(goalFontBig)
		love.graphics.setColor(10,10,10)
		tw = goalFontBig:getWidth("Goal!")
		local th = goalFontBig:getHeight("Goal!")
		love.graphics.print("Goal!", w/2-tw/2, h/2-th/2)
		--
		--love.graphics.setFont(goalFont)
		love.graphics.setColor(teams[lastTeamGoal].color)
		--tw = goalFont:getWidth("Goal!")
		--th = goalFont:getHeight("Goal!")
		love.graphics.print("Goal!", w/2-tw/2-3, h/2-th/2-3)
		love.graphics.setFont(mainFont)
	end
	-- Game over
	if isGameOver then
		love.graphics.setFont(goalFontBig)
		love.graphics.setColor(255,255,255)
		local string = "Draw"
		if teams[1].score > teams[2].score then
			string = teams[1].name .. " wins!"
		elseif teams[1].score < teams[2].score then
			string = teams[2].name .. " wins!"
		end
		tw = goalFontBig:getWidth(string)
		local th = goalFontBig:getHeight(string)
		love.graphics.print(string, w/2-tw/2, h/2-th/2)
		love.graphics.setFont(mainFont)
	end
end
