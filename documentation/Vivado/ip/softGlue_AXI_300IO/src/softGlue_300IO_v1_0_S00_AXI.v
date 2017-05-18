
`timescale 1 ns / 1 ps

	module softGlue_300IO_v1_0_S00_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 9
	)
	(
		// Users to add ports here
        input wire SOFTGLUE_REG_CLOCK,

        input wire SG_IN000, SG_IN001, SG_IN002, SG_IN003, SG_IN004, SG_IN005, SG_IN006, SG_IN007, SG_IN008, SG_IN009,
		input wire SG_IN010, SG_IN011, SG_IN012, SG_IN013, SG_IN014, SG_IN015, SG_IN016, SG_IN017, SG_IN018, SG_IN019,
		input wire SG_IN020, SG_IN021, SG_IN022, SG_IN023, SG_IN024, SG_IN025, SG_IN026, SG_IN027, SG_IN028, SG_IN029,
		input wire SG_IN030, SG_IN031, SG_IN032, SG_IN033, SG_IN034, SG_IN035, SG_IN036, SG_IN037, SG_IN038, SG_IN039,
        input wire SG_IN040, SG_IN041, SG_IN042, SG_IN043, SG_IN044, SG_IN045, SG_IN046, SG_IN047, SG_IN048, SG_IN049,
		input wire SG_IN050, SG_IN051, SG_IN052, SG_IN053, SG_IN054, SG_IN055, SG_IN056, SG_IN057, SG_IN058, SG_IN059,
		input wire SG_IN060, SG_IN061, SG_IN062, SG_IN063, SG_IN064, SG_IN065, SG_IN066, SG_IN067, SG_IN068, SG_IN069,
		input wire SG_IN070, SG_IN071, SG_IN072, SG_IN073, SG_IN074, SG_IN075, SG_IN076, SG_IN077, SG_IN078, SG_IN079,
		input wire SG_IN080, SG_IN081, SG_IN082, SG_IN083, SG_IN084, SG_IN085, SG_IN086, SG_IN087, SG_IN088, SG_IN089,
		input wire SG_IN090, SG_IN091, SG_IN092, SG_IN093, SG_IN094, SG_IN095, SG_IN096, SG_IN097, SG_IN098, SG_IN099,

        output wire SG_OUT100, SG_OUT101, SG_OUT102, SG_OUT103, SG_OUT104, SG_OUT105, SG_OUT106, SG_OUT107, SG_OUT108, SG_OUT109,
		output wire SG_OUT110, SG_OUT111, SG_OUT112, SG_OUT113, SG_OUT114, SG_OUT115, SG_OUT116, SG_OUT117, SG_OUT118, SG_OUT119,
		output wire SG_OUT120, SG_OUT121, SG_OUT122, SG_OUT123, SG_OUT124, SG_OUT125, SG_OUT126, SG_OUT127, SG_OUT128, SG_OUT129,
		output wire SG_OUT130, SG_OUT131, SG_OUT132, SG_OUT133, SG_OUT134, SG_OUT135, SG_OUT136, SG_OUT137, SG_OUT138, SG_OUT139,
        output wire SG_OUT140, SG_OUT141, SG_OUT142, SG_OUT143, SG_OUT144, SG_OUT145, SG_OUT146, SG_OUT147, SG_OUT148, SG_OUT149,
		output wire SG_OUT150, SG_OUT151, SG_OUT152, SG_OUT153, SG_OUT154, SG_OUT155, SG_OUT156, SG_OUT157, SG_OUT158, SG_OUT159,
		output wire SG_OUT160, SG_OUT161, SG_OUT162, SG_OUT163, SG_OUT164, SG_OUT165, SG_OUT166, SG_OUT167, SG_OUT168, SG_OUT169,
		output wire SG_OUT170, SG_OUT171, SG_OUT172, SG_OUT173, SG_OUT174, SG_OUT175, SG_OUT176, SG_OUT177, SG_OUT178, SG_OUT179,
		output wire SG_OUT180, SG_OUT181, SG_OUT182, SG_OUT183, SG_OUT184, SG_OUT185, SG_OUT186, SG_OUT187, SG_OUT188, SG_OUT189,
		output wire SG_OUT190, SG_OUT191, SG_OUT192, SG_OUT193, SG_OUT194, SG_OUT195, SG_OUT196, SG_OUT197, SG_OUT198, SG_OUT199,

        output wire SG_OUT200, SG_OUT201, SG_OUT202, SG_OUT203, SG_OUT204, SG_OUT205, SG_OUT206, SG_OUT207, SG_OUT208, SG_OUT209,
		output wire SG_OUT210, SG_OUT211, SG_OUT212, SG_OUT213, SG_OUT214, SG_OUT215, SG_OUT216, SG_OUT217, SG_OUT218, SG_OUT219,
		output wire SG_OUT220, SG_OUT221, SG_OUT222, SG_OUT223, SG_OUT224, SG_OUT225, SG_OUT226, SG_OUT227, SG_OUT228, SG_OUT229,
		output wire SG_OUT230, SG_OUT231, SG_OUT232, SG_OUT233, SG_OUT234, SG_OUT235, SG_OUT236, SG_OUT237, SG_OUT238, SG_OUT239,
        output wire SG_OUT240, SG_OUT241, SG_OUT242, SG_OUT243, SG_OUT244, SG_OUT245, SG_OUT246, SG_OUT247, SG_OUT248, SG_OUT249,
		output wire SG_OUT250, SG_OUT251, SG_OUT252, SG_OUT253, SG_OUT254, SG_OUT255, SG_OUT256, SG_OUT257, SG_OUT258, SG_OUT259,
		output wire SG_OUT260, SG_OUT261, SG_OUT262, SG_OUT263, SG_OUT264, SG_OUT265, SG_OUT266, SG_OUT267, SG_OUT268, SG_OUT269,
		output wire SG_OUT270, SG_OUT271, SG_OUT272, SG_OUT273, SG_OUT274, SG_OUT275, SG_OUT276, SG_OUT277, SG_OUT278, SG_OUT279,
		output wire SG_OUT280, SG_OUT281, SG_OUT282, SG_OUT283, SG_OUT284, SG_OUT285, SG_OUT286, SG_OUT287, SG_OUT288, SG_OUT289,
		output wire SG_OUT290, SG_OUT291, SG_OUT292, SG_OUT293, SG_OUT294, SG_OUT295, SG_OUT296, SG_OUT297, SG_OUT298, SG_OUT299,

        //output wire SG_OUT300, SG_OUT301, SG_OUT302, SG_OUT303, SG_OUT304, SG_OUT305, SG_OUT306, SG_OUT307, SG_OUT308, SG_OUT309,
		//output wire SG_OUT310, SG_OUT311, SG_OUT312, SG_OUT313, SG_OUT314, SG_OUT315, SG_OUT316, SG_OUT317, SG_OUT318, SG_OUT319,
		//output wire SG_OUT320, SG_OUT321, SG_OUT322, SG_OUT323, SG_OUT324, SG_OUT325, SG_OUT326, SG_OUT327, SG_OUT328, SG_OUT329,
		//output wire SG_OUT330, SG_OUT331, SG_OUT332, SG_OUT333, SG_OUT334, SG_OUT335, SG_OUT336, SG_OUT337, SG_OUT338, SG_OUT339,
        //output wire SG_OUT340, SG_OUT341, SG_OUT342, SG_OUT343, SG_OUT344, SG_OUT345, SG_OUT346, SG_OUT347, SG_OUT348, SG_OUT349,
		//output wire SG_OUT350, SG_OUT351, SG_OUT352, SG_OUT353, SG_OUT354, SG_OUT355, SG_OUT356, SG_OUT357, SG_OUT358, SG_OUT359,
		//output wire SG_OUT360, SG_OUT361, SG_OUT362, SG_OUT363, SG_OUT364, SG_OUT365, SG_OUT366, SG_OUT367, SG_OUT368, SG_OUT369,
		//output wire SG_OUT370, SG_OUT371, SG_OUT372, SG_OUT373, SG_OUT374, SG_OUT375, SG_OUT376, SG_OUT377, SG_OUT378, SG_OUT379,
		//output wire SG_OUT380, SG_OUT381, SG_OUT382, SG_OUT383, SG_OUT384, SG_OUT385, SG_OUT386, SG_OUT387, SG_OUT388, SG_OUT389,
		//output wire SG_OUT390, SG_OUT391, SG_OUT392, SG_OUT393, SG_OUT394, SG_OUT395, SG_OUT396, SG_OUT397, SG_OUT398, SG_OUT399,

        //output wire SG_OUT400, SG_OUT401, SG_OUT402, SG_OUT403, SG_OUT404, SG_OUT405, SG_OUT406, SG_OUT407, SG_OUT408, SG_OUT409,
		//output wire SG_OUT410, SG_OUT411, SG_OUT412, SG_OUT413, SG_OUT414, SG_OUT415, SG_OUT416, SG_OUT417, SG_OUT418, SG_OUT419,
		//output wire SG_OUT420, SG_OUT421, SG_OUT422, SG_OUT423, SG_OUT424, SG_OUT425, SG_OUT426, SG_OUT427, SG_OUT428, SG_OUT429,
		//output wire SG_OUT430, SG_OUT431, SG_OUT432, SG_OUT433, SG_OUT434, SG_OUT435, SG_OUT436, SG_OUT437, SG_OUT438, SG_OUT439,
        //output wire SG_OUT440, SG_OUT441, SG_OUT442, SG_OUT443, SG_OUT444, SG_OUT445, SG_OUT446, SG_OUT447, SG_OUT448, SG_OUT449,
		//output wire SG_OUT450, SG_OUT451, SG_OUT452, SG_OUT453, SG_OUT454, SG_OUT455, SG_OUT456, SG_OUT457, SG_OUT458, SG_OUT459,
		//output wire SG_OUT460, SG_OUT461, SG_OUT462, SG_OUT463, SG_OUT464, SG_OUT465, SG_OUT466, SG_OUT467, SG_OUT468, SG_OUT469,
		//output wire SG_OUT470, SG_OUT471, SG_OUT472, SG_OUT473, SG_OUT474, SG_OUT475, SG_OUT476, SG_OUT477, SG_OUT478, SG_OUT479,
		//output wire SG_OUT480, SG_OUT481, SG_OUT482, SG_OUT483, SG_OUT484, SG_OUT485, SG_OUT486, SG_OUT487, SG_OUT488, SG_OUT489,
		//output wire SG_OUT490, SG_OUT491, SG_OUT492, SG_OUT493, SG_OUT494, SG_OUT495, SG_OUT496, SG_OUT497, SG_OUT498, SG_OUT499,

        //output wire SG_OUT500, SG_OUT501, SG_OUT502, SG_OUT503, SG_OUT504, SG_OUT505, SG_OUT506, SG_OUT507, SG_OUT508, SG_OUT509,
		//output wire SG_OUT510, SG_OUT511,

		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 6;
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 128
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg4;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg5;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg6;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg7;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg8;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg9;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg10;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg11;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg12;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg13;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg14;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg15;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg16;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg17;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg18;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg19;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg20;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg21;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg22;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg23;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg24;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg25;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg26;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg27;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg28;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg29;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg30;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg31;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg32;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg33;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg34;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg35;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg36;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg37;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg38;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg39;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg40;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg41;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg42;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg43;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg44;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg45;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg46;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg47;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg48;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg49;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg50;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg51;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg52;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg53;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg54;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg55;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg56;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg57;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg58;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg59;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg60;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg61;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg62;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg63;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg64;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg65;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg66;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg67;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg68;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg69;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg70;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg71;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg72;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg73;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg74;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg75;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg76;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg77;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg78;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg79;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg80;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg81;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg82;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg83;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg84;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg85;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg86;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg87;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg88;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg89;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg90;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg91;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg92;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg93;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg94;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg95;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg96;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg97;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg98;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg99;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg100;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg101;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg102;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg103;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg104;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg105;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg106;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg107;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg108;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg109;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg110;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg111;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg112;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg113;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg114;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg115;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg116;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg117;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg118;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg119;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg120;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg121;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg122;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg123;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg124;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg125;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg126;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg127;
	wire	 slv_reg_rden;
	wire	 slv_reg_wren;
	reg [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
	integer	 byte_index;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RDATA	= axi_rdata;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	// Implement axi_awready generation
	// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
	// de-asserted when reset is low.


	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
	        begin
	          // slave is ready to accept write address when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_awready <= 1'b1;
	        end
	      else           
	        begin
	          axi_awready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_awaddr latching
	// This process is used to latch the address when both 
	// S_AXI_AWVALID and S_AXI_WVALID are valid. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_awaddr <= 0;
	    end 
	  else
	    begin    
	      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
	        begin
	          // Write Address latching 
	          axi_awaddr <= S_AXI_AWADDR;
	        end
	    end 
	end       

	// Implement axi_wready generation
	// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
	// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
	// de-asserted when reset is low. 

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_wready <= 1'b0;
	    end 
	  else
	    begin    
	      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID)
	        begin
	          // slave is ready to accept write data when 
	          // there is a valid write address and write data
	          // on the write address and data bus. This design 
	          // expects no outstanding transactions. 
	          axi_wready <= 1'b1;
	        end
	      else
	        begin
	          axi_wready <= 1'b0;
	        end
	    end 
	end       

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      slv_reg0 <= 0;
	      slv_reg1 <= 0;
	      slv_reg2 <= 0;
	      slv_reg3 <= 0;
	      slv_reg4 <= 0;
	      slv_reg5 <= 0;
	      slv_reg6 <= 0;
	      slv_reg7 <= 0;
	      slv_reg8 <= 0;
	      slv_reg9 <= 0;
	      slv_reg10 <= 0;
	      slv_reg11 <= 0;
	      slv_reg12 <= 0;
	      slv_reg13 <= 0;
	      slv_reg14 <= 0;
	      slv_reg15 <= 0;
	      slv_reg16 <= 0;
	      slv_reg17 <= 0;
	      slv_reg18 <= 0;
	      slv_reg19 <= 0;
	      slv_reg20 <= 0;
	      slv_reg21 <= 0;
	      slv_reg22 <= 0;
	      slv_reg23 <= 0;
	      slv_reg24 <= 0;
	      slv_reg25 <= 0;
	      slv_reg26 <= 0;
	      slv_reg27 <= 0;
	      slv_reg28 <= 0;
	      slv_reg29 <= 0;
	      slv_reg30 <= 0;
	      slv_reg31 <= 0;
	      slv_reg32 <= 0;
	      slv_reg33 <= 0;
	      slv_reg34 <= 0;
	      slv_reg35 <= 0;
	      slv_reg36 <= 0;
	      slv_reg37 <= 0;
	      slv_reg38 <= 0;
	      slv_reg39 <= 0;
	      slv_reg40 <= 0;
	      slv_reg41 <= 0;
	      slv_reg42 <= 0;
	      slv_reg43 <= 0;
	      slv_reg44 <= 0;
	      slv_reg45 <= 0;
	      slv_reg46 <= 0;
	      slv_reg47 <= 0;
	      slv_reg48 <= 0;
	      slv_reg49 <= 0;
	      slv_reg50 <= 0;
	      slv_reg51 <= 0;
	      slv_reg52 <= 0;
	      slv_reg53 <= 0;
	      slv_reg54 <= 0;
	      slv_reg55 <= 0;
	      slv_reg56 <= 0;
	      slv_reg57 <= 0;
	      slv_reg58 <= 0;
	      slv_reg59 <= 0;
	      slv_reg60 <= 0;
	      slv_reg61 <= 0;
	      slv_reg62 <= 0;
	      slv_reg63 <= 0;
	      slv_reg64 <= 0;
	      slv_reg65 <= 0;
	      slv_reg66 <= 0;
	      slv_reg67 <= 0;
	      slv_reg68 <= 0;
	      slv_reg69 <= 0;
	      slv_reg70 <= 0;
	      slv_reg71 <= 0;
	      slv_reg72 <= 0;
	      slv_reg73 <= 0;
	      // initialize s[299] output to 1, because it's used as a manual reset;
	      // slv_reg74[31:24] <= 8'b00100000;
	      slv_reg74 <= 32'h20000000;
	      slv_reg75 <= 0;
	      slv_reg76 <= 0;
	      slv_reg77 <= 0;
	      slv_reg78 <= 0;
	      slv_reg79 <= 0;
	      slv_reg80 <= 0;
	      slv_reg81 <= 0;
	      slv_reg82 <= 0;
	      slv_reg83 <= 0;
	      slv_reg84 <= 0;
	      slv_reg85 <= 0;
	      slv_reg86 <= 0;
	      slv_reg87 <= 0;
	      slv_reg88 <= 0;
	      slv_reg89 <= 0;
	      slv_reg90 <= 0;
	      slv_reg91 <= 0;
	      slv_reg92 <= 0;
	      slv_reg93 <= 0;
	      slv_reg94 <= 0;
	      slv_reg95 <= 0;
	      slv_reg96 <= 0;
	      slv_reg97 <= 0;
	      slv_reg98 <= 0;
	      slv_reg99 <= 0;
	      slv_reg100 <= 0;
	      slv_reg101 <= 0;
	      slv_reg102 <= 0;
	      slv_reg103 <= 0;
	      slv_reg104 <= 0;
	      slv_reg105 <= 0;
	      slv_reg106 <= 0;
	      slv_reg107 <= 0;
	      slv_reg108 <= 0;
	      slv_reg109 <= 0;
	      slv_reg110 <= 0;
	      slv_reg111 <= 0;
	      slv_reg112 <= 0;
	      slv_reg113 <= 0;
	      slv_reg114 <= 0;
	      slv_reg115 <= 0;
	      slv_reg116 <= 0;
	      slv_reg117 <= 0;
	      slv_reg118 <= 0;
	      slv_reg119 <= 0;
	      slv_reg120 <= 0;
	      slv_reg121 <= 0;
	      slv_reg122 <= 0;
	      slv_reg123 <= 0;
	      slv_reg124 <= 0;
	      slv_reg125 <= 0;
	      slv_reg126 <= 0;
	      slv_reg127 <= 0;
	    end 
	  else begin
	    if (slv_reg_wren)
	      begin
	        case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	          7'h00:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 0
	                slv_reg0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h01:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 1
	                slv_reg1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h02:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 2
	                slv_reg2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h03:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 3
	                slv_reg3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h04:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 4
	                slv_reg4[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h05:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 5
	                slv_reg5[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h06:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 6
	                slv_reg6[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h07:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 7
	                slv_reg7[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h08:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 8
	                slv_reg8[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h09:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 9
	                slv_reg9[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h0A:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 10
	                slv_reg10[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h0B:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 11
	                slv_reg11[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h0C:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 12
	                slv_reg12[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h0D:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 13
	                slv_reg13[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h0E:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 14
	                slv_reg14[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h0F:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 15
	                slv_reg15[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h10:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 16
	                slv_reg16[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h11:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 17
	                slv_reg17[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h12:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 18
	                slv_reg18[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h13:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 19
	                slv_reg19[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h14:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 20
	                slv_reg20[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h15:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 21
	                slv_reg21[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h16:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 22
	                slv_reg22[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h17:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 23
	                slv_reg23[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h18:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 24
	                slv_reg24[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h19:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 25
	                slv_reg25[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h1A:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 26
	                slv_reg26[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h1B:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 27
	                slv_reg27[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h1C:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 28
	                slv_reg28[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h1D:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 29
	                slv_reg29[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h1E:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 30
	                slv_reg30[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h1F:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 31
	                slv_reg31[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h20:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 32
	                slv_reg32[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h21:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 33
	                slv_reg33[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h22:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 34
	                slv_reg34[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h23:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 35
	                slv_reg35[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h24:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 36
	                slv_reg36[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h25:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 37
	                slv_reg37[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h26:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 38
	                slv_reg38[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h27:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 39
	                slv_reg39[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h28:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 40
	                slv_reg40[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h29:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 41
	                slv_reg41[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h2A:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 42
	                slv_reg42[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h2B:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 43
	                slv_reg43[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h2C:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 44
	                slv_reg44[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h2D:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 45
	                slv_reg45[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h2E:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 46
	                slv_reg46[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h2F:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 47
	                slv_reg47[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h30:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 48
	                slv_reg48[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h31:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 49
	                slv_reg49[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h32:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 50
	                slv_reg50[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h33:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 51
	                slv_reg51[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h34:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 52
	                slv_reg52[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h35:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 53
	                slv_reg53[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h36:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 54
	                slv_reg54[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h37:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 55
	                slv_reg55[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h38:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 56
	                slv_reg56[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h39:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 57
	                slv_reg57[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h3A:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 58
	                slv_reg58[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h3B:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 59
	                slv_reg59[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h3C:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 60
	                slv_reg60[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h3D:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 61
	                slv_reg61[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h3E:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 62
	                slv_reg62[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h3F:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 63
	                slv_reg63[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h40:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 64
	                slv_reg64[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h41:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 65
	                slv_reg65[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h42:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 66
	                slv_reg66[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h43:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 67
	                slv_reg67[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h44:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 68
	                slv_reg68[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h45:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 69
	                slv_reg69[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h46:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 70
	                slv_reg70[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h47:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 71
	                slv_reg71[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h48:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 72
	                slv_reg72[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h49:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 73
	                slv_reg73[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h4A:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 74
	                slv_reg74[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h4B:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 75
	                slv_reg75[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h4C:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 76
	                slv_reg76[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h4D:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 77
	                slv_reg77[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h4E:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 78
	                slv_reg78[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h4F:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 79
	                slv_reg79[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h50:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 80
	                slv_reg80[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h51:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 81
	                slv_reg81[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h52:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 82
	                slv_reg82[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h53:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 83
	                slv_reg83[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h54:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 84
	                slv_reg84[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h55:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 85
	                slv_reg85[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h56:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 86
	                slv_reg86[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h57:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 87
	                slv_reg87[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h58:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 88
	                slv_reg88[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h59:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 89
	                slv_reg89[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h5A:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 90
	                slv_reg90[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h5B:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 91
	                slv_reg91[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h5C:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 92
	                slv_reg92[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h5D:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 93
	                slv_reg93[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h5E:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 94
	                slv_reg94[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h5F:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 95
	                slv_reg95[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h60:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 96
	                slv_reg96[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h61:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 97
	                slv_reg97[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h62:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 98
	                slv_reg98[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h63:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 99
	                slv_reg99[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h64:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 100
	                slv_reg100[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h65:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 101
	                slv_reg101[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h66:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 102
	                slv_reg102[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h67:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 103
	                slv_reg103[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h68:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 104
	                slv_reg104[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h69:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 105
	                slv_reg105[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h6A:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 106
	                slv_reg106[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h6B:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 107
	                slv_reg107[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h6C:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 108
	                slv_reg108[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h6D:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 109
	                slv_reg109[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h6E:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 110
	                slv_reg110[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h6F:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 111
	                slv_reg111[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h70:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 112
	                slv_reg112[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h71:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 113
	                slv_reg113[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h72:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 114
	                slv_reg114[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h73:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 115
	                slv_reg115[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h74:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 116
	                slv_reg116[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h75:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 117
	                slv_reg117[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h76:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 118
	                slv_reg118[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h77:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 119
	                slv_reg119[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h78:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 120
	                slv_reg120[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h79:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 121
	                slv_reg121[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h7A:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 122
	                slv_reg122[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h7B:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 123
	                slv_reg123[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h7C:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 124
	                slv_reg124[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h7D:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 125
	                slv_reg125[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h7E:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 126
	                slv_reg126[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          7'h7F:
	            for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
	              if ( S_AXI_WSTRB[byte_index] == 1 ) begin
	                // Respective byte enables are asserted as per write strobes 
	                // Slave register 127
	                slv_reg127[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
	              end  
	          default : begin
	                      slv_reg0 <= slv_reg0;
	                      slv_reg1 <= slv_reg1;
	                      slv_reg2 <= slv_reg2;
	                      slv_reg3 <= slv_reg3;
	                      slv_reg4 <= slv_reg4;
	                      slv_reg5 <= slv_reg5;
	                      slv_reg6 <= slv_reg6;
	                      slv_reg7 <= slv_reg7;
	                      slv_reg8 <= slv_reg8;
	                      slv_reg9 <= slv_reg9;
	                      slv_reg10 <= slv_reg10;
	                      slv_reg11 <= slv_reg11;
	                      slv_reg12 <= slv_reg12;
	                      slv_reg13 <= slv_reg13;
	                      slv_reg14 <= slv_reg14;
	                      slv_reg15 <= slv_reg15;
	                      slv_reg16 <= slv_reg16;
	                      slv_reg17 <= slv_reg17;
	                      slv_reg18 <= slv_reg18;
	                      slv_reg19 <= slv_reg19;
	                      slv_reg20 <= slv_reg20;
	                      slv_reg21 <= slv_reg21;
	                      slv_reg22 <= slv_reg22;
	                      slv_reg23 <= slv_reg23;
	                      slv_reg24 <= slv_reg24;
	                      slv_reg25 <= slv_reg25;
	                      slv_reg26 <= slv_reg26;
	                      slv_reg27 <= slv_reg27;
	                      slv_reg28 <= slv_reg28;
	                      slv_reg29 <= slv_reg29;
	                      slv_reg30 <= slv_reg30;
	                      slv_reg31 <= slv_reg31;
	                      slv_reg32 <= slv_reg32;
	                      slv_reg33 <= slv_reg33;
	                      slv_reg34 <= slv_reg34;
	                      slv_reg35 <= slv_reg35;
	                      slv_reg36 <= slv_reg36;
	                      slv_reg37 <= slv_reg37;
	                      slv_reg38 <= slv_reg38;
	                      slv_reg39 <= slv_reg39;
	                      slv_reg40 <= slv_reg40;
	                      slv_reg41 <= slv_reg41;
	                      slv_reg42 <= slv_reg42;
	                      slv_reg43 <= slv_reg43;
	                      slv_reg44 <= slv_reg44;
	                      slv_reg45 <= slv_reg45;
	                      slv_reg46 <= slv_reg46;
	                      slv_reg47 <= slv_reg47;
	                      slv_reg48 <= slv_reg48;
	                      slv_reg49 <= slv_reg49;
	                      slv_reg50 <= slv_reg50;
	                      slv_reg51 <= slv_reg51;
	                      slv_reg52 <= slv_reg52;
	                      slv_reg53 <= slv_reg53;
	                      slv_reg54 <= slv_reg54;
	                      slv_reg55 <= slv_reg55;
	                      slv_reg56 <= slv_reg56;
	                      slv_reg57 <= slv_reg57;
	                      slv_reg58 <= slv_reg58;
	                      slv_reg59 <= slv_reg59;
	                      slv_reg60 <= slv_reg60;
	                      slv_reg61 <= slv_reg61;
	                      slv_reg62 <= slv_reg62;
	                      slv_reg63 <= slv_reg63;
	                      slv_reg64 <= slv_reg64;
	                      slv_reg65 <= slv_reg65;
	                      slv_reg66 <= slv_reg66;
	                      slv_reg67 <= slv_reg67;
	                      slv_reg68 <= slv_reg68;
	                      slv_reg69 <= slv_reg69;
	                      slv_reg70 <= slv_reg70;
	                      slv_reg71 <= slv_reg71;
	                      slv_reg72 <= slv_reg72;
	                      slv_reg73 <= slv_reg73;
	                      slv_reg74 <= slv_reg74;
	                      slv_reg75 <= slv_reg75;
	                      slv_reg76 <= slv_reg76;
	                      slv_reg77 <= slv_reg77;
	                      slv_reg78 <= slv_reg78;
	                      slv_reg79 <= slv_reg79;
	                      slv_reg80 <= slv_reg80;
	                      slv_reg81 <= slv_reg81;
	                      slv_reg82 <= slv_reg82;
	                      slv_reg83 <= slv_reg83;
	                      slv_reg84 <= slv_reg84;
	                      slv_reg85 <= slv_reg85;
	                      slv_reg86 <= slv_reg86;
	                      slv_reg87 <= slv_reg87;
	                      slv_reg88 <= slv_reg88;
	                      slv_reg89 <= slv_reg89;
	                      slv_reg90 <= slv_reg90;
	                      slv_reg91 <= slv_reg91;
	                      slv_reg92 <= slv_reg92;
	                      slv_reg93 <= slv_reg93;
	                      slv_reg94 <= slv_reg94;
	                      slv_reg95 <= slv_reg95;
	                      slv_reg96 <= slv_reg96;
	                      slv_reg97 <= slv_reg97;
	                      slv_reg98 <= slv_reg98;
	                      slv_reg99 <= slv_reg99;
	                      slv_reg100 <= slv_reg100;
	                      slv_reg101 <= slv_reg101;
	                      slv_reg102 <= slv_reg102;
	                      slv_reg103 <= slv_reg103;
	                      slv_reg104 <= slv_reg104;
	                      slv_reg105 <= slv_reg105;
	                      slv_reg106 <= slv_reg106;
	                      slv_reg107 <= slv_reg107;
	                      slv_reg108 <= slv_reg108;
	                      slv_reg109 <= slv_reg109;
	                      slv_reg110 <= slv_reg110;
	                      slv_reg111 <= slv_reg111;
	                      slv_reg112 <= slv_reg112;
	                      slv_reg113 <= slv_reg113;
	                      slv_reg114 <= slv_reg114;
	                      slv_reg115 <= slv_reg115;
	                      slv_reg116 <= slv_reg116;
	                      slv_reg117 <= slv_reg117;
	                      slv_reg118 <= slv_reg118;
	                      slv_reg119 <= slv_reg119;
	                      slv_reg120 <= slv_reg120;
	                      slv_reg121 <= slv_reg121;
	                      slv_reg122 <= slv_reg122;
	                      slv_reg123 <= slv_reg123;
	                      slv_reg124 <= slv_reg124;
	                      slv_reg125 <= slv_reg125;
	                      slv_reg126 <= slv_reg126;
	                      slv_reg127 <= slv_reg127;
	                    end
	        endcase
	      end
	  end
	end    

	// Implement write response logic generation
	// The write response and response valid signals are asserted by the slave 
	// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
	// This marks the acceptance of address and indicates the status of 
	// write transaction.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_bvalid  <= 0;
	      axi_bresp   <= 2'b0;
	    end 
	  else
	    begin    
	      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
	        begin
	          // indicates a valid write response is available
	          axi_bvalid <= 1'b1;
	          axi_bresp  <= 2'b0; // 'OKAY' response 
	        end                   // work error responses in future
	      else
	        begin
	          if (S_AXI_BREADY && axi_bvalid) 
	            //check if bready is asserted while bvalid is high) 
	            //(there is a possibility that bready is always asserted high)   
	            begin
	              axi_bvalid <= 1'b0; 
	            end  
	        end
	    end
	end   

	// Implement axi_arready generation
	// axi_arready is asserted for one S_AXI_ACLK clock cycle when
	// S_AXI_ARVALID is asserted. axi_awready is 
	// de-asserted when reset (active low) is asserted. 
	// The read address is also latched when S_AXI_ARVALID is 
	// asserted. axi_araddr is reset to zero on reset assertion.

	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_arready <= 1'b0;
	      axi_araddr  <= 32'b0;
	    end 
	  else
	    begin    
	      if (~axi_arready && S_AXI_ARVALID)
	        begin
	          // indicates that the slave has acceped the valid read address
	          axi_arready <= 1'b1;
	          // Read address latching
	          axi_araddr  <= S_AXI_ARADDR;
	        end
	      else
	        begin
	          axi_arready <= 1'b0;
	        end
	    end 
	end       

	// Implement axi_arvalid generation
	// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
	// S_AXI_ARVALID and axi_arready are asserted. The slave registers 
	// data are available on the axi_rdata bus at this instance. The 
	// assertion of axi_rvalid marks the validity of read data on the 
	// bus and axi_rresp indicates the status of read transaction.axi_rvalid 
	// is deasserted on reset (active low). axi_rresp and axi_rdata are 
	// cleared to zero on reset (active low).  
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rvalid <= 0;
	      axi_rresp  <= 0;
	    end 
	  else
	    begin    
	      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
	        begin
	          // Valid read data is available at the read data bus
	          axi_rvalid <= 1'b1;
	          axi_rresp  <= 2'b0; // 'OKAY' response
	        end   
	      else if (axi_rvalid && S_AXI_RREADY)
	        begin
	          // Read data is accepted by the master
	          axi_rvalid <= 1'b0;
	        end                
	    end
	end    

	// Implement memory mapped register select and read logic generation
	// Slave register read enable is asserted when valid address is available
	// and the slave is ready to accept the read address.
	assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
	always @(*)
	begin
	      // Address decoding for reading registers
	      case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
	        7'h00   : reg_data_out <= {r_RB[003], r_RB[002], r_RB[001], r_RB[000]};
	        7'h01   : reg_data_out <= {r_RB[007], r_RB[006], r_RB[005], r_RB[004]};
	        7'h02   : reg_data_out <= {r_RB[011], r_RB[010], r_RB[009], r_RB[008]};
	        7'h03   : reg_data_out <= {r_RB[015], r_RB[014], r_RB[013], r_RB[012]};
	        7'h04   : reg_data_out <= {r_RB[019], r_RB[018], r_RB[017], r_RB[016]};
	        7'h05   : reg_data_out <= {r_RB[023], r_RB[022], r_RB[021], r_RB[020]};
	        7'h06   : reg_data_out <= {r_RB[027], r_RB[026], r_RB[025], r_RB[024]};
	        7'h07   : reg_data_out <= {r_RB[031], r_RB[030], r_RB[029], r_RB[028]};
	        7'h08   : reg_data_out <= {r_RB[035], r_RB[034], r_RB[033], r_RB[032]};
	        7'h09   : reg_data_out <= {r_RB[039], r_RB[038], r_RB[037], r_RB[036]};
	        7'h0a   : reg_data_out <= {r_RB[043], r_RB[042], r_RB[041], r_RB[040]};
	        7'h0b   : reg_data_out <= {r_RB[047], r_RB[046], r_RB[045], r_RB[044]};
	        7'h0c   : reg_data_out <= {r_RB[051], r_RB[050], r_RB[049], r_RB[048]};
	        7'h0d   : reg_data_out <= {r_RB[055], r_RB[054], r_RB[053], r_RB[052]};
	        7'h0e   : reg_data_out <= {r_RB[059], r_RB[058], r_RB[057], r_RB[056]};

	        7'h0f	: reg_data_out <= {r_RB[063], r_RB[062], r_RB[061], r_RB[060]};
	        7'h10	: reg_data_out <= {r_RB[067], r_RB[066], r_RB[065], r_RB[064]};
	        7'h11	: reg_data_out <= {r_RB[071], r_RB[070], r_RB[069], r_RB[068]};
	        7'h12	: reg_data_out <= {r_RB[075], r_RB[074], r_RB[073], r_RB[072]};
	        7'h13	: reg_data_out <= {r_RB[079], r_RB[078], r_RB[077], r_RB[076]};
	        7'h14	: reg_data_out <= {r_RB[083], r_RB[082], r_RB[081], r_RB[080]};
	        7'h15	: reg_data_out <= {r_RB[087], r_RB[086], r_RB[085], r_RB[084]};
	        7'h16	: reg_data_out <= {r_RB[091], r_RB[090], r_RB[089], r_RB[088]};
	        7'h17	: reg_data_out <= {r_RB[095], r_RB[094], r_RB[093], r_RB[092]};
	        7'h18	: reg_data_out <= {r_RB[099], r_RB[098], r_RB[097], r_RB[096]};

	        7'h19   : reg_data_out <= {r_RB[103], r_RB[102], r_RB[101], r_RB[100]};
	        7'h1a   : reg_data_out <= {r_RB[107], r_RB[106], r_RB[105], r_RB[104]};
	        7'h1b   : reg_data_out <= {r_RB[111], r_RB[110], r_RB[109], r_RB[108]};
	        7'h1c   : reg_data_out <= {r_RB[115], r_RB[114], r_RB[113], r_RB[112]};
	        7'h1d   : reg_data_out <= {r_RB[119], r_RB[118], r_RB[117], r_RB[116]};
	        7'h1e   : reg_data_out <= {r_RB[123], r_RB[122], r_RB[121], r_RB[120]};
	        7'h1f   : reg_data_out <= {r_RB[127], r_RB[126], r_RB[125], r_RB[124]};
	        7'h20   : reg_data_out <= {r_RB[131], r_RB[130], r_RB[129], r_RB[128]};
	        7'h21   : reg_data_out <= {r_RB[135], r_RB[134], r_RB[133], r_RB[132]};
	        7'h22   : reg_data_out <= {r_RB[139], r_RB[138], r_RB[137], r_RB[136]};
	        7'h23   : reg_data_out <= {r_RB[143], r_RB[142], r_RB[141], r_RB[140]};
	        7'h24   : reg_data_out <= {r_RB[147], r_RB[146], r_RB[145], r_RB[144]};
	        7'h25   : reg_data_out <= {r_RB[151], r_RB[150], r_RB[149], r_RB[148]};
	        7'h26   : reg_data_out <= {r_RB[155], r_RB[154], r_RB[153], r_RB[152]};
	        7'h27   : reg_data_out <= {r_RB[159], r_RB[158], r_RB[157], r_RB[156]};
	        7'h28   : reg_data_out <= {r_RB[163], r_RB[162], r_RB[161], r_RB[160]};
	        7'h29   : reg_data_out <= {r_RB[167], r_RB[166], r_RB[165], r_RB[164]};
	        7'h2a   : reg_data_out <= {r_RB[171], r_RB[170], r_RB[169], r_RB[168]};
	        7'h2b   : reg_data_out <= {r_RB[175], r_RB[174], r_RB[173], r_RB[172]};
	        7'h2c   : reg_data_out <= {r_RB[179], r_RB[178], r_RB[177], r_RB[176]};
	        7'h2d   : reg_data_out <= {r_RB[183], r_RB[182], r_RB[181], r_RB[180]};
	        7'h2e   : reg_data_out <= {r_RB[187], r_RB[186], r_RB[185], r_RB[184]};
	        7'h2f   : reg_data_out <= {r_RB[191], r_RB[190], r_RB[189], r_RB[188]};
	        7'h30   : reg_data_out <= {r_RB[195], r_RB[194], r_RB[193], r_RB[192]};
	        7'h31   : reg_data_out <= {r_RB[199], r_RB[198], r_RB[197], r_RB[196]};
	        7'h32   : reg_data_out <= {r_RB[203], r_RB[202], r_RB[201], r_RB[200]};
	        7'h33   : reg_data_out <= {r_RB[207], r_RB[206], r_RB[205], r_RB[204]};
	        7'h34   : reg_data_out <= {r_RB[211], r_RB[210], r_RB[209], r_RB[208]};
	        7'h35   : reg_data_out <= {r_RB[215], r_RB[214], r_RB[213], r_RB[212]};
	        7'h36   : reg_data_out <= {r_RB[219], r_RB[218], r_RB[217], r_RB[216]};
	        7'h37   : reg_data_out <= {r_RB[223], r_RB[222], r_RB[221], r_RB[220]};
	        7'h38   : reg_data_out <= {r_RB[227], r_RB[226], r_RB[225], r_RB[224]};
	        7'h39   : reg_data_out <= {r_RB[231], r_RB[230], r_RB[229], r_RB[228]};
	        7'h3a   : reg_data_out <= {r_RB[235], r_RB[234], r_RB[233], r_RB[232]};
	        7'h3b   : reg_data_out <= {r_RB[239], r_RB[238], r_RB[237], r_RB[236]};
	        7'h3c	: reg_data_out <= {r_RB[243], r_RB[242], r_RB[241], r_RB[240]};
	        7'h3d	: reg_data_out <= {r_RB[247], r_RB[246], r_RB[245], r_RB[244]};
	        7'h3e	: reg_data_out <= {r_RB[251], r_RB[250], r_RB[249], r_RB[248]};
	        7'h3f	: reg_data_out <= {r_RB[255], r_RB[254], r_RB[253], r_RB[252]};
	        7'h40	: reg_data_out <= {r_RB[259], r_RB[258], r_RB[257], r_RB[256]};
	        7'h41	: reg_data_out <= {r_RB[263], r_RB[262], r_RB[261], r_RB[260]};
	        7'h42	: reg_data_out <= {r_RB[267], r_RB[266], r_RB[265], r_RB[264]};
	        7'h43	: reg_data_out <= {r_RB[271], r_RB[270], r_RB[269], r_RB[268]};
	        7'h44	: reg_data_out <= {r_RB[275], r_RB[274], r_RB[273], r_RB[272]};
	        7'h45	: reg_data_out <= {r_RB[279], r_RB[278], r_RB[277], r_RB[276]};
	        7'h46	: reg_data_out <= {r_RB[283], r_RB[282], r_RB[281], r_RB[280]};
	        7'h47	: reg_data_out <= {r_RB[287], r_RB[286], r_RB[285], r_RB[284]};
	        7'h48	: reg_data_out <= {r_RB[291], r_RB[290], r_RB[289], r_RB[288]};
	        7'h49	: reg_data_out <= {r_RB[295], r_RB[294], r_RB[293], r_RB[292]};
	        7'h4a	: reg_data_out <= {r_RB[299], r_RB[298], r_RB[297], r_RB[296]};
	        //7'h4b   : reg_data_out <= {r_RB[303], r_RB[302], r_RB[301], r_RB[300]};
	        //7'h4c   : reg_data_out <= {r_RB[307], r_RB[306], r_RB[305], r_RB[304]};
	        //7'h4d   : reg_data_out <= {r_RB[311], r_RB[310], r_RB[309], r_RB[308]};
	        //7'h4e   : reg_data_out <= {r_RB[315], r_RB[314], r_RB[313], r_RB[312]};
	        //7'h4f   : reg_data_out <= {r_RB[319], r_RB[318], r_RB[317], r_RB[316]};
	        //7'h50   : reg_data_out <= {r_RB[323], r_RB[322], r_RB[321], r_RB[320]};
	        //7'h51   : reg_data_out <= {r_RB[327], r_RB[326], r_RB[325], r_RB[324]};
	        //7'h52   : reg_data_out <= {r_RB[331], r_RB[330], r_RB[329], r_RB[328]};
	        //7'h53   : reg_data_out <= {r_RB[335], r_RB[334], r_RB[333], r_RB[332]};
	        //7'h54   : reg_data_out <= {r_RB[339], r_RB[338], r_RB[337], r_RB[336]};
	        //7'h55   : reg_data_out <= {r_RB[343], r_RB[342], r_RB[341], r_RB[340]};
	        //7'h56   : reg_data_out <= {r_RB[347], r_RB[346], r_RB[345], r_RB[344]};
	        //7'h57   : reg_data_out <= {r_RB[351], r_RB[350], r_RB[349], r_RB[348]};
	        //7'h58   : reg_data_out <= {r_RB[355], r_RB[354], r_RB[353], r_RB[352]};
	        //7'h59   : reg_data_out <= {r_RB[359], r_RB[358], r_RB[357], r_RB[356]};
	        //7'h5a   : reg_data_out <= {r_RB[363], r_RB[362], r_RB[361], r_RB[360]};
	        //7'h5b   : reg_data_out <= {r_RB[367], r_RB[366], r_RB[365], r_RB[364]};
	        //7'h5c   : reg_data_out <= {r_RB[371], r_RB[370], r_RB[369], r_RB[368]};
	        //7'h5d   : reg_data_out <= {r_RB[375], r_RB[374], r_RB[373], r_RB[372]};
	        //7'h5e   : reg_data_out <= {r_RB[379], r_RB[378], r_RB[377], r_RB[376]};
	        //7'h5f   : reg_data_out <= {r_RB[383], r_RB[382], r_RB[381], r_RB[380]};
	        //7'h60   : reg_data_out <= {r_RB[387], r_RB[386], r_RB[385], r_RB[384]};
	        //7'h61   : reg_data_out <= {r_RB[391], r_RB[390], r_RB[389], r_RB[388]};
	        //7'h62   : reg_data_out <= {r_RB[395], r_RB[394], r_RB[393], r_RB[392]};
	        //7'h63   : reg_data_out <= {r_RB[399], r_RB[398], r_RB[397], r_RB[396]};
	        //7'h64   : reg_data_out <= {r_RB[403], r_RB[402], r_RB[401], r_RB[400]};
	        //7'h65   : reg_data_out <= {r_RB[407], r_RB[406], r_RB[405], r_RB[404]};
	        //7'h66   : reg_data_out <= {r_RB[411], r_RB[410], r_RB[409], r_RB[408]};
	        //7'h67   : reg_data_out <= {r_RB[415], r_RB[414], r_RB[413], r_RB[412]};
	        //7'h68   : reg_data_out <= {r_RB[419], r_RB[418], r_RB[417], r_RB[416]};
	        //7'h69   : reg_data_out <= {r_RB[423], r_RB[422], r_RB[421], r_RB[420]};
	        //7'h6a   : reg_data_out <= {r_RB[427], r_RB[426], r_RB[425], r_RB[424]};
	        //7'h6b   : reg_data_out <= {r_RB[431], r_RB[430], r_RB[429], r_RB[428]};
	        //7'h6c   : reg_data_out <= {r_RB[435], r_RB[434], r_RB[433], r_RB[432]};
	        //7'h6d   : reg_data_out <= {r_RB[439], r_RB[438], r_RB[437], r_RB[436]};
	        //7'h6e   : reg_data_out <= {r_RB[443], r_RB[442], r_RB[441], r_RB[440]};
	        //7'h6f   : reg_data_out <= {r_RB[447], r_RB[446], r_RB[445], r_RB[444]};
	        //7'h70   : reg_data_out <= {r_RB[451], r_RB[450], r_RB[449], r_RB[448]};
	        //7'h71   : reg_data_out <= {r_RB[455], r_RB[454], r_RB[453], r_RB[452]};
	        //7'h72   : reg_data_out <= {r_RB[459], r_RB[458], r_RB[457], r_RB[456]};
	        //7'h73   : reg_data_out <= {r_RB[463], r_RB[462], r_RB[461], r_RB[460]};
	        //7'h74   : reg_data_out <= {r_RB[467], r_RB[466], r_RB[465], r_RB[464]};
	        //7'h75   : reg_data_out <= {r_RB[471], r_RB[470], r_RB[469], r_RB[468]};
	        //7'h76   : reg_data_out <= {r_RB[475], r_RB[474], r_RB[473], r_RB[472]};
	        //7'h77   : reg_data_out <= {r_RB[479], r_RB[478], r_RB[477], r_RB[476]};
	        //7'h78   : reg_data_out <= {r_RB[483], r_RB[482], r_RB[481], r_RB[480]};
	        //7'h79   : reg_data_out <= {r_RB[487], r_RB[486], r_RB[485], r_RB[484]};
	        //7'h7a   : reg_data_out <= {r_RB[491], r_RB[490], r_RB[489], r_RB[488]};
	        //7'h7b   : reg_data_out <= {r_RB[495], r_RB[494], r_RB[493], r_RB[492]};
	        //7'h7c   : reg_data_out <= {r_RB[499], r_RB[498], r_RB[497], r_RB[496]};
	        //7'h7d   : reg_data_out <= {r_RB[503], r_RB[502], r_RB[501], r_RB[500]};
	        //7'h7e   : reg_data_out <= {r_RB[507], r_RB[506], r_RB[505], r_RB[504]};
	        //7'h7f   : reg_data_out <= {r_RB[511], r_RB[510], r_RB[509], r_RB[508]};

	        7'h4b	: reg_data_out <= slv_reg75;
	        7'h4c	: reg_data_out <= slv_reg76;
	        7'h4d	: reg_data_out <= slv_reg77;
	        7'h4e	: reg_data_out <= slv_reg78;
	        7'h4f	: reg_data_out <= slv_reg79;
	        7'h50   : reg_data_out <= slv_reg80;
	        7'h51   : reg_data_out <= slv_reg81;
	        7'h52   : reg_data_out <= slv_reg82;
	        7'h53   : reg_data_out <= slv_reg83;
	        7'h54   : reg_data_out <= slv_reg84;
	        7'h55   : reg_data_out <= slv_reg85;
	        7'h56   : reg_data_out <= slv_reg86;
	        7'h57   : reg_data_out <= slv_reg87;
	        7'h58   : reg_data_out <= slv_reg88;
	        7'h59   : reg_data_out <= slv_reg89;
	        7'h5a	: reg_data_out <= slv_reg90;
	        7'h5b	: reg_data_out <= slv_reg91;
	        7'h5c	: reg_data_out <= slv_reg92;
	        7'h5d	: reg_data_out <= slv_reg93;
	        7'h5e	: reg_data_out <= slv_reg94;
	        7'h5f	: reg_data_out <= slv_reg95;
	        7'h60   : reg_data_out <= slv_reg96;
	        7'h61   : reg_data_out <= slv_reg97;
	        7'h62   : reg_data_out <= slv_reg98;
	        7'h63   : reg_data_out <= slv_reg99;
	        7'h64   : reg_data_out <= slv_reg100;
	        7'h65   : reg_data_out <= slv_reg101;
	        7'h66   : reg_data_out <= slv_reg102;
	        7'h67   : reg_data_out <= slv_reg103;
	        7'h68   : reg_data_out <= slv_reg104;
	        7'h69   : reg_data_out <= slv_reg105;
	        7'h6a   : reg_data_out <= slv_reg106;
	        7'h6b   : reg_data_out <= slv_reg107;
	        7'h6c   : reg_data_out <= slv_reg108;
	        7'h6d   : reg_data_out <= slv_reg109;
	        7'h6e   : reg_data_out <= slv_reg110;
	        7'h6f   : reg_data_out <= slv_reg111;
	        7'h70   : reg_data_out <= slv_reg112;
	        7'h71   : reg_data_out <= slv_reg113;
	        7'h72   : reg_data_out <= slv_reg114;
	        7'h73   : reg_data_out <= slv_reg115;
	        7'h74   : reg_data_out <= slv_reg116;
	        7'h75   : reg_data_out <= slv_reg117;
	        7'h76   : reg_data_out <= slv_reg118;
	        7'h77   : reg_data_out <= slv_reg119;
	        7'h78   : reg_data_out <= slv_reg120;
	        7'h79   : reg_data_out <= slv_reg121;
	        7'h7a   : reg_data_out <= slv_reg122;
	        7'h7b   : reg_data_out <= slv_reg123;
	        7'h7c   : reg_data_out <= slv_reg124;
	        7'h7d   : reg_data_out <= slv_reg125;
	        7'h7e   : reg_data_out <= slv_reg126;
	        7'h7f   : reg_data_out <= slv_reg127;

	        default : reg_data_out <= 0;
	      endcase
	end

	// Output register or memory read data
	always @( posedge S_AXI_ACLK )
	begin
	  if ( S_AXI_ARESETN == 1'b0 )
	    begin
	      axi_rdata  <= 0;
	    end 
	  else
	    begin    
	      // When there is a valid read address (S_AXI_ARVALID) with 
	      // acceptance of read address by the slave (axi_arready), 
	      // output the read dada 
	      if (slv_reg_rden)
	        begin
	          axi_rdata <= reg_data_out;     // register read data
	        end   
	    end
	end    

	// Add user logic here

	// signals for writing to AXI bus
	tri [15:0] softGlueBus;
    reg [15:0] softGlueBusReg;

	//localparam integer NUMREG = 512;
	localparam integer NUMREG = 400;

	wire [7:0] s [0:NUMREG-1];
	wire [7:0] s_RB [0:NUMREG-1];
	reg [7:0] r_RB [0:NUMREG-1];
	integer i, j;
    always @(posedge SOFTGLUE_REG_CLOCK)
    begin
        softGlueBusReg <= softGlueBus;
		for (i=0; i<NUMREG; i=i+1)
		begin
			r_RB[i] <= s_RB[i];
		end
	end

	// unpack 4-byte slave registers into 1-byte registers
	assign
		s[0] = slv_reg0[7:0],
		s[1] = slv_reg0[15:8],	
		s[2] = slv_reg0[23:16],
		s[3] = slv_reg0[31:24],

		s[4] = slv_reg1[7:0],
		s[5] = slv_reg1[15:8],	
		s[6] = slv_reg1[23:16],
		s[7] = slv_reg1[31:24],

		s[8] = slv_reg2[7:0],
		s[9] = slv_reg2[15:8],	
		s[10] = slv_reg2[23:16],
		s[11] = slv_reg2[31:24],

		s[12] = slv_reg3[7:0],
		s[13] = slv_reg3[15:8],	
		s[14] = slv_reg3[23:16],
		s[15] = slv_reg3[31:24],

		s[16] = slv_reg4[7:0],
		s[17] = slv_reg4[15:8],	
		s[18] = slv_reg4[23:16],
		s[19] = slv_reg4[31:24],

		s[20] = slv_reg5[7:0],
		s[21] = slv_reg5[15:8],	
		s[22] = slv_reg5[23:16],
		s[23] = slv_reg5[31:24],

		s[24] = slv_reg6[7:0],
		s[25] = slv_reg6[15:8],	
		s[26] = slv_reg6[23:16],
		s[27] = slv_reg6[31:24],

		s[28] = slv_reg7[7:0],
		s[29] = slv_reg7[15:8],	
		s[30] = slv_reg7[23:16],
		s[31] = slv_reg7[31:24],

		s[32] = slv_reg8[7:0],
		s[33] = slv_reg8[15:8],	
		s[34] = slv_reg8[23:16],
		s[35] = slv_reg8[31:24],

		s[36] = slv_reg9[7:0],
		s[37] = slv_reg9[15:8],	
		s[38] = slv_reg9[23:16],
		s[39] = slv_reg9[31:24],

		s[40] = slv_reg10[7:0],
		s[41] = slv_reg10[15:8],	
		s[42] = slv_reg10[23:16],
		s[43] = slv_reg10[31:24],

		s[44] = slv_reg11[7:0],
		s[45] = slv_reg11[15:8],	
		s[46] = slv_reg11[23:16],
		s[47] = slv_reg11[31:24],

		s[48] = slv_reg12[7:0],
		s[49] = slv_reg12[15:8],	
		s[50] = slv_reg12[23:16],
		s[51] = slv_reg12[31:24],

		s[52] = slv_reg13[7:0],
		s[53] = slv_reg13[15:8],	
		s[54] = slv_reg13[23:16],
		s[55] = slv_reg13[31:24],

		s[56] = slv_reg14[7:0],
		s[57] = slv_reg14[15:8],	
		s[58] = slv_reg14[23:16],
		s[59] = slv_reg14[31:24],

		s[60] = slv_reg15[7:0],
		s[61] = slv_reg15[15:8],  
		s[62] = slv_reg15[23:16],
		s[63] = slv_reg15[31:24],

		s[64] = slv_reg16[7:0],
		s[65] = slv_reg16[15:8],  
		s[66] = slv_reg16[23:16],
		s[67] = slv_reg16[31:24],

		s[68] = slv_reg17[7:0],
		s[69] = slv_reg17[15:8],  
		s[70] = slv_reg17[23:16],
		s[71] = slv_reg17[31:24],

		s[72] = slv_reg18[7:0],
		s[73] = slv_reg18[15:8],  
		s[74] = slv_reg18[23:16],
		s[75] = slv_reg18[31:24],

		s[76] = slv_reg19[7:0],
		s[77] = slv_reg19[15:8],  
		s[78] = slv_reg19[23:16],
		s[79] = slv_reg19[31:24],

		s[80] = slv_reg20[7:0],
		s[81] = slv_reg20[15:8],  
		s[82] = slv_reg20[23:16],
		s[83] = slv_reg20[31:24],

		s[84] = slv_reg21[7:0],
		s[85] = slv_reg21[15:8],  
		s[86] = slv_reg21[23:16],
		s[87] = slv_reg21[31:24],

		s[88] = slv_reg22[7:0],
		s[89] = slv_reg22[15:8],  
		s[90] = slv_reg22[23:16],
		s[91] = slv_reg22[31:24],

		s[92] = slv_reg23[7:0],
		s[93] = slv_reg23[15:8],  
		s[94] = slv_reg23[23:16],
		s[95] = slv_reg23[31:24],

		s[96] = slv_reg24[7:0],
		s[97] = slv_reg24[15:8],  
		s[98] = slv_reg24[23:16],
		s[99] = slv_reg24[31:24],

		s[100] = slv_reg25[7:0],
		s[101] = slv_reg25[15:8],	
		s[102] = slv_reg25[23:16],
		s[103] = slv_reg25[31:24],

		s[104] = slv_reg26[7:0],
		s[105] = slv_reg26[15:8],	
		s[106] = slv_reg26[23:16],
		s[107] = slv_reg26[31:24],

		s[108] = slv_reg27[7:0],
		s[109] = slv_reg27[15:8],	
		s[110] = slv_reg27[23:16],
		s[111] = slv_reg27[31:24],

		s[112] = slv_reg28[7:0],
		s[113] = slv_reg28[15:8],	
		s[114] = slv_reg28[23:16],
		s[115] = slv_reg28[31:24],

		s[116] = slv_reg29[7:0],
		s[117] = slv_reg29[15:8],	
		s[118] = slv_reg29[23:16],
		s[119] = slv_reg29[31:24],

		s[120] = slv_reg30[7:0],
		s[121] = slv_reg30[15:8],	
		s[122] = slv_reg30[23:16],
		s[123] = slv_reg30[31:24],

		s[124] = slv_reg31[7:0],
		s[125] = slv_reg31[15:8],	
		s[126] = slv_reg31[23:16],
		s[127] = slv_reg31[31:24],

		s[128] = slv_reg32[7:0],
		s[129] = slv_reg32[15:8],	
		s[130] = slv_reg32[23:16],
		s[131] = slv_reg32[31:24],	

		s[132] = slv_reg33[7:0],
		s[133] = slv_reg33[15:8],
		s[134] = slv_reg33[23:16],
		s[135] = slv_reg33[31:24],

		s[136] = slv_reg34[7:0],
		s[137] = slv_reg34[15:8],
		s[138] = slv_reg34[23:16],
		s[139] = slv_reg34[31:24],

		s[140] = slv_reg35[7:0],
		s[141] = slv_reg35[15:8],
		s[142] = slv_reg35[23:16],
		s[143] = slv_reg35[31:24],

		s[144] = slv_reg36[7:0],
		s[145] = slv_reg36[15:8],
		s[146] = slv_reg36[23:16],
		s[147] = slv_reg36[31:24],

		s[148] = slv_reg37[7:0],
		s[149] = slv_reg37[15:8],
		s[150] = slv_reg37[23:16],
		s[151] = slv_reg37[31:24],

		s[152] = slv_reg38[7:0],
		s[153] = slv_reg38[15:8],
		s[154] = slv_reg38[23:16],
		s[155] = slv_reg38[31:24],

		s[156] = slv_reg39[7:0],
		s[157] = slv_reg39[15:8],
		s[158] = slv_reg39[23:16],
		s[159] = slv_reg39[31:24],
		
		s[160] = slv_reg40[7:0],
		s[161] = slv_reg40[15:8],
		s[162] = slv_reg40[23:16],
		s[163] = slv_reg40[31:24],

		s[164] = slv_reg41[7:0],
		s[165] = slv_reg41[15:8],
		s[166] = slv_reg41[23:16],
		s[167] = slv_reg41[31:24],

		s[168] = slv_reg42[7:0],
		s[169] = slv_reg42[15:8],
		s[170] = slv_reg42[23:16],
		s[171] = slv_reg42[31:24],

		s[172] = slv_reg43[7:0],
		s[173] = slv_reg43[15:8],
		s[174] = slv_reg43[23:16],
		s[175] = slv_reg43[31:24],

		s[176] = slv_reg44[7:0],
		s[177] = slv_reg44[15:8],
		s[178] = slv_reg44[23:16],
		s[179] = slv_reg44[31:24],

		s[180] = slv_reg45[7:0],
		s[181] = slv_reg45[15:8],
		s[182] = slv_reg45[23:16],
		s[183] = slv_reg45[31:24],

		s[184] = slv_reg46[7:0],
		s[185] = slv_reg46[15:8],
		s[186] = slv_reg46[23:16],
		s[187] = slv_reg46[31:24],

		s[188] = slv_reg47[7:0],
		s[189] = slv_reg47[15:8],
		s[190] = slv_reg47[23:16],
		s[191] = slv_reg47[31:24],

		s[192] = slv_reg48[7:0],
		s[193] = slv_reg48[15:8],
		s[194] = slv_reg48[23:16],
		s[195] = slv_reg48[31:24],

		s[196] = slv_reg49[7:0],
		s[197] = slv_reg49[15:8],
		s[198] = slv_reg49[23:16],
		s[199] = slv_reg49[31:24],

		s[200] = slv_reg50[7:0],
		s[201] = slv_reg50[15:8],
		s[202] = slv_reg50[23:16],
		s[203] = slv_reg50[31:24],

		s[204] = slv_reg51[7:0],
		s[205] = slv_reg51[15:8],
		s[206] = slv_reg51[23:16],
		s[207] = slv_reg51[31:24],

		s[208] = slv_reg52[7:0],
		s[209] = slv_reg52[15:8],
		s[210] = slv_reg52[23:16],
		s[211] = slv_reg52[31:24],

		s[212] = slv_reg53[7:0],
		s[213] = slv_reg53[15:8],
		s[214] = slv_reg53[23:16],
		s[215] = slv_reg53[31:24],

		s[216] = slv_reg54[7:0],
		s[217] = slv_reg54[15:8],
		s[218] = slv_reg54[23:16],
		s[219] = slv_reg54[31:24],

		s[220] = slv_reg55[7:0],
		s[221] = slv_reg55[15:8],
		s[222] = slv_reg55[23:16],
		s[223] = slv_reg55[31:24],

		s[224] = slv_reg56[7:0],
		s[225] = slv_reg56[15:8],
		s[226] = slv_reg56[23:16],
		s[227] = slv_reg56[31:24],

		s[228] = slv_reg57[7:0],
		s[229] = slv_reg57[15:8],
		s[230] = slv_reg57[23:16],
		s[231] = slv_reg57[31:24],

		s[232] = slv_reg58[7:0],
		s[233] = slv_reg58[15:8],
		s[234] = slv_reg58[23:16],
		s[235] = slv_reg58[31:24],

		s[236] = slv_reg59[7:0],
		s[237] = slv_reg59[15:8],
		s[238] = slv_reg59[23:16],
		s[239] = slv_reg59[31:24],

		s[240] = slv_reg60[7:0],
		s[241] = slv_reg60[15:8],
		s[242] = slv_reg60[23:16],
		s[243] = slv_reg60[31:24],

		s[244] = slv_reg61[7:0],
		s[245] = slv_reg61[15:8],
		s[246] = slv_reg61[23:16],
		s[247] = slv_reg61[31:24],

		s[248] = slv_reg62[7:0],
		s[249] = slv_reg62[15:8],
		s[250] = slv_reg62[23:16],
		s[251] = slv_reg62[31:24],

		s[252] = slv_reg63[7:0],
		s[253] = slv_reg63[15:8],
		s[254] = slv_reg63[23:16],
		s[255] = slv_reg63[31:24],

		s[256] = slv_reg64[7:0],
		s[257] = slv_reg64[15:8],
		s[258] = slv_reg64[23:16],
		s[259] = slv_reg64[31:24],

		s[260] = slv_reg65[7:0],
		s[261] = slv_reg65[15:8],
		s[262] = slv_reg65[23:16],
		s[263] = slv_reg65[31:24],

		s[264] = slv_reg66[7:0],
		s[265] = slv_reg66[15:8],
		s[266] = slv_reg66[23:16],
		s[267] = slv_reg66[31:24],

		s[268] = slv_reg67[7:0],
		s[269] = slv_reg67[15:8],
		s[270] = slv_reg67[23:16],
		s[271] = slv_reg67[31:24],

		s[272] = slv_reg68[7:0],
		s[273] = slv_reg68[15:8],
		s[274] = slv_reg68[23:16],
		s[275] = slv_reg68[31:24],

		s[276] = slv_reg69[7:0],
		s[277] = slv_reg69[15:8],
		s[278] = slv_reg69[23:16],
		s[279] = slv_reg69[31:24],

		s[280] = slv_reg70[7:0],
		s[281] = slv_reg70[15:8],
		s[282] = slv_reg70[23:16],
		s[283] = slv_reg70[31:24],

		s[284] = slv_reg71[7:0],
		s[285] = slv_reg71[15:8],
		s[286] = slv_reg71[23:16],
		s[287] = slv_reg71[31:24],

		s[288] = slv_reg72[7:0],
		s[289] = slv_reg72[15:8],
		s[290] = slv_reg72[23:16],
		s[291] = slv_reg72[31:24],

		s[292] = slv_reg73[7:0],
		s[293] = slv_reg73[15:8],
		s[294] = slv_reg73[23:16],
		s[295] = slv_reg73[31:24],

		s[296] = slv_reg74[7:0],
		s[297] = slv_reg74[15:8],
		s[298] = slv_reg74[23:16],
		s[299] = slv_reg74[31:24];

		//s[300] = slv_reg75[7:0],
		//s[301] = slv_reg75[15:8],
		//s[302] = slv_reg75[23:16],
		//s[303] = slv_reg75[31:24],

		//s[304] = slv_reg76[7:0],
		//s[305] = slv_reg76[15:8],
		//s[306] = slv_reg76[23:16],
		//s[307] = slv_reg76[31:24],

		//s[308] = slv_reg77[7:0],
		//s[309] = slv_reg77[15:8],
		//s[310] = slv_reg77[23:16],
		//s[311] = slv_reg77[31:24],

		//s[312] = slv_reg78[7:0],
		//s[313] = slv_reg78[15:8],
		//s[314] = slv_reg78[23:16],
		//s[315] = slv_reg78[31:24],

		//s[316] = slv_reg79[7:0],
		//s[317] = slv_reg79[15:8],
		//s[318] = slv_reg79[23:16],
		//s[319] = slv_reg79[31:24],

		//s[320] = slv_reg80[7:0],
		//s[321] = slv_reg80[15:8],
		//s[322] = slv_reg80[23:16],
		//s[323] = slv_reg80[31:24],

		//s[324] = slv_reg81[7:0],
		//s[325] = slv_reg81[15:8],
		//s[326] = slv_reg81[23:16],
		//s[327] = slv_reg81[31:24],

		//s[328] = slv_reg82[7:0],
		//s[329] = slv_reg82[15:8],
		//s[330] = slv_reg82[23:16],
		//s[331] = slv_reg82[31:24],

		//s[332] = slv_reg83[7:0],
		//s[333] = slv_reg83[15:8],
		//s[334] = slv_reg83[23:16],
		//s[335] = slv_reg83[31:24],

		//s[336] = slv_reg84[7:0],
		//s[337] = slv_reg84[15:8],
		//s[338] = slv_reg84[23:16],
		//s[339] = slv_reg84[31:24],

		//s[340] = slv_reg85[7:0],
		//s[341] = slv_reg85[15:8],
		//s[342] = slv_reg85[23:16],
		//s[343] = slv_reg85[31:24],

		//s[344] = slv_reg86[7:0],
		//s[345] = slv_reg86[15:8],
		//s[346] = slv_reg86[23:16],
		//s[347] = slv_reg86[31:24],

		//s[348] = slv_reg87[7:0],
		//s[349] = slv_reg87[15:8],
		//s[350] = slv_reg87[23:16],
		//s[351] = slv_reg87[31:24],

		//s[352] = slv_reg88[7:0],
		//s[353] = slv_reg88[15:8],
		//s[354] = slv_reg88[23:16],
		//s[355] = slv_reg88[31:24],

		//s[356] = slv_reg89[7:0],
		//s[357] = slv_reg89[15:8],
		//s[358] = slv_reg89[23:16],
		//s[359] = slv_reg89[31:24],

		//s[360] = slv_reg90[7:0],
		//s[361] = slv_reg90[15:8],
		//s[362] = slv_reg90[23:16],
		//s[363] = slv_reg90[31:24],

		//s[364] = slv_reg91[7:0],
		//s[365] = slv_reg91[15:8],
		//s[366] = slv_reg91[23:16],
		//s[367] = slv_reg91[31:24],

		//s[368] = slv_reg92[7:0],
		//s[369] = slv_reg92[15:8],
		//s[370] = slv_reg92[23:16],
		//s[371] = slv_reg92[31:24],

		//s[372] = slv_reg93[7:0],
		//s[373] = slv_reg93[15:8],
		//s[374] = slv_reg93[23:16],
		//s[375] = slv_reg93[31:24],

		//s[376] = slv_reg94[7:0],
		//s[377] = slv_reg94[15:8],
		//s[378] = slv_reg94[23:16],
		//s[379] = slv_reg94[31:24],

		//s[380] = slv_reg95[7:0],
		//s[381] = slv_reg95[15:8],
		//s[382] = slv_reg95[23:16],
		//s[383] = slv_reg95[31:24],

		//s[384] = slv_reg96[7:0],
		//s[385] = slv_reg96[15:8],
		//s[386] = slv_reg96[23:16],
		//s[387] = slv_reg96[31:24],

		//s[388] = slv_reg97[7:0],
		//s[389] = slv_reg97[15:8],
		//s[390] = slv_reg97[23:16],
		//s[391] = slv_reg97[31:24],

		//s[392] = slv_reg98[7:0],
		//s[393] = slv_reg98[15:8],
		//s[394] = slv_reg98[23:16],
		//s[395] = slv_reg98[31:24],

		//s[396] = slv_reg99[7:0],
		//s[397] = slv_reg99[15:8],
		//s[398] = slv_reg99[23:16],
		//s[399] = slv_reg99[31:24];

		//s[400] = slv_reg100[7:0],
		//s[401] = slv_reg100[15:8],
		//s[402] = slv_reg100[23:16],
		//s[403] = slv_reg100[31:24],

		//s[404] = slv_reg101[7:0],
		//s[405] = slv_reg101[15:8],
		//s[406] = slv_reg101[23:16],
		//s[407] = slv_reg101[31:24],

		//s[408] = slv_reg102[7:0],
		//s[409] = slv_reg102[15:8],
		//s[410] = slv_reg102[23:16],
		//s[411] = slv_reg102[31:24],

		//s[412] = slv_reg103[7:0],
		//s[413] = slv_reg103[15:8],
		//s[414] = slv_reg103[23:16],
		//s[415] = slv_reg103[31:24],

		//s[416] = slv_reg104[7:0],
		//s[417] = slv_reg104[15:8],
		//s[418] = slv_reg104[23:16],
		//s[419] = slv_reg104[31:24],

		//s[420] = slv_reg105[7:0],
		//s[421] = slv_reg105[15:8],
		//s[422] = slv_reg105[23:16],
		//s[423] = slv_reg105[31:24],

		//s[424] = slv_reg106[7:0],
		//s[425] = slv_reg106[15:8],
		//s[426] = slv_reg106[23:16],
		//s[427] = slv_reg106[31:24],

		//s[428] = slv_reg107[7:0],
		//s[429] = slv_reg107[15:8],
		//s[430] = slv_reg107[23:16],
		//s[431] = slv_reg107[31:24],

		//s[432] = slv_reg108[7:0],
		//s[433] = slv_reg108[15:8],
		//s[434] = slv_reg108[23:16],
		//s[435] = slv_reg108[31:24],

		//s[436] = slv_reg109[7:0],
		//s[437] = slv_reg109[15:8],
		//s[438] = slv_reg109[23:16],
		//s[439] = slv_reg109[31:24],

		//s[440] = slv_reg110[7:0],
		//s[441] = slv_reg110[15:8],
		//s[442] = slv_reg110[23:16],
		//s[443] = slv_reg110[31:24],

		//s[444] = slv_reg111[7:0],
		//s[445] = slv_reg111[15:8],
		//s[446] = slv_reg111[23:16],
		//s[447] = slv_reg111[31:24],

		//s[448] = slv_reg112[7:0],
		//s[449] = slv_reg112[15:8],
		//s[450] = slv_reg112[23:16],
		//s[451] = slv_reg112[31:24],

		//s[452] = slv_reg113[7:0],
		//s[453] = slv_reg113[15:8],
		//s[454] = slv_reg113[23:16],
		//s[455] = slv_reg113[31:24],

		//s[456] = slv_reg114[7:0],
		//s[457] = slv_reg114[15:8],
		//s[458] = slv_reg114[23:16],
		//s[459] = slv_reg114[31:24],

		//s[460] = slv_reg115[7:0],
		//s[461] = slv_reg115[15:8],
		//s[462] = slv_reg115[23:16],
		//s[463] = slv_reg115[31:24],

		//s[464] = slv_reg116[7:0],
		//s[465] = slv_reg116[15:8],
		//s[466] = slv_reg116[23:16],
		//s[467] = slv_reg116[31:24],

		//s[468] = slv_reg117[7:0],
		//s[469] = slv_reg117[15:8],
		//s[470] = slv_reg117[23:16],
		//s[471] = slv_reg117[31:24],

		//s[472] = slv_reg118[7:0],
		//s[473] = slv_reg118[15:8],
		//s[474] = slv_reg118[23:16],
		//s[475] = slv_reg118[31:24],

		//s[476] = slv_reg119[7:0],
		//s[477] = slv_reg119[15:8],
		//s[478] = slv_reg119[23:16],
		//s[479] = slv_reg119[31:24],

		//s[480] = slv_reg120[7:0],
		//s[481] = slv_reg120[15:8],
		//s[482] = slv_reg120[23:16],
		//s[483] = slv_reg120[31:24],

		//s[484] = slv_reg121[7:0],
		//s[485] = slv_reg121[15:8],
		//s[486] = slv_reg121[23:16],
		//s[487] = slv_reg121[31:24],

		//s[488] = slv_reg122[7:0],
		//s[489] = slv_reg122[15:8],
		//s[490] = slv_reg122[23:16],
		//s[491] = slv_reg122[31:24],

		//s[492] = slv_reg123[7:0],
		//s[493] = slv_reg123[15:8],
		//s[494] = slv_reg123[23:16],
		//s[495] = slv_reg123[31:24],

		//s[496] = slv_reg124[7:0],
		//s[497] = slv_reg124[15:8],
		//s[498] = slv_reg124[23:16],
		//s[499] = slv_reg124[31:24],

		//s[500] = slv_reg125[7:0],
		//s[501] = slv_reg125[15:8],
		//s[502] = slv_reg125[23:16],
		//s[503] = slv_reg125[31:24],

		//s[504] = slv_reg126[7:0],
		//s[505] = slv_reg126[15:8],
		//s[506] = slv_reg126[23:16],
		//s[507] = slv_reg126[31:24],

		//s[508] = slv_reg127[7:0],
		//s[509] = slv_reg127[15:8],
		//s[510] = slv_reg127[23:16],
		//s[511] = slv_reg127[31:24];

    // softGlue inputs ("inputs" from viewpoint of logic elements)

    softGlue_Out out0(.s(s[000]),  .s_RB(s_RB[000]), .y(SG_IN000),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out1(.s(s[001]),  .s_RB(s_RB[001]), .y(SG_IN001),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out2(.s(s[002]),  .s_RB(s_RB[002]), .y(SG_IN002),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out3(.s(s[003]),  .s_RB(s_RB[003]), .y(SG_IN003),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out4(.s(s[004]),  .s_RB(s_RB[004]), .y(SG_IN004),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out5(.s(s[005]),  .s_RB(s_RB[005]), .y(SG_IN005),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out6(.s(s[006]),  .s_RB(s_RB[006]), .y(SG_IN006),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out7(.s(s[007]),  .s_RB(s_RB[007]), .y(SG_IN007),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out8(.s(s[008]),  .s_RB(s_RB[008]), .y(SG_IN008),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out9(.s(s[009]),  .s_RB(s_RB[009]), .y(SG_IN009),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_Out out10(.s(s[010]),  .s_RB(s_RB[010]), .y(SG_IN010),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out11(.s(s[011]),  .s_RB(s_RB[011]), .y(SG_IN011),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out12(.s(s[012]),  .s_RB(s_RB[012]), .y(SG_IN012),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out13(.s(s[013]),  .s_RB(s_RB[013]), .y(SG_IN013),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out14(.s(s[014]),  .s_RB(s_RB[014]), .y(SG_IN014),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out15(.s(s[015]),  .s_RB(s_RB[015]), .y(SG_IN015),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out16(.s(s[016]),  .s_RB(s_RB[016]), .y(SG_IN016),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out17(.s(s[017]),  .s_RB(s_RB[017]), .y(SG_IN017),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out18(.s(s[018]),  .s_RB(s_RB[018]), .y(SG_IN018),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out19(.s(s[019]),  .s_RB(s_RB[019]), .y(SG_IN019),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_Out out20(.s(s[020]),  .s_RB(s_RB[020]), .y(SG_IN020),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out21(.s(s[021]),  .s_RB(s_RB[021]), .y(SG_IN021),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out22(.s(s[022]),  .s_RB(s_RB[022]), .y(SG_IN022),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out23(.s(s[023]),  .s_RB(s_RB[023]), .y(SG_IN023),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out24(.s(s[024]),  .s_RB(s_RB[024]), .y(SG_IN024),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out25(.s(s[025]),  .s_RB(s_RB[025]), .y(SG_IN025),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out26(.s(s[026]),  .s_RB(s_RB[026]), .y(SG_IN026),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out27(.s(s[027]),  .s_RB(s_RB[027]), .y(SG_IN027),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out28(.s(s[028]),  .s_RB(s_RB[028]), .y(SG_IN028),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out29(.s(s[029]),  .s_RB(s_RB[029]), .y(SG_IN029),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_Out out30(.s(s[030]),  .s_RB(s_RB[030]), .y(SG_IN030),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out31(.s(s[031]),  .s_RB(s_RB[031]), .y(SG_IN031),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out32(.s(s[032]),  .s_RB(s_RB[032]), .y(SG_IN032),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out33(.s(s[033]),  .s_RB(s_RB[033]), .y(SG_IN033),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out34(.s(s[034]),  .s_RB(s_RB[034]), .y(SG_IN034),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out35(.s(s[035]),  .s_RB(s_RB[035]), .y(SG_IN035),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out36(.s(s[036]),  .s_RB(s_RB[036]), .y(SG_IN036),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out37(.s(s[037]),  .s_RB(s_RB[037]), .y(SG_IN037),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out38(.s(s[038]),  .s_RB(s_RB[038]), .y(SG_IN038),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out39(.s(s[039]),  .s_RB(s_RB[039]), .y(SG_IN039),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_Out out40(.s(s[040]),  .s_RB(s_RB[040]), .y(SG_IN040),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out41(.s(s[041]),  .s_RB(s_RB[041]), .y(SG_IN041),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out42(.s(s[042]),  .s_RB(s_RB[042]), .y(SG_IN042),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out43(.s(s[043]),  .s_RB(s_RB[043]), .y(SG_IN043),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out44(.s(s[044]),  .s_RB(s_RB[044]), .y(SG_IN044),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out45(.s(s[045]),  .s_RB(s_RB[045]), .y(SG_IN045),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out46(.s(s[046]),  .s_RB(s_RB[046]), .y(SG_IN046),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out47(.s(s[047]),  .s_RB(s_RB[047]), .y(SG_IN047),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out48(.s(s[048]),  .s_RB(s_RB[048]), .y(SG_IN048),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out49(.s(s[049]),  .s_RB(s_RB[049]), .y(SG_IN049),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_Out out50(.s(s[050]),  .s_RB(s_RB[050]), .y(SG_IN050),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out51(.s(s[051]),  .s_RB(s_RB[051]), .y(SG_IN051),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out52(.s(s[052]),  .s_RB(s_RB[052]), .y(SG_IN052),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out53(.s(s[053]),  .s_RB(s_RB[053]), .y(SG_IN053),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out54(.s(s[054]),  .s_RB(s_RB[054]), .y(SG_IN054),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out55(.s(s[055]),  .s_RB(s_RB[055]), .y(SG_IN055),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out56(.s(s[056]),  .s_RB(s_RB[056]), .y(SG_IN056),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out57(.s(s[057]),  .s_RB(s_RB[057]), .y(SG_IN057),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out58(.s(s[058]),  .s_RB(s_RB[058]), .y(SG_IN058),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out59(.s(s[059]),  .s_RB(s_RB[059]), .y(SG_IN059),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_Out out60(.s(s[060]),  .s_RB(s_RB[060]), .y(SG_IN060),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out61(.s(s[061]),  .s_RB(s_RB[061]), .y(SG_IN061),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out62(.s(s[062]),  .s_RB(s_RB[062]), .y(SG_IN062),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out63(.s(s[063]),  .s_RB(s_RB[063]), .y(SG_IN063),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out64(.s(s[064]),  .s_RB(s_RB[064]), .y(SG_IN064),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out65(.s(s[065]),  .s_RB(s_RB[065]), .y(SG_IN065),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out66(.s(s[066]),  .s_RB(s_RB[066]), .y(SG_IN066),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out67(.s(s[067]),  .s_RB(s_RB[067]), .y(SG_IN067),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out68(.s(s[068]),  .s_RB(s_RB[068]), .y(SG_IN068),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out69(.s(s[069]),  .s_RB(s_RB[069]), .y(SG_IN069),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_Out out70(.s(s[070]),  .s_RB(s_RB[070]), .y(SG_IN070),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out71(.s(s[071]),  .s_RB(s_RB[071]), .y(SG_IN071),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out72(.s(s[072]),  .s_RB(s_RB[072]), .y(SG_IN072),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out73(.s(s[073]),  .s_RB(s_RB[073]), .y(SG_IN073),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out74(.s(s[074]),  .s_RB(s_RB[074]), .y(SG_IN074),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out75(.s(s[075]),  .s_RB(s_RB[075]), .y(SG_IN075),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out76(.s(s[076]),  .s_RB(s_RB[076]), .y(SG_IN076),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out77(.s(s[077]),  .s_RB(s_RB[077]), .y(SG_IN077),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out78(.s(s[078]),  .s_RB(s_RB[078]), .y(SG_IN078),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out79(.s(s[079]),  .s_RB(s_RB[079]), .y(SG_IN079),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_Out out80(.s(s[080]),  .s_RB(s_RB[080]), .y(SG_IN080),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out81(.s(s[081]),  .s_RB(s_RB[081]), .y(SG_IN081),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out82(.s(s[082]),  .s_RB(s_RB[082]), .y(SG_IN082),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out83(.s(s[083]),  .s_RB(s_RB[083]), .y(SG_IN083),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out84(.s(s[084]),  .s_RB(s_RB[084]), .y(SG_IN084),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out85(.s(s[085]),  .s_RB(s_RB[085]), .y(SG_IN085),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out86(.s(s[086]),  .s_RB(s_RB[086]), .y(SG_IN086),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out87(.s(s[087]),  .s_RB(s_RB[087]), .y(SG_IN087),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out88(.s(s[088]),  .s_RB(s_RB[088]), .y(SG_IN088),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out89(.s(s[089]),  .s_RB(s_RB[089]), .y(SG_IN089),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_Out out90(.s(s[090]),  .s_RB(s_RB[090]), .y(SG_IN090),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out91(.s(s[091]),  .s_RB(s_RB[091]), .y(SG_IN091),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out92(.s(s[092]),  .s_RB(s_RB[092]), .y(SG_IN092),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out93(.s(s[093]),  .s_RB(s_RB[093]), .y(SG_IN093),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out94(.s(s[094]),  .s_RB(s_RB[094]), .y(SG_IN094),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out95(.s(s[095]),  .s_RB(s_RB[095]), .y(SG_IN095),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out96(.s(s[096]),  .s_RB(s_RB[096]), .y(SG_IN096),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out97(.s(s[097]),  .s_RB(s_RB[097]), .y(SG_IN097),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out98(.s(s[098]),  .s_RB(s_RB[098]), .y(SG_IN098),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_Out out99(.s(s[099]),  .s_RB(s_RB[099]), .y(SG_IN099),  .d(softGlueBus), .regClock(SOFTGLUE_REG_CLOCK));

	// outputs (softGlue inputs)

    softGlue_In in100(.s(s[100]),   .s_RB(s_RB[100]),  .d(softGlueBus), .y(SG_OUT100),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in101(.s(s[101]),   .s_RB(s_RB[101]),  .d(softGlueBus), .y(SG_OUT101),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in102(.s(s[102]),   .s_RB(s_RB[102]),  .d(softGlueBus), .y(SG_OUT102),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in103(.s(s[103]),   .s_RB(s_RB[103]),  .d(softGlueBus), .y(SG_OUT103),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in104(.s(s[104]),   .s_RB(s_RB[104]),  .d(softGlueBus), .y(SG_OUT104),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in105(.s(s[105]),   .s_RB(s_RB[105]),  .d(softGlueBus), .y(SG_OUT105),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in106(.s(s[106]),   .s_RB(s_RB[106]),  .d(softGlueBus), .y(SG_OUT106),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in107(.s(s[107]),   .s_RB(s_RB[107]),  .d(softGlueBus), .y(SG_OUT107),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in108(.s(s[108]),   .s_RB(s_RB[108]),  .d(softGlueBus), .y(SG_OUT108),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in109(.s(s[109]),   .s_RB(s_RB[109]),  .d(softGlueBus), .y(SG_OUT109),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in110(.s(s[110]),   .s_RB(s_RB[110]),  .d(softGlueBus), .y(SG_OUT110),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in111(.s(s[111]),   .s_RB(s_RB[111]),  .d(softGlueBus), .y(SG_OUT111),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in112(.s(s[112]),   .s_RB(s_RB[112]),  .d(softGlueBus), .y(SG_OUT112),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in113(.s(s[113]),   .s_RB(s_RB[113]),  .d(softGlueBus), .y(SG_OUT113),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in114(.s(s[114]),   .s_RB(s_RB[114]),  .d(softGlueBus), .y(SG_OUT114),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in115(.s(s[115]),   .s_RB(s_RB[115]),  .d(softGlueBus), .y(SG_OUT115),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in116(.s(s[116]),   .s_RB(s_RB[116]),  .d(softGlueBus), .y(SG_OUT116),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in117(.s(s[117]),   .s_RB(s_RB[117]),  .d(softGlueBus), .y(SG_OUT117),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in118(.s(s[118]),   .s_RB(s_RB[118]),  .d(softGlueBus), .y(SG_OUT118),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in119(.s(s[119]),   .s_RB(s_RB[119]),  .d(softGlueBus), .y(SG_OUT119),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in120(.s(s[120]),   .s_RB(s_RB[120]),  .d(softGlueBus), .y(SG_OUT120),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in121(.s(s[121]),   .s_RB(s_RB[121]),  .d(softGlueBus), .y(SG_OUT121),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in122(.s(s[122]),   .s_RB(s_RB[122]),  .d(softGlueBus), .y(SG_OUT122),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in123(.s(s[123]),   .s_RB(s_RB[123]),  .d(softGlueBus), .y(SG_OUT123),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in124(.s(s[124]),   .s_RB(s_RB[124]),  .d(softGlueBus), .y(SG_OUT124),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in125(.s(s[125]),   .s_RB(s_RB[125]),  .d(softGlueBus), .y(SG_OUT125),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in126(.s(s[126]),   .s_RB(s_RB[126]),  .d(softGlueBus), .y(SG_OUT126),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in127(.s(s[127]),   .s_RB(s_RB[127]),  .d(softGlueBus), .y(SG_OUT127),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in128(.s(s[128]),   .s_RB(s_RB[128]),  .d(softGlueBus), .y(SG_OUT128),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in129(.s(s[129]),   .s_RB(s_RB[129]),  .d(softGlueBus), .y(SG_OUT129),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in130(.s(s[130]),   .s_RB(s_RB[130]),  .d(softGlueBus), .y(SG_OUT130),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in131(.s(s[131]),   .s_RB(s_RB[131]),  .d(softGlueBus), .y(SG_OUT131),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in132(.s(s[132]),   .s_RB(s_RB[132]),  .d(softGlueBus), .y(SG_OUT132),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in133(.s(s[133]),   .s_RB(s_RB[133]),  .d(softGlueBus), .y(SG_OUT133),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in134(.s(s[134]),   .s_RB(s_RB[134]),  .d(softGlueBus), .y(SG_OUT134),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in135(.s(s[135]),   .s_RB(s_RB[135]),  .d(softGlueBus), .y(SG_OUT135),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in136(.s(s[136]),   .s_RB(s_RB[136]),  .d(softGlueBus), .y(SG_OUT136),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in137(.s(s[137]),   .s_RB(s_RB[137]),  .d(softGlueBus), .y(SG_OUT137),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in138(.s(s[138]),   .s_RB(s_RB[138]),  .d(softGlueBus), .y(SG_OUT138),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in139(.s(s[139]),   .s_RB(s_RB[139]),  .d(softGlueBus), .y(SG_OUT139),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in140(.s(s[140]),   .s_RB(s_RB[140]),  .d(softGlueBus), .y(SG_OUT140),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in141(.s(s[141]),   .s_RB(s_RB[141]),  .d(softGlueBus), .y(SG_OUT141),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in142(.s(s[142]),   .s_RB(s_RB[142]),  .d(softGlueBus), .y(SG_OUT142),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in143(.s(s[143]),   .s_RB(s_RB[143]),  .d(softGlueBus), .y(SG_OUT143),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in144(.s(s[144]),   .s_RB(s_RB[144]),  .d(softGlueBus), .y(SG_OUT144),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in145(.s(s[145]),   .s_RB(s_RB[145]),  .d(softGlueBus), .y(SG_OUT145),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in146(.s(s[146]),   .s_RB(s_RB[146]),  .d(softGlueBus), .y(SG_OUT146),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in147(.s(s[147]),   .s_RB(s_RB[147]),  .d(softGlueBus), .y(SG_OUT147),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in148(.s(s[148]),   .s_RB(s_RB[148]),  .d(softGlueBus), .y(SG_OUT148),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in149(.s(s[149]),   .s_RB(s_RB[149]),  .d(softGlueBus), .y(SG_OUT149),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in150(.s(s[150]),   .s_RB(s_RB[150]),  .d(softGlueBus), .y(SG_OUT150),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in151(.s(s[151]),   .s_RB(s_RB[151]),  .d(softGlueBus), .y(SG_OUT151),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in152(.s(s[152]),   .s_RB(s_RB[152]),  .d(softGlueBus), .y(SG_OUT152),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in153(.s(s[153]),   .s_RB(s_RB[153]),  .d(softGlueBus), .y(SG_OUT153),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in154(.s(s[154]),   .s_RB(s_RB[154]),  .d(softGlueBus), .y(SG_OUT154),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in155(.s(s[155]),   .s_RB(s_RB[155]),  .d(softGlueBus), .y(SG_OUT155),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in156(.s(s[156]),   .s_RB(s_RB[156]),  .d(softGlueBus), .y(SG_OUT156),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in157(.s(s[157]),   .s_RB(s_RB[157]),  .d(softGlueBus), .y(SG_OUT157),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in158(.s(s[158]),   .s_RB(s_RB[158]),  .d(softGlueBus), .y(SG_OUT158),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in159(.s(s[159]),   .s_RB(s_RB[159]),  .d(softGlueBus), .y(SG_OUT159),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in160(.s(s[160]),   .s_RB(s_RB[160]),  .d(softGlueBus), .y(SG_OUT160),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in161(.s(s[161]),   .s_RB(s_RB[161]),  .d(softGlueBus), .y(SG_OUT161),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in162(.s(s[162]),   .s_RB(s_RB[162]),  .d(softGlueBus), .y(SG_OUT162),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in163(.s(s[163]),   .s_RB(s_RB[163]),  .d(softGlueBus), .y(SG_OUT163),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in164(.s(s[164]),   .s_RB(s_RB[164]),  .d(softGlueBus), .y(SG_OUT164),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in165(.s(s[165]),   .s_RB(s_RB[165]),  .d(softGlueBus), .y(SG_OUT165),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in166(.s(s[166]),   .s_RB(s_RB[166]),  .d(softGlueBus), .y(SG_OUT166),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in167(.s(s[167]),   .s_RB(s_RB[167]),  .d(softGlueBus), .y(SG_OUT167),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in168(.s(s[168]),   .s_RB(s_RB[168]),  .d(softGlueBus), .y(SG_OUT168),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in169(.s(s[169]),   .s_RB(s_RB[169]),  .d(softGlueBus), .y(SG_OUT169),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in170(.s(s[170]),   .s_RB(s_RB[170]),  .d(softGlueBus), .y(SG_OUT170),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in171(.s(s[171]),   .s_RB(s_RB[171]),  .d(softGlueBus), .y(SG_OUT171),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in172(.s(s[172]),   .s_RB(s_RB[172]),  .d(softGlueBus), .y(SG_OUT172),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in173(.s(s[173]),   .s_RB(s_RB[173]),  .d(softGlueBus), .y(SG_OUT173),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in174(.s(s[174]),   .s_RB(s_RB[174]),  .d(softGlueBus), .y(SG_OUT174),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in175(.s(s[175]),   .s_RB(s_RB[175]),  .d(softGlueBus), .y(SG_OUT175),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in176(.s(s[176]),   .s_RB(s_RB[176]),  .d(softGlueBus), .y(SG_OUT176),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in177(.s(s[177]),   .s_RB(s_RB[177]),  .d(softGlueBus), .y(SG_OUT177),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in178(.s(s[178]),   .s_RB(s_RB[178]),  .d(softGlueBus), .y(SG_OUT178),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in179(.s(s[179]),   .s_RB(s_RB[179]),  .d(softGlueBus), .y(SG_OUT179),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in180(.s(s[180]),   .s_RB(s_RB[180]),  .d(softGlueBus), .y(SG_OUT180),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in181(.s(s[181]),   .s_RB(s_RB[181]),  .d(softGlueBus), .y(SG_OUT181),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in182(.s(s[182]),   .s_RB(s_RB[182]),  .d(softGlueBus), .y(SG_OUT182),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in183(.s(s[183]),   .s_RB(s_RB[183]),  .d(softGlueBus), .y(SG_OUT183),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in184(.s(s[184]),   .s_RB(s_RB[184]),  .d(softGlueBus), .y(SG_OUT184),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in185(.s(s[185]),   .s_RB(s_RB[185]),  .d(softGlueBus), .y(SG_OUT185),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in186(.s(s[186]),   .s_RB(s_RB[186]),  .d(softGlueBus), .y(SG_OUT186),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in187(.s(s[187]),   .s_RB(s_RB[187]),  .d(softGlueBus), .y(SG_OUT187),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in188(.s(s[188]),   .s_RB(s_RB[188]),  .d(softGlueBus), .y(SG_OUT188),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in189(.s(s[189]),   .s_RB(s_RB[189]),  .d(softGlueBus), .y(SG_OUT189),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in190(.s(s[190]),   .s_RB(s_RB[190]),  .d(softGlueBus), .y(SG_OUT190),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in191(.s(s[191]),   .s_RB(s_RB[191]),  .d(softGlueBus), .y(SG_OUT191),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in192(.s(s[192]),   .s_RB(s_RB[192]),  .d(softGlueBus), .y(SG_OUT192),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in193(.s(s[193]),   .s_RB(s_RB[193]),  .d(softGlueBus), .y(SG_OUT193),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in194(.s(s[194]),   .s_RB(s_RB[194]),  .d(softGlueBus), .y(SG_OUT194),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in195(.s(s[195]),   .s_RB(s_RB[195]),  .d(softGlueBus), .y(SG_OUT195),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in196(.s(s[196]),   .s_RB(s_RB[196]),  .d(softGlueBus), .y(SG_OUT196),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in197(.s(s[197]),   .s_RB(s_RB[197]),  .d(softGlueBus), .y(SG_OUT197),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in198(.s(s[198]),   .s_RB(s_RB[198]),  .d(softGlueBus), .y(SG_OUT198),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in199(.s(s[199]),   .s_RB(s_RB[199]),  .d(softGlueBus), .y(SG_OUT199),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in200(.s(s[200]),   .s_RB(s_RB[200]),  .d(softGlueBus), .y(SG_OUT200),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in201(.s(s[201]),   .s_RB(s_RB[201]),  .d(softGlueBus), .y(SG_OUT201),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in202(.s(s[202]),   .s_RB(s_RB[202]),  .d(softGlueBus), .y(SG_OUT202),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in203(.s(s[203]),   .s_RB(s_RB[203]),  .d(softGlueBus), .y(SG_OUT203),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in204(.s(s[204]),   .s_RB(s_RB[204]),  .d(softGlueBus), .y(SG_OUT204),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in205(.s(s[205]),   .s_RB(s_RB[205]),  .d(softGlueBus), .y(SG_OUT205),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in206(.s(s[206]),   .s_RB(s_RB[206]),  .d(softGlueBus), .y(SG_OUT206),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in207(.s(s[207]),   .s_RB(s_RB[207]),  .d(softGlueBus), .y(SG_OUT207),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in208(.s(s[208]),   .s_RB(s_RB[208]),  .d(softGlueBus), .y(SG_OUT208),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in209(.s(s[209]),   .s_RB(s_RB[209]),  .d(softGlueBus), .y(SG_OUT209),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in210(.s(s[210]),   .s_RB(s_RB[210]),  .d(softGlueBus), .y(SG_OUT210),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in211(.s(s[211]),   .s_RB(s_RB[211]),  .d(softGlueBus), .y(SG_OUT211),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in212(.s(s[212]),   .s_RB(s_RB[212]),  .d(softGlueBus), .y(SG_OUT212),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in213(.s(s[213]),   .s_RB(s_RB[213]),  .d(softGlueBus), .y(SG_OUT213),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in214(.s(s[214]),   .s_RB(s_RB[214]),  .d(softGlueBus), .y(SG_OUT214),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in215(.s(s[215]),   .s_RB(s_RB[215]),  .d(softGlueBus), .y(SG_OUT215),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in216(.s(s[216]),   .s_RB(s_RB[216]),  .d(softGlueBus), .y(SG_OUT216),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in217(.s(s[217]),   .s_RB(s_RB[217]),  .d(softGlueBus), .y(SG_OUT217),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in218(.s(s[218]),   .s_RB(s_RB[218]),  .d(softGlueBus), .y(SG_OUT218),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in219(.s(s[219]),   .s_RB(s_RB[219]),  .d(softGlueBus), .y(SG_OUT219),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in220(.s(s[220]),   .s_RB(s_RB[220]),  .d(softGlueBus), .y(SG_OUT220),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in221(.s(s[221]),   .s_RB(s_RB[221]),  .d(softGlueBus), .y(SG_OUT221),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in222(.s(s[222]),   .s_RB(s_RB[222]),  .d(softGlueBus), .y(SG_OUT222),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in223(.s(s[223]),   .s_RB(s_RB[223]),  .d(softGlueBus), .y(SG_OUT223),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in224(.s(s[224]),   .s_RB(s_RB[224]),  .d(softGlueBus), .y(SG_OUT224),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in225(.s(s[225]),   .s_RB(s_RB[225]),  .d(softGlueBus), .y(SG_OUT225),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in226(.s(s[226]),   .s_RB(s_RB[226]),  .d(softGlueBus), .y(SG_OUT226),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in227(.s(s[227]),   .s_RB(s_RB[227]),  .d(softGlueBus), .y(SG_OUT227),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in228(.s(s[228]),   .s_RB(s_RB[228]),  .d(softGlueBus), .y(SG_OUT228),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in229(.s(s[229]),   .s_RB(s_RB[229]),  .d(softGlueBus), .y(SG_OUT229),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in230(.s(s[230]),   .s_RB(s_RB[230]),  .d(softGlueBus), .y(SG_OUT230),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in231(.s(s[231]),   .s_RB(s_RB[231]),  .d(softGlueBus), .y(SG_OUT231),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in232(.s(s[232]),   .s_RB(s_RB[232]),  .d(softGlueBus), .y(SG_OUT232),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in233(.s(s[233]),   .s_RB(s_RB[233]),  .d(softGlueBus), .y(SG_OUT233),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in234(.s(s[234]),   .s_RB(s_RB[234]),  .d(softGlueBus), .y(SG_OUT234),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in235(.s(s[235]),   .s_RB(s_RB[235]),  .d(softGlueBus), .y(SG_OUT235),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in236(.s(s[236]),   .s_RB(s_RB[236]),  .d(softGlueBus), .y(SG_OUT236),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in237(.s(s[237]),   .s_RB(s_RB[237]),  .d(softGlueBus), .y(SG_OUT237),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in238(.s(s[238]),   .s_RB(s_RB[238]),  .d(softGlueBus), .y(SG_OUT238),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in239(.s(s[239]),   .s_RB(s_RB[239]),  .d(softGlueBus), .y(SG_OUT239),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in240(.s(s[240]),	.s_RB(s_RB[240]),  .d(softGlueBus), .y(SG_OUT240),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in241(.s(s[241]),	.s_RB(s_RB[241]),  .d(softGlueBus), .y(SG_OUT241),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in242(.s(s[242]),	.s_RB(s_RB[242]),  .d(softGlueBus), .y(SG_OUT242),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in243(.s(s[243]),	.s_RB(s_RB[243]),  .d(softGlueBus), .y(SG_OUT243),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in244(.s(s[244]),	.s_RB(s_RB[244]),  .d(softGlueBus), .y(SG_OUT244),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in245(.s(s[245]),	.s_RB(s_RB[245]),  .d(softGlueBus), .y(SG_OUT245),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in246(.s(s[246]),	.s_RB(s_RB[246]),  .d(softGlueBus), .y(SG_OUT246),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in247(.s(s[247]),	.s_RB(s_RB[247]),  .d(softGlueBus), .y(SG_OUT247),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in248(.s(s[248]),	.s_RB(s_RB[248]),  .d(softGlueBus), .y(SG_OUT248),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in249(.s(s[249]),	.s_RB(s_RB[249]),  .d(softGlueBus), .y(SG_OUT249),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in250(.s(s[250]),	.s_RB(s_RB[250]),  .d(softGlueBus), .y(SG_OUT250),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in251(.s(s[251]),	.s_RB(s_RB[251]),  .d(softGlueBus), .y(SG_OUT251),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in252(.s(s[252]),	.s_RB(s_RB[252]),  .d(softGlueBus), .y(SG_OUT252),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in253(.s(s[253]),	.s_RB(s_RB[253]),  .d(softGlueBus), .y(SG_OUT253),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in254(.s(s[254]),	.s_RB(s_RB[254]),  .d(softGlueBus), .y(SG_OUT254),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in255(.s(s[255]),	.s_RB(s_RB[255]),  .d(softGlueBus), .y(SG_OUT255),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in256(.s(s[256]),	.s_RB(s_RB[256]),  .d(softGlueBus), .y(SG_OUT256),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in257(.s(s[257]),	.s_RB(s_RB[257]),  .d(softGlueBus), .y(SG_OUT257),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in258(.s(s[258]),	.s_RB(s_RB[258]),  .d(softGlueBus), .y(SG_OUT258),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in259(.s(s[259]),	.s_RB(s_RB[259]),  .d(softGlueBus), .y(SG_OUT259),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in260(.s(s[260]),	.s_RB(s_RB[260]),  .d(softGlueBus), .y(SG_OUT260),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in261(.s(s[261]),	.s_RB(s_RB[261]),  .d(softGlueBus), .y(SG_OUT261),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in262(.s(s[262]),	.s_RB(s_RB[262]),  .d(softGlueBus), .y(SG_OUT262),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in263(.s(s[263]),	.s_RB(s_RB[263]),  .d(softGlueBus), .y(SG_OUT263),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in264(.s(s[264]),	.s_RB(s_RB[264]),  .d(softGlueBus), .y(SG_OUT264),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in265(.s(s[265]),	.s_RB(s_RB[265]),  .d(softGlueBus), .y(SG_OUT265),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in266(.s(s[266]),	.s_RB(s_RB[266]),  .d(softGlueBus), .y(SG_OUT266),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in267(.s(s[267]),	.s_RB(s_RB[267]),  .d(softGlueBus), .y(SG_OUT267),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in268(.s(s[268]),	.s_RB(s_RB[268]),  .d(softGlueBus), .y(SG_OUT268),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in269(.s(s[269]),	.s_RB(s_RB[269]),  .d(softGlueBus), .y(SG_OUT269),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in270(.s(s[270]),	.s_RB(s_RB[270]),  .d(softGlueBus), .y(SG_OUT270),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in271(.s(s[271]),	.s_RB(s_RB[271]),  .d(softGlueBus), .y(SG_OUT271),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in272(.s(s[272]),	.s_RB(s_RB[272]),  .d(softGlueBus), .y(SG_OUT272),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in273(.s(s[273]),	.s_RB(s_RB[273]),  .d(softGlueBus), .y(SG_OUT273),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in274(.s(s[274]),	.s_RB(s_RB[274]),  .d(softGlueBus), .y(SG_OUT274),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in275(.s(s[275]),	.s_RB(s_RB[275]),  .d(softGlueBus), .y(SG_OUT275),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in276(.s(s[276]),	.s_RB(s_RB[276]),  .d(softGlueBus), .y(SG_OUT276),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in277(.s(s[277]),	.s_RB(s_RB[277]),  .d(softGlueBus), .y(SG_OUT277),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in278(.s(s[278]),	.s_RB(s_RB[278]),  .d(softGlueBus), .y(SG_OUT278),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in279(.s(s[279]),	.s_RB(s_RB[279]),  .d(softGlueBus), .y(SG_OUT279),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in280(.s(s[280]),	.s_RB(s_RB[280]),  .d(softGlueBus), .y(SG_OUT280),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in281(.s(s[281]),	.s_RB(s_RB[281]),  .d(softGlueBus), .y(SG_OUT281),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in282(.s(s[282]),	.s_RB(s_RB[282]),  .d(softGlueBus), .y(SG_OUT282),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in283(.s(s[283]),	.s_RB(s_RB[283]),  .d(softGlueBus), .y(SG_OUT283),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in284(.s(s[284]),	.s_RB(s_RB[284]),  .d(softGlueBus), .y(SG_OUT284),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in285(.s(s[285]),	.s_RB(s_RB[285]),  .d(softGlueBus), .y(SG_OUT285),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in286(.s(s[286]),	.s_RB(s_RB[286]),  .d(softGlueBus), .y(SG_OUT286),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in287(.s(s[287]),	.s_RB(s_RB[287]),  .d(softGlueBus), .y(SG_OUT287),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in288(.s(s[288]),	.s_RB(s_RB[288]),  .d(softGlueBus), .y(SG_OUT288),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in289(.s(s[289]),	.s_RB(s_RB[289]),  .d(softGlueBus), .y(SG_OUT289),  .regClock(SOFTGLUE_REG_CLOCK));

    softGlue_In in290(.s(s[290]),	.s_RB(s_RB[290]),  .d(softGlueBus), .y(SG_OUT290),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in291(.s(s[291]),	.s_RB(s_RB[291]),  .d(softGlueBus), .y(SG_OUT291),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in292(.s(s[292]),	.s_RB(s_RB[292]),  .d(softGlueBus), .y(SG_OUT292),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in293(.s(s[293]),	.s_RB(s_RB[293]),  .d(softGlueBus), .y(SG_OUT293),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in294(.s(s[294]),	.s_RB(s_RB[294]),  .d(softGlueBus), .y(SG_OUT294),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in295(.s(s[295]),	.s_RB(s_RB[295]),  .d(softGlueBus), .y(SG_OUT295),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in296(.s(s[296]),	.s_RB(s_RB[296]),  .d(softGlueBus), .y(SG_OUT296),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in297(.s(s[297]),	.s_RB(s_RB[297]),  .d(softGlueBus), .y(SG_OUT297),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in298(.s(s[298]),	.s_RB(s_RB[298]),  .d(softGlueBus), .y(SG_OUT298),  .regClock(SOFTGLUE_REG_CLOCK));
    softGlue_In in299(.s(s[299]),	.s_RB(s_RB[299]),  .d(softGlueBus), .y(SG_OUT299),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in300(.s(s[300]),   .s_RB(s_RB[300]),  .d(softGlueBus), .y(SG_OUT300),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in301(.s(s[301]),   .s_RB(s_RB[301]),  .d(softGlueBus), .y(SG_OUT301),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in302(.s(s[302]),   .s_RB(s_RB[302]),  .d(softGlueBus), .y(SG_OUT302),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in303(.s(s[303]),   .s_RB(s_RB[303]),  .d(softGlueBus), .y(SG_OUT303),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in304(.s(s[304]),   .s_RB(s_RB[304]),  .d(softGlueBus), .y(SG_OUT304),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in305(.s(s[305]),   .s_RB(s_RB[305]),  .d(softGlueBus), .y(SG_OUT305),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in306(.s(s[306]),   .s_RB(s_RB[306]),  .d(softGlueBus), .y(SG_OUT306),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in307(.s(s[307]),   .s_RB(s_RB[307]),  .d(softGlueBus), .y(SG_OUT307),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in308(.s(s[308]),   .s_RB(s_RB[308]),  .d(softGlueBus), .y(SG_OUT308),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in309(.s(s[309]),   .s_RB(s_RB[309]),  .d(softGlueBus), .y(SG_OUT309),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in310(.s(s[310]),   .s_RB(s_RB[310]),  .d(softGlueBus), .y(SG_OUT310),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in311(.s(s[311]),   .s_RB(s_RB[311]),  .d(softGlueBus), .y(SG_OUT311),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in312(.s(s[312]),   .s_RB(s_RB[312]),  .d(softGlueBus), .y(SG_OUT312),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in313(.s(s[313]),   .s_RB(s_RB[313]),  .d(softGlueBus), .y(SG_OUT313),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in314(.s(s[314]),   .s_RB(s_RB[314]),  .d(softGlueBus), .y(SG_OUT314),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in315(.s(s[315]),   .s_RB(s_RB[315]),  .d(softGlueBus), .y(SG_OUT315),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in316(.s(s[316]),   .s_RB(s_RB[316]),  .d(softGlueBus), .y(SG_OUT316),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in317(.s(s[317]),   .s_RB(s_RB[317]),  .d(softGlueBus), .y(SG_OUT317),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in318(.s(s[318]),   .s_RB(s_RB[318]),  .d(softGlueBus), .y(SG_OUT318),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in319(.s(s[319]),   .s_RB(s_RB[319]),  .d(softGlueBus), .y(SG_OUT319),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in320(.s(s[320]),   .s_RB(s_RB[320]),  .d(softGlueBus), .y(SG_OUT320),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in321(.s(s[321]),   .s_RB(s_RB[321]),  .d(softGlueBus), .y(SG_OUT321),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in322(.s(s[322]),   .s_RB(s_RB[322]),  .d(softGlueBus), .y(SG_OUT322),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in323(.s(s[323]),   .s_RB(s_RB[323]),  .d(softGlueBus), .y(SG_OUT323),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in324(.s(s[324]),   .s_RB(s_RB[324]),  .d(softGlueBus), .y(SG_OUT324),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in325(.s(s[325]),   .s_RB(s_RB[325]),  .d(softGlueBus), .y(SG_OUT325),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in326(.s(s[326]),   .s_RB(s_RB[326]),  .d(softGlueBus), .y(SG_OUT326),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in327(.s(s[327]),   .s_RB(s_RB[327]),  .d(softGlueBus), .y(SG_OUT327),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in328(.s(s[328]),   .s_RB(s_RB[328]),  .d(softGlueBus), .y(SG_OUT328),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in329(.s(s[329]),   .s_RB(s_RB[329]),  .d(softGlueBus), .y(SG_OUT329),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in330(.s(s[330]),   .s_RB(s_RB[330]),  .d(softGlueBus), .y(SG_OUT330),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in331(.s(s[331]),   .s_RB(s_RB[331]),  .d(softGlueBus), .y(SG_OUT331),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in332(.s(s[332]),   .s_RB(s_RB[332]),  .d(softGlueBus), .y(SG_OUT332),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in333(.s(s[333]),   .s_RB(s_RB[333]),  .d(softGlueBus), .y(SG_OUT333),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in334(.s(s[334]),   .s_RB(s_RB[334]),  .d(softGlueBus), .y(SG_OUT334),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in335(.s(s[335]),   .s_RB(s_RB[335]),  .d(softGlueBus), .y(SG_OUT335),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in336(.s(s[336]),   .s_RB(s_RB[336]),  .d(softGlueBus), .y(SG_OUT336),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in337(.s(s[337]),   .s_RB(s_RB[337]),  .d(softGlueBus), .y(SG_OUT337),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in338(.s(s[338]),   .s_RB(s_RB[338]),  .d(softGlueBus), .y(SG_OUT338),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in339(.s(s[339]),   .s_RB(s_RB[339]),  .d(softGlueBus), .y(SG_OUT339),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in340(.s(s[340]),   .s_RB(s_RB[340]),  .d(softGlueBus), .y(SG_OUT340),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in341(.s(s[341]),   .s_RB(s_RB[341]),  .d(softGlueBus), .y(SG_OUT341),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in342(.s(s[342]),   .s_RB(s_RB[342]),  .d(softGlueBus), .y(SG_OUT342),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in343(.s(s[343]),   .s_RB(s_RB[343]),  .d(softGlueBus), .y(SG_OUT343),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in344(.s(s[344]),   .s_RB(s_RB[344]),  .d(softGlueBus), .y(SG_OUT344),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in345(.s(s[345]),   .s_RB(s_RB[345]),  .d(softGlueBus), .y(SG_OUT345),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in346(.s(s[346]),   .s_RB(s_RB[346]),  .d(softGlueBus), .y(SG_OUT346),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in347(.s(s[347]),   .s_RB(s_RB[347]),  .d(softGlueBus), .y(SG_OUT347),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in348(.s(s[348]),   .s_RB(s_RB[348]),  .d(softGlueBus), .y(SG_OUT348),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in349(.s(s[349]),   .s_RB(s_RB[349]),  .d(softGlueBus), .y(SG_OUT349),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in350(.s(s[350]),   .s_RB(s_RB[350]),  .d(softGlueBus), .y(SG_OUT350),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in351(.s(s[351]),   .s_RB(s_RB[351]),  .d(softGlueBus), .y(SG_OUT351),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in352(.s(s[352]),   .s_RB(s_RB[352]),  .d(softGlueBus), .y(SG_OUT352),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in353(.s(s[353]),   .s_RB(s_RB[353]),  .d(softGlueBus), .y(SG_OUT353),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in354(.s(s[354]),   .s_RB(s_RB[354]),  .d(softGlueBus), .y(SG_OUT354),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in355(.s(s[355]),   .s_RB(s_RB[355]),  .d(softGlueBus), .y(SG_OUT355),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in356(.s(s[356]),   .s_RB(s_RB[356]),  .d(softGlueBus), .y(SG_OUT356),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in357(.s(s[357]),   .s_RB(s_RB[357]),  .d(softGlueBus), .y(SG_OUT357),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in358(.s(s[358]),   .s_RB(s_RB[358]),  .d(softGlueBus), .y(SG_OUT358),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in359(.s(s[359]),   .s_RB(s_RB[359]),  .d(softGlueBus), .y(SG_OUT359),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in360(.s(s[360]),   .s_RB(s_RB[360]),  .d(softGlueBus), .y(SG_OUT360),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in361(.s(s[361]),   .s_RB(s_RB[361]),  .d(softGlueBus), .y(SG_OUT361),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in362(.s(s[362]),   .s_RB(s_RB[362]),  .d(softGlueBus), .y(SG_OUT362),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in363(.s(s[363]),   .s_RB(s_RB[363]),  .d(softGlueBus), .y(SG_OUT363),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in364(.s(s[364]),   .s_RB(s_RB[364]),  .d(softGlueBus), .y(SG_OUT364),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in365(.s(s[365]),   .s_RB(s_RB[365]),  .d(softGlueBus), .y(SG_OUT365),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in366(.s(s[366]),   .s_RB(s_RB[366]),  .d(softGlueBus), .y(SG_OUT366),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in367(.s(s[367]),   .s_RB(s_RB[367]),  .d(softGlueBus), .y(SG_OUT367),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in368(.s(s[368]),   .s_RB(s_RB[368]),  .d(softGlueBus), .y(SG_OUT368),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in369(.s(s[369]),   .s_RB(s_RB[369]),  .d(softGlueBus), .y(SG_OUT369),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in370(.s(s[370]),   .s_RB(s_RB[370]),  .d(softGlueBus), .y(SG_OUT370),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in371(.s(s[371]),   .s_RB(s_RB[371]),  .d(softGlueBus), .y(SG_OUT371),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in372(.s(s[372]),   .s_RB(s_RB[372]),  .d(softGlueBus), .y(SG_OUT372),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in373(.s(s[373]),   .s_RB(s_RB[373]),  .d(softGlueBus), .y(SG_OUT373),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in374(.s(s[374]),   .s_RB(s_RB[374]),  .d(softGlueBus), .y(SG_OUT374),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in375(.s(s[375]),   .s_RB(s_RB[375]),  .d(softGlueBus), .y(SG_OUT375),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in376(.s(s[376]),   .s_RB(s_RB[376]),  .d(softGlueBus), .y(SG_OUT376),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in377(.s(s[377]),   .s_RB(s_RB[377]),  .d(softGlueBus), .y(SG_OUT377),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in378(.s(s[378]),   .s_RB(s_RB[378]),  .d(softGlueBus), .y(SG_OUT378),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in379(.s(s[379]),   .s_RB(s_RB[379]),  .d(softGlueBus), .y(SG_OUT379),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in380(.s(s[380]),   .s_RB(s_RB[380]),  .d(softGlueBus), .y(SG_OUT380),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in381(.s(s[381]),   .s_RB(s_RB[381]),  .d(softGlueBus), .y(SG_OUT381),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in382(.s(s[382]),   .s_RB(s_RB[382]),  .d(softGlueBus), .y(SG_OUT382),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in383(.s(s[383]),   .s_RB(s_RB[383]),  .d(softGlueBus), .y(SG_OUT383),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in384(.s(s[384]),   .s_RB(s_RB[384]),  .d(softGlueBus), .y(SG_OUT384),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in385(.s(s[385]),   .s_RB(s_RB[385]),  .d(softGlueBus), .y(SG_OUT385),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in386(.s(s[386]),   .s_RB(s_RB[386]),  .d(softGlueBus), .y(SG_OUT386),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in387(.s(s[387]),   .s_RB(s_RB[387]),  .d(softGlueBus), .y(SG_OUT387),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in388(.s(s[388]),   .s_RB(s_RB[388]),  .d(softGlueBus), .y(SG_OUT388),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in389(.s(s[389]),   .s_RB(s_RB[389]),  .d(softGlueBus), .y(SG_OUT389),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in390(.s(s[390]),   .s_RB(s_RB[390]),  .d(softGlueBus), .y(SG_OUT390),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in391(.s(s[391]),   .s_RB(s_RB[391]),  .d(softGlueBus), .y(SG_OUT391),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in392(.s(s[392]),   .s_RB(s_RB[392]),  .d(softGlueBus), .y(SG_OUT392),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in393(.s(s[393]),   .s_RB(s_RB[393]),  .d(softGlueBus), .y(SG_OUT393),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in394(.s(s[394]),   .s_RB(s_RB[394]),  .d(softGlueBus), .y(SG_OUT394),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in395(.s(s[395]),   .s_RB(s_RB[395]),  .d(softGlueBus), .y(SG_OUT395),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in396(.s(s[396]),   .s_RB(s_RB[396]),  .d(softGlueBus), .y(SG_OUT396),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in397(.s(s[397]),   .s_RB(s_RB[397]),  .d(softGlueBus), .y(SG_OUT397),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in398(.s(s[398]),   .s_RB(s_RB[398]),  .d(softGlueBus), .y(SG_OUT398),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in399(.s(s[399]),   .s_RB(s_RB[399]),  .d(softGlueBus), .y(SG_OUT399),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in400(.s(s[400]),   .s_RB(s_RB[400]),  .d(softGlueBus), .y(SG_OUT400),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in401(.s(s[401]),   .s_RB(s_RB[401]),  .d(softGlueBus), .y(SG_OUT401),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in402(.s(s[402]),   .s_RB(s_RB[402]),  .d(softGlueBus), .y(SG_OUT402),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in403(.s(s[403]),   .s_RB(s_RB[403]),  .d(softGlueBus), .y(SG_OUT403),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in404(.s(s[404]),   .s_RB(s_RB[404]),  .d(softGlueBus), .y(SG_OUT404),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in405(.s(s[405]),   .s_RB(s_RB[405]),  .d(softGlueBus), .y(SG_OUT405),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in406(.s(s[406]),   .s_RB(s_RB[406]),  .d(softGlueBus), .y(SG_OUT406),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in407(.s(s[407]),   .s_RB(s_RB[407]),  .d(softGlueBus), .y(SG_OUT407),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in408(.s(s[408]),   .s_RB(s_RB[408]),  .d(softGlueBus), .y(SG_OUT408),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in409(.s(s[409]),   .s_RB(s_RB[409]),  .d(softGlueBus), .y(SG_OUT409),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in410(.s(s[410]),   .s_RB(s_RB[410]),  .d(softGlueBus), .y(SG_OUT410),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in411(.s(s[411]),   .s_RB(s_RB[411]),  .d(softGlueBus), .y(SG_OUT411),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in412(.s(s[412]),   .s_RB(s_RB[412]),  .d(softGlueBus), .y(SG_OUT412),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in413(.s(s[413]),   .s_RB(s_RB[413]),  .d(softGlueBus), .y(SG_OUT413),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in414(.s(s[414]),   .s_RB(s_RB[414]),  .d(softGlueBus), .y(SG_OUT414),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in415(.s(s[415]),   .s_RB(s_RB[415]),  .d(softGlueBus), .y(SG_OUT415),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in416(.s(s[416]),   .s_RB(s_RB[416]),  .d(softGlueBus), .y(SG_OUT416),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in417(.s(s[417]),   .s_RB(s_RB[417]),  .d(softGlueBus), .y(SG_OUT417),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in418(.s(s[418]),   .s_RB(s_RB[418]),  .d(softGlueBus), .y(SG_OUT418),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in419(.s(s[419]),   .s_RB(s_RB[419]),  .d(softGlueBus), .y(SG_OUT419),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in420(.s(s[420]),   .s_RB(s_RB[420]),  .d(softGlueBus), .y(SG_OUT420),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in421(.s(s[421]),   .s_RB(s_RB[421]),  .d(softGlueBus), .y(SG_OUT421),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in422(.s(s[422]),   .s_RB(s_RB[422]),  .d(softGlueBus), .y(SG_OUT422),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in423(.s(s[423]),   .s_RB(s_RB[423]),  .d(softGlueBus), .y(SG_OUT423),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in424(.s(s[424]),   .s_RB(s_RB[424]),  .d(softGlueBus), .y(SG_OUT424),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in425(.s(s[425]),   .s_RB(s_RB[425]),  .d(softGlueBus), .y(SG_OUT425),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in426(.s(s[426]),   .s_RB(s_RB[426]),  .d(softGlueBus), .y(SG_OUT426),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in427(.s(s[427]),   .s_RB(s_RB[427]),  .d(softGlueBus), .y(SG_OUT427),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in428(.s(s[428]),   .s_RB(s_RB[428]),  .d(softGlueBus), .y(SG_OUT428),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in429(.s(s[429]),   .s_RB(s_RB[429]),  .d(softGlueBus), .y(SG_OUT429),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in430(.s(s[430]),   .s_RB(s_RB[430]),  .d(softGlueBus), .y(SG_OUT430),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in431(.s(s[431]),   .s_RB(s_RB[431]),  .d(softGlueBus), .y(SG_OUT431),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in432(.s(s[432]),   .s_RB(s_RB[432]),  .d(softGlueBus), .y(SG_OUT432),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in433(.s(s[433]),   .s_RB(s_RB[433]),  .d(softGlueBus), .y(SG_OUT433),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in434(.s(s[434]),   .s_RB(s_RB[434]),  .d(softGlueBus), .y(SG_OUT434),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in435(.s(s[435]),   .s_RB(s_RB[435]),  .d(softGlueBus), .y(SG_OUT435),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in436(.s(s[436]),   .s_RB(s_RB[436]),  .d(softGlueBus), .y(SG_OUT436),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in437(.s(s[437]),   .s_RB(s_RB[437]),  .d(softGlueBus), .y(SG_OUT437),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in438(.s(s[438]),   .s_RB(s_RB[438]),  .d(softGlueBus), .y(SG_OUT438),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in439(.s(s[439]),   .s_RB(s_RB[439]),  .d(softGlueBus), .y(SG_OUT439),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in440(.s(s[440]),   .s_RB(s_RB[440]),  .d(softGlueBus), .y(SG_OUT440),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in441(.s(s[441]),   .s_RB(s_RB[441]),  .d(softGlueBus), .y(SG_OUT441),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in442(.s(s[442]),   .s_RB(s_RB[442]),  .d(softGlueBus), .y(SG_OUT442),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in443(.s(s[443]),   .s_RB(s_RB[443]),  .d(softGlueBus), .y(SG_OUT443),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in444(.s(s[444]),   .s_RB(s_RB[444]),  .d(softGlueBus), .y(SG_OUT444),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in445(.s(s[445]),   .s_RB(s_RB[445]),  .d(softGlueBus), .y(SG_OUT445),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in446(.s(s[446]),   .s_RB(s_RB[446]),  .d(softGlueBus), .y(SG_OUT446),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in447(.s(s[447]),   .s_RB(s_RB[447]),  .d(softGlueBus), .y(SG_OUT447),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in448(.s(s[448]),   .s_RB(s_RB[448]),  .d(softGlueBus), .y(SG_OUT448),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in449(.s(s[449]),   .s_RB(s_RB[449]),  .d(softGlueBus), .y(SG_OUT449),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in450(.s(s[450]),   .s_RB(s_RB[450]),  .d(softGlueBus), .y(SG_OUT450),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in451(.s(s[451]),   .s_RB(s_RB[451]),  .d(softGlueBus), .y(SG_OUT451),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in452(.s(s[452]),   .s_RB(s_RB[452]),  .d(softGlueBus), .y(SG_OUT452),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in453(.s(s[453]),   .s_RB(s_RB[453]),  .d(softGlueBus), .y(SG_OUT453),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in454(.s(s[454]),   .s_RB(s_RB[454]),  .d(softGlueBus), .y(SG_OUT454),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in455(.s(s[455]),   .s_RB(s_RB[455]),  .d(softGlueBus), .y(SG_OUT455),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in456(.s(s[456]),   .s_RB(s_RB[456]),  .d(softGlueBus), .y(SG_OUT456),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in457(.s(s[457]),   .s_RB(s_RB[457]),  .d(softGlueBus), .y(SG_OUT457),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in458(.s(s[458]),   .s_RB(s_RB[458]),  .d(softGlueBus), .y(SG_OUT458),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in459(.s(s[459]),   .s_RB(s_RB[459]),  .d(softGlueBus), .y(SG_OUT459),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in460(.s(s[460]),   .s_RB(s_RB[460]),  .d(softGlueBus), .y(SG_OUT460),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in461(.s(s[461]),   .s_RB(s_RB[461]),  .d(softGlueBus), .y(SG_OUT461),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in462(.s(s[462]),   .s_RB(s_RB[462]),  .d(softGlueBus), .y(SG_OUT462),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in463(.s(s[463]),   .s_RB(s_RB[463]),  .d(softGlueBus), .y(SG_OUT463),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in464(.s(s[464]),   .s_RB(s_RB[464]),  .d(softGlueBus), .y(SG_OUT464),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in465(.s(s[465]),   .s_RB(s_RB[465]),  .d(softGlueBus), .y(SG_OUT465),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in466(.s(s[466]),   .s_RB(s_RB[466]),  .d(softGlueBus), .y(SG_OUT466),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in467(.s(s[467]),   .s_RB(s_RB[467]),  .d(softGlueBus), .y(SG_OUT467),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in468(.s(s[468]),   .s_RB(s_RB[468]),  .d(softGlueBus), .y(SG_OUT468),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in469(.s(s[469]),   .s_RB(s_RB[469]),  .d(softGlueBus), .y(SG_OUT469),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in470(.s(s[470]),   .s_RB(s_RB[470]),  .d(softGlueBus), .y(SG_OUT470),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in471(.s(s[471]),   .s_RB(s_RB[471]),  .d(softGlueBus), .y(SG_OUT471),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in472(.s(s[472]),   .s_RB(s_RB[472]),  .d(softGlueBus), .y(SG_OUT472),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in473(.s(s[473]),   .s_RB(s_RB[473]),  .d(softGlueBus), .y(SG_OUT473),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in474(.s(s[474]),   .s_RB(s_RB[474]),  .d(softGlueBus), .y(SG_OUT474),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in475(.s(s[475]),   .s_RB(s_RB[475]),  .d(softGlueBus), .y(SG_OUT475),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in476(.s(s[476]),   .s_RB(s_RB[476]),  .d(softGlueBus), .y(SG_OUT476),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in477(.s(s[477]),   .s_RB(s_RB[477]),  .d(softGlueBus), .y(SG_OUT477),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in478(.s(s[478]),   .s_RB(s_RB[478]),  .d(softGlueBus), .y(SG_OUT478),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in479(.s(s[479]),   .s_RB(s_RB[479]),  .d(softGlueBus), .y(SG_OUT479),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in480(.s(s[480]),   .s_RB(s_RB[480]),  .d(softGlueBus), .y(SG_OUT480),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in481(.s(s[481]),   .s_RB(s_RB[481]),  .d(softGlueBus), .y(SG_OUT481),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in482(.s(s[482]),   .s_RB(s_RB[482]),  .d(softGlueBus), .y(SG_OUT482),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in483(.s(s[483]),   .s_RB(s_RB[483]),  .d(softGlueBus), .y(SG_OUT483),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in484(.s(s[484]),   .s_RB(s_RB[484]),  .d(softGlueBus), .y(SG_OUT484),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in485(.s(s[485]),   .s_RB(s_RB[485]),  .d(softGlueBus), .y(SG_OUT485),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in486(.s(s[486]),   .s_RB(s_RB[486]),  .d(softGlueBus), .y(SG_OUT486),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in487(.s(s[487]),   .s_RB(s_RB[487]),  .d(softGlueBus), .y(SG_OUT487),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in488(.s(s[488]),   .s_RB(s_RB[488]),  .d(softGlueBus), .y(SG_OUT488),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in489(.s(s[489]),   .s_RB(s_RB[489]),  .d(softGlueBus), .y(SG_OUT489),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in490(.s(s[490]),   .s_RB(s_RB[490]),  .d(softGlueBus), .y(SG_OUT490),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in491(.s(s[491]),   .s_RB(s_RB[491]),  .d(softGlueBus), .y(SG_OUT491),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in492(.s(s[492]),   .s_RB(s_RB[492]),  .d(softGlueBus), .y(SG_OUT492),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in493(.s(s[493]),   .s_RB(s_RB[493]),  .d(softGlueBus), .y(SG_OUT493),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in494(.s(s[494]),   .s_RB(s_RB[494]),  .d(softGlueBus), .y(SG_OUT494),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in495(.s(s[495]),   .s_RB(s_RB[495]),  .d(softGlueBus), .y(SG_OUT495),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in496(.s(s[496]),   .s_RB(s_RB[496]),  .d(softGlueBus), .y(SG_OUT496),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in497(.s(s[497]),   .s_RB(s_RB[497]),  .d(softGlueBus), .y(SG_OUT497),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in498(.s(s[498]),   .s_RB(s_RB[498]),  .d(softGlueBus), .y(SG_OUT498),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in499(.s(s[499]),   .s_RB(s_RB[499]),  .d(softGlueBus), .y(SG_OUT499),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in500(.s(s[500]),   .s_RB(s_RB[500]),  .d(softGlueBus), .y(SG_OUT500),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in501(.s(s[501]),   .s_RB(s_RB[501]),  .d(softGlueBus), .y(SG_OUT501),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in502(.s(s[502]),   .s_RB(s_RB[502]),  .d(softGlueBus), .y(SG_OUT502),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in503(.s(s[503]),   .s_RB(s_RB[503]),  .d(softGlueBus), .y(SG_OUT503),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in504(.s(s[504]),   .s_RB(s_RB[504]),  .d(softGlueBus), .y(SG_OUT504),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in505(.s(s[505]),   .s_RB(s_RB[505]),  .d(softGlueBus), .y(SG_OUT505),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in506(.s(s[506]),   .s_RB(s_RB[506]),  .d(softGlueBus), .y(SG_OUT506),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in507(.s(s[507]),   .s_RB(s_RB[507]),  .d(softGlueBus), .y(SG_OUT507),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in508(.s(s[508]),   .s_RB(s_RB[508]),  .d(softGlueBus), .y(SG_OUT508),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in509(.s(s[509]),   .s_RB(s_RB[509]),  .d(softGlueBus), .y(SG_OUT509),  .regClock(SOFTGLUE_REG_CLOCK));

    //softGlue_In in510(.s(s[510]),   .s_RB(s_RB[510]),  .d(softGlueBus), .y(SG_OUT510),  .regClock(SOFTGLUE_REG_CLOCK));
    //softGlue_In in511(.s(s[511]),   .s_RB(s_RB[511]),  .d(softGlueBus), .y(SG_OUT511),  .regClock(SOFTGLUE_REG_CLOCK));



	// User logic ends

	endmodule

// s[3:0] is the mux address.  (Leave open the option to use s[4:0].)
// if mux address==0, then use s[5] as the input value
// if s[6]==1, then negate the value before outputting it

// -- unclocked input --
//module    softGlue_In(
//  input wire [7:0] s, //s[3:0]=mux_address; s[5]=direct; s[6]=negate_input
//  output reg [7:0] s_RB, //s[3:0]=mux_address; s[5]=direct; s[6]=negate_input; s[7]=y
//  input wire [15:0] d,
//  output wire y,
//  input wire regClock
//  );
//
//  wire y_sel;
//
//  assign
//	  y_sel = (s[3:0]==4'h0) ? s[5]  : 1'bz,
//	y_sel = (s[3:0]==4'h1) ? d[1]  : 1'bz,
//	y_sel = (s[3:0]==4'h2) ? d[2]  : 1'bz,
//	y_sel = (s[3:0]==4'h3) ? d[3]  : 1'bz,
//	y_sel = (s[3:0]==4'h4) ? d[4]  : 1'bz,
//	y_sel = (s[3:0]==4'h5) ? d[5]  : 1'bz,
//	y_sel = (s[3:0]==4'h6) ? d[6]  : 1'bz,
//	y_sel = (s[3:0]==4'h7) ? d[7]  : 1'bz,
//	y_sel = (s[3:0]==4'h8) ? d[8]  : 1'bz,
//	y_sel = (s[3:0]==4'h9) ? d[9]  : 1'bz,
//	y_sel = (s[3:0]==4'ha) ? d[10] : 1'bz,
//	y_sel = (s[3:0]==4'hb) ? d[11] : 1'bz,
//	y_sel = (s[3:0]==4'hc) ? d[12] : 1'bz,
//	y_sel = (s[3:0]==4'hd) ? d[13] : 1'bz,
//	y_sel = (s[3:0]==4'he) ? d[14] : 1'bz,
//	y_sel = (s[3:0]==4'hf) ? d[15] : 1'bz;
//
//  assign y = (s[6]==1'b1) ? ~y_sel : y_sel;
//
//  always @(posedge regClock)
//  begin
//	  s_RB = {y, s[6:0]};
//  end
//  
//endmodule

// -- clocked input --
module softGlue_In(
	input wire [7:0] s, //s[3:0]=mux_address; s[5]=direct; s[6]=negate_input
	output reg [7:0] s_RB, //s[3:0]=mux_address; s[5]=direct; s[6]=negate_input; s[7]=y
	input wire [15:0] d,
	output reg y,
	input wire regClock
);

	wire y_sel;

	assign
		y_sel = (s[3:0]==4'h0) ? s[5]  : 1'bz,
		y_sel = (s[3:0]==4'h1) ? d[1]  : 1'bz,
		y_sel = (s[3:0]==4'h2) ? d[2]  : 1'bz,
		y_sel = (s[3:0]==4'h3) ? d[3]  : 1'bz,
		y_sel = (s[3:0]==4'h4) ? d[4]  : 1'bz,
		y_sel = (s[3:0]==4'h5) ? d[5]  : 1'bz,
		y_sel = (s[3:0]==4'h6) ? d[6]  : 1'bz,
		y_sel = (s[3:0]==4'h7) ? d[7]  : 1'bz,
		y_sel = (s[3:0]==4'h8) ? d[8]  : 1'bz,
		y_sel = (s[3:0]==4'h9) ? d[9]  : 1'bz,
		y_sel = (s[3:0]==4'ha) ? d[10] : 1'bz,
		y_sel = (s[3:0]==4'hb) ? d[11] : 1'bz,
		y_sel = (s[3:0]==4'hc) ? d[12] : 1'bz,
		y_sel = (s[3:0]==4'hd) ? d[13] : 1'bz,
		y_sel = (s[3:0]==4'he) ? d[14] : 1'bz,
		y_sel = (s[3:0]==4'hf) ? d[15] : 1'bz;

	always @(posedge regClock) begin
		y <= s[6] ? ~y_sel : y_sel;
		s_RB <= {(s[6] ? ~y_sel : y_sel), s[6:0]};
	end
  
endmodule


// -- clocked output --
module softGlue_Out(
	input wire [7:0] s,
	output reg [7:0] s_RB, //s[3:0]=mux_address; s[7]=y
	input wire y,
	output wire [15:0] d,
	input wire regClock
);
	reg y_clocked;

	always @(posedge regClock) begin
		y_clocked = y;
		s_RB = {y, s[6:0]};
	end

	assign
	d[0]	= (s[3:0]==4'h0) ? y_clocked : 1'bz,
	d[1]	= (s[3:0]==4'h1) ? y_clocked : 1'bz,
	d[2]	= (s[3:0]==4'h2) ? y_clocked : 1'bz,
	d[3]	= (s[3:0]==4'h3) ? y_clocked : 1'bz,
	d[4]	= (s[3:0]==4'h4) ? y_clocked : 1'bz,
	d[5]	= (s[3:0]==4'h5) ? y_clocked : 1'bz,
	d[6]	= (s[3:0]==4'h6) ? y_clocked : 1'bz,
	d[7]	= (s[3:0]==4'h7) ? y_clocked : 1'bz,
	d[8]	= (s[3:0]==4'h8) ? y_clocked : 1'bz,
	d[9]	= (s[3:0]==4'h9) ? y_clocked : 1'bz,
	d[10]	= (s[3:0]==4'ha) ? y_clocked : 1'bz,
	d[11]	= (s[3:0]==4'hb) ? y_clocked : 1'bz,
	d[12]	= (s[3:0]==4'hc) ? y_clocked : 1'bz,
	d[13]	= (s[3:0]==4'hd) ? y_clocked : 1'bz,
	d[14]	= (s[3:0]==4'he) ? y_clocked : 1'bz,
	d[15]	= (s[3:0]==4'hf) ? y_clocked : 1'bz;

endmodule

// -- unclocked output --
//module    softGlue_Out(
//  input wire [7:0] s,
//  output reg [7:0] s_RB, //s[3:0]=mux_address; s[7]=y
//  input wire y,
//  output wire [15:0] d,
//  input wire regClock
//  );
//
//  always @(posedge regClock)
//  begin
//  s_RB = {y, s[6:0]};
//  end
//
//  assign
//  d[0]  = (s[3:0]==4'h0) ? y : 1'bz,
//  d[1]  = (s[3:0]==4'h1) ? y : 1'bz,
//  d[2]  = (s[3:0]==4'h2) ? y : 1'bz,
//  d[3]  = (s[3:0]==4'h3) ? y : 1'bz,
//  d[4]  = (s[3:0]==4'h4) ? y : 1'bz,
//  d[5]  = (s[3:0]==4'h5) ? y : 1'bz,
//  d[6]  = (s[3:0]==4'h6) ? y : 1'bz,
//  d[7]  = (s[3:0]==4'h7) ? y : 1'bz,
//  d[8]  = (s[3:0]==4'h8) ? y : 1'bz,
//  d[9]  = (s[3:0]==4'h9) ? y : 1'bz,
//  d[10] = (s[3:0]==4'ha) ? y : 1'bz,
//  d[11] = (s[3:0]==4'hb) ? y : 1'bz,
//  d[12] = (s[3:0]==4'hc) ? y : 1'bz,
//  d[13] = (s[3:0]==4'hd) ? y : 1'bz,
//  d[14] = (s[3:0]==4'he) ? y : 1'bz,
//  d[15] = (s[3:0]==4'hf) ? y : 1'bz;
//
//endmodule

