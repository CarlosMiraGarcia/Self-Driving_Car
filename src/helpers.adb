with Ada.Text_IO; use Ada.Text_IO;

package body helpers with SPARK_Mode is

  procedure Clear is
   begin
      Put (ASCII.ESC);
      Put ("[2J");
   end Clear;

end helpers;
