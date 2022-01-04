local AI={}


function AI.initialize()


  chat ("Dies wird euer Ende sein")
  
  setBackNumber(4, 16)
  setBackNumber(2, 4)
  setBackNumber(1, 2) 
  setBackNumber(3, 8)


  setInitialPosition(1, 0.1, 0.5)
  setInitialPosition(2, 0.75, 0.5)
  setInitialPosition(3, 0.85, 0.35)
  setInitialPosition(4, 0.85, 0.65)

  setPlayerName(1, "Meine Oma")
  setPlayerName(2, "Angriff")
  setPlayerName(3, "Vertrauen")
  setPlayerName(4, "Kontrolle")
 

  t = 1
  z = 1
end



function getTeammateClosestToGoal()
    local ogx,ogy = getOpponentGoalPosition()
	local Teammate = 0
	local mindist = 1000000
	local k
	for k=2,4 do
	    local x,y = getTeammatePosition(k)
		if mindist > pointDistance(x,y,ogx,ogy) then
		   Teammate = k
		   mindist = pointDistance(x,y,ogx,ogy)
		end
    end
	return Teammate, mindist
end

function getTeammateSecondClosestToGoal()
    local ogx,ogy = getOpponentGoalPosition()
	local Teammate = 0
	local mindist = 1000000
	local k
	for k=2,4 do
	    if k ~= getTeammateClosestToGoal() then
	    local x,y = getTeammatePosition(k)
		if mindist > pointDistance(x,y,ogx,ogy) then
		   Teammate = k
		   mindist = pointDistance(x,y,ogx,ogy)
		end
		end
    end
	return Teammate, mindist
end

function getTeammateThirdClosestToGoal()
    local ogx,ogy = getOpponentGoalPosition()
	local Teammate = 0
	local mindist = 1000000
	local k
	for k=2,4 do
	    if k ~= getTeammateClosestToGoal() and k ~= getTeammateSecondClosestToGoal() then
	    local x,y = getTeammatePosition(k)
		if mindist > pointDistance(x,y,ogx,ogy) then
		   Teammate = k
		   mindist = pointDistance(x,y,ogx,ogy)
		end
		end
    end
	return Teammate, mindist
end

function getTeammateClosestToTheBall()
    local bx,by = getBallPosition()
	local Teammate = 2
	local mindist = 1000000
	for k=2,4 do
	    local x,y = getTeammatePosition(k)
		if mindist > pointDistance(x,y,bx,by) then
		   Teammate = k
		   mindist = pointDistance(x,y,bx,by)
		end
    end
	return Teammate, mindist
end

function getTeammateSecondClosestToBall()
    local bx,by = getBallPosition()
	local Teammate = 2
	local mindist = 1000000
	for k=2,4 do
	    if k ~= getTeammateClosestToTheBall() then
	    local x,y = getTeammatePosition(k)
		if mindist > pointDistance(x,y,bx,by) then
		   Teammate = k
		   mindist = pointDistance(x,y,bx,by)
		end
		end
    end
	return Teammate, mindist
end

function getTeammateThirdClosestToBall()
    local bx,by = getBallPosition()
	local Teammate = 2
	local mindist = 1000000
	for k=2,4 do
	    if k ~= getTeammateClosestToTheBall() and k~= getTeammateSecondClosestToBall() then
	    local x,y = getTeammatePosition(k)
		if mindist > pointDistance(x,y,bx,by) then
		   Teammate = k
		   mindist = pointDistance(x,y,bx,by)
		end
		end
    end
	return Teammate, mindist
end

function getTeammateClosestToOwnGoal()
    local gx,gy = getMyGoalPosition()
	local Teammate = 0
	local mindist = 1000000
	local k
	for k=2,4 do
	    local x,y = getTeammatePosition(k)
		if mindist > pointDistance(x,y,gx,gy) then
		   Teammate = k
		   mindist = pointDistance(x,y,gx,gy)
		end
    end
	return Teammate, mindist
end

function getTeammateSecondClosestToOwnGoal()
    local gx,gy = getMyGoalPosition()
	local Teammate = 0
	local mindist = 1000000
	local k
	for k=2,4 do
	    if k ~= getTeammateClosestToOwnGoal() then
	    local x,y = getTeammatePosition(k)
		if mindist > pointDistance(x,y,gx,gy) then
		   Teammate = k
		   mindist = pointDistance(x,y,gx,gy)
		end
		end
    end
	return Teammate, mindist
end

