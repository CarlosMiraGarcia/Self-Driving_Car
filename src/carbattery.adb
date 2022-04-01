with Ada.Text_IO; use Ada.Text_IO;
with helpers; use helpers;

package body carbattery with SPARK_Mode is

   procedure ChargeBattery (This : in out Battery) is
   begin
      if This.charge < MaxCharge then
         This.charge := This.charge + DischargeRatio;
         This.charging := True;
         Put_Line ("Charging");
      else
         This.charging := False;

      end if;
   end ChargeBattery;

   procedure UseBattery (This : in out Battery) is
   begin
      if This.charge >= DischargeRatio and This.charging = False
        and This.charge <= BatteryCharge'Last then
         This.charge := This.charge - DischargeRatio;
      end if;
   end UseBattery;

   function CreateBattery return Battery is
      result : Battery;
   begin
      result := (charge => (15),
                 charging => (False));
      return result;
   end CreateBattery;

end carbattery;
