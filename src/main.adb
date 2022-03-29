with Ada.Text_IO; use Ada.Text_IO;
with dashboard_warning_lights; use dashboard_warning_lights;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

procedure Main is
   Dashboard : dashboard_warning_lights.Lights;

   procedure Clear is
   begin
    Put (ASCII.ESC);
    Put ("[2J");
   end Clear;

   procedure Print is
   begin
      Clear;
      for i in Dashboard'Range loop
         if Dashboard(i).state = Off then
            Put_Line (i'Image & ": " & ESC & "[93m" & Dashboard(i).state'Image & ESC & "[0m");
         elsif Dashboard(i).state = On then
            Put_Line (i'Image & ": " & ESC & "[92m" & Dashboard(i).state'Image & ESC & "[0m");
         elsif Dashboard(i).state = Error then
            Put_Line (i'Image & ": " & ESC & "[91m" & Dashboard(i).state'Image & ESC & "[0m");
         end if;

      end loop;
   end Print;

   procedure LightsOn is
   begin
      for i in Dashboard'Range loop
         Dashboard(i).state := On;
      end loop;
   end LightsOn;

   procedure StartingCar is
   begin
      Clear;
      Put_Line("Starting Car");
   end StartingCar;

begin
   StartingCar;
   delay 3.0;
   LightsOn;
   Print;
   delay 3.0;
end Main;
