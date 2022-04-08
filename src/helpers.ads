with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO;
with Ada.Real_Time;

package helpers with
   SPARK_Mode
is

   type Lines is record
      Line : String (1 .. 55);
   end record;

   type LinesArray is array (1 .. 340) of Lines;
   Line_input      : String (1 .. 55);
   Char            : String (1 .. 1);
   CarPosition     : Integer          := 14;
   SidePositionCar : Integer          := 0;
   SidePositionObj : Integer          := 0;
   SideToObject    : Integer          := 0;
   SizeObject      : Integer          := 0;
   StringWarning   : String := "------------------------------------------------------------";
   DisplayedLines  : Constant Integer := 33;

   File_Input : File_Type;

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
     and then StringInput'Length = Line_input'Length and then StringInput'Last > Pos + 1
     and then StringInput'First = 1 and then CarPrint'First > 0 and then CarPrint'Last < 100;

   function GetChar
     (StringInput : String; Pos : Integer) return String with
      Pre => StringInput'First = 1 and then StringInput'Last = 55
      and then Pos < StringInput'Last - 1;

   procedure PrintMenu;
end helpers;
