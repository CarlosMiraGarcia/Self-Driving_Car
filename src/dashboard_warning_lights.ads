package dashboard_warning_lights with SPARK_Mode is

   --Types
   type Switch is (On, Off);
   type Error is (On, Off);
   type TypesOfLights is (ReadyToDrive, Charging, GeneralFault, ElectricalFault,
                          MasterWarning, BatteryTemperature, BatteryCharge,
                          LimitedPower, LowBattery);

   type Light is tagged record
      state : Switch;
      fault : Error;
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

   procedure CheckLights (This : in out Dashboard) with
     Post => (for all i in This.lights'Range => This.lights(i).state = On or This.lights(i).state = Off);

   function CreateLights return Dashboard;

end dashboard_warning_lights;
