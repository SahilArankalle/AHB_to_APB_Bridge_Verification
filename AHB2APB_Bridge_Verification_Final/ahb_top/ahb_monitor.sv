class ahb_monitor extends uvm_monitor;

    `uvm_component_utils(ahb_monitor)

    virtual ahb_if.ahb_mon_mp vif;

    ahb_agent_config ahb_cfg;

    uvm_analysis_port #(ahb_xtn) monitor_port;

    extern function new(string name = "ahb_monitor", uvm_component parent);
    extern function void build_phase (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);
    extern task run_phase (uvm_phase phase);
    extern task collect_data;

endclass

function ahb_monitor::new(string name = "ahb_monitor", uvm_component parent);
    super.new(name, parent);
    monitor_port = new("monitor_port", this);
endfunction 

function void ahb_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(ahb_agent_config)::get(this, "", "ahb_agent_config", ahb_cfg))
        `uvm_fatal("CONFIG", "cannot get() ahb agent config have you set it?")
    
endfunction

function void ahb_monitor::connect_phase(uvm_phase phase);
    vif = ahb_cfg.vif;
endfunction


task ahb_monitor::run_phase(uvm_phase phase);
    @(vif.ahb_mon_cb)
    forever
        collect_data();
endtask

task ahb_monitor::collect_data;

    ahb_xtn xtn;
    xtn = ahb_xtn::type_id::create("xtn");
    wait(vif.ahb_mon_cb.Hreadyout && (vif.ahb_mon_cb.Htrans == 2'b10 || vif.ahb_mon_cb.Htrans == 2'b11))
    xtn.Htrans = vif.ahb_mon_cb.Htrans;
    xtn.Hwrite = vif.ahb_mon_cb.Hwrite;
    xtn.Hreadyin = vif.ahb_mon_cb.Hreadyin;
    xtn.Hsize = vif.ahb_mon_cb.Hsize;
    xtn.Haddr = vif.ahb_mon_cb.Haddr;
    @(vif.ahb_mon_cb);
    wait(vif.ahb_mon_cb.Hreadyout && (vif.ahb_mon_cb.Htrans == 2'b10 || vif.ahb_mon_cb.Htrans == 2'b11))
    if(vif.ahb_mon_cb.Hwrite == 1'b1)
        xtn.Hwdata = vif.ahb_mon_cb.Hwdata;
    else
        xtn.Hrdata = vif.ahb_mon_cb.Hrdata;
    `uvm_info(get_type_name(), "this is the monitor", UVM_LOW)
    xtn.print(); 

    monitor_port.write(xtn);
endtask

