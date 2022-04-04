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
   Ch : Character := Ada.Characters.Latin_1.LC_L;
   Ch2 : Character := Ada.Characters.Latin_1.LC_L;
   SeparatorLine : String := "________________________________________";
   SeparatorLine2: String := "______________________________________________________________";
   BaterryPer : Float;

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

   procedure PrintHeader is
   begin
      Clear;
      Put_Line (HT & SeparatorLine2);
      Put_Line ("");
      CheckLights(dummy_car.dashboardLights);
      Put_Line ("");
      Put_Line (HT & SeparatorLine2);
      Put_Line ("");
      if dummy_car.carStatus = Off then
         Put (HT & " Car Status: " & " " & ESC & "[1;30m" & ESC & "[101m" & " " & dummy_car.carStatus'Image & " " & ESC & "[0m");
      elsif dummy_car.carStatus = On then
         Put (HT & " Car Status: " & " " & ESC & "[1;30m" & ESC & "[102m" & " " & dummy_car.carStatus'Image & " " & ESC & "[0m");
      end if;
      if dummy_car.carBattery.charging = Off then
         Put_Line (HT & HT & HT & "       Charging: " & ESC & "[1;30m" & ESC & "[101m" & " " & dummy_car.carBattery.charging'Image & " " & ESC & "[0m");
      elsif dummy_car.carBattery.charging = On then
         Put_Line (HT & HT & HT & "       Charging: " & ESC &  "[1;30m" & ESC & "[102m" & " " & dummy_car.carBattery.charging'Image & " " & ESC & "[0m");
      end if;
      Put (HT & " Gear Status: " & dummy_car.gearStatus'Image);
      BaterryPer := Float(dummy_car.carBattery.charge) / Float(dummy_car.carBattery.MaxCharge);
      if BaterryPer >= 0.6 then
         Put_Line(HT & HT & HT & " Battery Status: " & ESC & "[1;30m" & ESC & "[102m" & dummy_car.carBattery.charge'Image  & "% " & ESC & "[0m");
      elsif (BaterryPer >= 0.2 and BaterryPer < 0.6) then
         Put_Line (HT & HT & HT & " Battery Status: " & ESC & "[1;30m" & ESC & "[43m" & dummy_car.carBattery.charge'Image  & "% " & ESC & "[0m");
      else
         Put_Line (HT & HT & HT & " Battery Status: " & ESC & "[1;30m" & ESC & "[101m" & dummy_car.carBattery.charge'Image  & "% " & ESC & "[0m");
      end if;

      Put_Line (HT & SeparatorLine2);
      Put_Line ("");
      Put_Line (HT & " Road Max Speed: " & dummy_car.currentRoad.speed_limit'Image & " mph");
      Put_Line (HT & " Car Speed:   " & HT & "  " & dummy_car.speed'Image & " mph");
      Put_Line (HT & SeparatorLine2);
      Put_Line ("");
      Put_Line ("");
   end PrintHeader;


   task My_Task;

   task body My_Task is
   begin
      loop
         Get_Immediate(Ch);
         delay(0.5);
      end loop;
   end My_Task;

begin
   dummy_car.currentRoad.SetSpeedLimit(10);

   loop
      PrintHeader;
      if dummy_car.gearStatus = Parked and dummy_car.carBattery.charging = Off then

         Put_Line (HT & "Type one of the following options and press Enter:");
         Put_Line (HT & HT & HT & HT & HT &  HT &"        _______");
         Put_Line (HT & ESC & "[102m" & " s " & ESC & "[0m" & " to (s)tar/(s)top the car." & HT & "               //  ||\ \");
         Put_Line (HT & ESC & "[102m" & " p " & ESC & "[0m" & " to change gear to (p)arked." & HT & HT & " _____//___||_\ \___");
         Put_Line (HT & ESC & "[102m" & " a " & ESC & "[0m" & " to change gear to (a)dvancing." & HT & " )  _          _    \");
         Put_Line (HT & ESC & "[102m" & " r " & ESC & "[0m" & " to c gear to (r)eversing." & HT & HT & " |_/ \________/ \___|");
         Put_Line (HT & ESC & "[102m" & " c " & ESC & "[0m" & " to (c)harge the car." & HT & "      _____\_/________\_/____");
         Put_Line (HT & ESC & "[102m" & " e " & ESC & "[0m" & " to (e)xit the program." & HT & "      Art by Colin Douthwaite");
         delay(0.5);
         if Ch = Ada.Characters.Latin_1.LC_S then
            if dummy_car.carBattery.charge = BatteryCharge'First then
               Put_Line (HT & "No battery!!");
               delay(2.0);
            elsif dummy_car.carStatus = Off and dummy_car.gearStatus = Parked
              and (for all i in dummy_car.dashboardLights.lights'Range => dummy_car.dashboardLights.lights(i).state = Off) then
               StartingCar(dummy_car);
            elsif dummy_car.carStatus = On then
               dummy_car.dashboardLights.lights(ReadyToDrive).state := Off;
               dummy_car.carStatus := Off;
            elsif dummy_car.gearStatus /= Parked then
               Put_Line (HT & "The car cannot be started unless the gear is set to Parked");
               delay(2.0);
            end if;
         elsif Ch = Ada.Characters.Latin_1.LC_P then
            if dummy_car.carStatus = Off then
               GearParked(dummy_car);
            end if;
         elsif Ch = Ada.Characters.Latin_1.LC_A then
            if dummy_car.carStatus = On then
               GearAdvancing(dummy_car);
            else
               Put_Line(HT & "The car needs to be switched on before moving forward");
               delay(2.0);
            end if;
         elsif Ch = Ada.Characters.Latin_1.LC_R then
            if dummy_car.carStatus = On then
               GearReversing(dummy_car);
            else
               Put_Line(HT & "The car needs to be switched on before moving backwards");
               delay(2.0);
            end if;
         elsif Ch = Ada.Characters.Latin_1.LC_C then
            if dummy_car.carBattery.charge < BatteryCharge'Last then
               Clear;
               PlugBattery(dummy_car);
            else
               Put_Line (HT & "The battery is full!");
               delay(2.0);
            end if;
         elsif Ch = Ada.Characters.Latin_1.LC_E then
            Clear;
            exit;
         end if;

      elsif (dummy_car.gearStatus = Advancing or dummy_car.gearStatus = Reversing)
        and dummy_car.dashboardLights.lights(ReadyToDrive).state = On then
            PrintHeader;
            Drive(dummy_car);
         Put_Line (HT & "Type one of the following options and press Enter:");
         Put_Line (HT & HT & HT & HT & HT &  HT &"        _______");
         Put_Line (HT & ESC & "[102m" & " s " & ESC & "[0m" & " to (s)top the car." & HT & HT & "               //  ||\ \");
         Put_Line (HT & ESC & "[102m" & " p " & ESC & "[0m" & " to change gear to (p)arked." & HT & HT & " _____//___||_\ \___");
         Put_Line (HT & ESC & "[102m" & " a " & ESC & "[0m" & " to change gear to (a)dvancing." & HT & " )  _          _    \");
         Put_Line (HT & ESC & "[102m" & " r " & ESC & "[0m" & " to c gear to (r)eversing." & HT & HT & " |_/ \________/ \___|");
         Put_Line (HT & ESC & "[102m" & " c " & ESC & "[0m" & " to (c)harge the car." & HT & "      _____\_/________\_/____");
         Put_Line (HT & ESC & "[102m" & " e " & ESC & "[0m" & " to (e)xit the program." & HT & "      Art by Colin Douthwaite");
         delay(0.5);
         if Ch = Ada.Characters.Latin_1.LC_E then
            Clear;
            dummy_car.gearStatus := Parked;
         end if;

      elsif dummy_car.carBattery.charging = On then
         delay(0.5);
         PlugBattery(dummy_car);
      end if;
   end loop;

   --  delay 0.5;
   -- Read_File;
   -- dashboard_warning_lights.LightsOn;
   --  Print;
   --  delay 3.0;

end Main;
