`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Ankit Gumaste
// 
// Create Date: 07.04.2023 18:19:18
// Design Name: AHB2APB Bridge
// Module Name: Bridge_tb
// 
//////////////////////////////////////////////////////////////////////////////////


module Bridge_tb();

        reg Hclk;
        reg Hresetn;
        wire[31:0] Hrdata;
        wire[1:0] Hresp;
        wire Hreadyout;
        
        wire Hwrite;
        wire Hreadyin;
        wire [1:0] Htrans;
        wire [31:0] Haddr;
        wire [31:0] Hwdata;

        wire Pwrite;
        wire Penable;
        wire [2:0] Pselx;
        wire [31:0] Paddr;
        wire [31:0] Pwdata;
        wire [31:0] Prdata;
        
        wire [31:0] Paddrout;
        wire [31:0] Pwdataout;
        wire Pwriteout;
        wire Penableout;
        wire [2:0] Pselxout;
        

  
// Instantiating modules

AHB_Master AHBMaster_dut(.Hclk(Hclk),.Hresetn(Hresetn),.Hreadyout(Hreadyout),.Hresp(Hresp),.Hrdata(Hrdata),.Hwrite(Hwrite),.Hreadyin(Hreadyin),.Htrans(Htrans),.Hwdata(Hwdata),.Haddr(Haddr));
Bridge_top Bridgetop_dut(.Hclk(Hclk),.Hresetn(Hresetn),.Hwrite(Hwrite),.Hreadyin(Hreadyin),.Hready_out(Hreadyout),.Hwdata(Hwdata),.Haddr(Haddr),.Htrans(Htrans),.Prdata(Prdata),.Penable(Penable),.Pwrite(Pwrite),.Pselx(Pselx),.Paddr(Paddr),.Pwdata(Pwdata),.Hresp(Hresp),.Hrdata(Hrdata));
APB_Slave APBSlave_dut(.Pwrite(Pwrite),.Pselx(Pselx),.Penable(Penable),.Paddr(Paddr),.Pwdata(Pwdata),.Pwriteout(Pwriteout),.Pselxout(Pselxout),.Penableout(Penableout),.Paddrout(Paddrout),.Pwdataout(Pwdataout),.Prdata(Prdata));


//clock 
initial
begin
   Hclk = 0;
   forever #5 Hclk = ~ Hclk;
end

//reset
task rst;
begin
   Hresetn = 0;
   #4;
   Hresetn =1;
   end
endtask
 
//Single_read
initial
begin
   rst;
   AHBMaster_dut.single_read;
   @(posedge Hclk);
   #300 $finish;
end

/*
//Single_write
initial
begin
   rst;
   AHBMaster_dut.single_write;
   @(posedge Hclk);
   #300 $finish;
end
*/
endmodule

