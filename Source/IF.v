`ifndef _IF
`define _IF

`include "Defines.vh"
`include "IDInstDef.vh"

module IF (
    input wire  rst,

	input wire[`InstAddrBus]	pc_i,
	input wire[`InstBus]		rom_data_i,
	output reg[`InstAddrBus]	pc_o,
    output reg[`InstBus]    	inst_o,
	output wire[`InstAddrBus]	rom_addr_o,

	output reg 					r_enable_o,
	input wire					rom_busy_i,
	input wire					rom_done_i,

	output reg 					stall_req_o
);

assign rom_addr_o = pc_i;
reg my_rom_turn;
initial
begin
    my_rom_turn     =   1'b0;
end


always @ (*)
begin
    if (rst) 
    begin
		pc_o		=	`ZeroWord;
		r_enable_o	=	1'b0;
		stall_req_o	=	1'b0;
        inst_o      =  `ZeroWord;
        my_rom_turn =   1'b0;
    end
    else if (!rom_busy_i && !my_rom_turn)
    begin
        r_enable_o	=	1'b1;
        stall_req_o	=	1'b1;
        my_rom_turn =   1'b1;
    end
	else if (rom_busy_i)
	begin
	    stall_req_o	=	1'b1;
	end
    else if (my_rom_turn)
    begin
        r_enable_o	=	1'b0;	
        pc_o		=	pc_i;
        inst_o      =  rom_data_i;        
        stall_req_o	=	1'b0;
        my_rom_turn =   1'b0;
    end
end

always@(*)
begin

end

endmodule





`endif