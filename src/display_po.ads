with System;

package display_po is

    protected store_data is
        function get_data return Float;
        procedure put_data(num_rx : in Float);
        pragma Priority (System.Priority(20));
    private
        current_data : Float;
    end store_data;

end display_po;