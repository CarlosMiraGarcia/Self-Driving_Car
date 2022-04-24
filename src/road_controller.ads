package road_controller with
   SPARK_Mode
is

   type SpeedRange is range 0 .. 70;
   type RoadSize is range 1 .. 37;

   type Road is record
      speed_limit : SpeedRange;
   end record;

   procedure SetSpeedLimit (This : in out Road; speed : in SpeedRange) with
      Pre => This.speed_limit /= speed and speed >= SpeedRange'First and
      speed <= SpeedRange'Last,
      Post => This.speed_limit = speed;

   function CreateRoad return Road;

end road_controller;
