
with dashboard_warning_lights; use dashboard_warning_lights;
with road; use road;
with carbattery; use carbattery;

package vehicle with SPARK_Mode is

   type Gear is (Parked, Advancing, Reversing);
   type Status is (On, Off);

   type Car is record
      speed : SpeedRange := 0;
      dashboardLights : Dashboard := CreateLights;
      carBattery : Battery := CreateBattery;
      currentRoad : road.Road := CreateRoad;
      gearStatus : Gear := Parked;
      carStatus : Status := Off;
   end record;

   procedure Accelerate (This : in out Car) with
     Pre => This.speed <= SpeedRange'Last and This.speed < This.currentRoad.speed_limit,
     Post => This.speed = This.speed'Old + 1;

   procedure Decelerate (This : in out Car) with
     Pre => This.speed > SpeedRange'First,
     Post => This.speed = This.speed'Old - 1;

   procedure StartingCar (This: in out Car) with
     Pre => This.gearStatus = Parked and This.carStatus = Off
     and (for all i in This.dashboardLights.lights'Range => This.dashboardLights.lights(i).state = Off),
     Post => This.carStatus = On;

   procedure GearAdvancing (This: in out Car) with
     Pre => This.speed = 0,
     Post => This.gearStatus = Advancing;

   procedure GearReversing (This: in out Car) with
     Pre => This.speed = 0,
     Post => This.gearStatus = Reversing;

   procedure GearParked (This: in out Car) with
     Pre => This.speed = 0,
     Post => This.gearStatus = Parked;

   procedure PlugBattery (This : in out Car) with
     Pre => This.gearStatus = Parked and This.carBattery.charge < This.carBattery.MaxCharge and This.carStatus = Off;

   procedure Drive (This : in out Car) with
     Pre => (This.dashboardLights.lights(ReadyToDrive).state = On) and (This.gearStatus = Advancing or This.gearStatus = Reversing)
     and This.carBattery.charge >= DischargeRatio and This.carBattery.charge > This.carBattery.MinCharge
     and This.carBattery.charge <= This.carBattery.MaxCharge and (This.gearStatus = Advancing or This.gearStatus = Reversing)
     and This.carBattery.charging = Off and This.carStatus = On;

end vehicle;
