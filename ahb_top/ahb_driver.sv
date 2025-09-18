class ahb_driver extends uvm_driver;

    `uvm_component_utils(ahb_driver)

    ahb_agent_config ahb_cfg;

    extern function new(string name = "ahb_driver", uvm_component parent);
    extern function void build_phase (uvm_phase phase);

endclass

function ahb_driver::new (string name = "ahb_driver", uvm_component parent);
    super.new(name, parent);
endfunction 

function void ahb_driver::build_phase(uvm_phase phase);
    if(!uvm_config_db #(ahb_agent_config)::get(this, "", "ahb_agent_config", ahb_cfg))
        `uvm_fatal("CONFIG", "cannot get() ahb agent config have you set it?")
    
endfunction