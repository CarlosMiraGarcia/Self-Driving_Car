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

   procedure SplitAndRemove
     (StringInput : in String; Pos : in Integer; CarPrint : in String)
   is
      FirstHalf  : String (1 .. Pos);
      SecondHalf : String (1 .. StringInput'Length - Pos);
   begin
      Move (StringInput (1 .. Pos - 1), FirstHalf);
      Move (StringInput (Pos + CarPrint'Length + 1..StringInput'Last), SecondHalf);
      Put_Line (HT & "   " & FirstHalf & CarPrint & SecondHalf);
   end SplitAndRemove;

   function GetChar (StringInput : in String; Pos : in Integer) return String
   is
      FirstPart : String (1 .. 1);
   begin
      if (StringInput'First <= Pos) then
         Move (StringInput (Pos .. Pos), FirstPart);
         return FirstPart;
      else
         return "";
      end if;
   end GetChar;

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


end helpers;
