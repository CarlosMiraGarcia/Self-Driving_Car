with Ada.Text_IO; use Ada.Text_IO;
with dashboard_warning_lights; use dashboard_warning_lights;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;
with car; use car;
with dashboard_warning_lights; use dashboard_warning_lights;
with road; use road;
with helpers; use helpers;

procedure Main is
   dummy_car: car.Car;

   type Lines is
      record
         Line  : Ada.Strings.Unbounded.Unbounded_String;
      end record;
   type LinesArray is array (Natural range <>) of Lines;
   Line : Unbounded_String;

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
   dummy_car.StartingCar;
   delay(0.1);
   Clear;
   dummy_car.currentRoad.SetSpeedLimit(10);
   dummy_car.driving := True;
   delay(0.1);
   while true loop
      Clear;
      dummy_car.Update;
      Put_Line ("Driving: " & dummy_car.driving'Image);
      Put_line ("Charging: " & dummy_car.carBattery.charging'Image);
      Put_Line ("Battery_Status: " & dummy_car.carBattery.charge'Image & "%");
      Put_Line ("Car Speed: " & dummy_car.speed'Image & " mph");
      Put_Line ("Road Speed: " & dummy_car.currentRoad.speed_limit'Image & " mph");
      --  Put_line("Press:");
      --  Put_line("1 for Start");
      delay(0.3);
   end loop;

   --  delay 0.5;
   -- Read_File;
   -- dashboard_warning_lights.LightsOn;
   --  Print;
   --  delay 3.0;

end Main;
