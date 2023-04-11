`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Ankit Gumaste
// 
// Create Date: 07.04.2023 17:42:18
// Design Name: AHB2APB Bridge
// Module Name: AHB_Master
// 
//////////////////////////////////////////////////////////////////////////////////


module AHB_Master(Hclk,Hresetn,Hreadyout,Hresp,Hrdata,Hwrite,Hreadyin,Htrans,Hwdata,Haddr);

input Hclk,Hresetn,Hreadyout;
input [1:0]Hresp;
input [31:0] Hrdata;
output reg Hwrite,Hreadyin;
output reg [1:0] Htrans;
output reg [31:0] Hwdata,Haddr;

task single_write ;
 begin
  @(posedge Hclk)
  #2;
   begin
    Hwrite=1;
    Htrans=2'b10;
    Hreadyin=1;
    Haddr=32'h8000_0001;
   end
  
  @(posedge Hclk)
  #2;
   begin
    Htrans=2'b00;
    Hwdata=8'hA3;
   end 
 end
endtask


task single_read;
 begin
  @(posedge Hclk)
  #2;
   begin
    Hwrite=0;
    Htrans=2'b10;
    Hreadyin=1;
    Haddr=32'h8000_00A2;
   end
  
  @(posedge Hclk)
  #2;
   begin
    Htrans=2'b00;
   end 
 end
endtask


endmodule

