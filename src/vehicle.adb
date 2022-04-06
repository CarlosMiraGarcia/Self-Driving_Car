with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Strings.Maps;
with helpers; use helpers;

package body vehicle with SPARK_Mode is

   procedure Accelerate (This : in out Car)  is
   begin
      This.speed := This.speed + 1;
   end Accelerate;

   procedure Decelerate (This : in out Car)  is
   begin
      This.speed := This.speed - 1;
   end Decelerate;

   procedure StartingCar (This : in out Car) is
      type Index is range 1..15;
   begin
      if (for all i in This.dashboardLights.lights'Range => This.dashboardLights.lights(i).state = Off) then
         This.dashboardLights.lights(ReadyToDrive).state := On;
      else
         PrintError("   Run the diagnosis tool to fix the problems   ");
      end if;
      This.carStatus := On;
   end StartingCar;

   procedure GearForward (This : in out Car) is
   begin
      This.gearStatus := Forward;
      if This.carStatus = On and This.dashboardLights.lights(ReadyToDrive).state = On then
         This.accelerating := True;
      elsif (for some i in This.dashboardLights.lights'Range => This.dashboardLights.lights(i).state = Error) then
         PrintError("   Run the diagnosis tool to fix the problems   ");
      end if;
   end GearForward;

   procedure GearReversing (This : in out Car) is
   begin
      This.gearStatus := Reversing;
      if This.carStatus = On and This.dashboardLights.lights(ReadyToDrive).state = On  then
         This.accelerating := True;
      elsif (for some i in This.dashboardLights.lights'Range => This.dashboardLights.lights(i).state = Error) then
         PrintError("   Run the diagnosis tool to fix the problems   ");
      end if;
   end GearReversing;

   procedure GearParked (This : in out Car) is
   begin
      This.gearStatus := Parked;
      if This.carStatus = On then
         This.accelerating := False;
      end if;
   end GearParked;

   procedure PlugBattery (This : in out Car) is
   begin
      if This.gearStatus = Parked then
         if this.carBattery.charge < BatteryCharge'Last then
            ChargeBattery(This.carBattery);
            This.dashboardLights.lights(Charging).state := On;
            This.dashboardLights.lights(ReadyToDrive).state := Off;
            This.carBattery.charging := On;
         elsif This.carBattery.charge = BatteryCharge'Last then
            This.dashboardLights.lights(LowBattery).state := Off;
            This.dashboardLights.lights(Charging).state := Off;
            This.carBattery.charging := Off;
            if This.carStatus = On then
               This.dashboardLights.lights(ReadyToDrive).state := On;
            end if;
         end if;
      else
         PrintError("Gear needs to be set to Parked before charging");
         delay(2.0);
      end if;
   end PlugBattery;

   procedure Drive (This : in out car) is
   begin
      if This.carStatus = On then
         if This.accelerating = True and This.speed <= This.currentRoad.speed_limit
           and Integer(This.carBattery.charge) - Integer(This.speed) > 1 then
            UseBattery(This.carBattery);
            if This.speed < This.currentRoad.speed_limit then
               Accelerate(This);
            end if;
         elsif This.accelerating = False then
            if This.speed > SpeedRange'First then
               UseBattery(This.carBattery);
               Decelerate(This);
            elsif This.speed = 0 then
               This.gearStatus := Parked;
               This.dashboardLights.lights(ReadyToDrive).state := Off;
               This.carStatus := Off;
            end if;
         end if;
         if Integer(This.carBattery.charge) - Integer(This.speed) <= 1 then
            if This.accelerating = True then
               PrintError("      Not enough battery. Reducing speed now    ");
            end if;
            This.dashboardLights.lights(LowBattery).state := On;
            This.accelerating := False;
         end if;
      else
         PrintError("            The car needs to be on            ");
      end if;
   end Drive;

   procedure DiagnosisTool (This : in Car) is
   begin
      for light in This.dashboardLights.lights'Range loop
         Put_Line ("State of " & light'Image & " is " & This.dashboardLights.lights(light).state'Image);
      end loop;
   end DiagnosisTool;

end vehicle;