function getTeammateThirdClosestToOwnGoal()
    local gx,gy = getMyGoalPosition()
	local Teammate = 0
	local mindist = 1000000
	local k
	for k=2,4 do
	    if k ~= getTeammateClosestToOwnGoal() and k ~= getTeammateSecondClosestToOwnGoal() then
	    local x,y = getTeammatePosition(k)
		if mindist > pointDistance(x,y,gx,gy) then
		   Teammate = k
		   mindist = pointDistance(x,y,gx,gy)
		end
		end
    end
	return Teammate, mindist
end

function getOpponentClosestToGoal()
    local gx,gy = getMyGoalPosition()
	local opponent = 0
	local mindist = 1000000
	local k
	for k=1,4 do
	    local x,y = getOpponentPlayerPosition(k)
		if mindist > pointDistance(x,y,gx,gy) then
		   opponent = k
		   mindist = pointDistance(x,y,gx,gy)
		end
    end
	return opponent, mindist
end

function getOpponentSecondClosestToGoal()
    local gx,gy = getMyGoalPosition()
	local opponent = 0
	local mindist = 1000000
	local k
	for k=1,4 do
	    if k ~= getOpponentClosestToGoal() then
	    local x,y = getOpponentPlayerPosition(k)
		if mindist > pointDistance(x,y,gx,gy) then
		   opponent = k
		   mindist = pointDistance(x,y,gx,gy)
		end
		end
    end
	return opponent, mindist
end

function getOpponentThirdClosestToGoal()
    local gx,gy = getMyGoalPosition()
	local opponent = 0
	local mindist = 1000000
	local k
	for k=1,4 do
	    if k ~= getOpponentClosestToGoal() and k ~= getOpponentSecondClosestToGoal() then
	    local x,y = getOpponentPlayerPosition(k)
		if mindist > pointDistance(x,y,gx,gy) then
		   opponent = k
		   mindist = pointDistance(x,y,gx,gy)
		end
		end
    end
	return opponent, mindist
end

function getOpponentClosestToBall()
    local bx,by = getBallPosition()
	local opponent = 0
	local mindist = 1000000
	for k=1,4 do
	    local x,y = getOpponentPlayerPosition(k)
		if mindist > pointDistance(x,y,bx,by) then
		   opponent = k
		   mindist = pointDistance(x,y,bx,by)
		end
    end
	return opponent, mindist
end

function getOpponentSecondClosestToBall()
    local bx,by = getBallPosition()
	local opponent = 0
	local mindist = 1000000
	for k=1,4 do
	    if k ~= getOpponentClosestToBall() then
	    local x,y = getOpponentPlayerPosition(k)
		if mindist > pointDistance(x,y,bx,by) then
		   opponent = k
		   mindist = pointDistance(x,y,bx,by)
		end
		end
    end
	return opponent, mindist
end

function getOpponentThirdClosestToBall()
    local bx,by = getBallPosition()
	local opponent = 0
	local mindist = 1000000
	for k=1,4 do
	    if k ~= getOpponentClosestToBall() and k~= getOpponentSecondClosestToBall() then
	    local x,y = getOpponentPlayerPosition(k)
		if mindist > pointDistance(x,y,bx,by) then
		   opponent = k
		   mindist = pointDistance(x,y,bx,by)
		end
		end
    end
	return opponent, mindist
end


    


function AI.update()

-- Variablen:

-- Tore
    local gx,gy = getMyGoalPosition()
	local ogx,ogy = getOpponentGoalPosition()
	local topPostX, topPostY, bottomPostX, bottomPostY = getMyPostPositions()
	local otopPostX, otopPostY, obottomPostX, obottomPostY = getOpponentPostPositions()
	
-- Ball
    local bx,by = getBallPosition()
	local bvx,bvy = getBallVelocity()
	local bvnx,bvny = vecNormalize(bvx,bvy)
	local lvbx,lvby = vector(bx,by,bx+bvx,by+bvy)
	local lvb = math.sqrt(lvbx*lvbx+lvby*lvby)

-- Eigenes Team
    local x,y = getMyPosition()
	local mvx,mvy = getMyVelocity()

    local x1,y1 = getTeammatePosition(1)
    local x2,y2 = getTeammatePosition(2)
    local x3,y3 = getTeammatePosition(3)
    local x4,y4 = getTeammatePosition(4)

	local vx1,vy1 = getTeammateVelocity(1)
	local vx2,vy2 = getTeammateVelocity(2)
	local vx3,vy3 = getTeammateVelocity(3)
	local vx4,vy4 = getTeammateVelocity(4)
	
    local matecb,distcb = getTeammateClosestToTheBall()
    local matesb,distsb = getTeammateSecondClosestToBall()	
    local matetb,disttb = getTeammateThirdClosestToBall()	
	
    local xmcb,ymcb = getTeammatePosition(matecb)
    local xmsb,ymsb = getTeammatePosition(matesb)
    local xmtb,ymtb = getTeammatePosition(matetb)
	
    local matecog,distcog = getTeammateClosestToGoal()
    local matesog,distsog = getTeammateSecondClosestToGoal()
    local matetog,disttog = getTeammateThirdClosestToGoal()	
	
	local matecg,distcg = getTeammateClosestToOwnGoal()
	local matesg,distsg = getTeammateSecondClosestToOwnGoal()
	local matetg,disttg = getTeammateThirdClosestToOwnGoal()
	
