require("globals")
require("game")

function toFieldPosition(x,y)
	return x - (love.graphics.getWidth()/2-fieldWidth/2), y - (love.graphics.getHeight()/2-fieldHeight/2)
end

function toWindowPosition(x,y)
	return x + (love.graphics.getWidth()/2-fieldWidth/2),  y + (love.graphics.getHeight()/2-fieldHeight/2)
end

function toPixelVelocity(vx,vy)
	return vx*64, vy*64
end

function isValidNumber(x)
	return (type(x) == "number" and not(x ~= x) and x ~= math.huge)
end

function isValidPlayerNumber(i)
	return (i >= 1 and i <= numberOfPlayersPerTeam)
end

function isValidRelativePosition(x,y)
	return (x >= 0 and x <= 1 and y >= 0 and y <= 1)
end

function isInFieldBounds(x,y)
	return (x >= -goalDepth and x <= fieldWidth+2*goalDepth and y >= -goalDepth and y <= fieldHeight+2*goalDepth)
end

function AI_getPlayerRadius()
	return 14
end

function AI_getBallRadius()
	return 8
end

function AI_clearLine()
	currentPlayer.markedLine = {-1,-1,-1,-1}
end

function AI_clearPoint()
	currentPlayer.markedPoint = {-1,-1}
end

function AI_markLine(x1,y1,x2,y2)
	if tourneyMode then
		return
	end
	if not (isValidNumber(x1) and isValidNumber(y1) and isValidNumber(x2) and isValidNumber(y2) and isInFieldBounds(x1,y1) and isInFieldBounds(x2,y2)) then
		error("Invalid arguments for markLine(" .. tostring(x1) .. ", " .. tostring(y1) .. ", " .. tostring(x2) .. ", " .. tostring(y2) .. ")")
	end
	local wx1,wy1 = toWindowPosition(x1,y1)
	local wx2,wy2 = toWindowPosition(x2,y2)
	--teams[currentAITeam].markedLine = {wx1,wy1,wx2,wy2}
	currentPlayer.markedLine = {wx1,wy1,wx2,wy2}
end

function AI_markPoint(x,y)
	if tourneyMode then
		return
	end
	if not (isValidNumber(x) and isValidNumber(y) and isInFieldBounds(x,y) and isInFieldBounds(x,y)) then
		error("Invalid arguments for markPoint(" .. tostring(x) .. ", " .. tostring(y) .. ")")
	end
	local wx,wy = toWindowPosition(x,y)
	--teams[currentAITeam].markedPoint = {wx,wy}
	currentPlayer.markedPoint = {wx,wy}
end

local goals = {{0,fieldHeight/2},{fieldWidth,fieldHeight/2}}
function AI_getMyGoalPosition()
	local g = goals[currentAITeam]
	return g[1],g[2]
end

function AI_getOpponentGoalPosition()
	local g = goals[currentAITeam % 2 + 1]
	return g[1],g[2]
end

function AI_getMyPlayerNumber()
	return currentPlayerNumber - 4 * (currentAITeam-1)
end

function AI_setPlayerName(i,name)
	if not initializing then
		error("setPlayerName can only be called in initialize()!")
	end
	if type(name) ~= "string" then
		error("Invalid arguments for setPlayerName("..tostring(i)..", "..tostring(name)..")!")
	end
	i = math.floor(i)
	objects.players[i+4*(currentAITeam-1)].name = name
end

function AI_getName()
	return teams[currentAITeam].name
end

function AI_getTeamNumber()
	return currentAITeam
end

function AI_debugMsg(msg)
	addMessage(teams[currentAITeam],msg)
end

function AI_vector(x1,y1,x2,y2)
	if not (isValidNumber(x1) and isValidNumber(y1) and isValidNumber(x2) and isValidNumber(y2)) then
		error("Invalid arguments for vector("..tostring(x1)..", "..tostring(y1)..", "..tostring(x2)..", "..tostring(y2)..")")
	end
	return x2-x1, y2-y1
end

function AI_vecLength(v1,v2)
	if not (isValidNumber(v1) and isValidNumber(v2)) then
		error("Invalid arguments for vecLength("..tostring(vx)..", "..tostring(vy)..")")
	end
	return math.sqrt(v1*v1+v2*v2)
end

function AI_vecNormalize(v1,v2)
	if not (isValidNumber(v1) and isValidNumber(v2)) then
		error("Invalid arguments for vecNormalize("..tostring(vx)..", "..tostring(vy)..")")
	end
	local len = AI_vecLength(v1,v2)
	if len > 0 then
		return v1/len,v2/len
	else
		return 0,0
	end
end

