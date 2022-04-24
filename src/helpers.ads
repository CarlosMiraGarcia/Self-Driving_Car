with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO;
with Ada.Real_Time;
with vehicle_controller;    use vehicle_controller;
with battery_controller;    use battery_controller;

package helpers with
   SPARK_Mode
is

   function Invariant
     (StringInput : in String; Pos : in Integer) return Boolean is
     (StringInput'Last = 55 and StringInput'First = 1 and
      Pos <= StringInput'Last and Pos >= 1);

   procedure Clear;

   procedure PrintError (This : in String) with
      Pre => This'Length <= Integer'Last - 23;

   procedure PrintInfo (This : in String) with
      Pre => This'Length <= Integer'Last - 19;

   procedure PrintHeader (dummy_car : in Car);

   procedure PrintMenu;

   procedure PrintDiagnosisMenu;

   procedure SplitAndRemove
     (StringInput : in String; Pos : in Integer; CarPrint : in String) with
      Pre => Invariant (StringInput, Pos) and CarPrint'Length = 9;

   function GetChar (StringInput : String; Pos : Integer) return String with
      Pre  => Invariant (StringInput, Pos),
      Post => GetChar'Result'Length = 1;

private
   StringWarning : constant String :=
     "------------------------------------------------------------";

end helpers;
