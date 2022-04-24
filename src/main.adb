with Ada.Text_IO;                 use Ada.Text_IO;
with Ada.Characters.Latin_1;      use Ada.Characters.Latin_1;
with Ada.Text_IO.Text_Streams;    use Ada.Text_IO.Text_Streams;
with Ada.Strings.Unbounded;       use Ada.Strings.Unbounded;
with vehicle_controller;          use vehicle_controller;
with diagnosis_controller;        use diagnosis_controller;
with dashboard_lights_controller; use dashboard_lights_controller;
with battery_controller;          use battery_controller;
with road_controller;             use road_controller;
with helpers;                     use helpers;
with object_detection_controller; use object_detection_controller;
with satnav_controller;           use satnav_controller;
with Ada.Text_IO.Unbounded_IO;
with Ada.Numerics.Discrete_Random;

procedure Main is
   dummy_car    : Car;
   Ch           : Character := Ada.Characters.Latin_1.LC_L;
   NewRun       : Boolean   := True;
   CurrentIndex : Integer   := 6;
   Lines_Array  : LinesArray;

   procedure OpenFile is
      File_Input : File_Type;
   begin
      Open (File => File_Input, Mode => In_File, Name => "road.txt");
      for i in Lines_Array'Range loop
         Lines_Array (i) := ScanLine (Get_Line (File_Input));
      end loop;
      Close (File => File_Input);
   end OpenFile;

   procedure RandomSpeed (This : in out Road) is
      package Rand_Int is new Ada.Numerics.Discrete_Random (SpeedRange);
      use Rand_Int;
      Gene      : Generator;
      NumRandom : SpeedRange;
      Index     : Integer := 20;
      RandomNum : Integer;
   begin
      for i in 1..2 loop
         Reset (Gene);
         NumRandom := Random (Gene);
         RandomNum := Integer(NumRandom);
         if Index = Integer (NumRandom) then
            This.speed_limit := NumRandom;
         end if;
         Index := Index + 10;
         if Index = 80 then
            Index := 20;
         end if;
      end loop;
   end RandomSpeed;

   procedure RandomFault (This : in out Dashboard) is
      type RandRange is range 1 .. DashboardLights'Length;
      package Rand_Int is new Ada.Numerics.Discrete_Random (RandRange);
      use Rand_Int;
      Gene      : Generator;
      NumRandom : RandRange;
      Index     : Integer := 1;
   begin
      for i in This.lights'Range loop
         Reset (Gene);
         NumRandom := Random (Gene);
         if Index = Integer (NumRandom) then
            This.lights (i).error := On;
         end if;
         Index := Index + 1;
      end loop;
   end RandomFault;

   task ReadInput;

   task body ReadInput is
   begin
      loop
         Get_Immediate (Ch);
         delay (0.5);
         if Ch = Ada.Characters.Latin_1.LC_E then
            exit;
         end if;
      end loop;
   end ReadInput;