-- Gegner Team
	local ox1,oy1 = getOpponentPlayerPosition(1)
	local ox2,oy2 = getOpponentPlayerPosition(2)
	local ox3,oy3 = getOpponentPlayerPosition(3)
    local ox4,oy4 = getOpponentPlayerPosition(4)

	local ovx1,ovy1 = getOpponentVelocity(1)
	local ovx2,ovy2 = getOpponentVelocity(2)
	local ovx3,ovy3 = getOpponentVelocity(3)
	local ovx4,ovy4 = getOpponentVelocity(4)
	
	local oppcb, distoppcb = getOpponentClosestToBall()
	local oppsb, distoppsb = getOpponentSecondClosestToBall()
	local opptb, distopptb = getOpponentThirdClosestToBall()
	
    local oppcg,distoppcg = getOpponentClosestToGoal()
    local oppsg,distoppsg = getOpponentSecondClosestToGoal()	
    local opptg,distopptg = getOpponentThirdClosestToGoal()


	
-- Allgemein

function Ballbesitz()
	
	if pointDistance(xmcb,ymcb,bx,by)>40 then
		return false
	else
		return true
	end	
end


function Torgefahr()
	local p = 0
		p =	((bvy)/(bvx))*gx+by-((bvy)/(bvx))*bx
	if 135 <= p and p <= 265 then
		return true
	else
		return false
	end	
end	



function SchussBlocken()
	local p 
		p =	((bvy)/(bvx))*gx+by-((bvy)/(bvx))*bx		
	local tx,ty = vector(x,y,gx-mvx*0.5,p)
	move (tx,ty)
end
	

	
function LeererRaum()
	local px = math.abs(gx-500)
	local py = 100
	local tx = 0
	local ty = 0
	local largest = 0
	local opponent = 0
    for r=2,4 do		
		local x,y = getOpponentPlayerPosition(r)
		for k=1,3 do			
				for t=1,3 do							
					if largest < pointDistance(x,y,px,py) and pointDistance(x,y,px,py)<= pointDistance(ox2,oy2,px,py)and pointDistance(x,y,px,py)<= pointDistance(ox3,oy3,px,py) and pointDistance(x,y,px,py)<= pointDistance(ox4,oy4,px,py)then
						largest = pointDistance(x,y,px,py)
						tx = px
						ty = py
					end
				
					px = math.abs(gx-400-100*t)
				end
						
			py = 100*k			
		end
		opponent = r
	end
	return tx, ty, r, largest
end			


local dx,dy = LeererRaum()




function GegnerWeitWegVomBall()
	if pointDistance(bx,by,ox1+ovx1,oy1+ovy1) >= 200 and pointDistance(bx,by,ox2+ovx2,oy2+ovy2) >= 200 and pointDistance(bx,by,ox3+ovx3,oy3+ovy3) >= 200 and pointDistance(bx,by,ox4+ovx4,oy4+ovy4) >= 200 then
		return true
	else
		return false
	end
end



function Frei()
	if pointDistance(xmsb,ymsb,dx,dy)<100 or pointDistance(xmtb,ymtb,dx,dy)<100 then
		return true
	else
		return false
	end
end

	
function BallNahAmTor()
										-- and (gx-200-bx >= -400 or gx-200+bx >= 1200)
	if pointDistance(bx,by,gx,gy)< 250  then
		return true
	else
		return false
	end
end

function GuteSchussmoeglichkeit()
	if pointDistance(bx,by,ogx,ogy)<250 or (gx-200-bx >= -400 or gx-200+bx >= 1200) then
		return true
	else
		return false
	end
end



function GegnernNahAmBall()
	if distoppcb < 40 then
		return true
	else
		return false
	end
end	

function BallKontrollierbar()
	if pointDistance(bx,by,bx+bvx,by+bvy)< 330 then
		return true
	else
		return false
	end
end	


	-- Laufmechaniken

