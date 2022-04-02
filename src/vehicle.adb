with Ada.Text_IO; use Ada.Text_IO;
with helpers; use helpers;

package body vehicle with SPARK_Mode is

   procedure Accelerate (This : in out Car)  is
   begin
      This.speed := This.speed + 1;
      This.gearStatus := Advancing;
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

   procedure StartingCar (This : in out Car) is
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
      This.carStatus := On;
   end StartingCar;

   procedure StartCharging (This : in out Car) is
   begin
      This.carBattery.ChargeBattery;
   end StartCharging;

   procedure Update (This : in out car) is
   begin
      if This.carStatus = On and This.carBattery.charging = False and This.carBattery.charge >= DischargeRatio then
         if This.speed <= This.currentRoad.speed_limit and This.carBattery.charging = False then
            if This.speed < This.currentRoad.speed_limit then
               This.dashboardLights.lights(ReadyToDrive).state := On;
               This.Accelerate;
            else
               This.KeepSpeed;
            end if;
         end if;
      else
         if This.carBattery.charge = MinCharge and This.carStatus = On then
            This.dashboardLights.lights(ReadyToDrive).state := Off;
            This.dashboardLights.lights(LowBattery).state := On;
            if This.speed > SpeedRange'First then
               This.Decelerate;
            else
               This.gearStatus := Parked;
               This.carStatus := Off;
            end if;
         elsif This.carStatus = Off and This.carBattery.charging = True and
           this.carBattery.charge < MaxCharge and This.gearStatus = Parked then
            This.StartCharging;
            This.dashboardLights.lights(Charging).state := On;
            This.dashboardLights.lights(ReadyToDrive).state := Off;
            if This.carBattery.charge = MaxCharge then
               This.dashboardLights.lights(LowBattery).state := Off;
               This.dashboardLights.lights(Charging).state := Off;
               This.carBattery.charging := False;
            end if;
         end if;
      end if;
   end Update;

end vehicle;
