with STM32.GPIO; use STM32.GPIO;

package SevSeg is

    -- I don't think there is any need to use this.
    -- Use GPIO_Point and GPIO_Points instead.
    --subtype segment_pin is GPIO_point;
    --subtype common_pin is GPIO_point;

    procedure nothing;

    type Display_Sign is (Signed_Number, Unsigned_Number);
    type Display_Precision is (Integer_Number, Real_Number);
    type Common_Configuration is (Common_Anode, Common_Cathode);

    type SevSeg_Display (<>) is tagged private;

    -- Public Primitives
    function Create(Precision : Display_Precision;
                    Sign : Display_Sign;
                    Configuration : Common_Configuration;
                    Common_Pins_Count : Positive;
                    Segment_Pins_Count : Positive;
                    Fore_Digits : Positive;
                    Aft_Digits : Natural := 0;
                    Common_Pins : not null Access GPIO_points;
                    Segment_Pins : not null Access GPIO_points )
    return SevSeg_Display;

    function Get_Digit_Count(This : in SevSeg_Display) return Positive;
    
    procedure Generate_Frame (This : in out SevSeg_Display; Raw_Float : in Float);
    
    procedure Digit_On(This : in SevSeg_Display; Digit : in Positive);
    
    procedure Digit_Off(This : in SevSeg_Display; Digit : in Positive);

    --procedure Print_Info (This : in SevSeg_Display);

    --procedure Print_String_Image(This : SevSeg_Display);

    --procedure Print_Buffer (This : in SevSeg_Display);

private

    -- Private Primitives
    function Lossless_Integer ( This : in SevSeg_Display; Raw_Float : in Float) return Integer;

    function Bracket_Integer ( This : in SevSeg_Display; Unconstrained_Int : in Integer) return Integer;

    function Get_Integer_Image ( This : in SevSeg_Display; Raw_Float : in Float) return Integer;

    procedure Generate_String_Image ( This : in out SevSeg_Display; Raw_Float : in Float );

    -- Private declarations
    type Digit_Subframe is array (1 .. 8) of Boolean;

    frame_0 : constant Digit_Subframe := ( True, True, True, True, True, True, False, False );
    frame_1 : constant Digit_Subframe := ( False, True, True, False, False, False, False, False );
    frame_2 : constant Digit_Subframe := ( True, True, False, True, True, False, True, False ); 
    frame_3 : constant Digit_Subframe := ( True, True, True, True, False, False, True, False );
    frame_4 : constant Digit_Subframe := ( False, True, True, False, False, True, True, False );
    frame_5 : constant Digit_Subframe := ( True, False, True, True, False, True, True, False );
    frame_6 : constant Digit_Subframe := ( True, False, True, True, True, True, True, False );
    frame_7 : constant Digit_Subframe := ( True, True, True, False, False, False, False, False );
    frame_8 : constant Digit_Subframe := ( True, True, True, True, True, True, True, False );
    frame_9 : constant Digit_Subframe := ( True, True, True, True, False, True, True, False );
    frame_minus_sign : constant Digit_Subframe := ( False, False, False, False, False, False, True, False );
    frame_plus_sign : constant Digit_Subframe := ( False, False, False, False, False, False, False, False );
    frame_dot_point : constant Digit_Subframe := ( False, False, False, False, False, False, False, True );
    frame_blank_digit : constant Digit_Subframe := ( False, False, False, False, False, False, False, False );

    type Subframes is array (Natural range <>) of Digit_Subframe;
    frames_0_to_9_and_minus_blank : constant Subframes(0 .. 11) := (frame_0, frame_1, frame_2, frame_3, frame_4, frame_5, frame_6, frame_7, frame_8, frame_9, frame_minus_sign, frame_blank_digit);

    type Frame_Buffer is array (Positive Range <>, Positive Range <>) of Boolean;



    type SevSeg_Display (   Precision : Display_Precision;
                            Sign : Display_Sign;
                            Configuration : Common_Configuration;
                            String_Len : Positive;
                            Common_Pins_Count : Positive;
                            Segment_Pins_Count : Positive) is tagged
        record

            Fore_Digits : Positive;
            Aft_Digits : Natural;
            Max_Possible_Integer : Integer;
            Min_Possible_Integer : Integer;
            String_Image : String(1 .. String_Len);
            Buffer : Frame_Buffer(1 .. Common_Pins_Count, 1 .. Segment_Pins_Count);
            Common_Pins : not null Access GPIO_points;
            Segment_Pins : not null Access GPIO_points;

        end record;



end SevSeg;
