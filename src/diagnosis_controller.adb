package body diagnosis_controller with
   SPARK_Mode
is

   procedure DiagnosisTool (This : in Car) is
   begin
      for light in This.dashboardLights.lights'Range loop
         if This.dashboardLights.lights (light).error = On then
            if light = ReadyToDrive then
               PrintError ("FAULTY ReadyToDrive due to faulty cable         ");
            elsif light = ElectricFault then
               PrintError ("FAULTY ElectricFault due to a broken capacitor  ");
            elsif light = GeneralFault then
               PrintError ("FAULTY GeneralFault due to gear malfunction     ");
            elsif light = Charging then
               PrintError ("FAULTY Charging due to faulty battery           ");
            elsif light = LowBattery then
               PrintError ("FAULTY LowBattery due to sensor not responding  ");
            elsif light = BatteryTemp then
               PrintError ("FAULTY BatteryTemp due to high temperatures     ");
            end if;
         end if;
      end loop;
   end DiagnosisTool;

   procedure FixProblems (This : in out Car) is
   begin
      for light in This.dashboardLights.lights'Range loop
         if This.dashboardLights.lights (light).error = On then
            if light = ReadyToDrive then
               PrintInfo
                 ("ReadyToDrive: The faulty cable has been fixed       ");
            elsif light = ElectricFault then
               PrintInfo
                 ("ElectricFault: The capacitor has been replaced      ");
            elsif light = GeneralFault then
               PrintInfo
                 ("GeneralFault: The gear box has been replaced        ");
            elsif light = Charging then
               PrintInfo
                 ("Charging: The battery has been fixed                ");
            elsif light = LowBattery then
               PrintInfo
                 ("LowBattery: The battery sensor has been replaced    ");
            elsif light = BatteryTemp then
               PrintInfo
                 ("BatteryTemp: A faulty sensor has been replaced      ");
            end if;
         end if;
         This.dashboardLights.lights (light).error := Off;
      end loop;
      This.dashboardLights.lights (ReadyToDrive).state := On;
   end FixProblems;

end diagnosis_controller;
