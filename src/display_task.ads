with Ada.Real_Time;      use Ada.Real_Time;
with display_po; use display_po;
with SevSeg; use SevSeg;
with gpio_config; use gpio_config;
with System;


package display_task is

    pragma Elaborate_Body;

    --temp_integer : Constant Integer := 5;

    --my_display : constant display_parameters := (decimal_point => real_no, signed_number => signed_no, Fore_digits => 3, Aft_digits => 1); 

    --string_representation_data : String( 1 .. output_string_length(my_display) ) := (Others => ' ');
    
    Display_1 : SevSeg_Display := Create(   Precision => Real_Number,
                                            Sign => Signed_Number,
                                            Configuration => Common_Anode,
                                            Common_Pins_Count => Anodes'Length,
                                            Segment_Pins_Count => Segments'Length,
                                            Fore_Digits => 3,
                                            Aft_Digits => 1,
                                            Common_Pins => Anodes'Access,
                                            Segment_Pins => Segments'Access
                                        );
    
    Raw_Data : Float := 0.0;
    
    procedure My_Delay (Milliz : Natural);

    task display_data is
        pragma Priority (System.Priority(15));
    end display_data;

end display_task;
