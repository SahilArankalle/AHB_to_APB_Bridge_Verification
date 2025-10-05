class apb_monitor extends uvm_monitor;

    `uvm_component_utils(apb_monitor)

    virtual apb_if.apb_mon_mp vif;

    apb_agent_config apb_cfg;

    uvm_analysis_port #(apb_xtn) monitor_port;

    extern function new(string name = "apb_monitor", uvm_component parent);
    extern function void build_phase (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);
    extern task run_phase (uvm_phase phase);
    extern task collect_data();

endclass

function apb_monitor::new(string name = "apb_monitor", uvm_component parent);
    super.new(name, parent);
    monitor_port = new("monitor_port", this);

endfunction 

function void apb_monitor::build_phase(uvm_phase phase);
    if(!uvm_config_db #(apb_agent_config)::get(this, "", "apb_agent_config", apb_cfg))
        `uvm_fatal("CONFIG", "cannot get() apb agent config have you set it?")
    
endfunction

function void apb_monitor::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = apb_cfg.vif;
endfunction

task apb_monitor::run_phase(uvm_phase phase);
    forever 
        collect_data();
endtask

task apb_monitor::collect_data();
    apb_xtn xtn;
    xtn = apb_xtn::type_id::create("xtn");
    wait(vif.apb_mon_cb.Penable)
    @(vif.apb_mon_cb)
    xtn.Paddr = vif.apb_mon_cb.Paddr;
    xtn.Pwrite = vif.apb_mon_cb.Pwrite;
    xtn.Pselx = vif.apb_mon_cb.Pselx;
    if(xtn.Pwrite == 1)
        xtn.Pwdata = vif.apb_mon_cb.Pwdata;
    else
        xtn.Prdata = vif.apb_mon_cb.Prdata;
    @(vif.apb_mon_cb)

    `uvm_info(get_type_name(), "this is the monitor", UVM_LOW)
    xtn.print(); 

    monitor_port.write(xtn);
endtask
