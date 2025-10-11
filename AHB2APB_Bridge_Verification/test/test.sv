class test extends uvm_test;

    `uvm_component_utils(test)

    env_config env_cfg;
    env e;

    ahb_agent_config ahb_cfg;
    apb_agent_config apb_cfg;

	bit has_ahb_agent = 1;
	bit has_apb_agent = 1;

	extern function new(string name = "test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void config_bridge();

endclass

function test::new(string name = "test", uvm_component parent);
	super.new(name,parent);
endfunction


function void test::config_bridge();
	if(has_ahb_agent)
		begin
			ahb_cfg.is_active = UVM_ACTIVE;
			if(!uvm_config_db #(virtual ahb_if)::get(this, "", "ahb_if", ahb_cfg.vif))
				`uvm_fatal("VIF CONFIG", "cannot get() vif config have you set() it?")
			env_cfg.ahb_cfg = ahb_cfg;
		end

	if(has_apb_agent)
		begin
			apb_cfg.is_active = UVM_ACTIVE;
			if(!uvm_config_db #(virtual apb_if)::get(this, "", "apb_if", apb_cfg.vif))
				`uvm_fatal("VIF CONFIG", "cannot get() vif config have you set() it?")
			env_cfg.apb_cfg = apb_cfg;
		end
	
	env_cfg.has_ahb_agent = has_ahb_agent;
	env_cfg.has_apb_agent = has_apb_agent;

	uvm_config_db #(env_config)::set(this, "*", "env_config", env_cfg);

endfunction


function void test::build_phase(uvm_phase phase);

	env_cfg = env_config::type_id::create("env_config", this);

	if(has_ahb_agent)
	begin
		ahb_cfg = ahb_agent_config::type_id::create("ahb_cfg");
	end
	
	if(has_apb_agent)
	begin
		apb_cfg = apb_agent_config::type_id::create("apb_cfg");
	end	

	config_bridge();

	super.build_phase(phase);	

    e = env::type_id::create("env", this);

endfunction

class single_seqs extends test;

    `uvm_component_utils(single_seqs)


	v_seqs1 ahb_seqs1;

	extern function new(string name = "single_seqs", uvm_component parent);
	extern task run_phase(uvm_phase phase);
endclass

function single_seqs::new(string name = "single_seqs", uvm_component parent);
	super.new(name, parent);
endfunction


task single_seqs::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	ahb_seqs1 = v_seqs1::type_id::create("ahb_seqs1");
	ahb_seqs1.start(e.v_seqrh);
	#150;
	phase.drop_objection(this);
endtask

class incr_seqs extends test;

    `uvm_component_utils(incr_seqs)

int a=2;

$display("%d",a);
	v_seqs2 ahb_seqs2;

	extern function new(string name = "incr_seqs", uvm_component parent);
	extern task run_phase(uvm_phase phase);
endclass

function incr_seqs::new(string name = "incr_seqs", uvm_component parent);
	super.new(name, parent);
endfunction


task incr_seqs::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	ahb_seqs2 = v_seqs2::type_id::create("ahb_seqs2");
	ahb_seqs2.start(e.v_seqrh);
	#100;
	phase.drop_objection(this);
endtask



class wrap_seqs extends test;

    `uvm_component_utils(wrap_seqs)

	v_seqs3 ahb_seqs3;

	extern function new(string name = "wrap_seqs", uvm_component parent);
	extern task run_phase(uvm_phase phase);
endclass

function wrap_seqs::new(string name = "wrap_seqs", uvm_component parent);
	super.new(name, parent);
endfunction


task wrap_seqs::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	ahb_seqs3 = v_seqs3::type_id::create("ahb_seqs3");
	ahb_seqs3.start(e.v_seqrh);
	#200;
	phase.drop_objection(this);
endtask



