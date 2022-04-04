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
      This.dashboardLights.lights(ReadyToDrive).state := On;
      This.carStatus := On;
   end StartingCar;

   procedure GearAdvancing (This : in out Car) is
   begin
      This.gearStatus := Advancing;
   end GearAdvancing;

   procedure GearReversing (This : in out Car) is
   begin
      This.gearStatus := Reversing;
   end GearReversing;

   procedure GearParked (This : in out Car) is
   begin
      This.gearStatus := Parked;
   end GearParked;

   procedure PlugBattery (This : in out Car) is
   begin
      if this.carBattery.charge < BatteryCharge'Last then
         ChargeBattery(This.carBattery);
         This.dashboardLights.lights(Charging).state := On;
         This.carBattery.charging := On;
      elsif This.carBattery.charge = BatteryCharge'Last then
         This.dashboardLights.lights(LowBattery).state := Off;
         This.dashboardLights.lights(Charging).state := Off;
         This.carBattery.charging := Off;
      end if;
   end PlugBattery;

   procedure Drive (This : in out car) is
   begin
      if This.carStatus = On then
         UseBattery(This.carBattery);
         if Integer(This.carBattery.charge) - Integer(This.speed) >= 1 then
            if This.speed < This.currentRoad.speed_limit then
               Accelerate(This);
            end if;
         else
            Put_Line(HT & "Battery low. Looking for a place to charge");
            This.dashboardLights.lights(LowBattery).state := On;
            if This.speed > SpeedRange'First then
               Decelerate(This);
            else
               This.gearStatus := Parked;
               This.dashboardLights.lights(ReadyToDrive).state := Off;
               This.carStatus := Off;
            end if;
         end if;
      else
         Put_Line(HT & "The car needs to be on.");
         delay(2.0);
      end if;
   end Drive;

      --  if This.carStatus = On and This.carBattery.charge >= DischargeRatio and This.carBattery.charging = False
      --    and (This.gearStatus = Advancing or This.gearStatus = Reversing) then
      --  elsif This.carBattery.charge < DischargeRatio then
      --     This.carStatus := Off;
      --     This.dashboardLights.lights(ReadyToDrive).state := Off;
      --  end if;
end vehicle;
