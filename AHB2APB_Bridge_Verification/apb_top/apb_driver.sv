class apb_driver extends uvm_driver #(apb_xtn);

    `uvm_component_utils(apb_driver)

    virtual apb_if.apb_drv_mp vif;

    apb_agent_config apb_cfg;

    extern function new(string name = "apb_driver", uvm_component parent);
    extern function void build_phase (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);
    extern task run_phase (uvm_phase phase);
    extern task send_to_dut (apb_xtn xtn);

endclass

function apb_driver::new (string name = "apb_driver", uvm_component parent);
    super.new(name, parent);
endfunction 

function void apb_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", apb_cfg))
        `uvm_fatal("CONFIG", "cannot get() apb agent config have you set it?")
    
endfunction

function void apb_driver::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = apb_cfg.vif;
endfunction

task apb_driver::run_phase(uvm_phase phase);
    req = apb_xtn::type_id::create("req", this);
    forever
        send_to_dut(req);
endtask

task apb_driver::send_to_dut(apb_xtn xtn);
    wait(vif.apb_drv_cb.Pselx != 0)
    if(vif.apb_drv_cb.Pwrite == 0)
        if(vif.apb_drv_cb.Penable)
            vif.apb_drv_cb.Prdata <= {$urandom};
        repeat(2)
            @(vif.apb_drv_cb);
endtask




