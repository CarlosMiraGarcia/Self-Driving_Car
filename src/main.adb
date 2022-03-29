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
   type Index is range 1..14;
   begin
      for i in 0..2 loop
         for j in Index'Range loop
            delay 0.1;
            Clear;
            Put ("Starting Car ");
            if j = 1 then
               Put_Line ("o.......");
            elsif j = 2 then
               Put_Line (".o......");
            elsif j = 3 then
               Put_Line ("..o.....");
            elsif j = 4 then
               Put_Line ("...o....");
            elsif j = 5 then
               Put_Line ("....o...");
            elsif j = 6 then
               Put_Line (".....o..");
            elsif j = 7 then
               Put_Line ("......o.");
            elsif j = 8 then
               Put_Line (".......o");
            elsif j = 9 then
               Put_Line ("......o.");
            elsif j = 10 then
               Put_Line (".....o..");
            elsif j = 11 then
               Put_Line ("....o...");
            elsif j = 12 then
               Put_Line ("...o....");
            elsif j = 13 then
               Put_Line ("..o.....");
            elsif j = 14 then
               Put_Line (".o......");
            end if;
         end loop;
      end loop;
   end StartingCar;

begin
   --  StartingCar;
   --  delay 0.5;
   LightsOn;
   Print;
   delay 3.0;

end Main;
