with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with helpers;                use helpers;

package body dashboard_lights_controller with
   SPARK_Mode
is

   procedure LightsOff (This : in out Dashboard) is
   begin
      for i in This.lights'Range loop
         This.lights (i).state := Off;
      end loop;
   end LightsOff;

   procedure CheckLights (This : in Dashboard) is
   begin
      Put (HT);
      for i in This.lights'Range loop
         if This.lights (i).state = Off and This.lights (i).error = Off then
            Put (" " & i'Image & " ");
            Put (HT & HT & "");
         elsif This.lights (i).state = On and This.lights (i).error = Off then
            Put (ESC & "[102m");
            Put (" " & i'Image & " ");
            Put (ESC & "[0m");
            Put (HT & HT & "");
         elsif This.lights (i).error = On then
            Put (ESC & "[101m");
            Put (" " & i'Image & " ");
            Put (ESC & "[0m");
            Put (HT & HT & "");
         end if;
         if i = GeneralFault then
            Put_Line ("");
            Put (HT);
         end if;
      end loop;
      Put_Line ("");
   end CheckLights;

   function CreateLights return Dashboard is
      result : Dashboard;
   begin
      for i in DashboardLights'Range loop
         result.lights (i) := (state => (Off), error => (Off));
      end loop;
      return result;
   end CreateLights;

end dashboard_lights_controller;
