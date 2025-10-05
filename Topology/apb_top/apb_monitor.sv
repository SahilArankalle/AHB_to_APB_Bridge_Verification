class apb_monitor extends uvm_monitor;

    `uvm_component_utils(apb_monitor)

    apb_agent_config apb_cfg;

    //uvm_analysis_port #(apb_xtn) monitor_port;

    extern function new(string name = "apb_monitor", uvm_component parent);
    extern function void build_phase (uvm_phase phase);

endclass

function apb_monitor::new(string name = "apb_monitor", uvm_component parent);
    super.new(name, parent);
    //monitor_port = new("monitor_port", this)
endfunction 

function void apb_monitor::build_phase(uvm_phase phase);
    if(!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", apb_cfg))
        `uvm_fatal("CONFIG", "cannot get() apb agent config have you set it?")
    
endfunction