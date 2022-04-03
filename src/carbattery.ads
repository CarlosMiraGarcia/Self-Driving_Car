with Ada.Text_IO; use Ada.Text_IO;
with helpers; use helpers;

package carbattery with SPARK_Mode is

   type Status is (On, Off);

   type BatteryCharge is range 0..15;
   DischargeRatio : constant BatteryCharge := 1;
   Threshold : constant BatteryCharge := (BatteryCharge'Last - DischargeRatio);
   MinCharge: constant BatteryCharge := DischargeRatio;
   MaxCharge: constant BatteryCharge := BatteryCharge'Last;

   type Battery is record
      charge : BatteryCharge;
      charging : Status;
   end record;

   procedure ChargeBattery (This : in out Battery) with
     Pre => This.charge < BatteryCharge'Last,
     Post => This.charge = This.charge'Old + DischargeRatio;

   procedure UseBattery (This : in out Battery) with
     Pre => This.charge > MinCharge and This.charging = Off and This.charge <= MaxCharge,
     Post => This.charge = This.charge'Old - DischargeRatio;

   function CreateBattery return Battery;

end carbattery;
