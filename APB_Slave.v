`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Ankit Gumaste 
// 
// Create Date: 07.04.2023 17:46:21
// Design Name: AHB2APB Bridge
// Module Name: APB_Slave
// 
//////////////////////////////////////////////////////////////////////////////////


module APB_Slave(Pwrite,Pselx,Penable,Paddr,Pwdata,Pwriteout,Pselxout,Penableout,Paddrout,Pwdataout,Prdata);

input Pwrite,Penable;
input [2:0] Pselx;
input [31:0] Pwdata,Paddr;
output Pwriteout,Penableout;
output [2:0] Pselxout;
output [31:0] Pwdataout,Paddrout;
output reg [31:0] Prdata;

assign Penableout=Penable;
assign Pselxout=Pselx;
assign Pwriteout=Pwrite;
assign Paddrout=Paddr;
assign Pwdataout=Pwdata;

always @(*)
 begin
  if (~Pwrite && Penable)
   Prdata=$random;
  else
   Prdata=32'h0000_0000;
 end

endmodule

