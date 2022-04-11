package dashboard_controller with SPARK_Mode is

   --Types
   type Switch is (On, Off);
   type ErrorLight is (On, Off);
   type TypesOfLights is (ReadyToDrive, ElectricFault, GeneralFault, Charging,
                          LowBattery, BatteryTemp);

   type Light is record
      state : Switch;
      error : ErrorLight;
   end record;

   type DashboardLights is array (TypesOfLights) of Light;

   type Dashboard is record
      lights : DashboardLights;
   end record;

   type RandRange is range 1..DashboardLights'Length;

   procedure LightsOff (This : in out Dashboard) with
     Pre => (for some i in This.lights'Range => This.lights(i).state /= Off),
     Post => (for all i in This.lights'Range => This.lights(i).state = Off);

   procedure CheckLights (This : in Dashboard) with
     Pre => (for all i in This.lights'Range => This.lights(i).state = On or This.lights(i).state = Off
             or This.lights(i).error = On or This.lights(i).error = Off);

   function CreateLights return Dashboard;

end dashboard_controller;
