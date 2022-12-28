with Ada.Text_IO; use Ada.Text_IO;

package body SevSeg is

    procedure nothing is
    begin
        null;
    end nothing;
    
    
    function Get_Digit_Count(This : in SevSeg_Display) return Positive is
    begin
        return This.Common_Pins_Count;
    end Get_Digit_Count;
    
    

    function Create(Precision : Display_Precision;
                    Sign : Display_Sign;
                    Configuration : Common_Configuration;
                    Common_Pins_Count : Positive;
                    Segment_Pins_Count : Positive;
                    Fore_Digits : Positive;
                    Aft_Digits : Natural := 0;
                    Common_Pins : not null Access GPIO_points;
                    Segment_Pins : not null Access GPIO_points
                     )
    return SevSeg_Display is
        Max_Int : Integer := 0;
        Min_Int : Integer := 0;
        power_of_10 : Integer := 0;
        Str_Len : Positive := 1;
    begin

        power_of_10 := Fore_Digits;
        
        if Precision = Real_Number then
            power_of_10 := power_of_10 + Aft_Digits;
        end if;

        Max_Int := ( ( 10 ** power_of_10 ) - 1 );

        if Sign = Signed_Number then
            Min_Int := - ( ( 10 ** power_of_10 ) - 1 );
        else
            Min_Int := 0;
        end if;

        Str_Len := Fore_Digits;

        if Precision = Real_Number then
            Str_Len := Str_Len + Aft_Digits + 1;
        end if;

        if Sign = Signed_Number then
            Str_Len := Str_Len + 1;
        end if;               

        
        return SevSeg_Display'( Precision => Precision,
                        Sign => Sign,
                        Configuration => Configuration,
                        String_Len => Str_Len,
                        Common_Pins_Count => Common_Pins_Count,
                        Segment_Pins_Count => Segment_Pins_Count,
                        Fore_Digits => Fore_Digits,
                        Aft_Digits => Aft_Digits,
                        Max_Possible_Integer => Max_Int,
                        Min_Possible_Integer => Min_Int,
                        String_Image => (others => ' '),
                        Buffer => (others => (others => False) ),
                        Common_Pins => Common_Pins,
                        Segment_Pins => Segment_Pins
                        );
        
    end Create;


    function Lossless_Integer ( This : in SevSeg_Display; Raw_Float : in Float) return Integer is
        Lossless_Int : Integer;
        power_of_10 : Integer;
    begin
        if This.Precision = Real_Number then
            power_of_10 := This.Aft_Digits;
        else
            power_of_10 := 0;
        end if;

        Lossless_Int := Integer (Raw_Float * (10.0 ** power_of_10 ) );
        
        return Lossless_Int;
    end Lossless_Integer;


    function Bracket_Integer ( This : in SevSeg_Display; Unconstrained_Int : in Integer) return Integer is
        Bracketed_Int : Integer;
    begin
        if Unconstrained_Int > This.Max_Possible_Integer then
            Bracketed_Int := This.Max_Possible_Integer;
        elsif Unconstrained_Int < This.Min_Possible_Integer then
            Bracketed_Int := This.Min_Possible_Integer;
        else
            Bracketed_Int := Unconstrained_Int;
        end if;

        return Bracketed_Int;
    end Bracket_Integer;


    
    function Get_Integer_Image ( This : in SevSeg_Display; Raw_Float : in Float) return Integer is
        Unconstrained_Int : Integer;
        Constrained_Int : Integer;
    begin
        Unconstrained_Int := This.Lossless_Integer(Raw_Float);
        Constrained_Int := This.Bracket_Integer(Unconstrained_Int);

        return Constrained_Int;
    end Get_Integer_Image;



    procedure Generate_String_Image ( This : in out SevSeg_Display; Raw_Float : in Float ) is
        Sign_Len : Natural;
        Fore_Len : Natural;
        Decimal_Len : Natural;
        Aft_Len : Natural;
        Is_Negative : Boolean;
        Final_Int : Integer;
        Final_Int_Abs : Integer;
        Fore_Num : Integer := 0;
        Aft_Num : Integer := 0;
        Index_To_Update : Integer;
        Value_To_Update : Integer; 
    begin
        This.String_Image := (others => ' ');

        if This.Sign = Signed_Number then
            Sign_Len := 1;
        else
            Sign_Len := 0;
        end if;

        Fore_Len := This.Fore_Digits;

        if This.Precision = Real_Number then
            Decimal_Len := 1;
            Aft_Len := This.Aft_Digits;
        else
            Decimal_Len := 0;
            Aft_Len := 0;
        end if;

        Final_Int := This.Get_Integer_Image(Raw_Float);

        if Final_Int < 0 then
            Is_Negative := True;
            Final_Int_Abs := - Final_Int;
        else
            Is_Negative := False;
            Final_Int_Abs := Final_Int;
        end if;

        Fore_Num := (Final_Int_Abs) / (10 ** Aft_Len);

        -- required this check because if Aft_len = 0
        -- then it will result in "mod with zero divisor"
        -- which fails Constraint_Check.
        if Aft_Len > 0 then
            Aft_Num := (Final_Int_Abs) mod (10 ** Aft_Len);
        else
            Aft_Num := 0;
        end if;

        -- now start filling the String_Image

        -- First is the sign of number.
        if Sign_Len = 1 then
            Index_To_Update := Sign_Len;
            
            if Is_Negative then
                This.String_Image(Index_To_Update) := '-';
            else
                This.String_Image(Index_To_Update) := '+';
            end if;
        end if;

        -- Then the Digits before the decimal point
        before_decimal_point :
        for I in Integer range 1 .. Fore_Len loop
            Index_To_Update := (Fore_Len + Sign_Len) - (I - 1);
            Value_To_Update := (Fore_Num) mod (10);
            Fore_Num := (Fore_Num) / 10;
            This.String_Image(Index_To_Update) := Character'Val(48 + Value_To_Update);
        end loop before_decimal_point;

        -- Fill decimal point and digits after decimal point
        -- only if the number is Real_Number
        if Decimal_Len = 1 then
            -- Decimal point first
            Index_To_Update := Sign_Len + Fore_Len + Decimal_Len;
            This.String_Image(Index_To_Update) := '.';

            -- At last the digits after decimal point
            after_decimal_point:
            for J in Integer range 1 .. Aft_Len loop
                Index_To_Update := (This.String_Image'Length) - (J - 1);
                Value_To_Update := (Aft_Num) mod (10);
                Aft_Num := (Aft_Num) / (10);
                This.String_Image(Index_To_Update) := Character'Val(48 + Value_To_Update);
            end loop after_decimal_point;
        end if;

    end Generate_String_Image;



    procedure Generate_Frame (This : in out SevSeg_Display; Raw_Float : in Float) is
        Offset_Index : Integer := 0;
        Lookup_Index : Integer;
        Current_Char : Character;
    begin
        This.Generate_String_Image(Raw_Float);

        edit_buffer :
        for Digit_Index in This.Buffer'Range(1) loop

            if ( This.String_Image(Digit_Index) = '.' and not (Digit_Index = 1) ) then
                Offset_Index := 1;
                -- Set decimal point "ON" for previous digit subframe
                This.Buffer(Digit_Index - 1, This.Buffer'Last(2)) := True;
            end if;

            Current_Char := This.String_Image(Digit_Index + Offset_Index);

            case Current_Char is
                when  '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' =>
                    Lookup_Index := Character'Pos(Current_Char) - 48;
                when '-' =>
                    Lookup_Index := 10;
                when others =>
                    Lookup_Index := 11;
            end case;

            edit_digit :
            for Segment_Index in This.Buffer'Range(2) loop
                This.Buffer(Digit_Index, Segment_Index) := frames_0_to_9_and_minus_blank (Lookup_Index) (Segment_Index);
            end loop edit_digit;

        end loop edit_buffer;

    end Generate_Frame;
    
    
    
    procedure Digit_On(This : in SevSeg_Display; Digit : in Positive) is
    begin
        Sweep_Segments:
        for Segment in This.Segment_Pins'Range loop
            case This.Configuration is
                when Common_Anode =>
                    if This.Buffer(Digit, Segment) = True then
                        Clear(This.Segment_Pins.all(Segment));
                    else
                        Set(This.Segment_Pins.all(Segment));
                    end if;
                when others =>
                    if This.Buffer(Digit, Segment) = True then
                        Set(This.Segment_Pins.all(Segment));
                    else
                        Clear(This.Segment_Pins.all(Segment));
                    end if;
            end case;
            
        end loop Sweep_Segments;
        
        case This.Configuration is
            when Common_Anode =>
                Set(This.Common_Pins.all(Digit));
            when others =>
                Clear(This.Common_Pins.all(Digit));
        end case;
        
        
    end Digit_On;
    
    
    procedure Digit_Off(This : in SevSeg_Display; Digit : in Positive) is
    begin
        case This.Configuration is
            when Common_Anode =>
                Clear(This.Common_Pins.all(Digit));
            when others =>
                Set(This.Common_Pins.all(Digit));
        end case;
    end Digit_Off;


end SevSeg;
