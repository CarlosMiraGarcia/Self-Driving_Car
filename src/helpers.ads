with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO;
with Ada.Real_Time;
with vehicle; use vehicle;
with carbattery; use carbattery;


package helpers with
   SPARK_Mode
is
   type ScanLine is new String (1..55);
   type LinesArray is array (1..340) of ScanLine;

   StringWarning   : String := "------------------------------------------------------------";

   procedure Clear;

   procedure PrintError (This : in String) with
      Pre    => This'Length < 100,
      Global => (In_Out => (Ada.Text_IO.File_System),
       Input => (StringWarning, Ada.Real_Time.Clock_Time));

   procedure PrintInfo (This : in String) with
      Pre    => This'Length < 100,
      Global => (In_Out => (Ada.Text_IO.File_System),
       Input => (StringWarning, Ada.Real_Time.Clock_Time));

   procedure SplitAndRemove
     (StringInput : in String; Pos : in Integer; CarPrint : in String) with
      Pre => Pos <= Integer'Last - 1 and then Pos > 1
     and then StringInput'Length = 55 and then StringInput'Last > Pos + 1
     and then StringInput'First = 1 and then CarPrint'Length = 9;

   function GetChar
     (StringInput : String; Pos : Integer) return String with
     Pre => StringInput'Length = 55 and then Pos <= StringInput'Length
     and then Pos >= 1 and then StringInput'First <= Pos,
     Post => GetChar'Result'Length = 1;

   procedure PrintMenu;

   procedure PrintDiagnosisMenu;

   procedure PrintHeader (dummy_car : in out vehicle.Car) with
     Pre => dummy_car.carBattery.charge > dummy_car.carBattery.minCharge and
     dummy_car.carBattery.maxCharge = BatteryCharge'Last and
     dummy_car.carBattery.charge <= dummy_car.carBattery.maxCharge;

end helpers;
