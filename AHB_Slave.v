`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Ankit Gumaste 
// 
// Create Date: 02.04.2023 16:57:45
// Design Name: AHB2APB Bridge
// Module Name: AHB_Slave
// 
//////////////////////////////////////////////////////////////////////////////////

 module AHB_Slave(Hclk,Hresetn,Hwrite,Hreadyin,Htrans,Haddr,Hwdata,Prdata,valid,Haddr1,Haddr2,Hwdata1,Hwdata2,Hrdata,Hwritereg,tempselx,Hresp);

//************************************************************************
//port declaration
input Hclk,Hresetn;
input Hwrite,Hreadyin;
input [1:0] Htrans;
input [31:0] Haddr,Hwdata,Prdata;

output reg valid;
output reg [31:0] Haddr1,Haddr2,Hwdata1,Hwdata2;
output [31:0] Hrdata; 
output reg Hwritereg;
output reg [2:0] tempselx;
output reg [1:0] Hresp;

//**********************************************************************************
//Data transition type : Htrans
parameter IDLE = 2'b00, 
          BUSY = 2'b01, 
          NON_SEQ = 2'b10, 
          SEQ = 2'b11;

//different slaves used : tempselx	
parameter INTERURPT_CONTROLLER = 3'b001,
          COUNTER_TIMER = 3'b010,
          REMAP_PAUSE = 3'b100,
          UNDEFINED = 3'b000;

//**********************************************************************************
// assigning hrdata with prdata
assign Hrdata = Prdata;

//*******************************************************************************
// Implementing Pipeline Logic 
always @(posedge Hclk,negedge Hresetn)
begin
Hresp=1'b0;	
if (~Hresetn)
    begin
       Haddr1<=0;
	   Haddr2<=0;
	   Hwdata1<=0;
	   Hwdata2<=0;
	   Hwritereg<=0;
    end
else
    begin
       Haddr1<=Haddr;
	   Haddr2<=Haddr1;
	   Hwdata1<=Hwdata;
	   Hwdata2<=Hwdata1;
	   Hwritereg<=Hwrite;
    end
end

//*******************************************************************************
// Implementing Valid Logic Generation
always @(Hreadyin,Haddr,Htrans,Hresetn)
begin
    if(!Hresetn)
        valid=1'b0;
	if (Hresetn && Hreadyin && (Haddr>=32'h8000_0000 && Haddr<32'h8C00_0000) && (Htrans != IDLE || Htrans != BUSY) )
	   valid=1'b1;
	else if(Haddr>32'h8C00_0000 || !Hreadyin || (Htrans == IDLE || Htrans == BUSY))
       valid=1'b0;
end

//**********************************************************************************
// Implementing Tempselx Logic
always @(Haddr,Hresetn)
begin
if (Hresetn && Haddr>=32'h8000_0000 && Haddr<32'h8400_0000)
    tempselx=INTERURPT_CONTROLLER;
else if (Hresetn && Haddr>=32'h8400_0000 && Haddr<32'h8800_0000)
    tempselx=COUNTER_TIMER;
else if (Hresetn && Haddr>=32'h8800_0000 && Haddr<32'h8C00_0000)
	tempselx=REMAP_PAUSE;
else if(Hresetn && Haddr>=32'h8C00_0000 && Haddr<32'hBFFF_FFFF)
    tempselx=UNDEFINED;
end

//*******************************************************************************
			   
endmodule
