package body battery_controller with SPARK_Mode is

   procedure ChargeBattery (This : in out Battery) is
   begin
      if This.maxCharge - This.currentCharge >= 50 then
         This.currentCharge := This.currentCharge + DischargeRatio * 50;
      else
         This.currentCharge := This.maxCharge;
      end if;
      This.batteryPer := BatteryPercentage (This.currentCharge);

   end ChargeBattery;

   procedure UseBattery (This : in out Battery) is
   begin
      This.currentCharge := This.currentCharge - DischargeRatio;
      This.batteryPer := BatteryPercentage (This.currentCharge);
   end UseBattery;

   function BatteryPercentage (This: BatteryCharge) return Float is
   begin
      return (Float(This) / Float (BatteryCharge'Last)) * 100.0;
   end BatteryPercentage;

   function CreateBattery return Battery is
      result : Battery;
   begin
      result := (currentCharge => (300),
                 charging => (Off),
                 minCharge => (DischargeRatio),
                 maxCharge => (BatteryCharge'Last),
                 batteryPer => (BatteryPercentage(300)));
      return result;
   end CreateBattery;

end battery_controller;
