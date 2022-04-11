with helpers;            use helpers;
with vehicle_controller; use vehicle_controller;
with road_controller;    use road_controller;

package object_detection_controller with
   SPARK_Mode
is

   --Types
   type Detection is (RoadShoulder, RoadObject, RoadSurface);
   Distance_Detection : constant Integer := 10;

   function ScanRoad
     (NewLine : in ScanLine; Pos : in Integer; Object : in Detection)
      return Boolean with
      Pre => NewLine'First <= Pos and Pos <= NewLine'Length;

   procedure AvoidObject
     (NewLine : in ScanLine; Dummy_Car : in out Car; j : in Integer) with
      Pre => Dummy_Car.carPosition <= RoadSize'First and
      Dummy_Car.carPosition <= RoadSize'Last and Dummy_Car.carSize = 9;

end object_detection_controller;
