with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Characters.Latin_1;   use Ada.Characters.Latin_1;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with vehicle;                  use vehicle;
with dashboard_warning_lights; use dashboard_warning_lights;
with carbattery;               use carbattery;
with road;                     use road;
with helpers;                  use helpers;
with object_detection;         use object_detection;
with Ada.Text_IO.Unbounded_IO;
with Ada.Numerics.Discrete_Random;

procedure Main is
   dummy_car      : vehicle.Car;
   Ch             : Character := Ada.Characters.Latin_1.LC_L;
   NewRun       : Boolean := True;
   CurrentIndex : Integer := 7;
   Lines_Array  : LinesArray;



   procedure PrintRoad (Lines_Array : in LinesArray; Index : in Integer) is
      SidePositionObj : Integer          := 0;
      SideToObject    : Integer          := 0;
      SizeObject      : Integer          := 0;
      DisplayedLines  : Constant Integer := 33;
   begin
      if Lines_Array'Last > Index + DisplayedLines then
         for i in 1 .. 10 loop
            if (Lines_Array (Index)'Length > i + Integer(dummy_car.carPosition) + 1) then
               if ScanRoad (Lines_Array (Index), i, RoadShoulder) then
                  Put_Line (HT & "__SAT_NAV_____________________________________________________");
                  SplitAndRemove
                    (String(Lines_Array (Index - 5)), i + Integer(dummy_car.carPosition), "  _____  ");
                  SplitAndRemove
                    (String(Lines_Array (Index - 4)), i + Integer(dummy_car.carPosition), " /-----\ ");
                  SplitAndRemove
                    (String(Lines_Array (Index - 3)), i + Integer(dummy_car.carPosition), "(|     |)");
                  SplitAndRemove
                    (String(Lines_Array (Index - 2)), i + Integer(dummy_car.carPosition), " |_____| ");
                  SplitAndRemove
                    (String(Lines_Array (Index - 1)), i + Integer(dummy_car.carPosition), "(|\___/|)");
                  SplitAndRemove
                    (String(Lines_Array (Index)), i + Integer(dummy_car.carPosition), " \_o_o_/ ");
                  exit;
               end if;
            end if;
         end loop;
         for j in 1 .. 30 loop
            Put_Line (HT & "   " & String(Lines_Array (Index + j)));
            AvoidObject (Lines_Array (Index + j), dummy_car, j);
         end loop;
      end if;
   end PrintRoad;

   procedure OpenFile is
   File_Input : File_Type;
   begin
      Open (File => File_Input, Mode => In_File, Name => "road.txt");
      for i in Lines_Array'Range loop
         Lines_Array (i) := ScanLine(Get_Line (File_Input));
      end loop;
      Close (File => File_Input);
   end OpenFile;

   procedure RandomFault (This : in out Dashboard) is
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
   dummy_car.currentRoad.SetSpeedLimit (20);
   loop
      delay (0.5);
      Clear;
      Put_Line (HT & "__DASHBOARD_LIGHTS____________________________________________");
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
         PrintRoad(Lines_Array, CurrentIndex);
         Put_Line ("");
         Put_Line ("");
         PrintMenu;
         if Ch = Ada.Characters.Latin_1.LC_S then
            if dummy_car.carBattery.charge = BatteryCharge'First then
               PrintError ("  There is not enough battery to start the car  ");
            elsif dummy_car.carStatus = Off and dummy_car.gearStatus = Parked and
              dummy_car.carBattery.charging = Off then
               if NewRun then
                  --RandomFault (dummy_car.dashboardLights);
                  NewRun := False;
               end if;
               StartingCar (dummy_car);
            elsif dummy_car.carStatus = On then
               if dummy_car.speed > SpeedRange'First then
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
                 dummy_car.dashboardLights.lights (light).error = Off)
                and dummy_car.carBattery.charging = Off and dummy_car.dashboardLights.lights(LowBattery).state = Off then
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
              dummy_car.carBattery.charging = Off and dummy_car.dashboardLights.lights(LowBattery).state = Off then
               GearReversing (dummy_car);
            elsif dummy_car.dashboardLights.lights (LowBattery).state = On then
               PrintError (" There is not enough battery. Charge it first   ");
            elsif dummy_car.carStatus = Off then
               GearReversing (dummy_car);
            elsif dummy_car.speed > 0 then
               PrintError ("     Speed must be 0 in order to change gear    ");
            elsif
              (for some light in dummy_car.dashboardLights.lights'Range =>
                 dummy_car.dashboardLights.lights (light).error = On) then
               PrintError ("      Errors found. Run the diagnosis tool      ");
            end if;
         elsif Ch = Ada.Characters.Latin_1.LC_C then
            if dummy_car.carBattery.charge < BatteryCharge'Last and
              dummy_car.gearStatus = Parked then
               dummy_car.carBattery.charging := On;
            elsif dummy_car.carBattery.charge = BatteryCharge'Last and
              dummy_car.gearStatus = Parked then
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
           (dummy_car.gearStatus = Forward or dummy_car.gearStatus = Reversing) and
           dummy_car.dashboardLights.lights (ReadyToDrive).state = On then
            Drive (dummy_car);
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
