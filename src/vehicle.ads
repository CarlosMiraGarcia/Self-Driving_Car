with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with dashboard_warning_lights; use dashboard_warning_lights;
with road;                     use road;
with carbattery;               use carbattery;

package vehicle with
   SPARK_Mode
is

   type Gear is (Parked, Forward, Reversing);
   type Accelerator is (Yes, No);
   type Direction is (Straight, Left, Right);
   type Car is record
      speed           : SpeedRange := 0;
      dashboardLights : Dashboard  := CreateLights;
      carBattery      : Battery    := CreateBattery;
      currentRoad     : road.Road  := CreateRoad;
      gearStatus      : Gear       := Parked;
      carStatus       : Status     := Off;
      accelerating    : Boolean    := False;
      emergencyBreak  : Boolean    := False;
      diagnosis       : Boolean    := False;
      carPosition     : RoadSize   := 14;
      steeringWheel   : Direction  := Straight;
      carSize         : RoadSize   := 9;
      baterryPer      : Float;

   end record;
   StringError : Unbounded_String;

   procedure Accelerate (This : in out Car; Ammount : in SpeedRange) with
      Pre => This.speed < SpeedRange'Last and
      This.speed < This.currentRoad.speed_limit and
      (This.gearStatus = Forward or This.gearStatus = Reversing) and
      This.accelerating = True and Ammount <= This.currentRoad.speed_limit - This.speed,
      Post => This.speed = This.speed'Old + Ammount;

   procedure Decelerate (This : in out Car; Ammount : in SpeedRange) with
      Pre => This.speed > SpeedRange'First and
      (This.gearStatus = Forward or This.gearStatus = Reversing) and
      This.accelerating = False and Ammount <= This.speed - SpeedRange'First,
      Post => This.speed = This.speed'Old - Ammount;

   procedure StartingCar (This : in out Car) with
      Pre => This.gearStatus = Parked and This.carStatus = Off and
      (for all i in This.dashboardLights.lights'Range =>
         This.dashboardLights.lights (i).state = Off),
      Post => This.carStatus = On;

   procedure GearForward (This : in out Car) with
      Pre => This.speed = 0 and This.carBattery.charging = Off and
      This.dashboardLights.lights (ReadyToDrive).state = On,
      Post => This.gearStatus = Forward;

   procedure GearReversing (This : in out Car) with
      Pre => This.speed = 0 and This.carBattery.charging = Off and
      This.dashboardLights.lights (ReadyToDrive).state = On,
      Post => This.gearStatus = Reversing;

   procedure GearParked (This : in out Car) with
      Pre  => This.speed = 0,
      Post => This.gearStatus = Parked;

   procedure PlugBattery (This : in out Car) with
      Pre => This.gearStatus = Parked and
      This.carBattery.charge < This.carBattery.maxCharge;

   procedure Drive (This : in out Car) with
      Pre => (This.dashboardLights.lights (ReadyToDrive).state = On) and
      (This.gearStatus = Forward or This.gearStatus = Reversing) and
      This.carBattery.charge > This.carBattery.minCharge and
      This.carBattery.charge <= This.carBattery.maxCharge and
      This.carBattery.charging = Off and This.carStatus = On;

   procedure DiagnosisTool (This : in Car) with
      Pre => This.carStatus = On and This.gearStatus = Parked and
      (for some i in This.dashboardLights.lights'Range =>
         This.dashboardLights.lights (i).error = On);

   procedure FixProblems (This : in out Car) with
      Pre => This.carStatus = On and This.gearStatus = Parked and
      (for some i in This.dashboardLights.lights'Range =>
         This.dashboardLights.lights (i).error = On),
      Post =>
      (for all i in This.dashboardLights.lights'Range =>
         This.dashboardLights.lights (i).error = Off);

   procedure Move (This : in out Car; steeringWheel : in Direction) with
      Pre => This.carPosition >= RoadSize'First
      and then This.carPosition <= RoadSize'Last
      and then steeringWheel /= Straight;

end vehicle;
