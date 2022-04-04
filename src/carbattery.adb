package body carbattery with SPARK_Mode is

   procedure ChargeBattery (This : in out Battery) is
   begin
      This.charge := This.charge + DischargeRatio;

   end ChargeBattery;

   procedure UseBattery (This : in out Battery) is
   begin
      This.charge := This.charge - DischargeRatio;
   end UseBattery;

   function CreateBattery return Battery is
      result : Battery;
   begin
      result := (charge => (15),
                 charging => (Off),
                 MinCharge => (0),
                 MaxCharge => (15));
      return result;
   end CreateBattery;

end carbattery;
