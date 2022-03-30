with Ada.Text_IO; use Ada.Text_IO;
with dashboard_warning_lights; use dashboard_warning_lights;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;

procedure Main is
   Dashboard : dashboard_warning_lights.Lights;
   type Lines is
      record
         Line  : Ada.Strings.Unbounded.Unbounded_String;
      end record;
   type LinesArray is array (Natural range <>) of Lines;
   Line : Unbounded_String;
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

   procedure Read_File is
      File_Input : File_Type;
      Lines_Array : LinesArray(1..310);
      SeparatorLine : String := "________________________________________";
   begin
      Open (File => File_Input,
            Mode => In_File,
            Name => "road.txt");
      Clear;

      for i in Lines_Array'Range loop
         Lines_Array(i).Line := Ada.Text_IO.Unbounded_IO.Get_Line(File_Input);
      end loop;

      for i in Lines_Array'Range loop
         if i + 30 <= 310 then
            Line := Lines_Array(i).Line;

            for k in 1..10 loop
               if Element (Line, k) = '#' then
                  Replace_Element(Line, k+11, 'C');
                  Replace_Element(Line, k+12, 'A');
                  Replace_Element(Line, k+13, 'R');
                  Ada.Text_IO.Put_Line(SeparatorLine);
                  Ada.Text_IO.Put_Line("");
                  Ada.Text_IO.Unbounded_IO.Put_Line(Line);
                  exit;
               end if;
            end loop;
            for j in 1..30 loop
               Ada.Text_IO.Unbounded_IO.Put_Line(Lines_Array(i + j).Line);
            end loop;
            Ada.Text_IO.Put_Line(SeparatorLine);
            delay 0.02;
         else
            delay 0.5;
            exit;
         end if;
         Clear;
      end loop;
      Close(File => File_Input);
   end Read_File;

begin
   --  StartingCar;
   --  delay 0.5;
   Read_File;
   --  LightsOn;
   --  Print;
   --  delay 3.0;

end Main;
