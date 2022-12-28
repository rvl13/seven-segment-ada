with STM32.Device; use STM32.Device;
with STM32.GPIO; use STM32.GPIO;

package gpio_config is

    Segment_a : GPIO_Point renames PA0;
    Segment_b : GPIO_Point renames PA1;
    Segment_c : GPIO_Point renames PA2;
    Segment_d : GPIO_Point renames PA3;
    Segment_e : GPIO_Point renames PA4;
    Segment_f : GPIO_Point renames PA5;
    -- Not using the PA6 as, experienced some issues with this pin when used as GPIO.
    --Segment_g : segment_pin renames PA6;
    Segment_g : GPIO_Point renames PC5;
    Segment_dp : GPIO_Point renames PA7;

    Anode_1 : GPIO_Point renames PE7;
    Anode_2 : GPIO_Point renames PE8;
    Anode_3 : GPIO_Point renames PE9;
    Anode_4 : GPIO_Point renames PE10;
    Anode_5 : GPIO_Point renames PE11;


    Segments : aliased GPIO_points := (Segment_a, Segment_b, Segment_c, Segment_d, Segment_e, Segment_f, Segment_g, Segment_dp);
    Anodes : aliased GPIO_Points := (Anode_1, Anode_2, Anode_3, Anode_4, Anode_5);

    procedure Initialize_GPIO;

end gpio_config;