function Schusslinieblocken()
	local vx,vy = vector (gx,gy,bx,by)
	local o = (pointDistance(gx,gy,bx,by)/1000)-1
	local p = o*o*0.8
	p = math.max( p, 0.1)
	local vx1,vy1 = vector (x,y,gx+vx*p-mvx*0.5-8,gy+vy*p-mvy*0.5)
	move (vx1,vy1)
end


function Ballsichern()
	if getMyPlayerNumber() == matecb then
 		local x,y = getTeammatePosition(matecb)
		local ox,oy = getOpponentPlayerPosition(oppcb)
		local vx,vy = vector(ox,oy,x,y)
		local vnx,vny = vecNormalize(vx,vy)	
		move (vnx,vny)
	end
end	


function ZweiBlockenSchusslinieEinerErobertBall()	

	if getMyPlayerNumber() == matecb then
		local x,y = getTeammatePosition(matecb)	
		local vx,vy = vector(x,y,bx,by)
		move (vx,vy)
	end

	
	local ox,oy = getOpponentPlayerPosition(oppcg)
	local x1,y1 = getTeammatePosition(matesb)
	local x2,y2 = getTeammatePosition(matetb)
	
	if getMyPlayerNumber() == matesb and pointDistance(x1,y1,ox,oy)<pointDistance(x2,y2,ox,oy) then	
		local x,y = getTeammatePosition(matesb)
		local ox,oy = getOpponentPlayerPosition(oppcg)
		local vx,vy = vector (ox,oy,gx,gy)
		local vnx,vny = vecNormalize(vx,vy)
		local vx1,vy1 = vector (x,y,ox+vnx*80,oy+vny*80)
		move (vx1,vy1)	
	else
	if getMyPlayerNumber() == matesb then
		local ox,oy = getOpponentPlayerPosition(oppsg)
		local vx,vy = vector (ox,oy,gx,gy)
		local vnx,vny = vecNormalize(vx,vy)
		local vx1,vy1 = vector (x,y,ox+vnx*80,oy+vny*80)
		move (vx1,vy1)		
	end	
	end
	
	if getMyPlayerNumber() == matetb and pointDistance(x1,y1,ox,oy)<pointDistance(x2,y2,ox,oy) then
		local x,y = getTeammatePosition(matetb)
		local ox,oy = getOpponentPlayerPosition(oppsg)
		local vx,vy = vector (ox,oy,gx,gy)
		local vnx,vny = vecNormalize(vx,vy)
		local vx1,vy1 = vector (x,y,ox+vnx*80,oy+vny*80)
		move (vx1,vy1)
	else
	if getMyPlayerNumber() == matetb then
		local x,y = getTeammatePosition(matetb)
		local ox,oy = getOpponentPlayerPosition(oppcg)
		local vx,vy = vector (ox,oy,gx,gy)
		local vnx,vny = vecNormalize(vx,vy)
		local vx1,vy1 = vector (x,y,ox+vnx*80,oy+vny*80)
		move (vx1,vy1)
	end			
	end
end

	
function Freilaufen()				
	if getMyPlayerNumber() == matesb and pointDistance(xmsb,ymsb,dx,dy)<pointDistance(xmtb,ymtb,dx,dy)then
		local vx,vy = vector (xmsb,ymsb,dx,dy)
		move (vx,vy)
	end
	if getMyPlayerNumber() == matetb and pointDistance(xmsb,ymsb,dx,dy)>pointDistance(xmtb,ymtb,dx,dy)then
		local vx,vy = vector (xmtb,ymtb,dx,dy)
		move (vx,vy)
	end
end




	
	-- Schussmechaniken

function Abschlag()
	if canShoot() then
		local vx,vy = vector(bx,by,ogx,ogy-bvy*0.1)
		shoot (vx,vy,1)
	end
end

function SchussaufsTor()
	if canShoot() then
		local vx,vy = vector(bx,by,ogx,ogy-bvy*0.1)
		shoot (vx,vy,1)
	end
end	

function Ballhalten()
	if canShoot() then	
		local ox,oy = getOpponentPlayerPosition(oppcb)
		local vx,vy = vector(ox,oy,x,y)
		local vnx,vny = vecNormalize(vx,vy)
		local bvx,bvy = vector(bx,by,x+vnx*21,y+vny*21)
		shoot (bvx,bvy,0.3)
	end
end	


