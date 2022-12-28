
package body display_task is

    procedure My_Delay (Milliz : Natural) is
    begin
        delay until Clock + Milliseconds (Milliz);
    end My_Delay;


    task body display_data is
        Delay_Digit_Show : constant Natural := 5;
        --not required.
        --delay_digit_sweep : constant Natural := 1;
    begin

        Initialize_GPIO;
        
        beyond_infinity:
        loop

            -- read the number to be displayed.
            raw_data := store_data.get_data;

            -- convert it to the string for ease of manipulation further.
            --string_representation_data := to_display_string(raw_data, my_display);

            -- generate a frame containing boolean status for each segment for each digit.
            --generate_frame(string_representation_data);

            -- Generate Frame
            Display_1.Generate_Frame(Raw_Float => Raw_Data);
            
            -- now display on the seven segment display.
            sweep_digits :
            for I in Positive range 1 .. Display_1.Get_Digit_Count loop

                Display_1.Digit_On(Digit => I);
                My_Delay(Delay_Digit_Show);
                Display_1.Digit_Off(Digit => I);

            end loop sweep_digits; 

        end loop beyond_infinity;

    end display_data;

end display_task;
