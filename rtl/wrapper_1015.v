`timescale 1 ns / 1 ps

module myipSHIFT32_New #
(
    parameter integer C_AXIS_TDATA_WIDTH	= 32
)
(
    input wire  AXIS_ACLK,
    input wire  AXIS_ARESETN,

    // Input Stream (this IP is the Slave)
    input wire [C_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
    input wire  S_AXIS_TLAST,
    input wire  S_AXIS_TVALID,
    output reg  S_AXIS_TREADY,

    // Output Stream (this IP is the Master)
    output reg [C_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
    output reg  M_AXIS_TLAST,
    output reg  M_AXIS_TVALID,
    input wire  M_AXIS_TREADY
);

    // --- User Logic Signals ---
 	// Complete this piece
    wire [31:0] shifted;
 
 
 
    // --- IP Instantiation ---
	// Complete this piece
    ShiftRight32 UIP (.din(S_AXIS_TDATA), .dout(shifted));
	
	
	// --- AXI-4 STREAM IMPLEMENTATION ---
 
     // The same rule of thumb as the AXI-Lite adder:
    // VALID signals are sent by the one holding the payload,
    // and READY signals are sent by the one receiving the payload.

    // A stream has no addresses and no response channel. Each word is one
    // payload and one handshake. This IP sits in the middle of a stream, so it
    // plays both roles:
    // On the input stream (S_AXIS), the DMA has the payload, so it asserts TVALID. This IP receives it, so it asserts TREADY.
    // On the output stream (M_AXIS), this IP has the payload (the shifted word), so it asserts TVALID. The DMA receives it, so it asserts TREADY.

    // -------------------------------------------------------------------------
    // Stream Handshake & Data Capture

    // Controlled by this IP (Your Code):
    // S_AXIS_TREADY: "I am ready to receive your word."
    // M_AXIS_TVALID: "I have a shifted word for you. It is valid on the bus right now."
    // M_AXIS_TDATA:  The shifted word.
    // M_AXIS_TLAST:  Copied from S_AXIS_TLAST, so the DMA knows where the packet ends.

    // Controlled by the DMA:
    // S_AXIS_TVALID: "I have a valid word for you."
    // S_AXIS_TDATA:  The word to shift.
    // S_AXIS_TLAST:  "This is the last word of the packet."
    // M_AXIS_TREADY: "I am ready to receive your shifted word."

    // Here is what the timeline looks like for one word:
    // The DMA puts a word on S_AXIS_TDATA and raises S_AXIS_TVALID.
    // Your IP sees TVALID and sees that its output is free. It shouts "Got it!" by pulsing S_AXIS_TREADY for exactly one clock cycle.
    // On the clock edge where S_AXIS_TVALID and S_AXIS_TREADY are both 1, it saves the shifted word into M_AXIS_TDATA and raises M_AXIS_TVALID.
    // Your IP waits. It holds M_AXIS_TVALID high and keeps the word on the bus until the DMA takes it.
    // The DMA takes the word by raising M_AXIS_TREADY.
    // Your IP sees M_AXIS_TVALID and M_AXIS_TREADY both high, knows the word is delivered, and drops M_AXIS_TVALID.
    // If the next input word is already waiting, your IP pulses S_AXIS_TREADY on that same edge,
    // so a new word can be accepted every two clock cycles.
    // -------------------------------------------------------------------------
    always @(posedge AXIS_ACLK) begin
        if (!AXIS_ARESETN) begin 
  		// Complete this piece
            S_AXIS_TREADY <= 1'b0;
            M_AXIS_TVALID <= 1'b0;
            M_AXIS_TDATA <= 32'd0;
            M_AXIS_TLAST <= 1'b0;
        end 
		else begin
            // 1. Generate a 1-cycle TREADY pulse when a word is waiting and the output is free
            //    The output is free if it is empty, or if the DMA is taking the current word on this edge
            if (S_AXIS_TVALID && !S_AXIS_TREADY && (!M_AXIS_TVALID || M_AXIS_TREADY)) begin
                
				S_AXIS_TREADY <= 1'b1; 				// Complete this piece
            end 
			else begin
                S_AXIS_TREADY <=  1'b0; 		   // Complete this piece

            end

            // 2. Capture the shifted word and assert M_AXIS_TVALID on the handshake cycle
            if (S_AXIS_TREADY && S_AXIS_TVALID) begin
				// Complete this piece
				M_AXIS_TDATA <= shifted;
				M_AXIS_TLAST <= S_AXIS_TLAST;
                M_AXIS_TVALID <= 1'b1;

            end

            // 3. Clear M_AXIS_TVALID when the DMA accepts the word
            if (M_AXIS_TVALID && M_AXIS_TREADY) begin
                M_AXIS_TVALID <= 1'b0;
            end
        end
    end
endmodule
