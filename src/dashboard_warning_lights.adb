
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with helpers; use helpers;

package body dashboard_warning_lights with SPARK_Mode is

   procedure LightsOff (This : in out Dashboard) is
   begin
      for i in This.lights'Range loop
        This.lights(i).state := Off;
      end loop;
   end LightsOff;

   procedure LightsOn (This : in out Dashboard) is
   begin
      Clear;
      for i in This.lights'Range loop
         This.lights(i).state := On;
         Put (i'Image & ": ");
         Put (ESC & "[92m");
         Put (This.lights(i).state'Image);
         Put_Line (ESC & "[0m");
      end loop;
   end LightsOn;

   procedure CheckLights (This : in out Dashboard) is
   begin
      Clear;
      for i in This.lights'Range loop
         Put (i'Image & ": ");
         if This.lights(i).fault = On then
            This.lights(i).state := On;
            Put (ESC & "[91m");
            Put (This.lights(i).state'Image);
            Put_Line (ESC & "[0m");
         elsif This.lights(i).fault = Off then
            This.lights(i).state := Off;
            Put (ESC & "[93m");
            Put (This.lights(i).state'Image & ESC & "[0m");
            Put_Line (ESC & "[0m");
         end if;


      end loop;
   end CheckLights;

   function CreateLights return Dashboard is
      result : Dashboard;
   begin
      for i in DashboardLights'Range loop
         result.lights(i) := (state => (Off), fault => (Off));
      end loop;
      return result;
   end CreateLights;


end dashboard_warning_lights;
