with dashboard_warning_lights; use dashboard_warning_lights;
with road; use road;
with carbattery; use carbattery;

package car with SPARK_Mode is

   type Gear is (Parked, Advancing, Reversing);

   type Car is tagged record
      speed : SpeedRange := 0;
      dashboardLights : Dashboard := CreateLights;
      carBattery : Battery := CreateBattery;
      driving : Boolean := False;
      currentRoad : road.Road := CreateRoad;
      status : Gear := Parked;
   end record;

   procedure Accelerate (This : in out Car) with
     Pre'Class => This.speed <= SpeedRange'Last and This.speed < This.currentRoad.speed_limit
     and This.carBattery.charge > MinCharge and This.carBattery.charging = False and
     This.carBattery.charge <= MaxCharge and This.driving = True,
     Post => This.speed = This.speed'Old + 1;

   procedure KeepSpeed (This : in out Car) with
     Pre'Class => This.speed = This.currentRoad.speed_limit and This.carBattery.charge > MinCharge
     and This.carBattery.charging = False and This.carBattery.charge <= MaxCharge,
     Post => This.speed = This.speed'Old;

   procedure Decelerate (This : in out Car) with
     Pre'Class => This.speed > SpeedRange'First and This.driving = True,
     Post => This.speed = This.speed'Old - 1;

   procedure StartingCar (This: in Car) with
     Pre'Class => (for all i in This.dashboardLights.lights'Range => This.dashboardLights.lights(i).state = Off
                  and This.status = Parked);

   procedure Update (This : in out Car) with
     Pre'Class => (for all i in This.dashboardLights.lights'Range => This.dashboardLights.lights(i).state = Off);

end car;
