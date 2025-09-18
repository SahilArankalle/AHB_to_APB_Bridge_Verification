class apb_agt_top extends uvm_env;

    `uvm_component_utils(apb_agt_top)

    apb_agent agnth[];

    env_config env_cfg;

    extern function new(string name = "apb_agt_top", uvm_component parent);
    extern function void build_phase(uvm_phase phase);

endclass

function apb_agt_top::new(string name = "apb_agt_top", uvm_component parent);
    super.new(name, parent);
endfunction


function void apb_agt_top::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db #(env_config)::get(this, "", "env_config", env_cfg))
        `uvm_fatal(get_type_name, "not able to get the env configuration")

    agnth = new[env_cfg.no_of_apb_agents];
    foreach(agnth[i])
        begin
            agnth[i] = apb_agent::type_id::create($sformatf("agnth[%0d]", i), this);
            uvm_config_db #(apb_agent_config)::set(this, $sformatf("agnth[%0d]*", i), "apb_agent_config", env_cfg.apb_cfg[i]);

        end

endfunction

