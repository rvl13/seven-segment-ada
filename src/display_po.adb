package body display_po is

    protected body store_data is
        
        function get_data return Float is
        begin
            return current_data;
        end get_data;

        procedure put_data(num_rx : in Float) is
        begin
            current_data := num_rx;
        end put_data;

    end store_data;

end display_po;