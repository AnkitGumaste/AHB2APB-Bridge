`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer : Ankit Gumaste
// 
// Create Date: 04.04.2023 17:52:08
// Design Name: AHB2APB Bridge
// Module Name: Bridge_top
// 
//////////////////////////////////////////////////////////////////////////////////


module Bridge_top(Hclk,Hresetn,Hwrite,Hreadyin,Hready_out,Hwdata,Haddr,Htrans,Prdata,Penable,Pwrite,Pselx,Paddr,Pwdata,Hresp,Hrdata);

//*******************************************************************************
// Port Declaration
input Hclk,Hresetn,Hwrite,Hreadyin;
input [31:0] Hwdata,Haddr,Prdata;
input[1:0] Htrans;
output Penable,Pwrite,Hready_out;
output [1:0] Hresp; 
output [2:0] Pselx;
output [31:0] Paddr,Pwdata;
output [31:0] Hrdata;

//*******************************************************************************
//INTERMEDIATE SIGNALS

wire valid,Hwritereg;
wire [31:0] Haddr1,Haddr2,Hwdata1,Hwdata2;
wire [2:0] tempselx;

//*******************************************************************************
// MODULE INSTANTIATIONS
AHB_Slave AHBSLAVE(.Hclk(Hclk),.Hresetn(Hresetn),.Hwrite(Hwrite),.Hreadyin(Hreadyin),.Htrans(Htrans),.Haddr(Haddr),.Hwdata(Hwdata),.Prdata(Prdata),.valid(valid),.Haddr1(Haddr1),.Haddr2(Haddr2),.Hwdata1(Hwdata1),.Hwdata2(Hwdata2),.Hrdata(Hrdata),.Hwritereg(Hwritereg),.tempselx(tempselx),.Hresp(Hresp));
APB_fsm APBFSM(.Hclk(Hclk),.Hresetn(Hresetn),.valid(valid),.Haddr1(Haddr1),.Haddr2(Haddr2),.Hwdata1(Hwdata1),.Hwdata2(Hwdata2),.Hwrite(Hwrite),.Hwritereg(Hwritereg),.tempselx(tempselx),.Pwrite(Pwrite),.Penable(Penable),.Pselx(Pselx),.Paddr(Paddr),.Pwdata(Pwdata),.Hready_out(Hready_out));

endmodule
