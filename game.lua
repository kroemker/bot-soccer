function newGame(team1,team2,team1Color, team2Color)
    local w,h = love.graphics.getDimensions()

	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)

	objects = {}
	-- the ball
    objects.ball = {}
    objects.ball.body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()/2, "dynamic")
    objects.ball.shape = love.physics.newCircleShape(8)
    objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)
    objects.ball.fixture:setRestitution(0.2) --0.7 (0.2 gut)
    objects.ball.body:setLinearDamping(1)
	objects.ball.fixture:setFilterData(8,8,1)

	addBlock(love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2-fieldHeight/2-goalDepth, fieldWidth+2*goalDepth, goalDepth, true, false, false)
	addBlock(love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2+fieldHeight/2, fieldWidth+2*goalDepth, goalDepth, true, false, false)
	addBlock(love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2-fieldHeight/2, goalDepth, fieldHeight/2-goalSize/2, true, false, false)
	addBlock(love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2+goalSize/2, goalDepth, fieldHeight/2-goalSize/2, true, false, false)
	addBlock(love.graphics.getWidth()/2+fieldWidth/2, love.graphics.getHeight()/2-fieldHeight/2, goalDepth, fieldHeight/2-goalSize/2, true, false, false)
	addBlock(love.graphics.getWidth()/2+fieldWidth/2, love.graphics.getHeight()/2+goalSize/2, goalDepth, fieldHeight/2-goalSize/2, true, false, false)

	addEdgeBoundary(love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2-fieldHeight/2-goalDepth, love.graphics.getWidth()/2+fieldWidth/2+goalDepth, love.graphics.getHeight()/2-fieldHeight/2-goalDepth)
	addEdgeBoundary(love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2+fieldHeight/2+goalDepth, love.graphics.getWidth()/2+fieldWidth/2+goalDepth, love.graphics.getHeight()/2+fieldHeight/2+goalDepth)
	addEdgeBoundary(love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2-fieldHeight/2-goalDepth, love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2+fieldHeight/2+goalDepth)
	addEdgeBoundary(love.graphics.getWidth()/2+fieldWidth/2+goalDepth, love.graphics.getHeight()/2-fieldHeight/2-goalDepth, love.graphics.getWidth()/2+fieldWidth/2+goalDepth, love.graphics.getHeight()/2+fieldHeight/2+goalDepth)

	addCircleBoundary(w/2-fieldWidth/2-blockZoneRadius+blockZoneSize, h/2, blockZoneRadius, false, true, false)
	addCircleBoundary(w/2+fieldWidth/2+blockZoneRadius-blockZoneSize, h/2, blockZoneRadius, false, false, true)
	calculateCircleBoundaries(50)

    addTeam(team1, team1Color)
	addTeam(team2, team2Color)

    -- players
    objects.players = {}
    addNewPlayer(1,w/2-fieldWidth/8,h/2,1)
    addNewPlayer(1,w/2-3*fieldWidth/8,h/2,2)
    addNewPlayer(1,w/2-fieldWidth/4,h/2-fieldHeight/4,3)
    addNewPlayer(1,w/2-fieldWidth/4,h/2+fieldHeight/4,4)
    addNewPlayer(2,w/2+fieldWidth/8,h/2,1)
    addNewPlayer(2,w/2+3*fieldWidth/8,h/2,2)
    addNewPlayer(2,w/2+fieldWidth/4,h/2-fieldHeight/4,3)
    addNewPlayer(2,w/2+fieldWidth/4,h/2+fieldHeight/4,4)

    initializeAIEnvironment()
	initializing = true
    for k,v in pairs(teams) do
		if v.AI then
	        if type(v.AI.initialize) == "function" then
	            currentAITeam = k
	            --setfenv(v.AI.initialize, sandbox_env)
	            local status,result = pcall(v.AI.initialize)
	            if not status then
					addMessage(v, result)
					addMessage(v, "Initialization failed!")
				end
	        end
		end
    end
	initializing = false
    resetPosition()

    gameMode = INGAME
	setTimerTime(gameTimer,gameLength)
    continueTimer(countdownTimer)
end

