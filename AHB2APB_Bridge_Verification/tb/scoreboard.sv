class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    uvm_tlm_analysis_fifo #(ahb_xtn) ahb_fifo;
    uvm_tlm_analysis_fifo #(apb_xtn) apb_fifo;

    ahb_xtn hxtn;
    apb_xtn pxtn;

    covergroup cg1;
        HADDR : coverpoint hxtn.Haddr {
            bins slave1 = {[32'h8000_0000 : 32'h8000_03FF]};
            bins slave2 = {[32'h8400_0000 : 32'h8400_03FF]};
            bins slave3 = {[32'h8800_0000 : 32'h8800_03FF]};
            bins slave4 = {[32'h8C00_0000 : 32'h8C00_03FF]};
        }

        HSIZE : coverpoint hxtn.Hsize {
            bins slave1 = {0};
            bins slave2 = {1};
            bins slave3 = {2};
        }

        HWRITE : coverpoint hxtn.Hwrite {bins a1 = {1};}

        HTRANS : coverpoint hxtn.Htrans {
            bins slave1 = {2};
            bins slave2 = {3};
        }

        AHB : cross HTRANS, HADDR;
    
    endgroup

    covergroup cg2;
        PADDR : coverpoint pxtn.Paddr {
            bins slave1 = {[32'h8000_0000 : 32'h8000_03FF]};
            bins slave2 = {[32'h8400_0000 : 32'h8400_03FF]};
            bins slave3 = {[32'h8800_0000 : 32'h8800_03FF]};
            bins slave4 = {[32'h8C00_0000 : 32'h8C00_03FF]};
        }

        PWRITE : coverpoint pxtn.Pwrite { bins a1 = {1};}

        PSELX : coverpoint pxtn.Pselx {
            bins a1 = {0};
            bins a2 = {1};
            bins a3 = {2};
        }

        APB : cross PWRITE, PADDR;
    
    endgroup

    extern function new(string name = "scoreboard", uvm_component parent);
    extern task run_phase(uvm_phase phase);
    extern task compare_data(input int Hdata, Pdata, Haddr, Paddr);
    extern task check_data(ahb_xtn hxtn, apb_xtn pxtn);

endclass

function scoreboard::new(string name = "scoreboard", uvm_component parent);
    super.new(name, parent);
    cg1 = new();
    cg2 = new();
    ahb_fifo = new("ahb_fifo", this);
    apb_fifo = new("apb_fifo", this);
    hxtn = new();
    pxtn = new();
endfunction


task scoreboard::run_phase(uvm_phase phase);
    forever
        begin
            fork 
                begin
                    ahb_fifo.get(hxtn);
                    cg1.sample();
                end

                begin
                    apb_fifo.get(pxtn);
                    cg2.sample();
                end
            join

            check_data(hxtn, pxtn);
        end
endtask

task scoreboard::compare_data(input int Hdata, Pdata, Haddr, Paddr);
    if(Haddr == Paddr)
        begin
            `uvm_info(get_type_name(), "addr_matched", UVM_LOW)
            if(Hdata == Pdata)
                `uvm_info(get_type_name(), "data_matched", UVM_LOW)
            else
                `uvm_info(get_type_name(), "data_unmatched", UVM_LOW)
        end
    else
        `uvm_info(get_type_name(),"addr_matched", UVM_LOW)
endtask

task scoreboard::check_data(ahb_xtn hxtn, apb_xtn pxtn);
    if(hxtn.Hwrite == 1)
        begin
            if(hxtn.Hsize == 2'b00)
                begin               
                    if(hxtn.Haddr[1:0] == 2'b00)
                        begin
                            compare_data(hxtn.Hwdata[7:0], pxtn.Pwdata, hxtn.Haddr, pxtn.Paddr);
                        end
                    else if(hxtn.Haddr[1:0] == 2'b01)
                        begin
                            compare_data(hxtn.Hwdata[15:8], pxtn.Pwdata, hxtn.Haddr, pxtn.Paddr);
                        end
                    else if(hxtn.Haddr[1:0] == 2'b10)
                        begin
                            compare_data(hxtn.Hwdata[23:16], pxtn.Pwdata, hxtn.Haddr, pxtn.Paddr);
                        end
                    else
                        begin
                            compare_data(hxtn.Hwdata[31:24], pxtn.Pwdata, hxtn.Haddr, pxtn.Paddr);
                        end
                end
            
            if(hxtn.Hsize == 2'b01)
                begin
                    if(hxtn.Haddr[1:0] == 2'b00)
                        begin
                            compare_data(hxtn.Hwdata[15:0], pxtn.Pwdata, hxtn.Haddr, pxtn.Paddr);
                        end
                    else
                        begin
                            compare_data(hxtn.Hwdata[31:16], pxtn.Pwdata, hxtn.Haddr, pxtn.Paddr);
                        end
                end

            if(hxtn.Hsize == 2'b10)
                begin
                    if(hxtn.Haddr[1:0] == 2'b00)
                        begin
                            compare_data(hxtn.Hwdata, pxtn.Pwdata, hxtn.Haddr, pxtn.Paddr);
                        end
                end
        end
endtask


