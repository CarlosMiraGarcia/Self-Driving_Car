with dashboard_warning_lights; use dashboard_warning_lights;
with road; use road;

package car with SPARK_Mode is

   type Car is tagged record
      speed : SpeedLimit;
      roadlimit : SpeedLimit;
      dashboardLights : Dashboard := CreateLights;
   end record;

   procedure Accelerate (This : in out Car; ThisRoad : in road.Road) with
     Pre'Class => This.speed > SpeedLimit'First and This.speed < SpeedLimit'Last,
     Post => This.speed >= SpeedLimit'First;

   procedure FindSpeedLimit (This : in out Car; speed : in SpeedLimit) with
     Pre'Class => speed >= SpeedLimit'First and speed < SpeedLimit'Last,
     Post => This.roadlimit = speed;

   procedure StartingCar (This: in Car) with
     Pre'Class => (for all i in This.dashboardLights.lights'Range => This.dashboardLights.lights(i).state = Off);

end car;
