with Ada.Strings.Unbounded;       use Ada.Strings.Unbounded;
with dashboard_lights_controller; use dashboard_lights_controller;
with road_controller;             use road_controller;
with battery_controller;          use battery_controller;

package vehicle_controller with
   SPARK_Mode
is
   type Gear is (Parked, Forward, Reversing);
   type VechicleStatus is (On, Off);
   type Direction is (Straight, Left, Right);
   type Car is record
      speed           : SpeedRange     := 0;
      dashboardLights : Dashboard      := CreateLights;
      carBattery      : Battery        := CreateBattery;
      currentRoad     : Road           := CreateRoad;
      gearStatus      : Gear           := Parked;
      carStatus       : VechicleStatus := Off;
      accelerating    : Boolean        := False;
      braking         : Boolean        := False;
      diagnosis       : Boolean        := False;
      carPosition     : RoadSize       := 15;
      steeringWheel   : Direction      := Straight;
      size            : RoadSize       := 9;
   end record;

   procedure Brake (Speed : in out SpeedRange; Decrement : in SpeedRange) with
      Pre => Decrement <= Speed and Speed > SpeedRange'First,
      Post => Speed = Speed'Old - Decrement;

   procedure StartingCar (This : in out Car) with
      Pre => This.gearStatus = Parked and This.carStatus = Off and
      (for all i in This.dashboardLights.lights'Range =>
         This.dashboardLights.lights (i).state = Off),
      Post => This.carStatus = On;

   procedure GearForward (This : in out Car) with
      Pre => This.speed = 0 and
      This.dashboardLights.lights (ReadyToDrive).state = On,
      Post => This.gearStatus = Forward;

   procedure GearReversing (This : in out Car) with
      Pre => This.speed = 0 and
      This.dashboardLights.lights (ReadyToDrive).state = On,
      Post => This.gearStatus = Reversing;

   procedure GearParked (This : in out Car) with
      Pre  => This.speed = 0,
      Post => This.gearStatus = Parked;

   procedure PlugBattery (This : in out Car) with
      Pre => This.gearStatus = Parked and
      This.carBattery.currentCharge < This.carBattery.maxCharge;

   procedure Drive (This : in out Car) with
      Pre => (This.dashboardLights.lights (ReadyToDrive).state = On) and
      (This.gearStatus = Forward or This.gearStatus = Reversing) and
      This.carBattery.currentCharge > This.carBattery.minCharge and
      This.carBattery.currentCharge <= This.carBattery.maxCharge and
      This.carBattery.charging = Off and This.carStatus = On;

   procedure MoveLeft (This : in out Car) with
      Pre  => This.carPosition < RoadSize'Last,
      Post => This.carPosition > This.carPosition'Old and
      This.steeringWheel = Left;

   procedure MoveRight (This : in out Car) with
      Pre  => This.carPosition > RoadSize'First,
      Post => This.carPosition < This.carPosition'Old and
      This.steeringWheel = Right;

private
   procedure Accelerate (This : in out Car; Increment : in SpeedRange) with
      Pre => This.speed < This.currentRoad.speed_limit and
      Increment <= This.currentRoad.speed_limit - This.speed,
      Post => This.speed = This.speed'Old + Increment;

end vehicle_controller;
