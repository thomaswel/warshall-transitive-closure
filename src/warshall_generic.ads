with Ada.Text_IO;
use Ada.Text_IO;

generic
   -- type item will be boolean or integer and will make up the BMR
   -- type item is (<>);
   -- type label will be the axis headers, will be an enumeration type
   type label is (<>);

package warshall_generic is
   -- The BMR will be either Booleans or Integers 0/1
   -- Edit could not figure out how to get the bool/int compatability so just made them integer
   type Boolean_Matrix is array (positive range <>, positive range <>) of Integer;
   -- The function OR will overload the boolean OR when the item is type Integer
   function "OR" (x, y : Integer) return Integer;
   -- The makeBMR will only need the file name as a string, will make an out file of the BMR with "out"
   -- concatinated onto the end of the original filename
   procedure makeBMR ( file_name : in String);
   --procedure transitive_closure ( bmr : in out Boolean_Matrix );
   --procedure write_data ( file_name : in String; bmr : in Boolean_Matrix);
end warshall_generic;