function AI_pointDistance(x1,y1,x2,y2)
	if not (isValidNumber(x1) and isValidNumber(y1) and isValidNumber(x2) and isValidNumber(y2)) then
		error("Invalid arguments for pointDistance("..tostring(x1)..", "..tostring(y1)..", "..tostring(x2)..", "..tostring(y2)..")")
	end
	local v1,v2 = vector(x1,y1,x2,y2)
	return AI_vecLength(v1,v2)
end

function AI_getBallPosition()
	local x,y = toFieldPosition(objects.ball.body:getX(), objects.ball.body:getY())
	return x,y
end

function AI_getMyPosition()
	local x,y = toFieldPosition(currentPlayer.body:getX(), currentPlayer.body:getY())
	return x,y
end

function AI_getTeammatePosition(i)
	if not(isValidNumber(i) and isValidPlayerNumber(i)) then error("Invalid player number for getTeammatePosition("..tostring(i)..")") end
	i = math.floor(i)
	local x,y = toFieldPosition(objects.players[i+4*(currentAITeam-1)].body:getX(), objects.players[i+4*(currentAITeam-1)].body:getY())
	return x,y
end

function AI_getOpponentPlayerPosition(i)
	if not(isValidNumber(i) and isValidPlayerNumber(i)) then error("Invalid player number for getOpponentPlayerPosition("..tostring(i)..")") end
	i = math.floor(i)
	local x,y = toFieldPosition(objects.players[i+4*(currentAITeam % 2)].body:getX(), objects.players[i+4*(currentAITeam % 2)].body:getY())
	return x,y
end

function AI_getBallVelocity()
	return objects.ball.body:getLinearVelocity()
end

function AI_getMyVelocity()
	return currentPlayer.body:getLinearVelocity()
end

function AI_getTeammateVelocity(i)
	if not(isValidNumber(i) and isValidPlayerNumber(i)) then error("Invalid player number for getTeammateVelocity("..tostring(i)..")") end
	return objects.players[i+4*(currentAITeam-1)].body:getLinearVelocity()
end

function AI_getOpponentVelocity(i)
	if not(isValidNumber(i) and isValidPlayerNumber(i)) then error("Invalid player number for getOpponentVelocity("..tostring(i)..")") end
	return objects.players[i+4*(currentAITeam % 2)].body:getLinearVelocity()
end

function AI_setInitialPosition(i,x,y)
	if not(isValidNumber(i) and isValidPlayerNumber(i) and isValidNumber(x) and isValidNumber(y) and isValidRelativePosition(x,y)) then
		error("Invalid arguments for setInitialPosition("..tostring(i)..", "..tostring(x)..", "..tostring(y)..")")
	end
	i = math.floor(i)

	x,y = x*fieldWidth/2,y*fieldHeight
	if currentAITeam == 2 then
		x = fieldWidth-x
	end
	local wx,wy = toWindowPosition(x,y)
	objects.players[i+4*(currentAITeam-1)].initialPosition = {wx,wy}
end

function AI_getMyInitialPosition()
	return toFieldPosition(currentPlayer.initialPosition[1], currentPlayer.initialPosition[2])
end

function AI_getInitialPosition(i)
	if not (isValidNumber(i) and isValidPlayerNumber(i)) then return error("Invalid player number for getInitialPosition("..tostring(i)..")") end
	i = math.floor(i)
	local x,y = objects.players[i+4*(currentAITeam-1)].initialPosition[1], objects.players[i+4*(currentAITeam-1)].initialPosition[2]
	return toFieldPosition(x,y)
end

function AI_getTeamScore()
	return teams[currentAITeam].score
end

function AI_getOpponentScore()
	return teams[currentAITeam % 2 + 1].score
end

function AI_getFieldWidth()
	return fieldWidth
end

function AI_getFieldHeight()
	return fieldHeight
end

function AI_canShoot()
	return (AI_pointDistance(currentPlayer.body:getX(),currentPlayer.body:getY(),objects.ball.body:getX(),objects.ball.body:getY()) < shootDistance)
end

function AI_setBackNumber(i,n)
	if not initializing then
		error("setBackNumber can only be called in initialize()!")
	end
	if not (isValidNumber(i) and isValidPlayerNumber(i) and isValidNumber(n)) then
		error("Invalid arguments for setBackNumber("..tostring(i)..", "..tostring(n)..")!")
	end
	i,n = math.floor(i), math.floor(n)
	for t=1,4 do
		if t ~= i and objects.players[t+4*(currentAITeam-1)].backnumber == n then
			error("Cannot assign the same backnumber twice!")
		end
	end
	objects.players[i+4*(currentAITeam-1)].backnumber = n
end

