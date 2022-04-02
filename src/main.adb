with Ada.Text_IO; use Ada.Text_IO;
with dashboard_warning_lights; use dashboard_warning_lights;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;
with vehicle; use vehicle;
with dashboard_warning_lights; use dashboard_warning_lights;
with carbattery; use carbattery;
with road; use road;
with helpers; use helpers;

procedure Main is
   dummy_car: vehicle.Car;
   Line : Unbounded_String;
   Ch : String (1..1);

   type Lines is
      record
         Line  : Ada.Strings.Unbounded.Unbounded_String;
      end record;
   type LinesArray is array (Natural range <>) of Lines;

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
   dummy_car.currentRoad.SetSpeedLimit(10);
   loop
      Clear;
      dummy_car.dashboardLights.CheckLights;
      if dummy_car.carStatus = Off and dummy_car.carBattery.charging = False then
         Put_Line ("Press a key followed by Enter:" & HT & HT & "        _______");
         Put_Line (HT & HT & HT & HT & "               //  ||\ \");
         Put_Line (HT & ESC & "[102m" & " 1 " & ESC & "[0m" & " to Start the car." & HT & HT & " _____//___||_\ \___");
         Put_Line (HT & ESC & "[102m" & " 2 " & ESC & "[0m" & " to Charge the car." & HT & HT & " )  _          _    \");
         Put_Line (HT & ESC & "[102m" & " 3 " & ESC & "[0m" & " to Change gear." & HT & HT & " |_/ \________/ \___|");
         Put_Line (HT & ESC & "[102m" & " 0 " & ESC & "[0m" & " to exit the program." & "        ___\_/________\_/______");
         Put_Line (HT & HT & HT & HT & "        Art by Colin Douthwaite");
         Get (Item => Ch);
         if Ch = "1" then
            dummy_car.StartingCar;
         elsif Ch = "2" then
            if dummy_car.carBattery.charge < BatteryCharge'Last then
               Clear;
               dummy_car.carBattery.charging := True;
               dummy_car.carStatus := Off;
               Put_Line ("chargin");
            else
               Clear;
               Put_Line ("The battery is full!");
               delay(1.0);
            end if;
         --  elsif Ch = "3" then
         --  end if;
         elsif Ch = "0" then
            Clear;
            exit;
         end if;
      elsif dummy_car.carStatus = On then
         dummy_car.Update;
         Put_Line ("Car status: " & dummy_car.carStatus'Image);
         Put_Line ("Gear status: " & dummy_car.gearStatus'Image);
         Put_line ("Charging: " & dummy_car.carBattery.charging'Image);
         Put_Line ("Battery Status: " & dummy_car.carBattery.charge'Image & "%");
         Put_Line ("Car Speed: " & dummy_car.speed'Image & " mph");
         Put_Line ("Road Speed: " & dummy_car.currentRoad.speed_limit'Image & " mph");
         Put_Line ("");
         delay(0.3);
      elsif dummy_car.carBattery.charging = True then
         dummy_car.Update;
         Put_Line ("Charging the Battery");
         Put_line ("Charging: " & dummy_car.carBattery.charging'Image);
         Put_Line ("Battery Status: " & dummy_car.carBattery.charge'Image & "%");
         delay(0.3);
      end if;

   end loop;

   --  delay 0.5;
   -- Read_File;
   -- dashboard_warning_lights.LightsOn;
   --  Print;
   --  delay 3.0;

end Main;
