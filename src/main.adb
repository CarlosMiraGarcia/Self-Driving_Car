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
   NewRun : Boolean := True;

   procedure PrintHeader is
   begin
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
      Put_Line (HT & " Car Speed: " & HT & " " & dummy_car.speed'Image & " mph");


      Put_Line (HT & SeparatorLine2);
      Put_Line ("");
      Put_Line ("");
   end PrintHeader;

   procedure PrintMenu is
   begin
      Put_Line (HT & "Type one of the following options and press Enter:");
      Put_Line ("");
      Put_Line (HT & ESC & "[102m" & " s " & ESC & "[0m" & " to (s)tart/(s)top the car." & HT & HT &"        _______");
      Put_Line (HT & ESC & "[102m" & " p " & ESC & "[0m" & " to change gear to (p)arked." & HT & "               //  ||\ \");
      Put_Line (HT & ESC & "[102m" & " f " & ESC & "[0m" & " to change gear to (f)orward." & HT & " _____//___||_\ \___");
      Put_Line (HT & ESC & "[102m" & " r " & ESC & "[0m" & " to change gear to (r)eversing." & HT & " )  _          _    \");
      Put_Line (HT & ESC & "[102m" & " c " & ESC & "[0m" & " to (c)harge the car." & HT & HT & " |_/ \________/ \___|");
      Put_Line (HT & ESC & "[102m" & " d " & ESC & "[0m" & " to run the (d)iagnosis tool." & "      _____\_/________\_/____");
      Put_Line (HT & ESC & "[102m" & " e " & ESC & "[0m" & " to (e)xit the program." & HT & "      Art by Colin Douthwaite");
   end PrintMenu;

   procedure PrintDiagnosisMenu is
   begin
      Put_Line (HT & "Type one of the following options and press Enter:");
      Put_Line ("");
      Put_Line (HT & ESC & "[102m" & " s " & ESC & "[0m" & " to (s)tart the diagnosis.");
      Put_Line (HT & ESC & "[102m" & " f " & ESC & "[0m" & " to (f)ix the problems.");
      Put_Line (HT & ESC & "[102m" & " b " & ESC & "[0m" & " to go (b)ack.");
      Put_Line (HT & ESC & "[102m" & " e " & ESC & "[0m" & " to (e)xit the program.");
      delay(0.5);
   end PrintDiagnosisMenu;

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
            This.lights(i).error := On;
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
      Clear;
      Put_Line (HT & SeparatorLine2);
      Put_Line ("");
      CheckLights(dummy_car.dashboardLights);
      Put_Line ("");
      Put_Line (HT & SeparatorLine2);
      Put_Line ("");
      if dummy_car.diagnosis then
         PrintDiagnosisMenu;
         if Ch = Ada.Characters.Latin_1.LC_S then
            DiagnosisTool (dummy_car);
            delay(1.0);
         elsif Ch = Ada.Characters.Latin_1.LC_F then
            FixProblems (dummy_car);
         elsif Ch = Ada.Characters.Latin_1.LC_B then
            dummy_car.diagnosis := False;
            Clear;
         end if;
      elsif not dummy_car.diagnosis then
         PrintHeader;
         PrintMenu;
         delay(0.5);
         if Ch = Ada.Characters.Latin_1.LC_S then
            if dummy_car.carBattery.charge = BatteryCharge'First then
               PrintError ("  There is not enough battery to start the car ");
            elsif dummy_car.carStatus = Off and dummy_car.gearStatus = Parked and dummy_car.carBattery.charging = Off then
               if NewRun then
                  RandomFault(dummy_car.dashboardLights);
                  NewRun := False;
               end if;
               StartingCar(dummy_car);
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
               => dummy_car.dashboardLights.lights(light).error = Off) then
               GearForward(dummy_car);
            elsif dummy_car.carStatus = On and dummy_car.dashboardLights.lights(LowBattery).state = On then
               PrintError(" There is not enough battery. Charge it first   ");
            elsif dummy_car.carStatus = Off then
               GearForward(dummy_car);
            elsif dummy_car.speed > 0 then
               PrintError("     Speed must be 0 in order to change gear    ");
            elsif (for some light in dummy_car.dashboardLights.lights'Range
                   => dummy_car.dashboardLights.lights(light).error = Off) then
               PrintError("      Errors found. Run the diagnosis tool      ");
            end if;
         elsif Ch = Ada.Characters.Latin_1.LC_R then
            if dummy_car.carStatus = On  and dummy_car.speed = 0  and
              (for all light in dummy_car.dashboardLights.lights'Range
               => dummy_car.dashboardLights.lights(light).error = Off) then
               GearReversing(dummy_car);
            elsif dummy_car.carStatus = On and dummy_car.dashboardLights.lights(LowBattery).state = On then
               PrintError(" There is not enough battery. Charge it first   ");
            elsif dummy_car.carStatus = Off then
               GearReversing(dummy_car);
            elsif dummy_car.speed > 0 then
               PrintError("     Speed must be 0 in order to change gear    ");
            elsif (for some light in dummy_car.dashboardLights.lights'Range
                   => dummy_car.dashboardLights.lights(light).error = Off) then
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
         elsif Ch = Ada.Characters.Latin_1.LC_D then
            if dummy_car.carStatus = On then
               dummy_car.diagnosis := True;
            else
               PrintError("    The car must be on to start the diagnosis   ");
            end if;
         end if;
         if (dummy_car.gearStatus = Forward or dummy_car.gearStatus = Reversing)
           and dummy_car.dashboardLights.lights(ReadyToDrive).state = On then
            Drive(dummy_car);
         end if;
         if dummy_car.carBattery.charging = On then
            PlugBattery(dummy_car);
         end if;
      end if;
      if Ch = Ada.Characters.Latin_1.LC_E then
         Clear;
         exit;
      end if;
   end loop;

end Main;
