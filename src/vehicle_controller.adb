with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Strings.Maps;
with helpers;                use helpers;

package body vehicle_controller with
   SPARK_Mode
is

   procedure Accelerate (This : in out Car; Increment : in SpeedRange) is
   begin
      This.speed := This.speed + Increment;
   end Accelerate;

   procedure Brake (Speed : in out SpeedRange; Decrement : in SpeedRange) is
   begin
      Speed := Speed - Decrement;
   end Brake;

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
      if This.carBattery.batteryPer <= 0.10 then
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
         if This.carBattery.currentCharge < BatteryCharge'Last then
            ChargeBattery (This.carBattery);
            This.dashboardLights.lights (Charging).state     := On;
            This.dashboardLights.lights (ReadyToDrive).state := Off;
            This.carBattery.charging                         := On;
         elsif This.carBattery.currentCharge = BatteryCharge'Last then
            This.dashboardLights.lights (Charging).state := Off;
            This.carBattery.charging                     := Off;
            if This.carStatus = On then
               This.dashboardLights.lights (ReadyToDrive).state := On;
            end if;
         end if;
         if This.carBattery.batteryPer >= 0.1 then
            This.dashboardLights.lights (LowBattery).state := Off;
         end if;
      else
         PrintError (" Gear needs to be set to Parked before charging ");
      end if;
   end PlugBattery;

   procedure Drive (This : in out Car) is
   begin
      if This.carStatus = On then
         if This.braking = False and This.accelerating = True then
            if This.speed <= This.currentRoad.speed_limit and
              This.braking = False and
              Integer (This.carBattery.currentCharge) - Integer (This.speed) >
                1
            then
               UseBattery (This.carBattery);
               if This.speed <= This.currentRoad.speed_limit - 5 then
                  Accelerate (This, 5);
               elsif This.speed <= This.currentRoad.speed_limit - 1 then
                  Accelerate (This, 1);
               end if;
            end if;
         elsif This.braking or This.speed > This.currentRoad.speed_limit then
            if This.speed >= SpeedRange'First + 10 then
               Brake (This.speed, 10);
            elsif This.speed >= SpeedRange'First + 4 then
               Brake (This.speed, 4);
            elsif This.speed >= SpeedRange'First + 2 then
               Brake (This.speed, 2);
            elsif This.speed >= SpeedRange'First + 1 then
               Brake (This.speed, 1);
            elsif This.speed = 0 then
               This.gearStatus                                  := Parked;
               This.carStatus                                   := Off;
               This.dashboardLights.lights (ReadyToDrive).state := Off;
               This.accelerating                                := False;
               This.braking                                     := False;
            end if;
         elsif Integer (This.carBattery.currentCharge) -
           Integer (This.speed) <=
           1
         then
            This.dashboardLights.lights (LowBattery).state := On;
            if This.braking = False then
               PrintError ("      Not enough battery. Reducing speed now    ");
               This.braking := True;
               This.accelerating := False;
            end if;
         end if;
      else
         PrintError ("            The car needs to be on            ");
      end if;
   end Drive;

   procedure MoveLeft (This : in out Car) is
   begin
      This.carPosition   := This.carPosition + 1;
      This.steeringWheel := Left;
   end MoveLeft;

   procedure MoveRight (This : in out Car) is
   begin
      This.carPosition   := This.carPosition - 1;
      This.steeringWheel := Right;
   end MoveRight;

end vehicle_controller;
