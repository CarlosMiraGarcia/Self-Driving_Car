package dashboard_warning_lights with SPARK_Mode is

   --Types
   type Switch is (On, Off, Error);
   type TypesOfLights is (ReadyToDrive, Charging, GeneralFault, ElectricalFault,
                   MasterWarning, BatteryTemperature,
                   BatteryCharge, LimitedPower, LowBattery);

   type Light is tagged record
      state : Switch;
   end record;

   type Lights is array (TypesOfLights) of Light;


   procedure LightsOff (This : in out Lights) with
     Pre => (for all i in This'Range => This(i).state /= Off),
     Post => (for all i in This'Range => This(i).state = Off);

   procedure CheckLight (x: in Switch; y : in TypesOfLights; This : in out Lights) with
     Pre => x = On or x = Off or x = Error;


end dashboard_warning_lights;
