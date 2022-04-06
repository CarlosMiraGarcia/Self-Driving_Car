with Ada.Text_IO; use Ada.Text_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;
with Ada.Numerics.Discrete_Random;
with vehicle; use vehicle;
with dashboard_warning_lights; use dashboard_warning_lights;
with carbattery; use carbattery;
with road; use road;
with helpers; use helpers;

procedure Main is
   dummy_car: vehicle.Car;
   Ch : Character := Ada.Characters.Latin_1.LC_L;
   SeparatorLine2: String := "______________________________________________________________";
   BaterryPer : Float;

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
      Put (HT & " Road Max Speed: " & dummy_car.currentRoad.speed_limit'Image & " mph");
      Put_Line (HT & HT & "Accelerating: " & "  " & dummy_car.accelerating'Image);
      Put_Line (HT & " Car Speed: " & HT & "  " & dummy_car.speed'Image & " mph");


      Put_Line (HT & SeparatorLine2);
      Put_Line ("");
      Put_Line ("");
   end PrintHeader;

   procedure RandomFault (This : in out Dashboard) is
      package Rand_Int is new ada.numerics.discrete_random(randRange);
      use Rand_Int;
      Gene : Generator;
      NumRandom : RandRange;
      Index : Integer := 1;
   begin
      reset(Gene);
      NumRandom := Random(Gene);
      for i in This.lights'Range loop
         if Index = Integer(NumRandom) then
            This.lights(i).state := Error;
         end if;
         Index := Index + 1;
      end loop;

   end RandomFault;

   task My_Task;

   task body My_Task is
   begin
      loop
         Get_Immediate(Ch);
         delay(0.5);
         if Ch = Ada.Characters.Latin_1.LC_E then
            exit;
         end if;
      end loop;
   end My_Task;

begin
   dummy_car.currentRoad.SetSpeedLimit(20);
   loop
      PrintHeader;
      Put_Line (HT & "Type one of the following options and press Enter:");
      Put_Line (HT & HT & HT & HT & HT &  HT &"        _______");
      Put_Line (HT & ESC & "[102m" & " s " & ESC & "[0m" & " to (s)tar/(s)top the car." & HT & "               //  ||\ \");
      Put_Line (HT & ESC & "[102m" & " p " & ESC & "[0m" & " to change gear to (p)arked." & HT & HT & " _____//___||_\ \___");
      Put_Line (HT & ESC & "[102m" & " f " & ESC & "[0m" & " to change gear to (f)orward." & HT & " )  _          _    \");
      Put_Line (HT & ESC & "[102m" & " r " & ESC & "[0m" & " to change gear to (r)eversing." & HT & " |_/ \________/ \___|");
      Put_Line (HT & ESC & "[102m" & " c " & ESC & "[0m" & " to (c)harge the car." & HT & "      _____\_/________\_/____");
      Put_Line (HT & ESC & "[102m" & " e " & ESC & "[0m" & " to (e)xit the program." & HT & "      Art by Colin Douthwaite");
      delay(0.5);
      if Ch = Ada.Characters.Latin_1.LC_S then
         if dummy_car.carBattery.charge = BatteryCharge'First then
            PrintError ("  There is not enough battery to start the car ");
            delay(2.0);
         elsif dummy_car.carStatus = Off and dummy_car.gearStatus = Parked and dummy_car.carBattery.charging = Off then
            StartingCar(dummy_car);
            RandomFault(dummy_car.dashboardLights);
            RandomFault(dummy_car.dashboardLights);
         elsif dummy_car.carStatus = On then
            if dummy_car.speed > SpeedRange'First then
               dummy_car.accelerating := False;
            else
               LightsOff(dummy_car.dashboardLights);
               dummy_car.carStatus := Off;
            end if;
         elsif dummy_car.gearStatus /= Parked then
            PrintError ("  To start the car, the gear must be on Parked  ");
         elsif dummy_car.carBattery.charging = On then
            PrintError ("     Wait until the battery is fully charged    ");
         end if;
      elsif Ch = Ada.Characters.Latin_1.LC_P then
         if dummy_car.carStatus = Off and dummy_car.speed = 0 then
            GearParked(dummy_car);
         elsif dummy_car.speed > 0 then
            PrintError("     Speed must be 0 in order to change gear    ");
         end if;
      elsif Ch = Ada.Characters.Latin_1.LC_F then
         if dummy_car.carStatus = On and dummy_car.speed = 0 and
           (for all light in dummy_car.dashboardLights.lights'Range
            => dummy_car.dashboardLights.lights(light).state /= Error) then
            GearForward(dummy_car);
         elsif dummy_car.carStatus = On and dummy_car.dashboardLights.lights(LowBattery).state = On then
            PrintError(" There is not enough battery. Charge it first   ");
         elsif dummy_car.carStatus = Off then
            GearForward(dummy_car);
         elsif dummy_car.speed > 0 then
            PrintError("     Speed must be 0 in order to change gear    ");
         elsif (for some light in dummy_car.dashboardLights.lights'Range
                => dummy_car.dashboardLights.lights(light).state /= Error) then
            PrintError("      Errors found. Run the diagnosis tool      ");
         end if;
      elsif Ch = Ada.Characters.Latin_1.LC_R then
         if dummy_car.carStatus = On  and dummy_car.speed = 0  and
           (for all light in dummy_car.dashboardLights.lights'Range
            => dummy_car.dashboardLights.lights(light).state /= Error) then
            GearReversing(dummy_car);
         elsif dummy_car.carStatus = On and dummy_car.dashboardLights.lights(LowBattery).state = On then
            PrintError(" There is not enough battery. Charge it first   ");
         elsif dummy_car.carStatus = Off then
            GearReversing(dummy_car);
         elsif dummy_car.speed > 0 then
            PrintError("     Speed must be 0 in order to change gear    ");
         elsif (for some light in dummy_car.dashboardLights.lights'Range
                => dummy_car.dashboardLights.lights(light).state /= Error) then
            PrintError("      Errors found. Run the diagnosis tool      ");
         end if;
      elsif Ch = Ada.Characters.Latin_1.LC_C then
         if dummy_car.carBattery.charge < BatteryCharge'Last and dummy_car.gearStatus = Parked then
            dummy_car.carBattery.charging := On;
         elsif dummy_car.carBattery.charge = BatteryCharge'Last and dummy_car.gearStatus = Parked then
            PrintError("  Cannot charge the battery because it is full  ");
         elsif dummy_car.gearStatus /= Parked then
            PrintError("    To start charging, set the gear to Parked   ");
         end if;
      elsif Ch = Ada.Characters.Latin_1.LC_E then
         Clear;
         exit;
      end if;
      if (dummy_car.gearStatus = Forward or dummy_car.gearStatus = Reversing)
        and dummy_car.dashboardLights.lights(ReadyToDrive).state = On then
         Drive(dummy_car);
      elsif dummy_car.carBattery.charging = On then
         PlugBattery(dummy_car);
      end if;
   end loop;

   --  delay 0.5;
   -- Read_File;
   -- dashboard_warning_lights.LightsOn;
   --  Print;
   --  delay 3.0;

end Main;
