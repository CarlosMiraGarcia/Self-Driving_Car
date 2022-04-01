package dashboard_warning_lights with SPARK_Mode is

   --Types
   type Switch is (On, Off, Error);
   type TypesOfLights is (ReadyToDrive, ElectricalFault, GeneralFault, Charging,
                          LowBattery, BatteryTemp);

   type Light is record
      state : Switch;
   end record;

   type DashboardLights is array (TypesOfLights) of Light;

   type Dashboard is tagged record
      lights : DashboardLights;
   end record;

   procedure LightsOff (This : in out Dashboard) with
     Pre'Class => (for all i in This.lights'Range => This.lights(i).state /= Off),
     Post => (for all i in This.lights'Range => This.lights(i).state = Off);

   procedure LightsOn (This : in out Dashboard) with
     Pre'Class => (for all i in This.lights'Range => This.lights(i).state /= On),
     Post => (for all i in This.lights'Range => This.lights(i).state = On);

   procedure CheckLights (This : in Dashboard) with
     Pre'Class => (for all i in This.lights'Range => This.lights(i).state = On or This.lights(i).state = Off
              or This.lights(i).state = Error);

   function CreateLights return Dashboard;

end dashboard_warning_lights;
