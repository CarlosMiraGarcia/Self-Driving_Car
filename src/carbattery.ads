with Ada.Text_IO; use Ada.Text_IO;
with helpers; use helpers;

package carbattery with SPARK_Mode is

   type Status is (On, Off);
   wait : Constant Integer := 3;
   currentWait : Integer := 0;

   type BatteryCharge is range 0..100;
   DischargeRatio : constant BatteryCharge := 1;
   Threshold : constant BatteryCharge := (BatteryCharge'Last - DischargeRatio);

   type Battery is record
      charge : BatteryCharge;
      charging : Status;
      MinCharge: BatteryCharge := DischargeRatio;
      MaxCharge: BatteryCharge := BatteryCharge'Last;
   end record;

   procedure ChargeBattery (This : in out Battery) with
     Pre => This.charge < BatteryCharge'Last,
     Post => This.charge >= This.charge'Old;

   procedure UseBattery (This : in out Battery) with
     Pre => This.charge > This.MinCharge and This.charging = Off and This.charge <= This.MaxCharge,
     Post => This.charge <= This.charge'Old;

   function CreateBattery return Battery;

end carbattery;
