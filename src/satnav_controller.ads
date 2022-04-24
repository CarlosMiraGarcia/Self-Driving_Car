with vehicle_controller;          use vehicle_controller;
with object_detection_controller; use object_detection_controller;
with road_controller;             use road_controller;
with Ada.Characters.Latin_1;      use Ada.Characters.Latin_1;

package satnav_controller with
   SPARK_Mode
is
   DisplayedLines : constant Integer := 33;

   procedure PrintRoad
     (Lines_Array : in     Lines; Index : in Integer;
      dummy_car   : in out Car) with
      Pre => Index <= Integer'Last - DisplayedLines and Index > 5;

end satnav_controller;
