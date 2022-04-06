package road with SPARK_Mode is

   type SpeedRange is range 0..70;

   type Road is tagged record
      speed_limit : SpeedRange;
   end record;

   procedure UpdateRoadLimit (This : in out Road; speed : in SpeedRange) with
     Pre'Class => speed >= SpeedRange'First and speed <= SpeedRange'Last and speed /= This.speed_limit,
     Post => This.speed_limit >= SpeedRange'First and This.speed_limit <= SpeedRange'Last;

   procedure SetSpeedLimit (This : in out Road; speed : in SpeedRange) with
     Pre'Class => This.speed_limit /= speed and speed >= SpeedRange'First and speed <= SpeedRange'Last,
     Post => This.speed_limit >= SpeedRange'First and This.speed_limit <= SpeedRange'Last;

   function CreateRoad return Road;

end road;
