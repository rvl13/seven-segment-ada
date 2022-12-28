

package body display_value is


    task body send_data is
    begin

        num_tx := -5.2;

        infinite_loop :
        loop

            num_tx := num_tx + 0.1;

            store_data.put_data (num_tx);

            delay until Clock + Milliseconds (1000);
            
        end loop infinite_loop;

    end send_data;

end display_value;