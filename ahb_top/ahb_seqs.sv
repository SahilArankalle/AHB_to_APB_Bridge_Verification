class base_seqs extends uvm_sequence #(ahb_xtn);
    `uvm_object_utils(base_seqs)

    extern function new(string name = "base_seqs");

endclass

function base_seqs::new(string name = "base_seqs");
    super.new(name);
endfunction

class ahb_single_seqs extends base_seqs;
    `uvm_object_utils(ahb_single_seqs)

    extern function new(string name = "ahb_single_seqs");
    extern task body();

endclass

function ahb_single_seqs::new(string name = "ahb_single_seqs");
    super.new(name);
endfunction

task ahb_single_seqs::body();
    begin
        req = ahb_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize() with {Hburst == 3'd0; Htrans == 2'b10; Hwrite == 1;});
        finish_item(req);
    end
endtask

class ahb_incr_seqs extends base_seqs;
    `uvm_object_utils(ahb_incr_seqs)

    extern function new(string name = "ahb_incr_seqs");
    extern task body();

endclass

function ahb_incr_seqs::new(string name = "ahb_incr_seqs");
    super.new(name);
endfunction

task ahb_incr_seqs::body();

    bit [31:0] addr;
    bit [2:0] size;
    bit [2:0] burst;
    bit [2:0] temp_a;
    bit write;


    repeat(1)
    begin
        req = ahb_xtn::type_id::create("req");

        //NON-SEQUENTIAL
        start_item(req);
        assert(req.randomize with {req.Htrans == 2'b10; req.Hwrite == 1; ((req.Hburst == 3'd7) || (req.Hburst == 3'd5) || (req.Hburst == 3'd3) || (req.Hburst == 3'd1));});
        `uvm_info("INCREMENT", $sformatf("Printing from seqs /n %s", req.sprint()), UVM_LOW)
        finish_item(req);

        write = req.Hwrite;
        burst = req.Hburst;
        size = req.Hsize;
        addr = req.Haddr;
        temp_a = req.length;

        //SEQUENTIAL
        if((req.Hburst == 3'd7) | (req.Hburst == 3'd5) | (req.Hburst == 3'd3) | (req.Hburst == 3'd1))
        begin
            for(int i = 1; i < temp_a; i++)
                begin
                    start_item(req);
                    assert(req.randomize with {req.Haddr == addr+(2**size); req.Htrans == 2'b11; req.Hsize == size; req.Hburst == burst; req.Hwrite == write;});
                    `uvm_info("INCREMENT", $sformatf("Printing from seqs /n %s", req.sprint()), UVM_LOW)
                    finish_item(req);

                    burst = req.Hburst;
                    size = req.Hsize;
                    addr = req.Haddr;
                    write = req.Hwrite;
                
                end
        end
    end

    //IDLE 
    start_item(req);
    assert(req.randomize with {req.Haddr == addr; req.Htrans == 2'b00; req.Hsize == size; req.Hburst == burst; req.Hwrite == write;});
    `uvm_info("INCREMENT", $sformatf("Printing from seqs /n %s", req.sprint()), UVM_LOW)
    finish_item(req);

endtask



class ahb_wrap_seqs extends base_seqs;
    `uvm_object_utils(ahb_wrap_seqs)

    extern function new(string name = "ahb_wrap_seqs");
    extern task body();

endclass

function ahb_wrap_seqs::new(string name = "ahb_wrap_seqs");
    super.new(name);
endfunction

task ahb_wrap_seqs::body();

    bit [31:0] addr;
    bit [2:0] size;
    bit [2:0] burst;
    bit [2:0] temp_a;
    bit write;
    logic [9:0] start_address;
    logic [9:0] wrap_address;

    repeat(1)
    begin
        req = ahb_xtn::type_id::create("req");

        //NON-SEQUENTIAL
        start_item(req);
        assert(req.randomize with {req.Htrans == 2'b10; req.Hwrite == 1; ((req.Hburst == 3'd6) || (req.Hburst == 3'd4) || (req.Hburst == 3'd2));});
        `uvm_info("INCREMENT", $sformatf("Printing from seqs /n %s", req.sprint()), UVM_LOW)
        finish_item(req);

        write = req.Hwrite;
        burst = req.Hburst;
        size = req.Hsize;
        addr = req.Haddr;
        temp_a = req.length; 


        start_address = int'((addr/((2**size)*(temp_a)))) * ((2**size)*(temp_a));

        wrap_address = start_address + ((2**size)*(temp_a));

        if((req.Hburst == 3'd6) | (req.Hburst == 3'd4) | (req.Hburst == 3'd2))
        begin
            for (int i = 1; i < temp_a; i++)
                begin

                addr = req.Haddr + (2**size);

                start_item(req);

                if(addr >= wrap_address)
                    addr = start_address;

                assert(req.randomize with {req.Haddr == addr; req.Htrans == 2'b11; req.Hsize == size; req.Hburst == burst; req.Hwrite == write;});
                `uvm_info("INCREMENT", $sformatf("Printing from seqs /n %s", req.sprint()), UVM_LOW)
                finish_item(req);

                burst = req.Hburst;
                size = req.Hsize;
                addr = req.Haddr;
                write = req.Hwrite;
                
                end
        end
    end

    //IDLE 
    start_item(req);
    assert(req.randomize with {req.Haddr == addr; req.Htrans == 2'b00; req.Hsize == size; req.Hburst == burst; req.Hwrite == write;});
    `uvm_info("INCREMENT", $sformatf("Printing from seqs /n %s", req.sprint()), UVM_LOW)
    finish_item(req);

endtask