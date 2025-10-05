interface ahb_if(input bit clock);
		
	logic Hresetn;
	logic [31:0]Haddr;
	logic Hwrite;
	logic [1:0]Htrans;
	logic [2:0]Hsize;
	logic [31:0]Hrdata;
	logic [31:0]Hwdata;
	logic Hreadyin;
	logic Hreadyout;
	logic [2:0]Hburst;
	logic [1:0]Hresp;

	
	clocking ahb_drv_cb@(posedge clock);

		output Hresetn;
		output Haddr;
		output Hwrite;
		output Htrans;
		output Hsize;
		output Hwdata;
		output Hreadyin;
		output Hburst;
		input Hreadyout;
		input Hresp;

	endclocking
	
	clocking ahb_mon_cb@(posedge clock);
		
		input Hresetn;
		input Haddr;
		input Hwrite;
		input Htrans;
		input Hsize;
		input Hwdata;
		input Hreadyin;
		input Hburst;
		input Hreadyout;
		input Hresp;
		input Hrdata;
	endclocking
	
	modport ahb_drv_mp(clocking ahb_drv_cb);
	modport ahb_mon_mp(clocking ahb_mon_cb);
endinterface
