module keypad(valid, number, a, b, c, d, e, f, g);
   output 	valid;
   output [3:0] number;
   input 	a, b, c, d, e, f, g;
   wire		w1, w2, w3, w4, w5;

   or oABC(w1, a, b, c);
   or oWires(valid, w2, w3, w4, w5);

   and aD(w2, w1, d);
   and aE(w3, w1, e);
   and aF(w4, w1, f);
   and aBG(w5, b, g);

   assign number[0] = (a && d) || (c && d) || (b && e) || (a && f) || (c && f);
   assign number[1] = (b && d) || (c && d) || (c && e) || (a && f);
   assign number[2] = (a && e) || (b && e) || (c && e) || (a && f);
   assign number[3] = (b && f) || (c && f);

endmodule // keypad
