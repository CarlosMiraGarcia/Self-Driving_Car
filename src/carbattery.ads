with Ada.Text_IO; use Ada.Text_IO;
package carbattery with SPARK_Mode is

   type Status is (On, Off);
   wait : Constant Integer := 3;
   currentWait : Integer := 0;

   type BatteryCharge is range 0..1000;
   DischargeRatio :  constant BatteryCharge := 1;

   type Battery is record
      charge : BatteryCharge;
      charging : Status;
      minCharge: BatteryCharge;
      maxCharge: BatteryCharge;
   end record;

   procedure ChargeBattery (This : in out Battery) with
     Pre => This.charge < This.maxCharge,
     Post => This.charge >= This.charge'Old;

   procedure UseBattery (This : in out Battery) with
     Pre => This.charge > This.minCharge and This.charging = Off and This.charge <= This.maxCharge,
     Post => This.charge <= This.charge'Old;

   function CreateBattery return Battery;

end carbattery;
