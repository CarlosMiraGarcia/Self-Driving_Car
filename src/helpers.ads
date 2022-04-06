with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO;
with Ada.Real_Time;

package helpers with SPARK_Mode is

   type Lines is
      record
         Line  : Ada.Strings.Unbounded.Unbounded_String;
      end record;
   type LinesArray is array (1..310) of Lines;

   Lines_Array : LinesArray;
   Line_input : Unbounded_String;
   SeparatorLine : String := "________________________________________";
   StringWarning : String (1..60) := "------------------------------------------------------------";
   type Index is range 1..10;

   procedure Clear;

   procedure PrintError (This: in String) with
     Pre => This'Length < 100,
     Global => (In_Out => (Ada.Text_IO.File_System),
                Input =>  (StringWarning, Ada.Real_Time.Clock_Time));

   procedure PrintInfo (This: in String) with
     Pre => This'Length < 100,
     Global => (In_Out => (Ada.Text_IO.File_System),
                Input =>  (StringWarning, Ada.Real_Time.Clock_Time));

   --  procedure ReadFile (File_Input : in out File_Type) with
   --    Pre => Is_Open(File_Input) and then Mode (File_Input) /= In_File,
   --    Global => (In_Out => (Lines_Array, Line_input, Ada.Text_IO.File_System),
   --              Input => (SeparatorLine, Ada.Real_Time.Clock_Time));


end helpers;