function limitVelocity(playerLimit, ballLimit)
	for k,v in pairs(objects.players) do
		local vx,vy = v.body:getLinearVelocity()
		vx, vy = limitVector(vx, vy, playerLimit)
		v.body:setLinearVelocity(vx,vy)
	end

	local vx,vy = objects.ball.body:getLinearVelocity()
	vx, vy = limitVector(vx, vy, ballLimit)
	objects.ball.body:setLinearVelocity(vx,vy)
end

function limitVector(vx, vy, limit)
	local squaredLength = vx * vx + vy * vy
	if squaredLength > limit * limit then
		local nvx, nvy = normalize(vx, vy)
		return nvx * limit, nvy * limit
	end
	return vx, vy
end

function calculateCircleBoundaries(segments)
	local w,h = love.graphics.getDimensions()
	circleBoundaryLeft = {}
	local basex, basey = w/2-fieldWidth/2-blockZoneRadius+blockZoneSize, h/2
	local angle = math.acos((blockZoneRadius-blockZoneSize)/blockZoneRadius)
	local step = 2*angle/segments
	for i=0,segments do
		local cx,cy = basex + math.cos(angle-step*i) * blockZoneRadius, basey + math.sin(angle-step*i) * blockZoneRadius
		table.insert(circleBoundaryLeft, cx)
		table.insert(circleBoundaryLeft, cy)
	end

	circleBoundaryRight = {}
	local basex, basey = w/2+fieldWidth/2+blockZoneRadius-blockZoneSize, h/2
	local angle = math.acos(-(blockZoneRadius-blockZoneSize)/blockZoneRadius)
	local step = 2*(math.pi-angle)/segments
	for i=0,segments do
		local cx,cy = basex + math.cos(angle+step*i) * blockZoneRadius, basey - math.sin(angle+step*i) * blockZoneRadius
		table.insert(circleBoundaryRight, cx)
		table.insert(circleBoundaryRight, cy)
	end
end

function resetGame()
    gameMode = PREMENU
	playtime = false
    messages = {}
    teams = {}
    isGameOver = false
    resetTimer(countdownTimer)
	pauseTimer(gameTimer)
    resetTimer(gameTimer)
end

function resetPosition()
	local w,h = love.graphics.getDimensions()
    objects.ball.body:setPosition(w/2, h/2-middleCircleRadius+math.random(10,middleCircleRadius*2-10))
    objects.ball.body:setLinearVelocity(0,0)
    for k,v in pairs(objects.players) do
		local v1,v2,dist = vector(w/2,h/2,v.initialPosition[1], v.initialPosition[2])
		if dist < middleCircleRadius then
			if dist == 0 then
				v.body:setPosition(v.initialPosition[1]-middleCircleRadius+(v.team-1)*2*middleCircleRadius, h/2)
			else
				v1,v2 = normalize(v1,v2,dist)
				v.body:setPosition(w/2+v1*middleCircleRadius, h/2+v2*middleCircleRadius)
			end
		else
	        v.body:setPosition(v.initialPosition[1], v.initialPosition[2])
		end

        v.body:setLinearVelocity(0,0)
    end
    resetTimer(countdownTimer)
    continueTimer(countdownTimer)
end

function informAIsOnGoal()
	for k,v in pairs(teams) do
		if v.AI then
			if type(v.AI.onGoal) == "function" then
				currentAITeam = k
				local status,result = pcall(v.AI.onGoal)
				if not status then
					v.error = true
					addMessage(v,result)
				end
			end
		end
	end
end

function informAIsOnFinish()
	finalizing = true
	for k,v in pairs(teams) do
		if v.AI then
			if type(v.AI.finalize) == "function" then
				currentAITeam = k
				local status,result = pcall(v.AI.finalize)
				if not status then
					v.error = true
					addMessage(v,result)
				end
			end
		end
	end
	if restartAttr then
		local t1n,t2n,t1c,t2c = teams[1].name,teams[2].name,teams[1].colorIndex,teams[2].colorIndex
		resetGame()
		newGame(t1n,t2n,t1c,t2c)
	end
	restartAttr = false
	finalizing = false
end

