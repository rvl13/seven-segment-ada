with display_po; use display_po;
with Ada.Real_Time;      use Ada.Real_Time;
with System;

package display_value is

    num_tx : Float;

    task send_data is
        pragma Priority (System.Priority(18));
    end send_data;

end display_value;