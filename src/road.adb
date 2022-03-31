package body road with SPARK_Mode is

   procedure UpdateRoadLimit (This : in out Road; speed : in SpeedLimit) is
   begin
      This.speed_limit := speed;
   end UpdateRoadLimit;

end road;
