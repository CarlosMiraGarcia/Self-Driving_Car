package object_detection with SPARK_Mode is

   --Types

   Distance_Detection: Integer := 20;


   procedure MoveCar (x : in Integer) with
     Pre => x <= Distance_Detection;

end object_detection;
