package dashboard_lights_controller with
   SPARK_Mode
is

   --Types
   type Switch is (On, Off);
   type TypesOfLights is
     (ReadyToDrive, ElectricFault, GeneralFault, Charging, LowBattery,
      BatteryTemp);

   type Light is record
      state : Switch;
      error : Switch;
   end record;

   type DashboardLights is array (TypesOfLights) of Light;

   type Dashboard is record
      lights : DashboardLights;
   end record;

   procedure LightsOff (This : in out Dashboard) with
      Pre =>
      (for all i in This.lights'Range =>
         (This.lights (i).state = On or This.lights (i).state = Off)),
      Post => (for all i in This.lights'Range => This.lights (i).state = Off);

   procedure CheckLights (This : in Dashboard) with
      Pre =>
      (for all i in This.lights'Range =>
         (This.lights (i).state = On or This.lights (i).state = Off) and
         (This.lights (i).error = On or This.lights (i).error = Off));

   function CreateLights return Dashboard;

end dashboard_lights_controller;
