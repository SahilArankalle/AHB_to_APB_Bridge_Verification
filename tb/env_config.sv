class env_config extends uvm_object;

    `uvm_object_utils(env_config)

    int has_ahb_agent = 1;
    int has_apb_agent = 1;
    int no_of_ahb_agents = 1;
    int no_of_apb_agents = 1;


    ahb_agent_config ahb_cfg[];
    apb_agent_config apb_cfg[];

    extern function new(string name = "env_config");

endclass

function env_config::new(string name = "env_config");
        super.new(name);
endfunction


