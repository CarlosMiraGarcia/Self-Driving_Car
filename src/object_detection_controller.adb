with Ada.Text_IO; use Ada.Text_IO;
with helpers;     use helpers;

package body object_detection_controller with
   SPARK_Mode
is

   function ScanRoad
     (NewLine : in ScanLine; Pos : in Integer; Object : in Detection)
      return Boolean
   is
      SingleChar : String (1 .. 1);
   begin
      SingleChar := GetChar (String (NewLine), Pos);
      if SingleChar = "#" and Object = RoadLane then
         return True;
      elsif SingleChar = "X" and Object = RoadObject then
         return True;
      elsif SingleChar = " " and Object = RoadSurface then
         return True;
      else
         return False;
      end if;
   end ScanRoad;

   procedure AvoidObject (NewLine : in ScanLine; Dummy_Car : in out Car; j : in Integer)
   is
      ShoulderToObject : RoadSize;
      SizeObject       : RoadSize;
      RoadShoulderPos  : RoadSize := 2;
      Pos              : Integer;

   begin
      if j < 10 then
         for k in RoadSize'Range loop
            if ScanRoad(NewLine, Integer(k), RoadLane) then
               RoadShoulderPos := k;
            elsif k - RoadShoulderPos > 1 and ScanRoad (NewLine, Integer(k), RoadObject) then
               ShoulderToObject := k - RoadShoulderPos - 1;
               SizeObject       := 1;
               for p in k + 1 .. RoadSize'Last loop
                  if SizeObject < RoadSize'Last and ScanRoad (NewLine, Integer(p), RoadObject) then
                     SizeObject := SizeObject + RoadSize(1);
                  else
                     exit;
                  end if;
               end loop;
               for t in 0 .. SizeObject + 1 loop
                  for h in 0..Dummy_Car.size loop
                     if Dummy_Car.carPosition <= RoadSize'Last
                       and Dummy_Car.size = 9 and ShoulderToObject + t = Dummy_Car.carPosition + h then
                        Pos := Integer(RoadShoulderPos + (RoadSize'Last - Dummy_Car.size));
                        if ShoulderToObject > 9 and Dummy_Car.carPosition > RoadSize'First then
                           MoveRight (Dummy_Car);
                        elsif ShoulderToObject <= 9 and Pos <= NewLine'Length then
                           if ScanRoad (NewLine, Pos, RoadSurface) and Dummy_Car.carPosition < RoadSize'Last then
                              MoveLeft (Dummy_Car);
                           elsif ScanRoad (NewLine, Pos, RoadObject) then
                              Dummy_Car.braking := True;
                              Dummy_Car.accelerating := False;
                              return;
                           end if;
                        end if;
                     end if;
                  end loop;
               end loop;
               exit;
            end if;
            if j = 1 then
               Dummy_Car.steeringWheel := Straight;
            end if;
         end loop;
      end if;
   end AvoidObject;

end object_detection_controller;
