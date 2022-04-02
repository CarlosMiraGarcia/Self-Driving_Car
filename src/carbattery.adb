package body carbattery with SPARK_Mode is

   procedure ChargeBattery (This : in out Battery) is
   begin
      if This.charge < MaxCharge then
         This.charge := This.charge + DischargeRatio;
         This.charging := True;
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
      result := (charge => (5),
                 charging => (False));
      return result;
   end CreateBattery;

end carbattery;
