-- Written by Thomas Welborn
-- A Option Code : Assignment 1 Warshall

with Ada.Text_IO; use Ada.Text_IO;
with warshall_generic;
with Unchecked_Conversion;



procedure Main_A_Option is
   package IntIO is new Ada.Text_IO.Integer_IO (Integer);
   use IntIO;

   function characterToInteger is new Unchecked_Conversion (Character,Integer);

   -- info for A option data set 1
   type Names is (Aba, Bob, Joe, Ken, Sam, Sue, Tim, Tom, Jim);
   package NameIO is new Ada.Text_IO.Enumeration_IO(Names);
   use NameIO;
   package INTwarshall is new warshall_generic(label => Names);


   -- info for A option data set 2
   -- could not get the 1,2,3,4,5,6,7 to work for the so I added x's in front of them
   type Data2 is (x1, x2, x3, x4, x5, x6, x7);
   package Data2IO is new Ada.Text_IO.Enumeration_IO(Data2);
   use Data2IO;
   package Data2warshall is new warshall_generic(label => Data2);

   aIn1 : String := "a_input_1.txt";
   aIn2 : String := "a_input_2.txt";


begin
   INTwarshall.makeBMR(aIn1);
   Data2warshall.makeBMR(aIn2);

end Main_A_Option;
