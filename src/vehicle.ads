
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with dashboard_warning_lights; use dashboard_warning_lights;
with road; use road;
with carbattery; use carbattery;

package vehicle with SPARK_Mode is

   type Gear is (Parked, Forward, Reversing);
   type Accelerator is (Yes, No);

   type Car is record
      speed : SpeedRange := 0;
      dashboardLights : Dashboard := CreateLights;
      carBattery : Battery := CreateBattery;
      currentRoad : road.Road := CreateRoad;
      gearStatus : Gear := Parked;
      carStatus : Status := Off;
      accelerating : Boolean := False;
   end record;
   StringError : Unbounded_String;

   procedure Accelerate (This : in out Car) with
     Pre => This.speed <= SpeedRange'Last and This.speed < This.currentRoad.speed_limit
     and (This.gearStatus = Forward or This.gearStatus = Reversing) and This.accelerating = True,
     Post => This.speed = This.speed'Old + 1;

   procedure Decelerate (This : in out Car) with
     Pre => This.speed > SpeedRange'First and (This.gearStatus = Forward or This.gearStatus = Reversing)
     and This.accelerating = False,
     Post => This.speed = This.speed'Old - 1;

   procedure StartingCar (This: in out Car) with
     Pre => This.gearStatus = Parked and This.carStatus = Off
     and (for all i in This.dashboardLights.lights'Range => This.dashboardLights.lights(i).state = Off),
     Post => This.carStatus = On;

   procedure GearForward (This: in out Car) with
     Pre => This.speed = 0 and This.carBattery.charging = Off and This.dashboardLights.lights(ReadyToDrive).state = On,
     Post => This.gearStatus = Forward;

   procedure GearReversing (This: in out Car) with
     Pre => This.speed = 0 and This.carBattery.charging = Off and This.dashboardLights.lights(ReadyToDrive).state = On,
     Post => This.gearStatus = Reversing;

   procedure GearParked (This: in out Car) with
     Pre => This.speed = 0,
     Post => This.gearStatus = Parked;

   procedure PlugBattery (This : in out Car) with
     Pre => This.gearStatus = Parked and This.carBattery.charge < This.carBattery.MaxCharge;

   procedure Drive (This : in out Car) with
     Pre => (This.dashboardLights.lights(ReadyToDrive).state = On) and (This.gearStatus = Forward or This.gearStatus = Reversing)
     and This.carBattery.charge >= DischargeRatio and This.carBattery.charge > This.carBattery.MinCharge
     and This.carBattery.charge <= This.carBattery.MaxCharge and This.carBattery.charging = Off and This.carStatus = On;

   procedure DiagnosisTool (This : in Car) with
     Pre => This.carStatus = Off and This.gearStatus = Parked;

end vehicle;
