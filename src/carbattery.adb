package body carbattery with SPARK_Mode is

   procedure ChargeBattery (This : in out Battery) is
   begin
      if BatteryCharge'Last - This.charge >= 10 then
         This.charge := This.charge + DischargeRatio * 10;
      else
         This.charge := BatteryCharge'Last;
      end if;

   end ChargeBattery;

   procedure UseBattery (This : in out Battery) is
   begin
      This.charge := This.charge - DischargeRatio;
   end UseBattery;

   function CreateBattery return Battery is
      result : Battery;
   begin
      result := (charge => (100),
                 charging => (Off),
                 MinCharge => (0),
                 MaxCharge => (30));
      return result;
   end CreateBattery;

end carbattery;
