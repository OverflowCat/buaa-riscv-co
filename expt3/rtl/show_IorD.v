module show_IorD(
       input [32-1:0] IorD,
       output[56-1:0] HEX_o
);

digital_tube u_digital_tube_0( .codein(IorD[4*1-1:0*4]), .codeout(HEX_o[7*1-1:0*7]) );//HEX0
digital_tube u_digital_tube_1( .codein(IorD[4*2-1:1*4]), .codeout(HEX_o[7*2-1:1*7]) );//HEX1
digital_tube u_digital_tube_2( .codein(IorD[4*3-1:2*4]), .codeout(HEX_o[7*3-1:2*7]) );//HEX2
digital_tube u_digital_tube_3( .codein(IorD[4*4-1:3*4]), .codeout(HEX_o[7*4-1:3*7]) );//HEX3
digital_tube u_digital_tube_4( .codein(IorD[4*5-1:4*4]), .codeout(HEX_o[7*5-1:4*7]) );//HEX4
digital_tube u_digital_tube_5( .codein(IorD[4*6-1:5*4]), .codeout(HEX_o[7*6-1:5*7]) );//HEX5
digital_tube u_digital_tube_6( .codein(IorD[4*7-1:6*4]), .codeout(HEX_o[7*7-1:6*7]) );//HEX6
digital_tube u_digital_tube_7( .codein(IorD[4*8-1:7*4]), .codeout(HEX_o[7*8-1:7*7]) );//HEX7

endmodule
