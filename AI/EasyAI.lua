local AI={}

function AI.initialize()
end

function getTeammateClosestToBall()
	local bx,by = getBallPosition()
	local mate = 0
	local mindist = 1000000
	for k=1,4 do
		local x,y = getTeammatePosition(k)
		if mindist > pointDistance(x,y,bx,by) then
			mate = k
			mindist = pointDistance(x,y,bx,by)
		end
	end
	return mate
end

function AI.update()
	local x,y = getMyPosition()
	local bx,by = getBallPosition()

	if getTeammateClosestToBall() == getMyPlayerNumber() then
		local vx,vy = vector(x,y,bx,by)
		move(vx,vy)
	end

	if canShoot() then
		shoot()
	end
end

function AI.onGoal()
end

function AI.finalize()
end

return AI
