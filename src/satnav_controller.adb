with vehicle_controller;          use vehicle_controller;
with road_controller;             use road_controller;
with helpers;                     use helpers;
with object_detection_controller; use object_detection_controller;
with Ada.Text_IO;                 use Ada.Text_IO;
with Ada.Characters.Latin_1;      use Ada.Characters.Latin_1;

package body satnav_controller with
   SPARK_Mode
is

   procedure PrintRoad
     (Lines_Array : in Lines; Index : in Integer; dummy_car : in out Car)
   is
   begin
      if Lines_Array'Last > Index + DisplayedLines then
         for i in 1 .. Lines_Array (Index)'Last loop
            if ScanRoad (Lines_Array (Index), i, RoadLane) then
               if
                 (Lines_Array (Index)'Length >
                  i + Integer (dummy_car.carPosition))
               then
                  Put_Line
                    (HT &
                     "__SAT_NAV_____________________________________________________");
                  SplitAndRemove
                    (String (Lines_Array (Index - 5)),
                     i + Integer (dummy_car.carPosition), "  _____  ");
                  SplitAndRemove
                    (String (Lines_Array (Index - 4)),
                     i + Integer (dummy_car.carPosition), " /-----\ ");
                  SplitAndRemove
                    (String (Lines_Array (Index - 3)),
                     i + Integer (dummy_car.carPosition), "(|     |)");
                  SplitAndRemove
                    (String (Lines_Array (Index - 2)),
                     i + Integer (dummy_car.carPosition), " |_____| ");
                  SplitAndRemove
                    (String (Lines_Array (Index - 1)),
                     i + Integer (dummy_car.carPosition), "(|\___/|)");
                  SplitAndRemove
                    (String (Lines_Array (Index)),
                     i + Integer (dummy_car.carPosition), " \_o_o_/ ");
                  exit;
               end if;
            end if;
         end loop;
         for j in 1 .. 27 loop
            Put_Line (HT & "   " & String (Lines_Array (Index + j)));
            AvoidObject (Lines_Array (Index + j), dummy_car, j);
         end loop;
      end if;
   end PrintRoad;

end satnav_controller;
