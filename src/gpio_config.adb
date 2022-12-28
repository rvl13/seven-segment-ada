package body gpio_config is


    procedure Initialize_GPIO is
        procedure Initialize_Segments;

        procedure Initialize_Segments is
        begin
            Enable_Clock (Segments);

            Configure_IO
               (Segments,
               (Mode_Out,
                Resistors   => Floating,
                Output_Type => Push_Pull,
                Speed       => Speed_100MHz));
        end Initialize_Segments;

        procedure Initialize_Anodes;

        procedure Initialize_Anodes is
        begin
            Enable_Clock (Anodes);

            Configure_IO
               (Anodes,
               (Mode_Out,
                Resistors   => Floating,
                Output_Type => Push_Pull,
                Speed       => Speed_100MHz));
        end Initialize_Anodes;


    begin
        Initialize_Segments;
        Initialize_Anodes;
    end Initialize_GPIO;


end gpio_config;
