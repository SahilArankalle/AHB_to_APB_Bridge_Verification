class env extends uvm_env;

    `uvm_component_utils(env)

    ahb_agt_top ahb_top;
    apb_agt_top apb_top;

    env_config env_cfg;
    v_sequencer v_seqrh;
    scoreboard sb;

    extern function new(string name = "env", uvm_component parent);
    extern function void build_phase (uvm_phase phase);
    extern function void connect_phase (uvm_phase phase);

endclass

function env::new(string name = "env", uvm_component parent);
        super.new(name, parent);
endfunction


function void env::build_phase(uvm_phase phase);

    if(!uvm_config_db #(env_config)::get(this, "", "env_config", env_cfg))
        `uvm_fatal("ENV", "cannot get the env_config")

    if(env_cfg.has_ahb_agent)
        begin
            uvm_config_db #(ahb_agent_config)::set(this, "*", "ahb_agent_config", env_cfg.ahb_cfg);
            ahb_top = ahb_agt_top::type_id::create("ahb_top", this);
        end

	if(env_cfg.has_apb_agent)
        begin
            uvm_config_db #(apb_agent_config)::set(this, "*", "apb_agent_config", env_cfg.apb_cfg);
            apb_top = apb_agt_top::type_id::create("apb_top", this);
        end

    super.build_phase(phase);

    if(env_cfg.has_virtual_sequencer)
        v_seqrh = v_sequencer::type_id::create("v_seqrh", this);

    if(env_cfg.has_scoreboard)
        sb = scoreboard::type_id::create("sb", this);

endfunction 


function void env::connect_phase(uvm_phase phase);
    if(env_cfg.has_virtual_sequencer)
        begin
            if(env_cfg.has_ahb_agent)
                v_seqrh.ahb_seqrh = ahb_top.agnth.seqrh;
        end

        ahb_top.agnth.monh.monitor_port.connect(sb.ahb_fifo.analysis_export);
        apb_top.agnth.monh.monitor_port.connect(sb.apb_fifo.analysis_export);

        `uvm_info(get_type_name(), $sformatf("APB monitor = %0p", apb_top.agnth.monh), UVM_LOW)


endfunction


