with Ada.Text_IO; use Ada.Text_IO;
with helpers; use helpers;

package body car with SPARK_Mode is

   procedure Accelerate (This : in out Car; ThisRoad : in road.Road)  is
   begin
      if This.speed < ThisRoad.speed_limit then
         This.speed := This.speed + 1;
      end if;
   end Accelerate;

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

   procedure FindSpeedLimit (This : in out Car; speed : in SpeedLimit) is
   begin
      if This.roadlimit /= speed then
         This.roadlimit := speed;
      end if;
   end FindSpeedLimit;

end car;