function Ballpassen()
	if pointDistance(xmsb,ymsb,dx,dy)<100 and canShoot() then
		local x,y = getTeammatePosition(matecb)
		local sx,sy = getTeammatePosition(matesb)
		local vsx,vsy = getTeammateVelocity(matesb)	
		local vx,vy = vector(bx,by,sx+vsx*0.2,sy+vsy*0.2)	
		shoot (vx,vy,0.6)		
	end	
		
	if pointDistance(xmtb,ymtb,dx,dy)<100 and canShoot() then		
		local x,y = getTeammatePosition(matecb)
		local tx,ty = getTeammatePosition(matetb)
		local vtx,vty = getTeammateVelocity(matetb)		
		local vx,vy = vector(bx,by,tx+vtx*0.2,ty+vty*0.2)
		shoot (vx,vy,0.6)
	end
end			







-- Spielverhalten


if GegnerWeitWegVomBall() and getMyPlayerNumber() == matecb then

	local vx,vy = vector(x,y,bx,by)
	move(vx,vy)
	
	SchussaufsTor()
else


if getMyPlayerNumber()~=1 then 	


-- Verteidigung
	
if BallNahAmTor() then

	ZweiBlockenSchusslinieEinerErobertBall()
	Abschlag()
	
	
else
	
-- Aufbauspiel	

if Ballbesitz() then


	

	-- Spieler im Ballbesitz

		Ballsichern()
		Freilaufen()
	
		if GuteSchussmoeglichkeit() or GegnernNahAmBall() or BallKontrollierbar() == false then
			SchussaufsTor()
		else
			
		
	-- Ball passen
		if Frei() then
			Ballpassen()
		else

		
	
	-- Ball halten

			Ballhalten()

		end
		end
	
	-- Freilaufen 


	
else

	ZweiBlockenSchusslinieEinerErobertBall()

end
end
end








-- Meine Oma


if getMyPlayerNumber() == 1 then

--	if Torgefahr() then
--		SchussBlocken()
--		Abschlag()
--	else		
		Schusslinieblocken()
		Abschlag()
--end	
end


	
end	
end


	
	
	
	
	
	
	
	
m=0
function getTeamScored ()
	local g = getTeamScore()
	if m < g then
	   m = g
	   return true
	else
	   return false
	end
end



function AI.onGoal()


if getTeamScored() then

	if t == 10 then
		chat ("Hinten dichte Manndeckung und vorne über die Flügel agie... Huch, schon wieder ein Tor")
		t=t+1
	end
	if t == 9 then
		chat ("Dich snack ich weg wie Plankton")
		t=t+1
	end
	if t == 8 then
		chat ("Das ist mir zu einfach. Ich wuerde lieber eine Partie gegen die Prachtschmerle spielen")
		t=t+1
	end
	if t == 7 then
		chat ("Zickedi Zack, Schnickedi Schnack")
		t=t+1
	end
	if t == 6 then
		chat ("Kontrolle: Ist hier jemand ohne Fahrschein?")
		t=t+1
	end
	if t == 5 then
		chat ("Meine Oma sagt immer: Dicke Kinder haben auf dem Fußballplatz nichts verloren")
		t=t+1
	end	
	if t == 4 then
		chat  ("Angriff ist die beste Verteidigung")
		t=t+1
	end	
	if t == 3 then
		chat ("Kontrolle ist außer sich")
		t=t+1
	end	
	if t == 2 then
		chat ("Da kann ja meine Oma noch besser spielen")
		t=t+1
	end
	if t == 1 then
		chat ("Vertrauen ist gut, Kontrolle ist besser")
		t=t+1
	end



else
	if z == 7 then
		chat ("Ich frage mich wie es meinem Freund, der Prachtschmerle, gerade geht")
		z=z+1
	end
	if z == 6 then
		chat ("Meine Oma: Leute, ihr muesst besser verteidigen. Die zwirbeln mir hier eine Bude nach der anderen rein! ")
		z=z+1
	end
	if z == 5 then
		chat ("Ich hab das Vertrauen in meine Oma verloren")
		z=z+1
	end
	if z == 4 then
		chat ("Das angriffsweise Vorgehen elektrisiert die Gemüter, aber die Erfahrung hat gezeigt,")
		chat ("dass diese gehobene Stimmung bei großen Verlusten in das volle Gegenteil umschlagen kann")
		z=z+1
	end
	if z == 3 then
		chat ("Mir persönlich spielt Angriff zu passiv")
		z=z+1
	end
	if z == 2 then
		chat ("Anfangs hatte ich Vertrauen in die Verteidigung")
		z=z+1
	end
	if z == 1 then
		chat ("Meine Oma hat nunmal nicht die besten Reflexe")
		z=z+1
	end
end




end


function AI.finalize()

chat ("GG, am Ende steht es Unentschieden: Spaß zu Spaß")

end

return AI
