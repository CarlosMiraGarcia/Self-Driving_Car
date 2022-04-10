package body carbattery with SPARK_Mode is

   procedure ChargeBattery (This : in out Battery) is
   begin
      if This.maxCharge - This.charge >= 10 then
         This.charge := This.charge + DischargeRatio * 10;
      else
         This.charge := This.maxCharge;
      end if;

   end ChargeBattery;

   procedure UseBattery (This : in out Battery) is
   begin
      This.charge := This.charge - DischargeRatio;
   end UseBattery;

   function CreateBattery return Battery is
      result : Battery;
   begin
      result := (charge => (BatteryCharge'Last),
                 charging => (Off),
                 minCharge => (DischargeRatio),
                 maxCharge => (BatteryCharge'Last));
      return result;
   end CreateBattery;

end carbattery;
