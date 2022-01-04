local AI={}

-- called once at the start of the game
function AI.initialize()

  local w,h = getFieldWidth()/2, getFieldHeight()
  local teamPositions = {
    {0.05*w , 0.5*h},
    {0.6*w , 0.5*h},
    {0.95*w , 0.3*h},
    {0.3*w , 0.7*h}
    }

    setInitialPosition(1, 0.05, 0.5)
    setInitialPosition(2, 0.6, 0.5)
    setInitialPosition(3, 0.7, 0.3)
    setInitialPosition(4, 0.3, 0.7)

    setBackNumber(1, 112)
    setBackNumber(2, 115)
  	setBackNumber(3, 110)
  	setBackNumber(4, 911)

    setPlayerName(1, "Feuerwehr")
    setPlayerName(2, "Behoerden-Notruf")
    setPlayerName(3, "Polizei")
    setPlayerName(4, "Police")

end

-- called every frame for every player of the ai i.e. 4 times per frame
function AI.update()

  local w,h = getFieldWidth()/2, getFieldHeight()
  local bx,by = getBallPosition()
  local x,y = getMyPosition()
  local gx,gy = getMyGoalPosition()
  local ogx,ogy = getOpponentGoalPosition()
  local topPostX, topPostY, bottomPostX, bottomPostY = getMyPostPositions()
  local bmx,bmy = getBallVelocity()
  local bmxe,bmye = vecNormalize(bmx,bmy)
  local o1x,o1y = getOpponentPlayerPosition(1)
  local o2x,o2y = getOpponentPlayerPosition(2)
  local o3x,o3y = getOpponentPlayerPosition(3)
  local o4x,o4y = getOpponentPlayerPosition(4)
  local p1mx,p1my = getTeammateVelocity(1)
  local p1mxe,p1mye = vecNormalize(p1mx,p1my)
  local p2mx,p2my = getTeammateVelocity(2)
  local p2mxe,p2mye = vecNormalize(p2mx,p2my)
  local p3mx,p3my = getTeammateVelocity(3)
  local p3mxe,p3mye = vecNormalize(p3mx,p3my)
  local p4mx,p4my = getTeammateVelocity(4)
  local p4mxe,p4mye = vecNormalize(p4mx,p4my)

  if getMyPlayerNumber() == 1 then  -- torhüter
  if by+(gx-bx)/bmx*bmy > topPostY and by+(gx-bx)/bmx*bmy < bottomPostY then
    local vx,vy = vector(x,y,gx,by+(gx-bx)/bmx*bmy)
    local tx,ty = vecNormalize(vector(gx,by+(gx-bx)/bmx*bmy,bx,by))
    move(vx-0.2*p1mx+20*tx,vy-0.2*p1my+20*ty)
  else
    local vx,vy = vector(x,y,math.abs(gx-25),gy)
    local glx,gly = vecNormalize(vector(gx,gy,bx,by))
    glx,gly = 15*glx,45*gly
    move ((vx+glx-18*p1mxe),(vy+gly-18*p1mye))
  end
  end

  if getMyPlayerNumber() == 2 then  -- defender
    if pointDistance(bx,by,x,y) <= 0.3*h then
        local vx,vy = vecNormalize(vector(x,y,bx,by))
        move(2*vx+0.5*bmxe-0.7*p2mxe,2*vy+2*bmye-0.7*p2mye)
    else
      local vx,vy = vector(x,y,gx,gy)
      local glx,gly = vecNormalize(vector(gx,gy,bx,by))
      glx,gly = 200*glx,200*gly
      move ((vx+glx),(vy+gly))
    end
  end

  if getMyPlayerNumber() == 3 then   -- pressing
    local vx,vy = vecNormalize(vector(x,y,bx,by))
    move(1.6*vx+0.9*bmxe-0.6*p3mxe,1.6*vy+0.9*bmye-0.6*p3mye)
  end

  if getMyPlayerNumber() == 4 then --stürmer
    if pointDistance(bx,by,x,y) <= 0.5*h then
      local vx,vy = vecNormalize(vector(x,y,bx,by))
      move(vx+bmxe-0.6*p4mxe,vy+bmye-0.6*p4mye)
      move(vx,vy)
    else
      local op1x,op1y = vector(o1x,o1y,x,y)
      op1x,op1y = 1/((op1x*op1x)+1),1/((op1y*op1y)+1)
      local op2x,op2y = vector(o2x,o2y,x,y)
      op2x,op2y = 1/((op2x*op2x)+1),1/((op2y*op2y)+1)
      local op3x,op3y = vector(o3x,o3y,x,y)
      op3x,op3y = 1/((op3x*op3x)+1),1/((op3y*op3y)+1)
      local op4x,op4y = vector(o4x,o4y,x,y)
      op4x,op4y = 1/((op4x*op4x)+1),1/((op4y*op4y)+1)
      local vx,vy = vector(x,y,math.abs(gx-w*1.5),h*0.5)
      vx,vy = vecNormalize(vx,vy)
      local opx,opy = vecNormalize(op1x+op2x+op3x+op4x,op1y+op2y+op3y+op4y)
      vx,vy = vx+opx,vy+opy*0.7
      move(vx,vy)
    end
  end


  if pointDistance(bx,by,x,y) <= 50 then
    local vx,vy = vector(bx,by,ogx,ogy)
    shoot(vx,vy,1)
  end
end

-- called when a team scored
function AI.onGoal()
end

-- called once at the end of the game
function AI.finalize()
end

return AI
