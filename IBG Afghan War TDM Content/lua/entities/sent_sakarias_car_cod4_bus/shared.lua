ENT.Base = "sent_sakarias_scar_base"
ENT.Type = "anim"

ENT.PrintName = "Bus"
ENT.Author = "Prof.Heavy"
ENT.Category = "Call of Duty 4"
ENT.Information = ""
ENT.AdminOnly = false
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.AddSpawnHeight = 50
ENT.ViewDist = 200
ENT.ViewDistUp = 10

ENT.NrOfSeats = 23
ENT.NrOfWheels = 4
ENT.NrOfExhausts = 0
ENT.NrOfFrontLights = 0
ENT.NrOfRearLights = 0

ENT.SeatPos = {}
ENT.WheelInfo = {}
ENT.ExhaustPos = {}
ENT.FrontLightsPos = {}
ENT.RearLightsPos = {}

ENT.effectPos = NULL

ENT.DefaultSoftnesFront =15
ENT.DefaultSoftnesRear =15

ENT.CarMass =350
ENT.StabiliserOffset = NULL
ENT.StabilisationMultiplier = 70

ENT.DefaultSound = "vehicles/diesel_loop2.wav"
ENT.EngineEffectName = "Default"
ENT.HornSound = "scarhorns/horn 1.wav"

ENT.CarModel = "models/cod_bus_body.mdl"
ENT.TireModel = "models/cod_bus_wheel.mdl"
ENT.AnimType = 1

ENT.FrontLightColor = "220 220 160"
------------------------------------VARIABLES END

for i = 1, ENT.NrOfWheels do
	ENT.WheelInfo[i] = {}
end

local xPos = 0
local yPos = 0
local zPos = 0

//SEAT POSITIONS
--Seat Position 1
xPos = 177.19999694824
yPos = -34.900001525879
zPos = 42.799999237061
ENT.SeatPos[1] = Vector(xPos, yPos, zPos)

--Seat Position 2
xPos = 32.799999237061
yPos = 32.400001525879
zPos = 42.200000762939
ENT.SeatPos[2] = Vector(xPos, yPos, zPos)

--Seat Position 3
xPos = 33.799999237061
yPos = 13.199999809265
zPos = 41.099998474121
ENT.SeatPos[3] = Vector(xPos, yPos, zPos)

--Seat Position 4
xPos = 31.700000762939
yPos = -48.400001525879
zPos = 42
ENT.SeatPos[4] = Vector(xPos, yPos, zPos)

--Seat Position 5
xPos = 31.200000762939
yPos = -29.10000038147
zPos = 41.599998474121
ENT.SeatPos[5] = Vector(xPos, yPos, zPos)

--Seat Position 6
xPos = -3.7000000476837
yPos = 30.89999961853
zPos = 42.558506011963
ENT.SeatPos[6] = Vector(xPos, yPos, zPos)

--Seat Position 7
xPos = -3.7000000476837
yPos = 11.60000038147
zPos = 42.558506011963
ENT.SeatPos[7] = Vector(xPos, yPos, zPos)

--Seat Position 8
xPos = -4
yPos = -30.39999961853
zPos = 42.099998474121
ENT.SeatPos[8] = Vector(xPos, yPos, zPos)

--Seat Position 9
xPos = -3.2000000476837
yPos = -49.099998474121
zPos = 41.900001525879
ENT.SeatPos[9] = Vector(xPos, yPos, zPos)

--Seat Position 10
xPos = -39.200000762939
yPos = -30.39999961853
zPos = 41.900001525879
ENT.SeatPos[10] = Vector(xPos, yPos, zPos)

--Seat Position 11
xPos = -39.200000762939
yPos = -48.900001525879
zPos = 41.900001525879
ENT.SeatPos[11] = Vector(xPos, yPos, zPos)

--Seat Position 12
xPos = -74.5
yPos = -34.400001525879
zPos = 41.5
ENT.SeatPos[12] = Vector(xPos, yPos, zPos)

--Seat Position 13
xPos = -73.900001525879
yPos = -49.400001525879
zPos = 41.5
ENT.SeatPos[13] = Vector(xPos, yPos, zPos)

--Seat Position 14
xPos = -116.19999694824
yPos = -30.39999961853
zPos = 42.400001525879
ENT.SeatPos[14] = Vector(xPos, yPos, zPos)

--Seat Position 15
xPos = -115.40000152588
yPos = -48.700000762939
zPos = 41
ENT.SeatPos[15] = Vector(xPos, yPos, zPos)

--Seat Position 16
xPos = -191.39999389648
yPos = -32.200000762939
zPos = 41.700000762939
ENT.SeatPos[16] = Vector(xPos, yPos, zPos)

--Seat Position 17
xPos = -191.39999389648
yPos = -48.5
zPos = 41.700000762939
ENT.SeatPos[17] = Vector(xPos, yPos, zPos)

