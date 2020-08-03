VERSION_MAJOR = 1
VERSION_MINOR = 1

-- CONSTANTS
STARTSCREEN = 0
PREMENU = 1
INGAME = 2

-- TABLES
objects = {}
teams = {}
messages = {}
aiFiles = {}
fieldMeshVertices = {}
fieldMesh = {}
colors = {
	{200,30,30},
	{30,200,30},
	{30,30,200},
	{200,200,30},
	{200,30,200},
	{30,200,200}
}
circleBoundaryLeft = {}
circleBoundaryRight = {}
hitSounds = {}
goalSounds = {}

-- MECHANIC OPTIONS
fieldWidth = 800
fieldHeight = 400
slopeOffset = 75
goalSize = 140
goalDepth = 40
blockZoneRadius = 140
blockZoneSize = 60
shootDistance = 40
postSize = 10
maximumShootPower = 1000
maximumMovePower = 80
gameLength = 240
middleCircleRadius = 0.25 * fieldHeight
numberOfPlayersPerTeam = 4
tourneyMode = false

-- GAME VARS
gameTimer = {}
countdownTimer = {}
goalTimer = {}
goalFont = love.graphics.newFont("Assets/collegiateHeavyOutline.ttf",80)
goalFontBig = love.graphics.newFont("Assets/collegiateHeavyOutline.ttf",94)
startScreenFont = love.graphics.newFont("Assets/collegiateHeavyOutline.ttf",140)
mainFont = love.graphics.newFont("Assets/collegiateHeavyOutline.ttf",40)
backnumberFont = love.graphics.newFont("Assets/collegiateHeavyOutline.ttf",14)
chatFont = love.graphics.newFont("Assets/arial.ttf",16)
playtime = false
isGameOver = false
lastTeamGoal = 1 -- team that scored last goal
gameMode = STARTSCREEN

-- UI VARS
aiSelectionBoxDimensions = {200,400}
aiSelectionBoxItemHeight = 40
aiSelectionBoxMaxVisibleItems = aiSelectionBoxDimensions[2]/aiSelectionBoxItemHeight
aiSelectionBoxHoverColorBk = {50,255,50,32}
aiSelectionBoxHoverColor = {50,255,50,32}
aiSelectionBoxClickColor = {50,50,255,32}
startButtonSize = {300,75}
backButtonSize = {95,75}
numberOfHitSounds = 4
numberOfGoalSounds = 2

-- AI STUFF
initializing = false
finalizing = false
currentAI = 1
currentAITeam = 1
currentPlayer = {}
currentPlayerNumber = 0
moveAttr, shootAttr, restartAttr = {0,0}, false, false
shootVec, shootStrength = {0,0}, 0
sandbox_env = {
	ipairs = ipairs,
  	next = next,
  	pairs = pairs,
  	pcall = pcall,
  	tonumber = tonumber,
  	tostring = tostring,
  	type = type,
  	unpack = unpack,
  	coroutine = { create = coroutine.create, resume = coroutine.resume,
      	running = coroutine.running, status = coroutine.status,
      	wrap = coroutine.wrap },
  	string = { byte = string.byte, char = string.char, find = string.find,
      	format = string.format, gmatch = string.gmatch, gsub = string.gsub,
      	len = string.len, lower = string.lower, match = string.match,
      	rep = string.rep, reverse = string.reverse, sub = string.sub,
      	upper = string.upper },
  	table = { insert = table.insert, maxn = table.maxn, remove = table.remove,
      	sort = table.sort },
  	math = { abs = math.abs, acos = math.acos, asin = math.asin,
      	atan = math.atan, atan2 = math.atan2, ceil = math.ceil, cos = math.cos,
      	cosh = math.cosh, deg = math.deg, exp = math.exp, floor = math.floor,
      	fmod = math.fmod, frexp = math.frexp, huge = math.huge,
      	ldexp = math.ldexp, log = math.log, log10 = math.log10, max = math.max,
      	min = math.min, modf = math.modf, pi = math.pi, pow = math.pow,
      	rad = math.rad, random = math.random, sin = math.sin, sinh = math.sinh,
      	sqrt = math.sqrt, tan = math.tan, tanh = math.tanh },
  	os = { clock = os.clock, difftime = os.difftime, time = os.time },
}
