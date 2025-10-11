interface apb_if(input bit clock);
		
	bit Presetn;
	bit [31:0]Paddr;
	bit [3:0]Pselx;
	bit Penable;
	bit Pwrite;
	bit [31:0]Prdata;
	bit [31:0]Pwdata;
	
	clocking apb_drv_cb@(posedge clock);
		default input #1 output #0;
		output Prdata;
		input Presetn;
		input Penable;
		input Pwrite;
		input Paddr;
		input Pselx;
	endclocking 
	
	clocking apb_mon_cb@(posedge clock);
		default input #1 output #0;

		input Paddr;
		input Pselx;
		input Penable;
		input Pwrite;
		input Prdata;
		input Pwdata;
	endclocking 
	
	modport apb_drv_mp(clocking apb_drv_cb);
	modport apb_mon_mp(clocking apb_mon_cb);
endinterface
