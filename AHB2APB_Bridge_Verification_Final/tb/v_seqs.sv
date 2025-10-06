class v_seqs extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(v_seqs)

    ahb_sequencer ahb_seqrh;
    v_sequencer v_seqrh;

    extern function new(string name = "v_seqs");
    extern task body();

endclass

function v_seqs::new(string name = "v_seqs");
    super.new(name);
endfunction

task v_seqs::body();
    if(!$cast(v_seqrh, m_sequencer))
        `uvm_error("BODY", "Error in casting of virtual sequencer")
    
    else
        ahb_seqrh = v_seqrh.ahb_seqrh;

endtask



class v_seqs1 extends v_seqs;
    `uvm_object_utils(v_seqs1)

    ahb_single_seqs seq1;

    extern function new(string name = "v_seqs1");
    extern task body();

endclass

function v_seqs1::new(string name = "v_seqs1");
    super.new(name);
endfunction

task v_seqs1::body();
    super.body();
    seq1 = ahb_single_seqs::type_id::create("seq1");
    seq1.start(ahb_seqrh);

endtask


class v_seqs2 extends v_seqs;
    `uvm_object_utils(v_seqs2)

    ahb_incr_seqs seq2;

    extern function new(string name = "v_seqs2");
    extern task body();

endclass


function v_seqs2::new(string name = "v_seqs2");
    super.new(name);
endfunction

task v_seqs2::body();
    super.body();
    seq2 = ahb_incr_seqs::type_id::create("seq2");
    seq2.start(ahb_seqrh);

endtask


class v_seqs3 extends v_seqs;
    `uvm_object_utils(v_seqs3)

    ahb_wrap_seqs seq3;

    extern function new(string name = "v_seqs3");
    extern task body();

endclass


function v_seqs3::new(string name = "v_seqs3");
    super.new(name);
endfunction

task v_seqs3::body();
    super.body();
    seq3 = ahb_wrap_seqs::type_id::create("seq3");
    seq3.start(ahb_seqrh);

endtask