function handleGoal()
    local w,h = love.graphics.getDimensions()
    if (objects.ball.body:getX() < w/2-fieldWidth/2) then
        teams[2].score = teams[2].score + 1
        resetTimer(goalTimer)
        continueTimer(goalTimer)
        pauseTimer(gameTimer)
        playtime = false
        lastTeamGoal = 2
		informAIsOnGoal()
		goalSounds[math.random(1, numberOfGoalSounds)]:play()
		whistleSound:play()
    elseif (objects.ball.body:getX() > w/2+fieldWidth/2) then
        teams[1].score = teams[1].score + 1
        resetTimer(goalTimer)
        continueTimer(goalTimer)
        pauseTimer(gameTimer)
        playtime = false
        lastTeamGoal = 1
		informAIsOnGoal()
		goalSounds[math.random(1, numberOfGoalSounds)]:play()
		whistleSound:play()
    end
end

function shoot(p, vx, vy, power)
    resetTimer(p.shootTimer)
    continueTimer(p.shootTimer)
    local v1,v2,dist = vector(p.body:getX(),p.body:getY(), objects.ball.body:getX(), objects.ball.body:getY())
    if dist < shootDistance then
        v1,v2 = normalize(v1,v2,dist)
        objects.ball.body:applyForce(power*vx,power*vy)
		local soundno = math.random(1,numberOfHitSounds)
		if hitSounds[soundno]:isPlaying() then
			hitSounds[soundno]:stop()
		end
		love.audio.play(hitSounds[soundno])
    end
end

function addMessage(team, msg)
	local message = {}
	message.team = team
	message.message = msg
	table.insert(messages, message)
end

function addTeam(name, color)
	local team = {}
	team.score = 0
	team.colorIndex = color
	team.color = colors[color]
	team.name = name
	team.markedPoint = {-100,-100}
	team.markedLine = {-100,-100,-100,-100}
	team.error = false
	team.AI, err = loadAI(team.name)
	if not team.AI then
		addMessage(team,err)
		team.error = true
	end
	table.insert(teams, team)
end

function addNewPlayer(team, x, y, backnumber)
    local player = {}
    player.initialPosition = {x,y}
    player.body = love.physics.newBody(world, x,y, "dynamic")
    player.shape = love.physics.newCircleShape(14)
    player.fixture = love.physics.newFixture(player.body, player.shape, 1.6)
    player.fixture:setRestitution(0.3)
	if backnumber == 1 then
		player.fixture:setFilterData(0,0,1)
	else
		player.fixture:setFilterData(team,team,1)
	end
    player.body:setLinearDamping(1)
    player.team = team
	player.backnumber = backnumber
    player.shootTimer = addTimer(0.1, nil, false)
	player.markedLine = {-100,-100,-100,-100}
	player.markedPoint = {-100,-100}
	player.name = ""
    table.insert(objects.players, player)
end

function addEdgeBoundary(x1,y1,x2,y2)
	local edge = {}
	edge.body = love.physics.newBody(world, 0,0)
	edge.shape = love.physics.newEdgeShape(x1, y1, x2, y2)
	edge.fixture = love.physics.newFixture(edge.body, edge.shape, 5)
	edge.fixture:setFilterData(0,0,1)
	table.insert(objects, edge)
end

function addBlock(x, y, w, h, blockBall, blockT1, blockT2)
	local block = {}
	block.body = love.physics.newBody(world, x+w/2, y+h/2)
    block.shape = love.physics.newRectangleShape(0, 0, w, h)
    block.fixture = love.physics.newFixture(block.body, block.shape, 5)
	local category = 0
	if blockBall then category = category + 8 end
	if blockT2 then category = category + 2 end
	if blockT1 then category = category + 1 end
	block.fixture:setFilterData(category, 8+2+1, 0)
	table.insert(objects, block)
end

function addCircleBoundary(x, y, r, blockBall, blockT1, blockT2)
	local circle = {}
	circle.body = love.physics.newBody(world, x, y)
    circle.shape = love.physics.newCircleShape(r)
    circle.fixture = love.physics.newFixture(circle.body, circle.shape, 5)
	local category = 0
	if blockBall then category = category + 8 end
	if blockT2 then category = category + 2 end
	if blockT1 then category = category + 1 end
	circle.fixture:setFilterData(category, 8+2+1, 0)
	table.insert(objects, circle)
