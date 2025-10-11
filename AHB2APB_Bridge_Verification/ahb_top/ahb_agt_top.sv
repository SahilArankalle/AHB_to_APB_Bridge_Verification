class ahb_agt_top extends uvm_env;

    `uvm_component_utils(ahb_agt_top)

    ahb_agent agnth;

    extern function new(string name = "ahb_agt_top", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass

function ahb_agt_top::new(string name = "ahb_agt_top", uvm_component parent);
    super.new(name, parent);
endfunction


function void ahb_agt_top::build_phase(uvm_phase phase);
    super.build_phase(phase);
    agnth = ahb_agent::type_id::create("agnth", this);

endfunction


task ahb_agt_top::run_phase(uvm_phase phase);
    uvm_top.print_topology;
endtask

