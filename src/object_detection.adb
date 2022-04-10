with Ada.Text_IO; use Ada.Text_IO;
with helpers;     use helpers;

package body object_detection with
   SPARK_Mode
is

   function ScanRoad
     (NewLine : in ScanLine; Pos : in Integer; Object : in Detection)
      return Boolean
   is
      Char : String (1 .. 1);
   begin
      Char := GetChar (String (NewLine), Pos);
      if Char = "#" and Object = RoadShoulder then
         return True;
      elsif Char = "X" and Object = RoadObject then
         return True;
      elsif Char = " " and Object = RoadSurface then
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
            if ScanRoad(NewLine, Integer(k), RoadShoulder) then
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
                  for h in 0..Dummy_Car.carSize loop
                     if Dummy_Car.carPosition <= RoadSize'Last
                       and Dummy_Car.carSize = 9 and ShoulderToObject + t = Dummy_Car.carPosition + h then
                        Pos := Integer(RoadShoulderPos + (RoadSize'Last - Dummy_Car.carSize));
                        if ShoulderToObject > 9 then
                           Move (Dummy_Car, Left);
                        elsif ShoulderToObject <= 9 and Pos <= NewLine'Length then
                           if ScanRoad (NewLine, Pos, RoadSurface) and Dummy_Car.carPosition >= RoadSize'First then
                              Move (Dummy_Car, Right);
                           elsif ScanRoad (NewLine, Pos, RoadObject) then
                              Put_Line ("Cannot move");
                           end if;
                        end if;
                     end if;
                  end loop;
               end loop;
               exit;
            end if;
         end loop;
      end if;
   end AvoidObject;

end object_detection;
