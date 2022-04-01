with Ada.Text_IO; use Ada.Text_IO;
with helpers; use helpers;

package body car with SPARK_Mode is

   procedure Accelerate (This : in out Car)  is
   begin
      This.speed := This.speed + 1;
      This.carBattery.UseBattery;
   end Accelerate;

   procedure KeepSpeed (This : in out Car) is
   begin
        This.carBattery.UseBattery;
   end KeepSpeed;

   procedure Decelerate (This : in out Car)  is
   begin
      This.speed := This.speed - 1;
   end Decelerate;

   procedure StartingCar (This : in Car) is
      type Index is range 1..14;
   begin
      for i in 0..2 loop
         for j in Index'Range loop
            -- Change to 0.1 after
            delay 0.01;
            Clear;
            Put ("Starting Car ");
            if j = 1 then
               Put_Line ("o.......");
            elsif j = 2 then
               Put_Line (".o......");
            elsif j = 3 then
               Put_Line ("..o.....");
            elsif j = 4 then
               Put_Line ("...o....");
            elsif j = 5 then
               Put_Line ("....o...");
            elsif j = 6 then
               Put_Line (".....o..");
            elsif j = 7 then
               Put_Line ("......o.");
            elsif j = 8 then
               Put_Line (".......o");
            elsif j = 9 then
               Put_Line ("......o.");
            elsif j = 10 then
               Put_Line (".....o..");
            elsif j = 11 then
               Put_Line ("....o...");
            elsif j = 12 then
               Put_Line ("...o....");
            elsif j = 13 then
               Put_Line ("..o.....");
            elsif j = 14 then
               Put_Line (".o......");
            end if;
         end loop;
      end loop;
   end StartingCar;

   procedure Update (This : in out car) is
   begin
      this.dashboardLights.CheckLights;
      if This.driving = True and This.carBattery.charging = False and This.carBattery.charge >= DischargeRatio then
         if This.speed <= This.currentRoad.speed_limit and This.carBattery.charging = False then
            if This.speed < This.currentRoad.speed_limit then
               This.dashboardLights.lights(ReadyToDrive).state := On;
               This.Accelerate;
            else
               This.KeepSpeed;
            end if;
         end if;
      else
         if This.carBattery.charge = MinCharge and This.driving = True then
            This.dashboardLights.lights(ReadyToDrive).state := Off;
            This.dashboardLights.lights(LowBattery).state := On;
            if This.speed > SpeedRange'First then
               This.Decelerate;
            else
               This.driving := False;
            end if;
         elsif This.driving = False and This.carBattery.charge < MaxCharge then
            This.carBattery.ChargeBattery;
            This.dashboardLights.lights(Charging).state := On;
            This.dashboardLights.lights(ReadyToDrive).state := Off;
            This.carBattery.charging := True;
            if This.carBattery.charge = MaxCharge then
               This.carBattery.charging := False;
               This.dashboardLights.lights(LowBattery).state := Off;
               This.dashboardLights.lights(Charging).state := Off;
               This.driving := True;
            end if;
         end if;
      end if;
   end Update;

end car;