--Seat Position 18
xPos = -151.59858703613
yPos = -31.299999237061
zPos = 41.599998474121
ENT.SeatPos[18] = Vector(xPos, yPos, zPos)

--Seat Position 19
xPos = -151.60000610352
yPos = -48.599998474121
zPos = 41.799999237061
ENT.SeatPos[19] = Vector(xPos, yPos, zPos)

--Seat Position 20
xPos = -150
yPos = 32.299999237061
zPos = 41
ENT.SeatPos[20] = Vector(xPos, yPos, zPos)

--Seat Position 21
xPos = -150.5
yPos = 12.800000190735
zPos = 41
ENT.SeatPos[21] = Vector(xPos, yPos, zPos)

--Seat Position 22
xPos = -186.10000610352
yPos = 34
zPos = 42
ENT.SeatPos[22] = Vector(xPos, yPos, zPos)

--Seat Position 23
xPos = -184.60000610352
yPos = 15.199999809265
zPos = 41
ENT.SeatPos[23] = Vector(xPos, yPos, zPos)

//WHEEL POSITIONS
--Wheel Position 1
xPos = 116.69999694824
yPos = -55.099998474121
zPos = 14.699999809265
ENT.WheelInfo[1].Pos = Vector(xPos, yPos, zPos)
ENT.WheelInfo[1].Side = true
ENT.WheelInfo[1].Torq = true
ENT.WheelInfo[1].Steer = 1

--Wheel Position 2
xPos = 117.30000305176
yPos = 42.900001525879
zPos = 14.699999809265
ENT.WheelInfo[2].Pos = Vector(xPos, yPos, zPos)
ENT.WheelInfo[2].Side = false
ENT.WheelInfo[2].Torq = true
ENT.WheelInfo[2].Steer = 1

--Wheel Position 3
xPos = -151.39999389648
yPos = -55.799999237061
zPos = 14.699999809265
ENT.WheelInfo[3].Pos = Vector(xPos, yPos, zPos)
ENT.WheelInfo[3].Side = true
ENT.WheelInfo[3].Torq = true
ENT.WheelInfo[3].Steer = 0

--Wheel Position 4
xPos = -151.39999389648
yPos = 42.299999237061
zPos = 14.699999809265
ENT.WheelInfo[4].Pos = Vector(xPos, yPos, zPos)
ENT.WheelInfo[4].Side = false
ENT.WheelInfo[4].Torq = true
ENT.WheelInfo[4].Steer = 0

//FRONT LIGHT POSITIONS
//REAR LIGHT POSITIONS
//EXHAUST POSITIONS
//EFFECT POSITION
xPos = 0
yPos = -15.300000190735
zPos = 17.200000762939
ENT.effectPos = Vector(xPos, yPos, zPos)

//CAR CHARACTERISTICS
ENT.DefaultAcceleration = 690.70001220703
ENT.DefaultMaxSpeed = 660.70001220703
ENT.DefaultTurboEffect = 2
ENT.DefaultTurboDuration = 4
ENT.DefaultTurboDelay = 10
ENT.DefaultReverseForce = 1000
ENT.DefaultReverseMaxSpeed = 200
ENT.DefaultBreakForce = 2000
ENT.DefaultSteerForce = 5
ENT.DefautlSteerResponse = 0.30000001192093
ENT.DefaultStabilisation = 2000
ENT.DefaultNrOfGears = 5
ENT.DefaultAntiSlide = 10
ENT.DefaultAutoStraighten = 5
ENT.DeafultSuspensionAddHeight = 10
ENT.DefaultHydraulicActive = 0

list.Set( "SCarsList", ENT.PrintName, ENT )

function ENT:Initialize()
		
	self:Setup()

	if (SERVER) then
		--Setting up the car characteristics
		self:SetAcceleration( self.DefaultAcceleration )
		self:SetMaxSpeed( self.DefaultMaxSpeed )
		
		self:SetTurboEffect( self.DefaultTurboEffect )
		self:SetTurboDuration( self.DefaultTurboDuration )
		self:SetTurboDelay( self.DefaultTurboDelay )
		
		self:SetReverseForce( self.DefaultReverseForce )
		self:SetReverseMaxSpeed( self.DefaultReverseMaxSpeed )
		self:SetBreakForce( self.DefaultBreakForce )
		
		self:SetSteerForce( self.DefaultSteerForce )
		self:SetSteerResponse( self.DefautlSteerResponse )
		
		self:SetStabilisation( self.DefaultStabilisation )
		self:SetNrOfGears( self.DefaultNrOfGears )
		self:SetAntiSlide( self.DefaultAntiSlide )
		self:SetAutoStraighten( self.DefaultAutoStraighten )	
		
		self:SetSuspensionAddHeight( self.DeafultSuspensionAddHeight )
		self:SetHydraulicActive( self.DefaultHydraulicActive )
	end
end

function ENT:SpecialThink()
end

function ENT:SpecialRemove()	
end

function ENT:SpecialReposition()
end