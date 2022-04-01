with Ada.Text_IO; use Ada.Text_IO;
with helpers; use helpers;

package carbattery with SPARK_Mode is

   type BatteryCharge is range 0..20;
   DischargeRatio : constant BatteryCharge := 1;
   Threshold : constant BatteryCharge := (BatteryCharge'Last - DischargeRatio);
   MaxCharge: constant BatteryCharge := 20;
   MinCharge: constant BatteryCharge := 0;

   type Battery is tagged record
      charge : BatteryCharge;
      charging : Boolean;

   end record;

   procedure ChargeBattery (This : in out Battery) with
     Pre'Class => This.charge < MaxCharge,
     Post => This.charge = This.charge'Old + DischargeRatio;

   procedure UseBattery (This : in out Battery) with
     Pre'Class => This.charge > MinCharge and This.charging = False and
     This.charge <= MaxCharge and MinCharge < MaxCharge,
     Post => This.charge = This.charge'Old - DischargeRatio;

   function CreateBattery return Battery;

end carbattery;
