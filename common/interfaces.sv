// SPDX-License-Identifier: Apache-2.0
// SMVDU-TITAN-X SoC — System Interfaces
// Iteration 3: Added AXI4-Stream interface definition.
`timescale 1ns/1ps

`ifndef INTERFACES_SV
`define INTERFACES_SV

// -------------------------------------------------------
// AXI4 Master Interface
// -------------------------------------------------------
interface axi4_if #(
    parameter AW = 40,
    parameter DW = 64,
    parameter IDW = 4
);
    logic          awvalid;
    logic          awready;
    logic [AW-1:0] awaddr;
    logic [IDW-1:0]awid;
    logic [7:0]    awlen;
    logic [2:0]    awsize;
    
    logic          wvalid;
    logic          wready;
    logic [DW-1:0] wdata;
    logic [DW/8-1:0]wstrb;
    logic          wlast;
    
    logic          bvalid;
    logic          bready;
    logic [1:0]    bresp;
    logic [IDW-1:0]bid;
    
    logic          arvalid;
    logic          arready;
    logic [AW-1:0] araddr;
    logic [IDW-1:0]arid;
    logic [7:0]    arlen;
    logic [2:0]    arsize;
    
    logic          rvalid;
    logic          rready;
    logic [DW-1:0] rdata;
    logic [1:0]    rresp;
    logic          rlast;
    logic [IDW-1:0]rid;
    
    modport master (
        output awvalid, awaddr, awid, awlen, awsize, wvalid, wdata, wstrb, wlast, bready, arvalid, araddr, arid, arlen, arsize, rready,
        input  awready, wready, bvalid, bresp, bid, arready, rvalid, rdata, rresp, rlast, rid
    );
    
    modport slave (
        input  awvalid, awaddr, awid, awlen, awsize, wvalid, wdata, wstrb, wlast, bready, arvalid, araddr, arid, arlen, arsize, rready,
        output awready, wready, bvalid, bresp, bid, arready, rvalid, rdata, rresp, rlast, rid
    );
endinterface

// -------------------------------------------------------
// AXI4-Stream Interface (NEW)
// -------------------------------------------------------
interface axi4_stream_if #(
    parameter DW = 32
);
    logic          tvalid;
    logic          tready;
    logic [DW-1:0] tdata;
    logic          tlast;
    logic          tuser; // Usually Start of Frame (SOF) in video

    modport master (
        output tvalid, tdata, tlast, tuser,
        input  tready
    );

    modport slave (
        input  tvalid, tdata, tlast, tuser,
        output tready
    );
endinterface

// -------------------------------------------------------
// APB Interface
// -------------------------------------------------------
interface apb_if #(
    parameter AW = 32,
    parameter DW = 32
);
    logic [AW-1:0] paddr;
    logic          psel;
    logic          penable;
    logic          pwrite;
    logic [DW-1:0] pwdata;
    logic [DW-1:0] prdata;
    logic          pready;
    logic          pslverr;
    
    modport master (
        output paddr, psel, penable, pwrite, pwdata,
        input  prdata, pready, pslverr
    );
    
    modport slave (
        input  paddr, psel, penable, pwrite, pwdata,
        output prdata, pready, pslverr
    );
endinterface

`endif
