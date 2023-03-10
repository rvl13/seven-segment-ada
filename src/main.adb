with display_value;              pragma Unreferenced (display_value);
with display_task;               pragma Unreferenced (display_task);
--  These packages contains the task that actually controls the app so
--  although it is not referenced directly in the main procedure, we need it
--  in the closure of the context clauses so that it will be included in the
--  executable.

with Last_Chance_Handler;  pragma Unreferenced (Last_Chance_Handler);
--  The "last chance handler" is the user-defined routine that is called when
--  an exception is propagated. We need it in the executable, therefore it
--  must be somewhere in the closure of the context clauses.

with System;

procedure main is
    pragma Priority (System.Priority'First);
begin
    loop
        null;
    end loop;
end main;