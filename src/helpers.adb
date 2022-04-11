with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;
with Ada.Strings.Fixed;      use Ada.Strings.Fixed;

package body helpers with
   SPARK_Mode
is
   procedure Clear is
   begin
      Put (ASCII.ESC);
      Put ("[2J");
   end Clear;

   procedure PrintError (This : in String) is
   begin
      Put_Line ("");
      Put (HT & ESC & "[101m");
      Put (StringWarning);
      Put_Line (ESC & "[0m");
      Put_Line (HT & ESC & "[101m" & "  Warning: " & This & " " & ESC & "[0m");
      Put (HT & ESC & "[101m");
      Put (StringWarning);
      Put_Line (ESC & "[0m");
      delay (2.0);
   end PrintError;

   procedure PrintInfo (This : in String) is
   begin
      Put_Line ("");
      Put (HT & ESC & "[102m");
      Put (StringWarning);
      Put_Line (ESC & "[0m");
      Put_Line (HT & ESC & "[102m" & "  Info: " & This & ESC & "[0m");
      Put (HT & ESC & "[102m");
      Put (StringWarning);
      Put_Line (ESC & "[0m");
      delay (2.0);
   end PrintInfo;

   procedure PrintMenu is
   begin

      Put_Line (HT & "_MENU_________________________________________________________");
      Put_Line (HT & "Type one of the following options and press Enter:");
      Put_Line ("");
      Put_Line
        (HT & ESC & "[102m" & " s " & ESC & "[0m" &
         " to (s)tart/(s)top the car." & HT & HT & "        _______");
      Put_Line
        (HT & ESC & "[102m" & " p " & ESC & "[0m" &
         " to change gear to (p)arked." & HT & "               //  ||\ \");
      Put_Line
        (HT & ESC & "[102m" & " f " & ESC & "[0m" &
         " to change gear to (f)orward." & HT & " _____//___||_\ \___");
      Put_Line
        (HT & ESC & "[102m" & " r " & ESC & "[0m" &
         " to change gear to (r)eversing." & HT & " )  _          _    \");
      Put_Line
        (HT & ESC & "[102m" & " c " & ESC & "[0m" & " to (c)harge the car." &
         HT & HT & " |_/ \________/ \___|");
      Put_Line
        (HT & ESC & "[102m" & " d " & ESC & "[0m" &
         " to run the (d)iagnosis tool." & "      _____\_/________\_/____");
      Put_Line
        (HT & ESC & "[102m" & " e " & ESC & "[0m" & " to (e)xit the program." &
         HT & "      Art by Colin Douthwaite");
   end PrintMenu;

   procedure PrintHeader (dummy_car : in out vehicle.Car) is
   begin
      Put_Line (HT & "__STATUS______________________________________________________");
      if dummy_car.carStatus = Off then
         Put (HT & " Car Status: " & " " & ESC & "[1;30m" & ESC & "[101m" & " " &
                dummy_car.carStatus'Image & " " & ESC & "[0m");
      elsif dummy_car.carStatus = On then
         Put (HT & " Car Status: " & " " & ESC & "[1;30m" & ESC & "[102m" & " " &
                dummy_car.carStatus'Image & " " & ESC & "[0m");
      end if;
      if dummy_car.carBattery.charging = Off then
         Put_Line (HT & HT & HT & "Charging Status: " & ESC & "[1;30m" & ESC &
                     "[101m" & " " & dummy_car.carBattery.charging'Image & " " & ESC &
                     "[0m");
      elsif dummy_car.carBattery.charging = On then
         Put_Line (HT & HT & HT & "Charging Status: " & ESC & "[1;30m" & ESC &
                     "[102m" & " " & dummy_car.carBattery.charging'Image & " " & ESC &
                     "[0m");
      end if;
      Put (HT & " Gear Status: " & dummy_car.gearStatus'Image);
      dummy_car.baterryPer := Float(dummy_car.carBattery.charge) / Float(BatteryCharge'Last);

      if dummy_car.baterryPer >= 0.5 then
         Put_Line (HT & HT & HT & "Battery Status: " & ESC & "[1;30m" & ESC &
                     "[102m" & Integer(dummy_car.carBattery.charge / BatteryCharge(10))'Image & "% " & ESC & "[0m");
      elsif (dummy_car.baterryPer >= 0.1 and dummy_car.baterryPer < 0.5) then
         Put_Line (HT & HT & HT & "Battery Status: " & ESC & "[1;30m" & ESC &
                     "[43m" & Integer(dummy_car.carBattery.charge / BatteryCharge(10))'Image & "% " & ESC & "[0m");
      else
         Put_Line (HT & HT & HT & "Battery Status: " & ESC & "[1;30m" & ESC &
                     "[101m" & Integer(dummy_car.carBattery.charge / BatteryCharge(10))'Image & "% " & ESC & "[0m");
      end if;
      Put_Line ("");
      Put_Line (HT & "__DRIVING_____________________________________________________");
      Put (HT & " Road Max Speed: " & dummy_car.currentRoad.speed_limit'Image & " mph");
      Put_Line (HT & HT & "Accelerating: " & "  " & dummy_car.accelerating'Image);
      Put (HT & " Car Speed: " & HT & dummy_car.speed'Image & " mph");
      Put_Line (HT & HT & "      Steering Wheel: " & dummy_car.steeringWheel'Image);
      Put_Line ("");
   end PrintHeader;

   procedure PrintDiagnosisMenu is
   begin
      Put_Line (HT & "Type one of the following options and press Enter:");
      Put_Line ("");
      Put_Line
        (HT & ESC & "[102m" & " s " & ESC & "[0m" &
         " to (s)tart the diagnosis.");
      Put_Line
        (HT & ESC & "[102m" & " f " & ESC & "[0m" & " to (f)ix the problems.");
      Put_Line (HT & ESC & "[102m" & " b " & ESC & "[0m" & " to go (b)ack.");
      Put_Line
        (HT & ESC & "[102m" & " e " & ESC & "[0m" & " to (e)xit the program.");

   end PrintDiagnosisMenu;

   procedure SplitAndRemove
     (StringInput : in String; Pos : in Integer; CarPrint : in String)
   is
      FirstHalf  : String (1 .. Pos);
      SecondHalf : String (1 .. StringInput'Length - Pos);
   begin
      Move (StringInput (1 .. Pos), FirstHalf);
      Move (StringInput (Pos + CarPrint'Length + 1..StringInput'Last), SecondHalf);
      Put_Line (HT & "   " & FirstHalf & CarPrint & SecondHalf);
   end SplitAndRemove;

   function GetChar (StringInput : in String; Pos : in Integer) return String
   is
      FirstPart : String (1 .. 1);
   begin
      Move (StringInput (Pos .. Pos), FirstPart);
      return FirstPart;
   end GetChar;

end helpers;
