with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Strings.Maps;
with helpers; use helpers;

package body vehicle_controller with
   SPARK_Mode
is

   procedure Accelerate (This : in out Car; Ammount : in SpeedRange) is
   begin
      This.speed := This.speed + Ammount;
   end Accelerate;

   procedure Decelerate (This : in out Car; Ammount : in SpeedRange) is
   begin
      This.speed := This.speed - Ammount;
   end Decelerate;

   procedure StartingCar (This : in out Car) is
      type Index is range 1 .. 15;
   begin
      if
        (for all i in This.dashboardLights.lights'Range =>
           This.dashboardLights.lights (i).error = Off)
      then
         This.dashboardLights.lights (ReadyToDrive).state := On;
      else
         PrintError ("   Run the diagnosis tool to fix the problems   ");
      end if;
      if This.baterryPer <= 0.10 then
         This.dashboardLights.lights (LowBattery).state := On;
      end if;

      This.carStatus := On;
   end StartingCar;

   procedure GearForward (This : in out Car) is
   begin
      This.gearStatus := Forward;
      if This.carStatus = On and
        This.dashboardLights.lights (ReadyToDrive).state = On
      then
         This.accelerating := True;
      elsif
        (for some i in This.dashboardLights.lights'Range =>
           This.dashboardLights.lights (i).error = On)
      then
         PrintError ("   Run the diagnosis tool to fix the problems   ");
      end if;
   end GearForward;

   procedure GearReversing (This : in out Car) is
   begin
      This.gearStatus := Reversing;
      if This.carStatus = On and
        This.dashboardLights.lights (ReadyToDrive).state = On
      then
         This.accelerating := True;
      elsif
        (for some i in This.dashboardLights.lights'Range =>
           This.dashboardLights.lights (i).error = On)
      then
         PrintError ("   Run the diagnosis tool to fix the problems   ");
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
         if This.carBattery.charge < BatteryCharge'Last then
            ChargeBattery (This.carBattery);
            This.dashboardLights.lights (Charging).state := On;
            This.dashboardLights.lights (ReadyToDrive).state := Off;
            This.carBattery.charging := On;
         elsif This.carBattery.charge = BatteryCharge'Last then
            This.dashboardLights.lights (Charging).state := Off;
            This.carBattery.charging := Off;
            if This.carStatus = On then
               This.dashboardLights.lights (ReadyToDrive).state := On;
            end if;
         end if;
         if This.baterryPer >= 0.1 then
            This.dashboardLights.lights (LowBattery).state := Off;
         end if;
      else
         PrintError (" Gear needs to be set to Parked before charging ");
      end if;
   end PlugBattery;

   procedure Drive (This : in out Car) is
   begin
      if This.carStatus = On then
         if This.accelerating = True and
           This.speed <= This.currentRoad.speed_limit and
           Integer (This.carBattery.charge) - Integer (This.speed) > 1
         then
            UseBattery (This.carBattery);
            if This.speed <= This.currentRoad.speed_limit - 5 then
               Accelerate (This, 5);
            elsif This.speed <= This.currentRoad.speed_limit - 1 then
               Accelerate (This, 1);
            end if;
         elsif This.accelerating = False then
            if This.speed >= SpeedRange'First + 5 then
               Decelerate (This, 5);
            elsif This.speed >= SpeedRange'First + 1 then
               Decelerate (This, 1);
            elsif This.speed = 0 then
               This.gearStatus := Parked;
               This.carStatus := Off;
               This.dashboardLights.lights (ReadyToDrive).state := Off;
            end if;
         elsif Integer (This.carBattery.charge) - Integer (This.speed) <= 1
         then
            This.dashboardLights.lights (LowBattery).state := On;
            if This.accelerating = True then
               PrintError ("      Not enough battery. Reducing speed now    ");
               This.accelerating := False;
            end if;
         end if;
      else
         PrintError ("            The car needs to be on            ");
      end if;
   end Drive;

   procedure Move (This : in out Car; steeringWheel : in Direction) is
   begin
      if steeringWheel = Right and This.carPosition /= RoadSize'First then
         This.carPosition := This.carPosition - 1;
      elsif steeringWheel = Left and This.carPosition /= RoadSize'Last then
         This.carPosition := This.carPosition + 1;
      end if;
   end Move;

end vehicle_controller;
