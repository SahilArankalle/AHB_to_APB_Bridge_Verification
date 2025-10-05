class env extends uvm_env;

    `uvm_component_utils(env)

    ahb_agt_top ahb_top;
    apb_agt_top apb_top;

    env_config env_cfg;

    extern function new(string name = "env", uvm_component parent);
    extern function void build_phase (uvm_phase phase);

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

endfunction 