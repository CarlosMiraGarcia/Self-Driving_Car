package road with SPARK_Mode is

   type SpeedLimit is range 10..70;

   type Road is tagged record
      speed_limit : SpeedLimit;
   end record;

   procedure UpdateRoadLimit (This : in out Road; speed : in SpeedLimit) with
     Pre'Class => speed >= SpeedLimit'First and speed <= SpeedLimit'Last,
     Post => This.speed_limit >= SpeedLimit'First and This.speed_limit <= SpeedLimit'Last;


end road;
