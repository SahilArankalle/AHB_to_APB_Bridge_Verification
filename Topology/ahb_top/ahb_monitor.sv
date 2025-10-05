class ahb_monitor extends uvm_monitor;

    `uvm_component_utils(ahb_monitor)

    ahb_agent_config ahb_cfg;

    //uvm_analysis_port #(ahb_xtn) monitor_port;

    extern function new(string name = "ahb_monitor", uvm_component parent);
    extern function void build_phase (uvm_phase phase);

endclass

function ahb_monitor::new(string name = "ahb_monitor", uvm_component parent);
    super.new(name, parent);
    //monitor_port = new("monitor_port", this)
endfunction 

function void ahb_monitor::build_phase(uvm_phase phase);
    if(!uvm_config_db #(ahb_agent_config)::get(this, "", "ahb_agent_config", ahb_cfg))
        `uvm_fatal("CONFIG", "cannot get() ahb agent config have you set it?")
    
endfunction