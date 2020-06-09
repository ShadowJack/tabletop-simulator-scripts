function onload()
end

--
-- Containers GUIDs
hardProblemsBagId = 'bc30d3'
easyProblemsBagId = '4b51a2'
deckId = '10838d'

--
-- Places on the map
lomotId = '7c4a87'
lankrskiePescheriId = 'a44c9a'
chernostekolyeId = '9b368e'
skandId = '722be6'
lankrskiyMostId = '9844f6'

mestoGdeNeSvetitSolnce = '63a6b6'
britvennoeLezvie = 'b7b434'
skolzkayaVpadina = '01b397'
obelisk = '28bd77'
verzila = 'e00aa6'
ribyiRuchyi = 'ddaca4'
podzemelya = '4fd83f'
vertkoyeIZhestkoyeMestechko = '5bb6f6'
hizhinaMatushkiVetrovosk = 'd3e414'
plyasuni = '2c32d7'
kapustniyKolodec = '2e53b6'
chertovDub = '7b2f92'
lankrskiyZamok1 = '43f5d4'
lankrskiyZamok2 = 'e08cb7'
durnoyZad = '38260b'
lankrskiyProval = '4a631e'
hizhinaMargat = 'e2b578'
bezumniyDurnostay = 'c9b360'
gorodLankr1 = '512a23'
gorodLankr2 = 'e005d7'
gorodLankr3 = '982b09'

--
-- Boxes on the field
box1 = 'd65a41'
box2 = '6d05ad'
box3 = 'c0fcf9'
box4 = 'e92d91'
box5 = '40f08c'
box6 = '3fdc38'
boxes = {box1, box2, box3, box4, box5, box6}

initialHardProblemsBoxes = {
	{1, 1, 1, 0, 0, 0},
	{1, 1, 2, 1, 1, 1},
	{2, 2, 2, 2, 2, 2},
	{2, 2, 2, 2, 2, 0},
}
initialEasyProblemsBoxes = {
	{2, 2, 1, 0, 0, 0},
	{2, 2, 1, 2, 1, 1},
	{2, 2, 2, 2, 2, 2},
	{4, 4, 4, 3, 3, 0},
}

function prepareTable(player, mouseBtn, btnId) 
	local numberOfPlayers = 0
	if btnId == 'prepare1' then numberOfPlayers = 1
	elseif btnId == 'prepare2' then numberOfPlayers = 2
	elseif btnId == 'prepare3' then numberOfPlayers = 3
	else numberOfPlayers = 4
	end

	print('Preparing a table for ' .. numberOfPlayers .. ' players')

	-- shuffle everything that needs to be shuffled
	shuffle(hardProblemsBagId)
	shuffle(easyProblemsBagId)
	shuffle(deckId)

	-- put problems on the field
	putHardProblemsOnField()
	putEasyProblemsOnField()
	
	-- put problems in the boxes
	putProblemsInBoxes(numberOfPlayers)

	-- TODO: put hihihiTokens
	
	closePanel()
end

function shuffle(bagId)
	getObjectFromGUID(bagId).shuffle()
end


initialHardPlaces = {lomotId, lankrskiePescheriId, chernostekolyeId, skandId, lankrskiyMostId}

function putHardProblemsOnField()
	local bag = getObjectFromGUID(hardProblemsBagId)
	for k, placeId in pairs(initialHardPlaces) do
		putNextProblem(bag, placeId, true)
	end
end

initialEasyPlaces = {
	mestoGdeNeSvetitSolnce,
	skolzkayaVpadina,
	ribyiRuchyi,
	lankrskiyZamok1,
	durnoyZad,
	plyasuni,
	kapustniyKolodec,
	gorodLankr1,
	gorodLankr2,
	bezumniyDurnostay
}

function putEasyProblemsOnField()
	local bag = getObjectFromGUID(easyProblemsBagId)
	for k, placeId in pairs(initialEasyPlaces) do
		putNextProblem(bag, placeId, false)
	end
end

function putProblemsInBoxes(playersCount)
	-- hard problems
	local bag = getObjectFromGUID(hardProblemsBagId)
	for i, numOfProblems in pairs(initialHardProblemsBoxes[playersCount]) do
		local boxId = boxes[i]
		for x = 1, numOfProblems do
			putNextProblem(bag, boxId, true)
		end
	end

	local bag = getObjectFromGUID(easyProblemsBagId)
	for i, numOfProblems in pairs(initialEasyProblemsBoxes[playersCount]) do
		local boxId = boxes[i]
		for x = 1, numOfProblems do
			-- 100ms delays between the spawns to give some time
			-- for previous problem to stop moving
			Wait.time(|| putNextProblem(bag, boxId, false), x / 10)
		end
	end
end


function putNextProblem(bag, placeId, isHard)
	local params = buildProblemRetrievalParams(placeId, isHard) 
	bag.takeObject(params)
end

function buildProblemRetrievalParams(placeId, isHard)
	placePosition = getObjectFromGUID(placeId).positionToWorld(Vector(0, 0, 0))

	return {
		position = placePosition,
		-- rotate on 180 degrees as bag is positioned incorrectly
		-- at the beginning of the game
		rotation = Vector(0, 180, 0),
		smooth = not isHard,
		callback_function = |problem| onProblemRetrieved(problem, isHard)
	}
end

function onProblemRetrieved(problem, isHard)
	if isHard then problem.flip() end

	-- Scale the problem token
	problem.scale(2)
end

function closePanel()
	self.UI.hide('mainPanel')
end
