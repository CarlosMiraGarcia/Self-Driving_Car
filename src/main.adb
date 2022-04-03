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
   SeparatorLine : String := "________________________________________";
   SeparatorLine2: String := "______________________________________________________________";
   type Lines is
      record
         Line  : Ada.Strings.Unbounded.Unbounded_String;
      end record;
   type LinesArray is array (Natural range <>) of Lines;

   procedure Read_File is
      File_Input : File_Type;
      Lines_Array : LinesArray(1..310);

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
      Put_Line (HT & SeparatorLine2);
      Put_Line ("");
      CheckLights(dummy_car.dashboardLights);
      Put_Line ("");
      Put_Line (HT & SeparatorLine2);
      Put_Line ("");
      if dummy_car.carStatus = Off then
         Put (HT & " Car Status: " & HT & ESC & "[101m" & " " & dummy_car.carStatus'Image & " " & ESC & "[0m");
      elsif dummy_car.carStatus = On then
         Put (HT & " Car Status: " & HT & ESC &  "[102m" & " " & dummy_car.carStatus'Image & " " & ESC & "[0m");
      end if;
      Put_Line (HT & HT & HT & "Gear Status: " & dummy_car.gearStatus'Image);
      Put_Line (HT & SeparatorLine2);
      Put_Line ("");
      Put_Line ("");

      if dummy_car.gearStatus = Parked and dummy_car.carBattery.charging = Off then
         Put_Line (HT & "Press a key followed by Enter:");
         Put_Line (HT & HT & HT & HT & HT &  HT &"        _______");
         Put_Line (HT & ESC & "[102m" & " 1 " & ESC & "[0m" & " to Start the car." & HT & HT & "               //  ||\ \");
         Put_Line (HT & ESC & "[102m" & " 2 " & ESC & "[0m" & " to Change gear to Parked." & HT & HT & " _____//___||_\ \___");
         Put_Line (HT & ESC & "[102m" & " 3 " & ESC & "[0m" & " to Change gear to Advancing." & HT & " )  _          _    \");
         Put_Line (HT & ESC & "[102m" & " 4 " & ESC & "[0m" & " to Change gear to Reversing." & HT & " |_/ \________/ \___|");
         Put_Line (HT & ESC & "[102m" & " 5 " & ESC & "[0m" & " to Charge the car." & HT & HT & "      _____\_/________\_/____");
         Put_Line (HT & ESC & "[102m" & " 0 " & ESC & "[0m" & " to exit the program." & HT & "      Art by Colin Douthwaite");
         Get (Item => Ch);
         if Ch = "1" then
            if dummy_car.carBattery.charge = BatteryCharge'First then
               Clear;
               Put_Line (HT & "No battery!!");
               delay(2.0);
            elsif dummy_car.carStatus = Off and dummy_car.gearStatus = Parked
              and (for all i in dummy_car.dashboardLights.lights'Range => dummy_car.dashboardLights.lights(i).state = Off) then
               StartingCar(dummy_car);
            elsif dummy_car.gearStatus /= Parked then
               Put_Line ("");
               Put_Line ("");
               Put_Line (HT & "The car cannot be started unless the gear is set to Parked");
               delay(2.0);
            elsif dummy_car.carStatus = On then
               Put_Line ("");
               Put_Line ("");
               Put_Line (HT & "Car is already on!");
               delay(2.0);
            end if;
         elsif Ch = "2" then
            if dummy_car.carStatus = Off then
               GearParked(dummy_car);
            else
               Put_Line ("");
               Put_Line ("");
               Put_Line (HT & "The speed of the car must be 0 before changing gear!");
            end if;
         elsif Ch = "3" then
            if dummy_car.carStatus = On then
               GearAdvancing(dummy_car);
            else
               Put_Line(HT & "The car needs to be switched on before moving forward");
               delay(2.0);
            end if;
         elsif Ch = "4" then
            if dummy_car.carStatus = On then
               GearReversing(dummy_car);
            else
               Put_Line ("");
               Put_Line ("");
               Put_Line(HT & "The car needs to be switched on before moving backwards");
               delay(2.0);
            end if;
         elsif Ch = "5" then
            if dummy_car.carBattery.charge < BatteryCharge'Last then
               Clear;
               PlugBattery(dummy_car);
            else
               Put_Line ("");
               Put_Line ("");
               Put_Line (HT & "The battery is full!");
               delay(2.0);
            end if;
         elsif Ch = "0" then
            Clear;
            exit;
         end if;
      elsif (dummy_car.gearStatus = Advancing or dummy_car.gearStatus = Reversing)
        and dummy_car.dashboardLights.lights(ReadyToDrive).state = On then
         Drive(dummy_car);
         Put_Line (HT & "Battery Status: " & dummy_car.carBattery.charge'Image & "%");
         Put_Line (HT & "Car Speed: " & dummy_car.speed'Image & " mph");
         Put_Line (HT & "Road Speed: " & dummy_car.currentRoad.speed_limit'Image & " mph");
         Put_Line ("");
         -- ADD MENU THAT LET YOU CHANGE GEAR, STOP, STOP THE CAR, ETC...
         -- ADD MENU THAT LET YOU CHANGE GEAR, STOP, STOP THE CAR, ETC...
         -- ADD MENU THAT LET YOU CHANGE GEAR, STOP, STOP THE CAR, ETC...
         -- ADD MENU THAT LET YOU CHANGE GEAR, STOP, STOP THE CAR, ETC...
         delay(0.5);
      elsif dummy_car.carBattery.charging = On then
         PlugBattery(dummy_car);
         Put_Line (HT & "Charging the Battery");
         Put_line (HT & "Charging: " & dummy_car.carBattery.charging'Image);
         Put_Line (HT & "Battery Status: " & dummy_car.carBattery.charge'Image & "%");
         delay(0.5);
      end if;
   end loop;

   --  delay 0.5;
   -- Read_File;
   -- dashboard_warning_lights.LightsOn;
   --  Print;
   --  delay 3.0;

end Main;
