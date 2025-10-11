class v_sequencer extends uvm_sequencer #(uvm_sequence_item);
    `uvm_component_utils(v_sequencer);
  
    ahb_sequencer ahb_seqrh;

    extern function new(string name = "v_sequencer", uvm_component parent);

endclass

function v_sequencer::new(string name="v_sequencer",uvm_component parent);
    super.new(name,parent);
endfunction