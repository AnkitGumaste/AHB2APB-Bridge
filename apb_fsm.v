`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//  
// Engineer: Ankit Gumaste
// 
// Create Date: 24.03.2023 11:58:38
// Design Name: AHB2APB Bridge
// Module Name: apb_fsm
// 
//////////////////////////////////////////////////////////////////////////////////


module APB_fsm(Hclk,Hresetn,valid,Haddr1,Haddr2,Hwdata1,Hwdata2,Hwrite,Hwritereg,tempselx,Pwrite,Penable,Pselx,Paddr,Pwdata,Hready_out);
    
//*********************************************************************************
//port declaration
input Hclk,Hresetn,valid,Hwrite,Hwritereg;
input [31:0] Haddr1,Haddr2,Hwdata1,Hwdata2;
input [2:0] tempselx;

output reg Pwrite,Penable;
output reg Hready_out;  
output reg [2:0] Pselx;
output reg [31:0] Paddr,Pwdata;

reg [2:0] PRESENT_STATE,NEXT_STATE;
//Temporary assignments
reg Penable_temp,Hready_out_temp,Pwrite_temp;
reg [2:0] Pselx_temp;
reg [31:0] Paddr_temp, Pwdata_temp,addr;


//*********************************************************************************
//State Declaration
parameter ST_IDLE=3'b000;
parameter ST_WWAIT=3'b001;
parameter ST_READ= 3'b010;
parameter ST_WRITE=3'b011;
parameter ST_WRITEP=3'b100;
parameter ST_RENABLE=3'b101;
parameter ST_WENABLE=3'b110;
parameter ST_WENABLEP=3'b111;

//*********************************************************************************
//Present State Logic
always @(posedge Hclk)
begin
    if (~Hresetn)
        PRESENT_STATE<=ST_IDLE;
    else
        PRESENT_STATE<=NEXT_STATE;
end
 
//*********************************************************************************
//Next state logic 
always@(PRESENT_STATE,valid,Hwrite,Hwritereg)
begin
case(PRESENT_STATE)

    ST_IDLE:
        begin
            if (~valid)
                NEXT_STATE<=ST_IDLE;
            else if (valid && Hwrite)
                NEXT_STATE<=ST_WWAIT;
            else if (valid && ~Hwrite) 
                NEXT_STATE<=ST_READ;
        end    

    ST_WWAIT:
        begin
            if (~valid)
                NEXT_STATE<=ST_WRITE;
            else
                NEXT_STATE<=ST_WRITEP;
        end

    ST_READ:NEXT_STATE<=ST_RENABLE;
        
    ST_WRITE:
        begin
            if (~valid)
                NEXT_STATE<=ST_WENABLE;
            else
               NEXT_STATE<=ST_WENABLEP;
        end

    ST_WRITEP:NEXT_STATE<=ST_WENABLEP;
   

	ST_RENABLE:
        begin
            if (~valid)
                NEXT_STATE<=ST_IDLE;
            else if (valid && Hwrite)
                NEXT_STATE<=ST_WWAIT;
            else if (valid && ~Hwrite)
                NEXT_STATE<=ST_READ;
        end

	ST_WENABLE:
        begin
            if (~valid)
                NEXT_STATE<=ST_IDLE;
            else if (valid && Hwrite)
                NEXT_STATE<=ST_WWAIT;
            else if (valid && ~Hwrite)
                NEXT_STATE<=ST_READ;
        end

	ST_WENABLEP:
	   begin
		    if (~valid && Hwritereg)
		       NEXT_STATE<=ST_WRITE;
		    else if (valid && Hwritereg)
		       NEXT_STATE<=ST_WRITEP;
		    else if (~Hwritereg)
		       NEXT_STATE<=ST_READ;
	   end

	default:NEXT_STATE<=ST_IDLE;
	   
  endcase
 end

//*********************************************************************************
//Output Logic
always @(*)
 begin
    Penable_temp=1'b0;
    Hready_out_temp=1'b0;
    Pwrite_temp=1'b0;
    Pselx_temp=1'b0;
    Paddr_temp=1'b0;
    Pwdata_temp=1'b0;
    
   case(PRESENT_STATE)  
	ST_IDLE: Hready_out_temp=1'b1;
	ST_WWAIT:Hready_out_temp=1'b1;
	ST_READ: begin
	           Paddr_temp = Haddr1;
		       Pselx_temp = tempselx;
		       Hready_out_temp = 1'b0;
		     end

	ST_WRITE:begin
                Paddr_temp = Haddr1;
		        Hready_out_temp = 1'b0;
		        Pselx_temp = tempselx;
		        Pwdata_temp = Hwdata1;
		        Pwrite_temp = 1'b1;
		     end

	ST_WRITEP:begin
                Paddr_temp = Haddr2;
		        addr = Paddr_temp;
		        Pselx_temp = tempselx;
		        Pwdata_temp = Hwdata1;
		        Pwrite_temp = 1'b1;
		      end

	ST_RENABLE:begin
	              Penable_temp = 1'b1;
		          Hready_out_temp = 1'b1;
		          Paddr_temp = Haddr2; // doubt
		          Pselx_temp = tempselx;
               end

	ST_WENABLEP:begin
			       Paddr_temp=addr;
				   Pwrite_temp=1'b1;
				   Pselx_temp=tempselx;
				   Penable_temp=1'b1;
				   Pwdata_temp=Hwdata2;
				   Hready_out_temp=1'b1;
				  end

	ST_WENABLE :begin
			       Paddr_temp=Haddr1;
			       Hready_out_temp=1'b1;
			       Pselx_temp=tempselx;
			       Pwdata_temp=Hwdata1;
				   Pwrite_temp=1'b1;
				   Penable_temp=1'b1;
				   end   
   
   endcase
 end
 
always @(posedge Hclk)
 begin
  
  if (~Hresetn)
   begin
    Paddr<=0;
	Pwrite<=0;
	Pselx<=0;
	Pwdata<=0;
	Penable<=0;
	Hready_out<=0;
   end
  
  else
   begin
    Paddr<=Paddr_temp;
	Pwrite<=Pwrite_temp;
	Pselx<=Pselx_temp;
	Pwdata<=Pwdata_temp;
	Penable<=Penable_temp;
	Hready_out<=Hready_out_temp;
   end
 end

endmodule
