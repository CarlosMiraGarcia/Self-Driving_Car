package body road_controller with SPARK_Mode is

   procedure UpdateRoadLimit (This : in out Road; speed : in SpeedRange) is
   begin
      This.speed_limit := speed;
   end UpdateRoadLimit;

  function CreateRoad return Road is
      result : Road;
   begin
      result := (speed_limit => (0));
      return result;
   end CreateRoad;

   procedure SetSpeedLimit (This : in out Road; speed : in SpeedRange) is
   begin
      This.speed_limit := speed;
   end SetSpeedLimit;

end road_controller;
