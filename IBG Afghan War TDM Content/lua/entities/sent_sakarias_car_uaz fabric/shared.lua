ENT.Base = "sent_sakarias_scar_base"
ENT.Type = "anim"

ENT.PrintName = "UAZ Fabric"
ENT.Author = "Prof.Heavy"
ENT.Category = "Call of Duty 4"
ENT.Information = ""
ENT.AdminOnly = false
ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.AddSpawnHeight = 50
ENT.ViewDist = 200
ENT.ViewDistUp = 10

ENT.NrOfSeats = 5
ENT.NrOfWheels = 4
ENT.NrOfExhausts = 0
ENT.NrOfFrontLights = 2
ENT.NrOfRearLights = 2

ENT.SeatPos = {}
ENT.WheelInfo = {}
ENT.ExhaustPos = {}
ENT.FrontLightsPos = {}
ENT.RearLightsPos = {}

ENT.effectPos = NULL

ENT.DefaultSoftnesFront =15
ENT.DefaultSoftnesRear =15

ENT.CarMass =250
ENT.StabiliserOffset = NULL
ENT.StabilisationMultiplier = 70

ENT.DefaultSound = "vehicles/diesel_loop2.wav"
ENT.EngineEffectName = "Rally"
ENT.HornSound = "scarhorns/horn 1.wav"

ENT.CarModel = "models/uaz_fabric_body.mdl"
ENT.TireModel = "models/uaz_wheel.mdl"
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
xPos = 5
yPos = -25
zPos = 28.89999961853
ENT.SeatPos[1] = Vector(xPos, yPos, zPos)

--Seat Position 2
xPos = 3.2000000476837
yPos = 8.1000003814697
zPos = 29.5
ENT.SeatPos[2] = Vector(xPos, yPos, zPos)

--Seat Position 3
xPos = -33.900001525879
yPos = 11.5
zPos = 28.5
ENT.SeatPos[3] = Vector(xPos, yPos, zPos)

--Seat Position 4
xPos = -33.900001525879
yPos = -10.10000038147
zPos = 28.5
ENT.SeatPos[4] = Vector(xPos, yPos, zPos)

--Seat Position 5
xPos = -31
yPos = -30.700000762939
zPos = 29.200000762939
ENT.SeatPos[5] = Vector(xPos, yPos, zPos)

//WHEEL POSITIONS
--Wheel Position 1
xPos = 55.599998474121
yPos = -42.200000762939
zPos = 6.8000001907349
ENT.WheelInfo[1].Pos = Vector(xPos, yPos, zPos)
ENT.WheelInfo[1].Side = true
ENT.WheelInfo[1].Torq = true
ENT.WheelInfo[1].Steer = 1

--Wheel Position 2
xPos = 55.5
yPos = 25.299999237061
zPos = 6.8000001907349
ENT.WheelInfo[2].Pos = Vector(xPos, yPos, zPos)
ENT.WheelInfo[2].Side = false
ENT.WheelInfo[2].Torq = true
ENT.WheelInfo[2].Steer = 1

--Wheel Position 3
xPos = -60.900001525879
yPos = -42.799999237061
zPos = 6.8000001907349
ENT.WheelInfo[3].Pos = Vector(xPos, yPos, zPos)
ENT.WheelInfo[3].Side = true
ENT.WheelInfo[3].Torq = true
ENT.WheelInfo[3].Steer = 0

--Wheel Position 4
xPos = -60.599998474121
yPos = 25.799999237061
zPos = 6.8000001907349
ENT.WheelInfo[4].Pos = Vector(xPos, yPos, zPos)
ENT.WheelInfo[4].Side = false
ENT.WheelInfo[4].Torq = true
ENT.WheelInfo[4].Steer = 0

//FRONT LIGHT POSITIONS
--Front light 1
xPos = 84
yPos = 12.39999961853
zPos = 35
ENT.FrontLightsPos[1] = Vector(xPos, yPos, zPos)

--Front light 2
xPos = 83
yPos = -29
zPos = 34.599998474121
ENT.FrontLightsPos[2] = Vector(xPos, yPos, zPos)

//REAR LIGHT POSITIONS
--Rear light 1
xPos = -92.099998474121
yPos = -35.599998474121
zPos = 33.099998474121
ENT.RearLightsPos[1] = Vector(xPos, yPos, zPos)

--Rear light 2
xPos = -92.099998474121
yPos = 18.299999237061
zPos = 34.299999237061
ENT.RearLightsPos[2] = Vector(xPos, yPos, zPos)

//EXHAUST POSITIONS
//EFFECT POSITION
xPos = 50.599998474121
yPos = -9.3000001907349
zPos = 43.400001525879
ENT.effectPos = Vector(xPos, yPos, zPos)

//CAR CHARACTERISTICS
ENT.DefaultAcceleration = 1389.3000488281
ENT.DefaultMaxSpeed = 1230.5999755859
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