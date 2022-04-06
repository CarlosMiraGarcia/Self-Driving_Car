with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;
with Ada.Characters.Latin_1; use Ada.Characters.Latin_1;

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
      delay(2.0);
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
      delay(2.0);
   end PrintInfo;

   --  procedure ReadFile (File_Input : in out File_Type) is
   --  begin
   --     --  Open (File => File_Input,
   --     --        Mode => In_File,
   --     --        Name => "road.txt");
   --     Clear;
   --     for i in Lines_Array'Range loop
   --        Lines_Array (i).Line := Ada.Text_IO.Unbounded_IO.Get_Line (File_Input);
   --     end loop;
   --     for j in Lines_Array'Range loop
   --        if j + 30 <= Lines_Array'Last then
   --           Line_input := Lines_Array(j).Line;
   --           for k in Index'Range loop
   --
   --              if Element (Line_input, Integer(k)) = '#' then
   --                 Replace_Element (Line_input, Integer(k) + 11, 'C');
   --                 Replace_Element (Line_input, Integer(k) + 12, 'A');
   --                 Replace_Element (Line_input, Integer(k) + 13, 'R');
   --                 Ada.Text_IO.Put_Line (SeparatorLine);
   --                 Ada.Text_IO.Put_Line ("");
   --                 Ada.Text_IO.Unbounded_IO.Put_Line (Line_input);
   --                 exit;
   --              end if;
   --           end loop;
   --           for q in 1 .. 30 loop
   --              Ada.Text_IO.Unbounded_IO.Put_Line (Lines_Array (q + j).Line);
   --           end loop;
   --           Ada.Text_IO.Put_Line (SeparatorLine);
   --        else
   --           delay 0.5;
   --           exit;
   --        end if;
   --        Clear;
   --     end loop;
   --     Close (File => File_Input);
   --  end ReadFile;

end helpers;
