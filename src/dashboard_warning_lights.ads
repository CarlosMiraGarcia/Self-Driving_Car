package dashboard_warning_lights with SPARK_Mode is

   --Types
   type Switch is (On, Off, Error);
   type TypesOfLights is (ReadyToDrive, ElectricFault, GeneralFault, Charging,
                          LowBattery, BatteryTemp);

   type Light is record
      state : Switch;
   end record;

   type DashboardLights is array (TypesOfLights) of Light;

   type Dashboard is record
      lights : DashboardLights;
   end record;

   type RandRange is range 1..DashboardLights'Length;

   procedure LightsOff (This : in out Dashboard) with
     Pre => (for all i in This.lights'Range => This.lights(i).state /= Off),
     Post => (for all i in This.lights'Range => This.lights(i).state = Off);

   procedure LightsOn (This : in out Dashboard) with
     Pre => (for all i in This.lights'Range => This.lights(i).state /= On),
     Post => (for all i in This.lights'Range => This.lights(i).state = On);

   procedure CheckLights (This : in Dashboard) with
     Pre => (for all i in This.lights'Range => This.lights(i).state = On or This.lights(i).state = Off
              or This.lights(i).state = Error);

   function CreateLights return Dashboard;

end dashboard_warning_lights;
