class apb_driver extends uvm_driver;

    `uvm_component_utils(apb_driver)

    apb_agent_config apb_cfg;

    extern function new(string name = "apb_driver", uvm_component parent);
    extern function void build_phase (uvm_phase phase);

endclass

function apb_driver::new (string name = "apb_driver", uvm_component parent);
    super.new(name, parent);
endfunction 

function void apb_driver::build_phase(uvm_phase phase);
    if(!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", apb_cfg))
        `uvm_fatal("CONFIG", "cannot get() apb agent config have you set it?")
    
endfunction