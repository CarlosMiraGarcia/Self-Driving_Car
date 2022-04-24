with helpers;            use helpers;
with vehicle_controller; use vehicle_controller;
with road_controller;    use road_controller;

package object_detection_controller with
   SPARK_Mode
is
   --Types
   type ScanLine is new String (1 .. 55);
   type LinesArray is array (1 .. 340) of ScanLine;
   type Detection is (RoadLane, RoadObject, RoadSurface);
   type DistanceFoot is range 1 .. 100;

   function ScanRoad
     (NewLine : in ScanLine; Pos : in Integer; Object : in Detection)
      return Boolean with
      Pre => NewLine'First <= Pos and Pos <= NewLine'Length;

   procedure AvoidObject
     (NewLine : in ScanLine; Dummy_Car : in out Car; j : in Integer) with
      Pre => Dummy_Car.carPosition >= RoadSize'First and
      Dummy_Car.carPosition <= RoadSize'Last and NewLine'First = 1 and
      NewLine'Last = 55;

end object_detection_controller;
