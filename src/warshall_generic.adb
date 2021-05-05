with Ada.Text_IO; use Ada.Text_IO;
with Unchecked_Conversion;
package body warshall_generic is

   package LabelIO is new Ada.Text_IO.Enumeration_IO(label);
   use LabelIO;


   function characterToInteger is new Unchecked_Conversion (Character, Integer);

   function "OR" (x, y : Integer) return Integer is
   begin
      if x + y > 0 then
         return 1;
      else
         return 0;
      end if;
   end "OR";


   procedure makeBMR (file_name : in String) is
      -- declarations for files
      fileIn : File_Type;
      fileOut : File_type;
      file_output_name : String(1 .. (file_name'Length + 3)); -- just will add "OUT" onto the end of the file name for the output
      -- Size of the BMR is the first character in the input file
      sizeChar : Character;
      size : Integer;
      -- First we need to get the length of each item in the enumeration type
      -- Need the length to set the temp string that reads in data to the right length
      -- Will only be functional if each item in the enumeration type is the same character length long
      labelChar : Character;
      label_size : Integer;

   begin
      -- set the output file name with string manipulation
      -- take off the .txt then add OUT.txt
      file_output_name := file_name(1..(file_name'Length-4)) & "OUT.txt";

      -- open the input file
      Open (File => fileIn, Mode => In_File, Name => file_name);
      -- get the size of the bmr and size of each label
      Get(fileIn, sizeChar);
      Get(fileIn, labelChar);
      size := CharacterToInteger(sizeChar);
      size := size - 48; --convert from ASCII
      label_size := CharacterToInteger(labelChar);
      label_size := label_size - 48;

      -- start the actual large gathering of data
      declare
         bmr : Boolean_Matrix(1..size, 1..size) := (others => (others => 0));
         -- declare the two temp strings to retrieve data from the file
         tempS1 : String(1..label_size);
         tempS2 : String(1..label_size);
         -- declare the two temp labels that will be found by converting the string to item type with Label'Val
         tempL1 : label;
         tempL2 : label;
         -- declare the two temp integers that will be the positions of the enumeration type for bmr insertion
         tempP1 : Integer;
         tempP2 : Integer;
      begin
         while not End_Of_File (File => fileIn) loop
            get(fileIn, tempS1);
            get(fileIn, tempS2);
            tempL1 := label'Value(tempS1);
            tempL2 := label'Value(tempS2);
            tempP1 := label'Pos(tempL1);
            tempP2 := label'Pos(tempL2);
            -- remember to add 1 to both of them since enumeration types start the count at 0
            tempP1 := tempP1 + 1;
            tempP2 := tempP2 + 1;
            -- finally plug in the positions to the bmr and set those values to 1
            bmr(tempP1, tempP2) := 1;
         end loop;

         -- transitive boolean relation on the bmr using the overloaded "OR"
         for i in 1 .. bmr'Length loop
            for j in 1 .. bmr'Length loop
               if bmr(j, i) = 1 then
                  for k in 1 .. bmr'Length loop
                     bmr (j, k) := bmr(j, k) OR bmr(i, k);
                  end loop;
               end if;
            end loop;
         end loop;

         -- print onto output file fully formatted using the label_size variable
         -- all output files should be squares of label_size+1 by label_size+1
         Create (File => fileOut, Mode => Out_File, Name => file_output_name);
         for i in 1 .. (label_size + 1) loop
            put(fileOut, " ");
         end loop;

         for i in label loop
            put(fileOut, label'Image(i));
            put(fileOut, " ");
         end loop;

         Put (fileOut, ASCII.LF);

         for i in 1 .. bmr'Length loop
            put(fileOut, label'Image(label'val(i-1)));
            put(fileOut, " ");
            for j in 1 .. bmr'Length loop
               for k in 1 .. (label_size - 2) loop
                  put(fileOut, " ");
               end loop;

               Put (fileOut, (Integer'Image (bmr (i, j))));
               put(fileOut, " ");
            end loop;
            put(fileOut, ASCII.LF);
         end loop;
         Close (fileOut);

      end;

      -- close the file
      Close(fileIn);

      exception
      when End_Error =>
      if Is_Open (fileIn) then
         Close (fileIn);
      end if;
      if Is_Open (fileOut) then
         Close (fileOut);
      end if;

   end makeBMR;

end warshall_generic;
