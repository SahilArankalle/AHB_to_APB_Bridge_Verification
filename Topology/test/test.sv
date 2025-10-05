class test extends uvm_test;

    `uvm_component_utils(test)

    env_config env_cfg;
    env e;

    ahb_agent_config ahb_cfg[];
    apb_agent_config apb_cfg[];

	int no_of_ahb_agents=1;
	int no_of_apb_agents=1;

	extern function new(string name = "test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

function test::new(string name = "test", uvm_component parent);
	super.new(name,parent);
endfunction

function void test:: build_phase(uvm_phase phase);
	super.build_phase(phase);	

	env_cfg = env_config::type_id::create("env_config", this);

	if(env_cfg.has_ahb_agent)
	begin
		env_cfg.ahb_cfg=new[no_of_ahb_agents];
	end
	
	if(env_cfg.has_apb_agent)
	begin
		env_cfg.apb_cfg=new[no_of_apb_agents];
	end	

	ahb_cfg=new[no_of_ahb_agents];
	apb_cfg=new[no_of_apb_agents];

    env_cfg.ahb_cfg = ahb_cfg;
    env_cfg.apb_cfg = apb_cfg;
	

	env_cfg.no_of_ahb_agents=no_of_ahb_agents;
	env_cfg.no_of_apb_agents=no_of_apb_agents;
	
	uvm_config_db #(env_config)::set(this,"*","env_config",env_cfg);

    e = env::type_id::create("env", this);

endfunction


function void test::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
endfunction