begin
   OpenFile;
   SetSpeedLimit (dummy_car.currentRoad, 20);
   loop
      delay (0.5);
      Clear;
      Put_Line
        (HT &
         "__DASHBOARD_LIGHTS____________________________________________");
      CheckLights (dummy_car.dashboardLights);
      Put_Line ("");
      if dummy_car.diagnosis then
         PrintDiagnosisMenu;
         if Ch = Ada.Characters.Latin_1.LC_S then
            DiagnosisTool (dummy_car);
         elsif Ch = Ada.Characters.Latin_1.LC_F then
            FixProblems (dummy_car);
         elsif Ch = Ada.Characters.Latin_1.LC_B then
            dummy_car.diagnosis := False;
         end if;
      elsif not dummy_car.diagnosis then
         PrintHeader (dummy_car);
         PrintRoad (Lines_Array, CurrentIndex, dummy_car);
         Put_Line ("");
         PrintMenu;
         if Ch = Ada.Characters.Latin_1.LC_S then
            if dummy_car.carBattery.currentCharge = BatteryCharge'First then
               PrintError ("  There is not enough battery to start the car  ");
            elsif dummy_car.carStatus = Off and
              dummy_car.gearStatus = Parked and
              dummy_car.carBattery.charging = Off
            then
               if NewRun then
                  --RandomFault (dummy_car.dashboardLights);
                  NewRun := False;
               end if;
               StartingCar (dummy_car);
            elsif dummy_car.carStatus = On then
               if dummy_car.speed > SpeedRange'First then
                  dummy_car.braking := True;
                  dummy_car.accelerating := False;

               else
                  LightsOff (dummy_car.dashboardLights);
                  dummy_car.carStatus := Off;
               end if;
            elsif dummy_car.gearStatus /= Parked then
               PrintError ("  To start the car, the gear must be on Parked  ");
            elsif dummy_car.carBattery.charging = On then
               PrintError ("     Wait until the battery is fully charged    ");
            end if;
         elsif Ch = Ada.Characters.Latin_1.LC_P then
            if dummy_car.carStatus = Off and dummy_car.speed = 0 then
               GearParked (dummy_car);
            elsif dummy_car.speed > 0 then
               PrintError ("     Speed must be 0 in order to change gear    ");
            end if;
         elsif Ch = Ada.Characters.Latin_1.LC_F then
            if dummy_car.carStatus = On and dummy_car.speed = 0 and
              (for all light in dummy_car.dashboardLights.lights'Range =>
                 dummy_car.dashboardLights.lights (light).error = Off) and
              dummy_car.carBattery.charging = Off and
              dummy_car.dashboardLights.lights (LowBattery).state = Off
            then
               GearForward (dummy_car);
            elsif dummy_car.dashboardLights.lights (LowBattery).state = On then
               PrintError (" There is not enough battery. Charge it first   ");
            elsif dummy_car.carStatus = Off then
               GearForward (dummy_car);
            elsif dummy_car.speed > 0 then
               PrintError ("     Speed must be 0 in order to change gear    ");
            elsif
              (for some light in dummy_car.dashboardLights.lights'Range =>
                 dummy_car.dashboardLights.lights (light).error = On)
            then
               PrintError ("      Errors found. Run the diagnosis tool      ");
            end if;
         elsif Ch = Ada.Characters.Latin_1.LC_R then
            if dummy_car.carStatus = On and dummy_car.speed = 0 and
              (for all light in dummy_car.dashboardLights.lights'Range =>
                 dummy_car.dashboardLights.lights (light).error = Off) and
              dummy_car.carBattery.charging = Off and
              dummy_car.dashboardLights.lights (LowBattery).state = Off
            then
               GearReversing (dummy_car);
            elsif dummy_car.dashboardLights.lights (LowBattery).state = On then
               PrintError (" There is not enough battery. Charge it first   ");
            elsif dummy_car.carStatus = Off then
               GearReversing (dummy_car);
            elsif dummy_car.speed > 0 then
               PrintError ("     Speed must be 0 in order to change gear    ");
            elsif
              (for some light in dummy_car.dashboardLights.lights'Range =>
                 dummy_car.dashboardLights.lights (light).error = On)
            then
               PrintError ("      Errors found. Run the diagnosis tool      ");
            end if;
         elsif Ch = Ada.Characters.Latin_1.LC_C then
            if dummy_car.carBattery.currentCharge < BatteryCharge'Last and
              dummy_car.gearStatus = Parked
            then
               dummy_car.carBattery.charging := On;
            elsif dummy_car.carBattery.currentCharge = BatteryCharge'Last and
              dummy_car.gearStatus = Parked
            then
               PrintError ("  Cannot charge the battery because it is full  ");
            elsif dummy_car.gearStatus /= Parked then
               PrintError ("    To start charging, set the gear to Parked   ");
            end if;
         elsif Ch = Ada.Characters.Latin_1.LC_D then
            if dummy_car.carStatus = On then
               dummy_car.diagnosis := True;
            else
               PrintError ("    The car must be on to start the diagnosis   ");
            end if;
         elsif
           (dummy_car.gearStatus = Forward or
            dummy_car.gearStatus = Reversing) and
           dummy_car.dashboardLights.lights (ReadyToDrive).state = On
         then
            Drive (dummy_car);
            RandomSpeed (dummy_car.currentRoad);
            if dummy_car.speed > 0 then
               CurrentIndex := CurrentIndex + 1;
            end if;
         elsif dummy_car.carBattery.charging = On then
            PlugBattery (dummy_car);
         end if;
      end if;
      if Ch = Ada.Characters.Latin_1.LC_E then
         Clear;
         exit;
      end if;
   end loop;

end Main;