function AI_getMyPostPositions()
	return (currentAITeam-1)*fieldWidth, fieldHeight/2-goalSize/2, (currentAITeam-1)*fieldWidth, fieldHeight/2+goalSize/2
end

function AI_getOpponentPostPositions()
	return (currentAITeam%2)*fieldWidth, fieldHeight/2-goalSize/2, (currentAITeam%2)*fieldWidth, fieldHeight/2+goalSize/2
end

function AI_shoot(vx,vy,strength)
	if initializing then error("shoot must not be called in initialize()!") end
	shootAttr = true
	if vx and vy and strength and strength >= 0 and strength <= 1 then
		shootStrength = strength
		shootVec[1],shootVec[2] = AI_vecNormalize(vx,vy)
	else
		local v1,v2 = AI_vector(currentPlayer.body:getX(),currentPlayer.body:getY(), objects.ball.body:getX(), objects.ball.body:getY())
		shootVec[1],shootVec[2] = AI_vecNormalize(v1,v2)
		shootStrength = 1
	end
end

function AI_move(vx,vy)
	if initializing then error("move must not be called in initialize()!") end
	if not (isValidNumber(vx) and isValidNumber(vy)) then
		error("Invalid arguments for move("..tostring(vx)..", "..tostring(vy)..")!")
	end
	moveAttr = {vx,vy}
end

function AI_restart()
	if not finalizing then error("restart can only be called in finalize()!") end
	restartAttr = true
end

function initializeAIEnvironment()
	sandbox_env.getName = AI_getName
	sandbox_env.getTeamNumber = AI_getTeamNumber
	sandbox_env.getOpponentGoalPosition = AI_getOpponentGoalPosition
	sandbox_env.getMyGoalPosition = AI_getMyGoalPosition
	sandbox_env.getMyPlayerNumber = AI_getMyPlayerNumber
	sandbox_env.chat = AI_debugMsg
	sandbox_env.markPoint = AI_markPoint
	sandbox_env.markLine = AI_markLine
	sandbox_env.getBallRadius = AI_getBallRadius
	sandbox_env.getPlayerRadius = AI_getPlayerRadius
	sandbox_env.vector = AI_vector
	sandbox_env.vecLength = AI_vecLength
	sandbox_env.vecNormalize = AI_vecNormalize
	sandbox_env.pointDistance = AI_pointDistance
	sandbox_env.getBallPosition = AI_getBallPosition
	sandbox_env.getMyPosition = AI_getMyPosition
	sandbox_env.getTeammatePosition = AI_getTeammatePosition
	sandbox_env.getOpponentPlayerPosition = AI_getOpponentPlayerPosition
	sandbox_env.getMyInitialPosition = AI_getMyInitialPosition
	sandbox_env.setInitialPosition = AI_setInitialPosition
	sandbox_env.getInitialPosition = AI_getInitialPosition
	sandbox_env.getFieldWidth = AI_getFieldWidth
	sandbox_env.getFieldHeight = AI_getFieldHeight
	sandbox_env.setBackNumber = AI_setBackNumber
	sandbox_env.setPlayerName = AI_setPlayerName
	sandbox_env.getTeamScore = AI_getTeamScore
	sandbox_env.getOpponentScore = AI_getOpponentScore
	sandbox_env.getOpponentVelocity = AI_getOpponentVelocity
	sandbox_env.getTeammateVelocity = AI_getTeammateVelocity
	sandbox_env.getMyVelocity = AI_getMyVelocity
	sandbox_env.getBallVelocity = AI_getBallVelocity
	sandbox_env.getMyPostPositions = AI_getMyPostPositions
	sandbox_env.getOpponentPostPositions = AI_getOpponentPostPositions
	sandbox_env.getOuterRingWidth = function() return goalDepth end
	sandbox_env.clearLine = AI_clearLine
	sandbox_env.clearPoint = AI_clearPoint
	sandbox_env.canShoot = AI_canShoot
	sandbox_env.shoot = AI_shoot
	sandbox_env.move = AI_move
	sandbox_env.restart = AI_restart
end

function updateAI()
	for k,v in pairs(objects.players) do
		if not teams[v.team].error then
			currentPlayerNumber = k
			currentPlayer = v
			currentAITeam = v.team
			moveAttr = {0,0}
			shootAttr = false

			local status,result = pcall(teams[currentAITeam].AI.update)
			if not status then
				teams[v.team].error = true
				addMessage(teams[v.team],result)
			end

			local v1,v2 = AI_vecNormalize(moveAttr[1], moveAttr[2])
			v.body:applyForce(v1*maximumMovePower, v2*maximumMovePower)
			if shootAttr then
				shoot(v, shootVec[1], shootVec[2], shootStrength*maximumShootPower)
			end
		end
	end
end
