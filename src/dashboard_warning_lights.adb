package body dashboard_warning_lights with SPARK_Mode is

   procedure LightsOff (This : in out Lights) is
   begin
      for i in This'Range loop
         if This(i).state /= Off then
            This(i).state := Off;
         end if;
      end loop;
   end LightsOff;


   procedure CheckLight (x: in Switch; y : in TypesOfLights; This : in out Lights) is
   begin
      if x = On or x = Off or x = Error then
         This(y).state := x;
      end if;
   end CheckLight;

end dashboard_warning_lights;
