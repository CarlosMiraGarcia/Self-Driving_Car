with Ada.Text_IO; use Ada.Text_IO;

package battery_controller with
   SPARK_Mode
is

   type ChargingStatus is (On, Off);
   type BatteryCharge is range 0 .. 1_000;
   type Battery is record
      currentCharge : BatteryCharge;
      charging      : ChargingStatus;
      minCharge     : BatteryCharge;
      maxCharge     : BatteryCharge;
      batteryPer    : Float;
   end record;

   procedure ChargeBattery (This : in out Battery) with
      Pre  => This.currentCharge < This.maxCharge,
      Post => This.currentCharge >= This.currentCharge'Old;

   procedure UseBattery (This : in out Battery) with
      Pre  => This.currentCharge > This.minCharge and This.charging = Off,
      Post => This.currentCharge < This.currentCharge'Old;

   function BatteryPercentage (This : BatteryCharge) return Float with
      Post => BatteryPercentage'Result >= 0.0 and
      BatteryPercentage'Result <= 100.0;

   function CreateBattery return Battery;

private
   DischargeRatio : constant BatteryCharge := 1;

end battery_controller;
