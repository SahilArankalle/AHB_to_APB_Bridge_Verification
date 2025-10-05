class ahb_driver extends uvm_driver#(ahb_xtn);

    `uvm_component_utils(ahb_driver)

    virtual ahb_if.ahb_drv_mp vif;
    ahb_agent_config ahb_cfg;

    extern function new(string name = "ahb_driver", uvm_component parent);
    extern function void build_phase (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);
    extern task send_to_dut(ahb_xtn req);
    extern task run_phase (uvm_phase);

endclass

function ahb_driver::new (string name = "ahb_driver", uvm_component parent);
    super.new(name, parent);
endfunction 

function void ahb_driver::build_phase(uvm_phase phase);
    if(!uvm_config_db #(ahb_agent_config)::get(this, "", "ahb_agent_config", ahb_cfg))
        `uvm_fatal("CONFIG", "cannot get() ahb agent config have you set it?")
    
endfunction

function void ahb_driver::connect_phase(uvm_phase phase);
    vif = ahb_cfg.vif;
endfunction

task ahb_driver::send_to_dut(ahb_xtn req);

    while(vif.ahb_drv_cb.Hreadyout !== 1'b1)
        @(vif.ahb_drv_cb);
    vif.ahb_drv_cb.Haddr <= req.Haddr;
    vif.ahb_drv_cb.Hwrite <= req.Hwrite;
    vif.ahb_drv_cb.Htrans <= req.Htrans;
    vif.ahb_drv_cb.Hsize <= req.Hsize;
    vif.ahb_drv_cb.Hreadyin <= 1'b1;


    @(vif.ahb_drv_cb);
    while(vif.ahb_drv_cb.Hreadyout !== 1'b1);
        @(vif.ahb_drv_cb);
    if(req.Hwrite == 1'b1)
        vif.ahb_drv_cb.Hwdata <= req.Hwdata;
    else
        vif.ahb_drv_cb.Hwdata <= 32'b0;

    `uvm_info(get_type_name(), "this is the driver", UVM_LOW)
    req.print();

endtask


task ahb_driver::run_phase(uvm_phase phase);
    @(vif.ahb_drv_cb)
    vif.ahb_drv_cb.Hresetn <= 0;
    @(vif.ahb_drv_cb)
    vif.ahb_drv_cb.Hresetn <= 1;

    forever
        begin
            seq_item_port.get_next_item(req);
            send_to_dut(req);
            seq_item_port.item_done();
        end
endtask



    