end

function gameOver()
	whistleEndSound:play()
    playtime = false
    isGameOver = true
	informAIsOnFinish()
end

function startGame()
	whistleSound:play()
    playtime = true
    continueTimer(gameTimer)
end

function loadAI(filename)
	-- open file
	local file = io.open("AI/" .. filename .. ".lua", "r")
	local content = file:read("*all")
	file:close()
    -- execute code safely
    local status, result = runInSandbox(content)
	-- read data and check for errors
	if not status then return nil,result end

	if type(result.update) ~= "function" then
		return nil,"An AI needs at least an update method implementation!"
	end

	return result,""
end

function runInSandbox(code)
	if code:byte(1) == 27 then return false, "Binary code prohibited" end
	local fn, msg = loadstring(code)
	if not fn then return false, msg end
	setfenv(fn, sandbox_env)
	return pcall(fn)
end

function drawField()
	-- field
	--setDrawingColorInUnitSpace(20,150,20,255)
	--love.graphics.rectangle("fill", love.graphics.getWidth()/2-fieldWidth/2, love.graphics.getHeight()/2-fieldHeight/2, fieldWidth, fieldHeight)
	--love.graphics.rectangle("fill", love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2-goalSize/2, goalDepth, goalSize)
	--love.graphics.rectangle("fill", love.graphics.getWidth()/2+fieldWidth/2, love.graphics.getHeight()/2-goalSize/2, goalDepth, goalSize)
	setDrawingColorInUnitSpace(255,255,255,255)
	--love.graphics.draw(grassTexture, fieldQuad, love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2-fieldHeight/2)
	love.graphics.draw(grassTexture, fieldQuad, love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2-fieldHeight/2-goalDepth)
	--love.graphics.draw(fieldMesh, 0, 0)
	--love.graphics.draw(grassTexture, goalQuad, love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2-goalSize/2)
	--love.graphics.draw(grassTexture, goalQuad, love.graphics.getWidth()/2+fieldWidth/2, love.graphics.getHeight()/2-goalSize/2)
	--setDrawingColorInUnitSpace(10,10,10,255)
	--love.graphics.rectangle("fill", love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2-fieldHeight/2, goalDepth, fieldHeight/2-goalSize/2)
	--love.graphics.rectangle("fill", love.graphics.getWidth()/2-fieldWidth/2-goalDepth, love.graphics.getHeight()/2+goalSize/2, goalDepth, fieldHeight/2-goalSize/2)
	--love.graphics.rectangle("fill", love.graphics.getWidth()/2+fieldWidth/2, love.graphics.getHeight()/2-fieldHeight/2, goalDepth, fieldHeight/2-goalSize/2)
	--love.graphics.rectangle("fill", love.graphics.getWidth()/2+fieldWidth/2, love.graphics.getHeight()/2+goalSize/2, goalDepth, fieldHeight/2-goalSize/2)
	-- lines on field
	local w,h  = love.graphics.getDimensions()
	setDrawingColorInUnitSpace(255,255,255,180)
	love.graphics.setLineWidth(2)
	--love.graphics.line(w/2-fieldWidth/2, h/2-fieldHeight/2+slopeOffset, w/2-fieldWidth/2, h/2+fieldHeight/2-slopeOffset, w/2-fieldWidth/2+slopeOffset, h/2+fieldHeight/2,
	--				   w/2+fieldWidth/2-slopeOffset, h/2+fieldHeight/2, w/2+fieldWidth/2, h/2+fieldHeight/2-slopeOffset, w/2+fieldWidth/2, h/2-fieldHeight/2+slopeOffset,
	--				   w/2+fieldWidth/2-slopeOffset, h/2-fieldHeight/2, w/2-fieldWidth/2+slopeOffset, h/2-fieldHeight/2, w/2-fieldWidth/2, h/2-fieldHeight/2+slopeOffset)
	love.graphics.rectangle("line", w/2-fieldWidth/2, h/2-fieldHeight/2, fieldWidth, fieldHeight)
	love.graphics.line(w/2, h/2-fieldHeight/2, w/2, h/2+fieldHeight/2)
	love.graphics.circle("line", w/2, h/2, middleCircleRadius)
	love.graphics.rectangle("line", w/2-fieldWidth/2-goalDepth, h/2-goalSize/2, goalDepth, goalSize)
	love.graphics.rectangle("line", w/2+fieldWidth/2, h/2-goalSize/2, goalDepth, goalSize)
	--love.graphics.rectangle("line", w/2-fieldWidth/2, h/2-blockZoneHeight/2, blockZoneWidth, blockZoneHeight)
	--love.graphics.rectangle("line", w/2+fieldWidth/2-blockZoneWidth, h/2-blockZoneHeight/2, blockZoneWidth, blockZoneHeight)
	setDrawingColorInUnitSpace(255,255,255,255)
	love.graphics.rectangle("fill", w/2-fieldWidth/2-postSize/2, h/2-goalSize/2-postSize/2, postSize, postSize)
	love.graphics.rectangle("fill", w/2-fieldWidth/2-postSize/2, h/2+goalSize/2-postSize/2, postSize, postSize)
	love.graphics.rectangle("fill", w/2+fieldWidth/2-postSize/2, h/2-goalSize/2-postSize/2, postSize, postSize)
	love.graphics.rectangle("fill", w/2+fieldWidth/2-postSize/2, h/2+goalSize/2-postSize/2, postSize, postSize)
	--love.graphics.circle("line", w/2-fieldWidth/2-blockZoneRadius+blockZoneSize, h/2, blockZoneRadius)
	--love.graphics.circle("line", w/2+fieldWidth/2+blockZoneRadius-blockZoneSize, h/2, blockZoneRadius)
	love.graphics.line(circleBoundaryLeft)
	love.graphics.line(circleBoundaryRight)

	setDrawingColorInUnitSpace(0,0,0,255)
	love.graphics.rectangle("line", w/2-fieldWidth/2-goalDepth-1, h/2-fieldHeight/2-goalDepth-1, fieldWidth+2*goalDepth+2, fieldHeight+2*goalDepth+2)

	-- ai marked points
	for k,v in pairs(objects.players) do
		setDrawingColorInUnitSpace(teams[v.team].color)
		if v.markedPoint[1] > 0 and v.markedPoint[2] > 0 then
			love.graphics.circle("fill", v.markedPoint[1], v.markedPoint[2], 4)
		end
		if v.markedLine[1] > 0 and v.markedLine[2] > 0 and v.markedLine[3] > 0 and v.markedLine[4] > 0 then
			love.graphics.line(v.markedLine[1], v.markedLine[2], v.markedLine[3], v.markedLine[4])
		end
	end

	-- ball
	setDrawingColorInUnitSpace(200,200,200,255)
	love.graphics.setLineWidth(1)
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())
	setDrawingColorInUnitSpace(10,10,10)
	love.graphics.circle("line", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

	-- players
	for k,v in pairs(objects.players) do
		setDrawingColorInUnitSpace(teams[v.team].color)
		love.graphics.circle("fill", v.body:getX(), v.body:getY(), v.shape:getRadius())
		if isTimerEnabled(v.shootTimer) then
			setDrawingColorInUnitSpace(200,200,200)
		else
			setDrawingColorInUnitSpace(10,10,10)
		end
		love.graphics.circle("line", v.body:getX(), v.body:getY(), v.shape:getRadius())
		love.graphics.setFont(backnumberFont)
		local wbn,hbn = love.graphics.getFont():getWidth(v.backnumber), love.graphics.getFont():getHeight(v.backnumber)
		love.graphics.print(v.backnumber, v.body:getX()-wbn/2, v.body:getY()-hbn/2)
	end

	-- player names
	love.graphics.setFont(backnumberFont)
	for k,v in pairs(objects.players) do
		setDrawingColorInUnitSpace(200,200,200)
		local tnw,tnh = love.graphics.getFont():getWidth(v.name), love.graphics.getFont():getHeight(v.name)
		love.graphics.print(v.name, v.body:getX()-tnw/2, v.body:getY()-tnh-18)
	end
end
