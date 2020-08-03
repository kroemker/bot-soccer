require("globals")
require("timers")
require("game")
require("ui")
require("AIEnvironment")

-- TODO: make everything more eye-appealing (particle system for game over (maybe even goal), images and textures for stuff maybe)
-- TODO: tournament mode
-- TODO: whirl shader background, set timelength of match, number of players etc. in menu screen, sound off button, commentator, goal getter detection, names for players
function love.load()
	local major, minor, revision, codename = love.getVersion()
    local str = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)
    print(str)

    gameTimer = addTimer(gameLength, gameOver, false)
    countdownTimer = addTimer(3, startGame, false)
    goalTimer = addTimer(2, resetPosition, false)

    --initial graphics setup
    love.graphics.setBackgroundColor(10, 10, 10)
    love.graphics.setFont(mainFont)
	love.window.setTitle("BotSoccer")
	math.randomseed(os.time())

    local w,h = love.graphics.getDimensions()
	grassTexture = love.graphics.newImage("Assets/grass3.png")
	backgroundTexture = love.graphics.newImage("Assets/background.png")

	fieldQuad = love.graphics.newQuad(0, 0, fieldWidth+2*goalDepth, fieldHeight+2*goalDepth, grassTexture:getDimensions())
	goalQuad = love.graphics.newQuad(0, 0, goalDepth, goalSize, grassTexture:getDimensions())
	fieldMeshVertices = {
		{w/2-fieldWidth/2+slopeOffset, h/2-fieldHeight/2, slopeOffset/fieldWidth, 0},
		{w/2+fieldWidth/2-slopeOffset, h/2-fieldHeight/2, 1-slopeOffset/fieldWidth, 0},
		{w/2+fieldWidth/2, h/2-fieldHeight/2+slopeOffset, 1, slopeOffset/fieldHeight},
		{w/2+fieldWidth/2, h/2+fieldHeight/2-slopeOffset, 1, 1-slopeOffset/fieldHeight},
		{w/2+fieldWidth/2-slopeOffset, h/2+fieldHeight/2, 1-slopeOffset/fieldWidth, 1},
		{w/2-fieldWidth/2+slopeOffset, h/2+fieldHeight/2, slopeOffset/fieldWidth, 1},
		{w/2-fieldWidth/2, h/2+fieldHeight/2-slopeOffset, 0, 1-slopeOffset/fieldHeight},
		{w/2-fieldWidth/2, h/2-fieldHeight/2+slopeOffset, 0, slopeOffset/fieldHeight}
	}
	fieldMesh = love.graphics.newMesh(fieldMeshVertices)
	fieldMesh:setTexture(grassTexture)

	-- sounds
	menuMusic = love.audio.newSource("Assets/menu.mp3")
	menuMusic:setLooping(true)
	menuMusic:setVolume(0.1)
	ambienceSound = love.audio.newSource("Assets/ambience1.wav", "static")
	ambienceSound:setLooping(true)
	ambienceSound:setVolume(0.05)
	for i=1,numberOfGoalSounds do
		goalSounds[i] = love.audio.newSource("Assets/goal" .. i .. ".wav", "static")
		goalSounds[i]:setVolume(0.2)
	end
	for i=1,numberOfHitSounds do
		hitSounds[i] = love.audio.newSource("Assets/hit" .. i .. ".wav", "static")
		hitSounds[i]:setVolume(0.05)
	end
	whistleSound = love.audio.newSource("Assets/whistle.wav", "static")
	whistleSound:setVolume(0.7)
	whistleEndSound = love.audio.newSource("Assets/endwhistle.wav", "static")
	whistleEndSound:setVolume(0.7)

	if love.filesystem.isFused() then
		local dir = love.filesystem.getSourceBaseDirectory()
		local success = love.filesystem.mount(dir, "BotSoccer")

		if success then
			aiFiles = love.filesystem.getDirectoryItems("BotSoccer/AI")
		else
			love.quit()
		end
	else
		aiFiles = love.filesystem.getDirectoryItems("AI")
	end
	initializeUI()
	fadeInSound(menuMusic, 12)
end

function love.draw()
	drawBackground()
	if gameMode == INGAME then
		drawField()
	end
	drawUI()
end

function love.mousepressed(x, y, button)
	updateUIMousePressed(x,y,button)
end

function love.mousereleased(x, y, button)
	updateUIMouseReleased(x,y,button)
end

function vector(x1,y1,x2,y2)
    local d1,d2 = x2-x1,y2-y1
    return d1,d2,math.sqrt(d1*d1+d2*d2)
end

function normalize(v1,v2,length)
    if length==nil then
        length = math.sqrt(v1*v1+v2*v2)
    end
    return v1/length,v2/length
end

function love.update(dt)
	if world then
		world:update(dt)
		limitVelocity(400)
	end
    updateTimers(dt)
	updateUI(dt)

    if playtime then
		updateAI()

        if love.keyboard.isDown("right") then
            objects.players[1].body:applyForce(maximumMovePower, 0)
        elseif love.keyboard.isDown("left") then
            objects.players[1].body:applyForce(-maximumMovePower, 0)
        end
        if love.keyboard.isDown("up") then
            objects.players[1].body:applyForce(0, -maximumMovePower)
        elseif love.keyboard.isDown("down") then
            objects.players[1].body:applyForce(0, maximumMovePower)
        end
        if love.keyboard.isDown("q") then
            shoot(objects.players[1])
        end

        handleGoal()
    end
end
