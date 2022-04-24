with vehicle_controller;          use vehicle_controller;
with battery_controller;          use battery_controller;
with dashboard_lights_controller; use dashboard_lights_controller;
with helpers;                     use helpers;

package diagnosis_controller with
   SPARK_Mode
is

   function Invariant (This : in Car) return Boolean is
     (This.carStatus = On and This.gearStatus = Parked);

   procedure DiagnosisTool (This : in Car) with
     Pre => Invariant (This);

   procedure FixProblems (This : in out Car) with
      Pre => Invariant (This) and
      (for some i in This.dashboardLights.lights'Range =>
         This.dashboardLights.lights (i).error = On),
      Post => (for all i in This.dashboardLights.lights'Range =>
                 This.dashboardLights.lights (i).error = Off);

end diagnosis_controller;
