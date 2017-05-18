
`timescale 1 ns / 1 ps

	module softGlue_300IO_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 9,

		// Parameters of Axi Slave Bus Interface S_AXI_INTR
		parameter integer C_S_AXI_INTR_DATA_WIDTH	= 32,
		parameter integer C_S_AXI_INTR_ADDR_WIDTH	= 5,
		parameter integer C_NUM_OF_INTR	= 32,
		parameter  C_INTR_SENSITIVITY	= 32'h00000000,
		parameter  C_INTR_ACTIVE_STATE	= 32'hFFFFFFFF,
		parameter integer C_IRQ_SENSITIVITY	= 1,
		parameter integer C_IRQ_ACTIVE_STATE	= 1
	)
	(
		// Users to add ports here
        input wire softGlueRegClock,
        output wire softGlueRegClockOut,

        input wire sg_in000, sg_in001, sg_in002, sg_in003, sg_in004, sg_in005, sg_in006, sg_in007, sg_in008, sg_in009,
		input wire sg_in010, sg_in011, sg_in012, sg_in013, sg_in014, sg_in015, sg_in016, sg_in017, sg_in018, sg_in019,
		input wire sg_in020, sg_in021, sg_in022, sg_in023, sg_in024, sg_in025, sg_in026, sg_in027, sg_in028, sg_in029,
		input wire sg_in030, sg_in031, sg_in032, sg_in033, sg_in034, sg_in035, sg_in036, sg_in037, sg_in038, sg_in039,
        input wire sg_in040, sg_in041, sg_in042, sg_in043, sg_in044, sg_in045, sg_in046, sg_in047, sg_in048, sg_in049,
		input wire sg_in050, sg_in051, sg_in052, sg_in053, sg_in054, sg_in055, sg_in056, sg_in057, sg_in058, sg_in059,
		input wire sg_in060, sg_in061, sg_in062, sg_in063, sg_in064, sg_in065, sg_in066, sg_in067, sg_in068, sg_in069,
		input wire sg_in070, sg_in071, sg_in072, sg_in073, sg_in074, sg_in075, sg_in076, sg_in077, sg_in078, sg_in079,
		input wire sg_in080, sg_in081, sg_in082, sg_in083, sg_in084, sg_in085, sg_in086, sg_in087, sg_in088, sg_in089,
		input wire sg_in090, sg_in091, sg_in092, sg_in093, sg_in094, sg_in095, sg_in096, sg_in097, sg_in098, sg_in099,

        output wire sg_out100, sg_out101, sg_out102, sg_out103, sg_out104, sg_out105, sg_out106, sg_out107, sg_out108, sg_out109,
		output wire sg_out110, sg_out111, sg_out112, sg_out113, sg_out114, sg_out115, sg_out116, sg_out117, sg_out118, sg_out119,
		output wire sg_out120, sg_out121, sg_out122, sg_out123, sg_out124, sg_out125, sg_out126, sg_out127, sg_out128, sg_out129,
		output wire sg_out130, sg_out131, sg_out132, sg_out133, sg_out134, sg_out135, sg_out136, sg_out137, sg_out138, sg_out139,
        output wire sg_out140, sg_out141, sg_out142, sg_out143, sg_out144, sg_out145, sg_out146, sg_out147, sg_out148, sg_out149,
		output wire sg_out150, sg_out151, sg_out152, sg_out153, sg_out154, sg_out155, sg_out156, sg_out157, sg_out158, sg_out159,
		output wire sg_out160, sg_out161, sg_out162, sg_out163, sg_out164, sg_out165, sg_out166, sg_out167, sg_out168, sg_out169,
		output wire sg_out170, sg_out171, sg_out172, sg_out173, sg_out174, sg_out175, sg_out176, sg_out177, sg_out178, sg_out179,
		output wire sg_out180, sg_out181, sg_out182, sg_out183, sg_out184, sg_out185, sg_out186, sg_out187, sg_out188, sg_out189,
		output wire sg_out190, sg_out191, sg_out192, sg_out193, sg_out194, sg_out195, sg_out196, sg_out197, sg_out198, sg_out199,

        output wire sg_out200, sg_out201, sg_out202, sg_out203, sg_out204, sg_out205, sg_out206, sg_out207, sg_out208, sg_out209,
		output wire sg_out210, sg_out211, sg_out212, sg_out213, sg_out214, sg_out215, sg_out216, sg_out217, sg_out218, sg_out219,
		output wire sg_out220, sg_out221, sg_out222, sg_out223, sg_out224, sg_out225, sg_out226, sg_out227, sg_out228, sg_out229,
		output wire sg_out230, sg_out231, sg_out232, sg_out233, sg_out234, sg_out235, sg_out236, sg_out237, sg_out238, sg_out239,
        output wire sg_out240, sg_out241, sg_out242, sg_out243, sg_out244, sg_out245, sg_out246, sg_out247, sg_out248, sg_out249,
		output wire sg_out250, sg_out251, sg_out252, sg_out253, sg_out254, sg_out255, sg_out256, sg_out257, sg_out258, sg_out259,
		output wire sg_out260, sg_out261, sg_out262, sg_out263, sg_out264, sg_out265, sg_out266, sg_out267, sg_out268, sg_out269,
		output wire sg_out270, sg_out271, sg_out272, sg_out273, sg_out274, sg_out275, sg_out276, sg_out277, sg_out278, sg_out279,
		output wire sg_out280, sg_out281, sg_out282, sg_out283, sg_out284, sg_out285, sg_out286, sg_out287, sg_out288, sg_out289,
		output wire sg_out290, sg_out291, sg_out292, sg_out293, sg_out294, sg_out295, sg_out296, sg_out297, sg_out298, sg_out299,

        //output wire sg_out300, sg_out301, sg_out302, sg_out303, sg_out304, sg_out305, sg_out306, sg_out307, sg_out308, sg_out309,
		//output wire sg_out310, sg_out311, sg_out312, sg_out313, sg_out314, sg_out315, sg_out316, sg_out317, sg_out318, sg_out319,
		//output wire sg_out320, sg_out321, sg_out322, sg_out323, sg_out324, sg_out325, sg_out326, sg_out327, sg_out328, sg_out329,
		//output wire sg_out330, sg_out331, sg_out332, sg_out333, sg_out334, sg_out335, sg_out336, sg_out337, sg_out338, sg_out339,
        //output wire sg_out340, sg_out341, sg_out342, sg_out343, sg_out344, sg_out345, sg_out346, sg_out347, sg_out348, sg_out349,
		//output wire sg_out350, sg_out351, sg_out352, sg_out353, sg_out354, sg_out355, sg_out356, sg_out357, sg_out358, sg_out359,
		//output wire sg_out360, sg_out361, sg_out362, sg_out363, sg_out364, sg_out365, sg_out366, sg_out367, sg_out368, sg_out369,
		//output wire sg_out370, sg_out371, sg_out372, sg_out373, sg_out374, sg_out375, sg_out376, sg_out377, sg_out378, sg_out379,
		//output wire sg_out380, sg_out381, sg_out382, sg_out383, sg_out384, sg_out385, sg_out386, sg_out387, sg_out388, sg_out389,
		//output wire sg_out390, sg_out391, sg_out392, sg_out393, sg_out394, sg_out395, sg_out396, sg_out397, sg_out398, sg_out399,

        //output wire sg_out400, sg_out401, sg_out402, sg_out403, sg_out404, sg_out405, sg_out406, sg_out407, sg_out408, sg_out409,
		//output wire sg_out410, sg_out411, sg_out412, sg_out413, sg_out414, sg_out415, sg_out416, sg_out417, sg_out418, sg_out419,
		//output wire sg_out420, sg_out421, sg_out422, sg_out423, sg_out424, sg_out425, sg_out426, sg_out427, sg_out428, sg_out429,
		//output wire sg_out430, sg_out431, sg_out432, sg_out433, sg_out434, sg_out435, sg_out436, sg_out437, sg_out438, sg_out439,
        //output wire sg_out440, sg_out441, sg_out442, sg_out443, sg_out444, sg_out445, sg_out446, sg_out447, sg_out448, sg_out449,
		//output wire sg_out450, sg_out451, sg_out452, sg_out453, sg_out454, sg_out455, sg_out456, sg_out457, sg_out458, sg_out459,
		//output wire sg_out460, sg_out461, sg_out462, sg_out463, sg_out464, sg_out465, sg_out466, sg_out467, sg_out468, sg_out469,
		//output wire sg_out470, sg_out471, sg_out472, sg_out473, sg_out474, sg_out475, sg_out476, sg_out477, sg_out478, sg_out479,
		//output wire sg_out480, sg_out481, sg_out482, sg_out483, sg_out484, sg_out485, sg_out486, sg_out487, sg_out488, sg_out489,
		//output wire sg_out490, sg_out491, sg_out492, sg_out493, sg_out494, sg_out495, sg_out496, sg_out497, sg_out498, sg_out499,

        //output wire sg_out500, sg_out501, sg_out502, sg_out503, sg_out504, sg_out505, sg_out506, sg_out507, sg_out508, sg_out509,
		//output wire sg_out510, sg_out511,

		input wire [C_NUM_OF_INTR-1 :0] int_from_logic,
		// debugging
		output wire [C_NUM_OF_INTR-1 :0] det_intr_wire,
		output wire [C_NUM_OF_INTR-1 :0] intr_rising_edge_wire,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready,

		// Ports of Axi Slave Bus Interface S_AXI_INTR
		input wire  s_axi_intr_aclk,
		input wire  s_axi_intr_aresetn,
		input wire [C_S_AXI_INTR_ADDR_WIDTH-1 : 0] s_axi_intr_awaddr,
		input wire [2 : 0] s_axi_intr_awprot,
		input wire  s_axi_intr_awvalid,
		output wire  s_axi_intr_awready,
		input wire [C_S_AXI_INTR_DATA_WIDTH-1 : 0] s_axi_intr_wdata,
		input wire [(C_S_AXI_INTR_DATA_WIDTH/8)-1 : 0] s_axi_intr_wstrb,
		input wire  s_axi_intr_wvalid,
		output wire  s_axi_intr_wready,
		output wire [1 : 0] s_axi_intr_bresp,
		output wire  s_axi_intr_bvalid,
		input wire  s_axi_intr_bready,
		input wire [C_S_AXI_INTR_ADDR_WIDTH-1 : 0] s_axi_intr_araddr,
		input wire [2 : 0] s_axi_intr_arprot,
		input wire  s_axi_intr_arvalid,
		output wire  s_axi_intr_arready,
		output wire [C_S_AXI_INTR_DATA_WIDTH-1 : 0] s_axi_intr_rdata,
		output wire [1 : 0] s_axi_intr_rresp,
		output wire  s_axi_intr_rvalid,
		input wire  s_axi_intr_rready,
		output wire  irq
	);
// Instantiation of Axi Bus Interface S00_AXI
	softGlue_300IO_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) softGlue_300IO_v1_0_S00_AXI_inst (

		.SOFTGLUE_REG_CLOCK(softGlueRegClock),

        .SG_IN000(sg_in000), .SG_IN001(sg_in001), .SG_IN002(sg_in002), .SG_IN003(sg_in003), .SG_IN004(sg_in004), .SG_IN005(sg_in005), .SG_IN006(sg_in006), .SG_IN007(sg_in007), .SG_IN008(sg_in008), .SG_IN009(sg_in009),
		.SG_IN010(sg_in010), .SG_IN011(sg_in011), .SG_IN012(sg_in012), .SG_IN013(sg_in013), .SG_IN014(sg_in014), .SG_IN015(sg_in015), .SG_IN016(sg_in016), .SG_IN017(sg_in017), .SG_IN018(sg_in018), .SG_IN019(sg_in019),
		.SG_IN020(sg_in020), .SG_IN021(sg_in021), .SG_IN022(sg_in022), .SG_IN023(sg_in023), .SG_IN024(sg_in024), .SG_IN025(sg_in025), .SG_IN026(sg_in026), .SG_IN027(sg_in027), .SG_IN028(sg_in028), .SG_IN029(sg_in029),
		.SG_IN030(sg_in030), .SG_IN031(sg_in031), .SG_IN032(sg_in032), .SG_IN033(sg_in033), .SG_IN034(sg_in034), .SG_IN035(sg_in035), .SG_IN036(sg_in036), .SG_IN037(sg_in037), .SG_IN038(sg_in038), .SG_IN039(sg_in039),
        .SG_IN040(sg_in040), .SG_IN041(sg_in041), .SG_IN042(sg_in042), .SG_IN043(sg_in043), .SG_IN044(sg_in044), .SG_IN045(sg_in045), .SG_IN046(sg_in046), .SG_IN047(sg_in047), .SG_IN048(sg_in048), .SG_IN049(sg_in049),
		.SG_IN050(sg_in050), .SG_IN051(sg_in051), .SG_IN052(sg_in052), .SG_IN053(sg_in053), .SG_IN054(sg_in054), .SG_IN055(sg_in055), .SG_IN056(sg_in056), .SG_IN057(sg_in057), .SG_IN058(sg_in058), .SG_IN059(sg_in059),
		.SG_IN060(sg_in060), .SG_IN061(sg_in061), .SG_IN062(sg_in062), .SG_IN063(sg_in063), .SG_IN064(sg_in064), .SG_IN065(sg_in065), .SG_IN066(sg_in066), .SG_IN067(sg_in067), .SG_IN068(sg_in068), .SG_IN069(sg_in069),
		.SG_IN070(sg_in070), .SG_IN071(sg_in071), .SG_IN072(sg_in072), .SG_IN073(sg_in073), .SG_IN074(sg_in074), .SG_IN075(sg_in075), .SG_IN076(sg_in076), .SG_IN077(sg_in077), .SG_IN078(sg_in078), .SG_IN079(sg_in079),
		.SG_IN080(sg_in080), .SG_IN081(sg_in081), .SG_IN082(sg_in082), .SG_IN083(sg_in083), .SG_IN084(sg_in084), .SG_IN085(sg_in085), .SG_IN086(sg_in086), .SG_IN087(sg_in087), .SG_IN088(sg_in088), .SG_IN089(sg_in089),
		.SG_IN090(sg_in090), .SG_IN091(sg_in091), .SG_IN092(sg_in092), .SG_IN093(sg_in093), .SG_IN094(sg_in094), .SG_IN095(sg_in095), .SG_IN096(sg_in096), .SG_IN097(sg_in097), .SG_IN098(sg_in098), .SG_IN099(sg_in099),

		.SG_OUT100(sg_out100), .SG_OUT101(sg_out101), .SG_OUT102(sg_out102), .SG_OUT103(sg_out103), .SG_OUT104(sg_out104), .SG_OUT105(sg_out105), .SG_OUT106(sg_out106), .SG_OUT107(sg_out107), .SG_OUT108(sg_out108), .SG_OUT109(sg_out109),
		.SG_OUT110(sg_out110), .SG_OUT111(sg_out111), .SG_OUT112(sg_out112), .SG_OUT113(sg_out113), .SG_OUT114(sg_out114), .SG_OUT115(sg_out115), .SG_OUT116(sg_out116), .SG_OUT117(sg_out117), .SG_OUT118(sg_out118), .SG_OUT119(sg_out119),
		.SG_OUT120(sg_out120), .SG_OUT121(sg_out121), .SG_OUT122(sg_out122), .SG_OUT123(sg_out123), .SG_OUT124(sg_out124), .SG_OUT125(sg_out125), .SG_OUT126(sg_out126), .SG_OUT127(sg_out127), .SG_OUT128(sg_out128), .SG_OUT129(sg_out129),
		.SG_OUT130(sg_out130), .SG_OUT131(sg_out131), .SG_OUT132(sg_out132), .SG_OUT133(sg_out133), .SG_OUT134(sg_out134), .SG_OUT135(sg_out135), .SG_OUT136(sg_out136), .SG_OUT137(sg_out137), .SG_OUT138(sg_out138), .SG_OUT139(sg_out139),
		.SG_OUT140(sg_out140), .SG_OUT141(sg_out141), .SG_OUT142(sg_out142), .SG_OUT143(sg_out143), .SG_OUT144(sg_out144), .SG_OUT145(sg_out145), .SG_OUT146(sg_out146), .SG_OUT147(sg_out147), .SG_OUT148(sg_out148), .SG_OUT149(sg_out149),
		.SG_OUT150(sg_out150), .SG_OUT151(sg_out151), .SG_OUT152(sg_out152), .SG_OUT153(sg_out153), .SG_OUT154(sg_out154), .SG_OUT155(sg_out155), .SG_OUT156(sg_out156), .SG_OUT157(sg_out157), .SG_OUT158(sg_out158), .SG_OUT159(sg_out159),
		.SG_OUT160(sg_out160), .SG_OUT161(sg_out161), .SG_OUT162(sg_out162), .SG_OUT163(sg_out163), .SG_OUT164(sg_out164), .SG_OUT165(sg_out165), .SG_OUT166(sg_out166), .SG_OUT167(sg_out167), .SG_OUT168(sg_out168), .SG_OUT169(sg_out169),
		.SG_OUT170(sg_out170), .SG_OUT171(sg_out171), .SG_OUT172(sg_out172), .SG_OUT173(sg_out173), .SG_OUT174(sg_out174), .SG_OUT175(sg_out175), .SG_OUT176(sg_out176), .SG_OUT177(sg_out177), .SG_OUT178(sg_out178), .SG_OUT179(sg_out179),
		.SG_OUT180(sg_out180), .SG_OUT181(sg_out181), .SG_OUT182(sg_out182), .SG_OUT183(sg_out183), .SG_OUT184(sg_out184), .SG_OUT185(sg_out185), .SG_OUT186(sg_out186), .SG_OUT187(sg_out187), .SG_OUT188(sg_out188), .SG_OUT189(sg_out189),
		.SG_OUT190(sg_out190), .SG_OUT191(sg_out191), .SG_OUT192(sg_out192), .SG_OUT193(sg_out193), .SG_OUT194(sg_out194), .SG_OUT195(sg_out195), .SG_OUT196(sg_out196), .SG_OUT197(sg_out197), .SG_OUT198(sg_out198), .SG_OUT199(sg_out199),

		.SG_OUT200(sg_out200), .SG_OUT201(sg_out201), .SG_OUT202(sg_out202), .SG_OUT203(sg_out203), .SG_OUT204(sg_out204), .SG_OUT205(sg_out205), .SG_OUT206(sg_out206), .SG_OUT207(sg_out207), .SG_OUT208(sg_out208), .SG_OUT209(sg_out209),
		.SG_OUT210(sg_out210), .SG_OUT211(sg_out211), .SG_OUT212(sg_out212), .SG_OUT213(sg_out213), .SG_OUT214(sg_out214), .SG_OUT215(sg_out215), .SG_OUT216(sg_out216), .SG_OUT217(sg_out217), .SG_OUT218(sg_out218), .SG_OUT219(sg_out219),
		.SG_OUT220(sg_out220), .SG_OUT221(sg_out221), .SG_OUT222(sg_out222), .SG_OUT223(sg_out223), .SG_OUT224(sg_out224), .SG_OUT225(sg_out225), .SG_OUT226(sg_out226), .SG_OUT227(sg_out227), .SG_OUT228(sg_out228), .SG_OUT229(sg_out229),
		.SG_OUT230(sg_out230), .SG_OUT231(sg_out231), .SG_OUT232(sg_out232), .SG_OUT233(sg_out233), .SG_OUT234(sg_out234), .SG_OUT235(sg_out235), .SG_OUT236(sg_out236), .SG_OUT237(sg_out237), .SG_OUT238(sg_out238), .SG_OUT239(sg_out239),
		.SG_OUT240(sg_out240), .SG_OUT241(sg_out241), .SG_OUT242(sg_out242), .SG_OUT243(sg_out243), .SG_OUT244(sg_out244), .SG_OUT245(sg_out245), .SG_OUT246(sg_out246), .SG_OUT247(sg_out247), .SG_OUT248(sg_out248), .SG_OUT249(sg_out249),
		.SG_OUT250(sg_out250), .SG_OUT251(sg_out251), .SG_OUT252(sg_out252), .SG_OUT253(sg_out253), .SG_OUT254(sg_out254), .SG_OUT255(sg_out255), .SG_OUT256(sg_out256), .SG_OUT257(sg_out257), .SG_OUT258(sg_out258), .SG_OUT259(sg_out259),
		.SG_OUT260(sg_out260), .SG_OUT261(sg_out261), .SG_OUT262(sg_out262), .SG_OUT263(sg_out263), .SG_OUT264(sg_out264), .SG_OUT265(sg_out265), .SG_OUT266(sg_out266), .SG_OUT267(sg_out267), .SG_OUT268(sg_out268), .SG_OUT269(sg_out269),
		.SG_OUT270(sg_out270), .SG_OUT271(sg_out271), .SG_OUT272(sg_out272), .SG_OUT273(sg_out273), .SG_OUT274(sg_out274), .SG_OUT275(sg_out275), .SG_OUT276(sg_out276), .SG_OUT277(sg_out277), .SG_OUT278(sg_out278), .SG_OUT279(sg_out279),
		.SG_OUT280(sg_out280), .SG_OUT281(sg_out281), .SG_OUT282(sg_out282), .SG_OUT283(sg_out283), .SG_OUT284(sg_out284), .SG_OUT285(sg_out285), .SG_OUT286(sg_out286), .SG_OUT287(sg_out287), .SG_OUT288(sg_out288), .SG_OUT289(sg_out289),
		.SG_OUT290(sg_out290), .SG_OUT291(sg_out291), .SG_OUT292(sg_out292), .SG_OUT293(sg_out293), .SG_OUT294(sg_out294), .SG_OUT295(sg_out295), .SG_OUT296(sg_out296), .SG_OUT297(sg_out297), .SG_OUT298(sg_out298), .SG_OUT299(sg_out299),

		//.SG_OUT300(sg_out300), .SG_OUT301(sg_out301), .SG_OUT302(sg_out302), .SG_OUT303(sg_out303), .SG_OUT304(sg_out304), .SG_OUT305(sg_out305), .SG_OUT306(sg_out306), .SG_OUT307(sg_out307), .SG_OUT308(sg_out308), .SG_OUT309(sg_out309),
		//.SG_OUT310(sg_out310), .SG_OUT311(sg_out311), .SG_OUT312(sg_out312), .SG_OUT313(sg_out313), .SG_OUT314(sg_out314), .SG_OUT315(sg_out315), .SG_OUT316(sg_out316), .SG_OUT317(sg_out317), .SG_OUT318(sg_out318), .SG_OUT319(sg_out319),
		//.SG_OUT320(sg_out320), .SG_OUT321(sg_out321), .SG_OUT322(sg_out322), .SG_OUT323(sg_out323), .SG_OUT324(sg_out324), .SG_OUT325(sg_out325), .SG_OUT326(sg_out326), .SG_OUT327(sg_out327), .SG_OUT328(sg_out328), .SG_OUT329(sg_out329),
		//.SG_OUT330(sg_out330), .SG_OUT331(sg_out331), .SG_OUT332(sg_out332), .SG_OUT333(sg_out333), .SG_OUT334(sg_out334), .SG_OUT335(sg_out335), .SG_OUT336(sg_out336), .SG_OUT337(sg_out337), .SG_OUT338(sg_out338), .SG_OUT339(sg_out339),
		//.SG_OUT340(sg_out340), .SG_OUT341(sg_out341), .SG_OUT342(sg_out342), .SG_OUT343(sg_out343), .SG_OUT344(sg_out344), .SG_OUT345(sg_out345), .SG_OUT346(sg_out346), .SG_OUT347(sg_out347), .SG_OUT348(sg_out348), .SG_OUT349(sg_out349),
		//.SG_OUT350(sg_out350), .SG_OUT351(sg_out351), .SG_OUT352(sg_out352), .SG_OUT353(sg_out353), .SG_OUT354(sg_out354), .SG_OUT355(sg_out355), .SG_OUT356(sg_out356), .SG_OUT357(sg_out357), .SG_OUT358(sg_out358), .SG_OUT359(sg_out359),
		//.SG_OUT360(sg_out360), .SG_OUT361(sg_out361), .SG_OUT362(sg_out362), .SG_OUT363(sg_out363), .SG_OUT364(sg_out364), .SG_OUT365(sg_out365), .SG_OUT366(sg_out366), .SG_OUT367(sg_out367), .SG_OUT368(sg_out368), .SG_OUT369(sg_out369),
		//.SG_OUT370(sg_out370), .SG_OUT371(sg_out371), .SG_OUT372(sg_out372), .SG_OUT373(sg_out373), .SG_OUT374(sg_out374), .SG_OUT375(sg_out375), .SG_OUT376(sg_out376), .SG_OUT377(sg_out377), .SG_OUT378(sg_out378), .SG_OUT379(sg_out379),
		//.SG_OUT380(sg_out380), .SG_OUT381(sg_out381), .SG_OUT382(sg_out382), .SG_OUT383(sg_out383), .SG_OUT384(sg_out384), .SG_OUT385(sg_out385), .SG_OUT386(sg_out386), .SG_OUT387(sg_out387), .SG_OUT388(sg_out388), .SG_OUT389(sg_out389),
		//.SG_OUT390(sg_out390), .SG_OUT391(sg_out391), .SG_OUT392(sg_out392), .SG_OUT393(sg_out393), .SG_OUT394(sg_out394), .SG_OUT395(sg_out395), .SG_OUT396(sg_out396), .SG_OUT397(sg_out397), .SG_OUT398(sg_out398), .SG_OUT399(sg_out399),

		//.SG_OUT400(sg_out400), .SG_OUT401(sg_out401), .SG_OUT402(sg_out402), .SG_OUT403(sg_out403), .SG_OUT404(sg_out404), .SG_OUT405(sg_out405), .SG_OUT406(sg_out406), .SG_OUT407(sg_out407), .SG_OUT408(sg_out408), .SG_OUT409(sg_out409),
		//.SG_OUT410(sg_out410), .SG_OUT411(sg_out411), .SG_OUT412(sg_out412), .SG_OUT413(sg_out413), .SG_OUT414(sg_out414), .SG_OUT415(sg_out415), .SG_OUT416(sg_out416), .SG_OUT417(sg_out417), .SG_OUT418(sg_out418), .SG_OUT419(sg_out419),
		//.SG_OUT420(sg_out420), .SG_OUT421(sg_out421), .SG_OUT422(sg_out422), .SG_OUT423(sg_out423), .SG_OUT424(sg_out424), .SG_OUT425(sg_out425), .SG_OUT426(sg_out426), .SG_OUT427(sg_out427), .SG_OUT428(sg_out428), .SG_OUT429(sg_out429),
		//.SG_OUT430(sg_out430), .SG_OUT431(sg_out431), .SG_OUT432(sg_out432), .SG_OUT433(sg_out433), .SG_OUT434(sg_out434), .SG_OUT435(sg_out435), .SG_OUT436(sg_out436), .SG_OUT437(sg_out437), .SG_OUT438(sg_out438), .SG_OUT439(sg_out439),
		//.SG_OUT440(sg_out440), .SG_OUT441(sg_out441), .SG_OUT442(sg_out442), .SG_OUT443(sg_out443), .SG_OUT444(sg_out444), .SG_OUT445(sg_out445), .SG_OUT446(sg_out446), .SG_OUT447(sg_out447), .SG_OUT448(sg_out448), .SG_OUT449(sg_out449),
		//.SG_OUT450(sg_out450), .SG_OUT451(sg_out451), .SG_OUT452(sg_out452), .SG_OUT453(sg_out453), .SG_OUT454(sg_out454), .SG_OUT455(sg_out455), .SG_OUT456(sg_out456), .SG_OUT457(sg_out457), .SG_OUT458(sg_out458), .SG_OUT459(sg_out459),
		//.SG_OUT460(sg_out460), .SG_OUT461(sg_out461), .SG_OUT462(sg_out462), .SG_OUT463(sg_out463), .SG_OUT464(sg_out464), .SG_OUT465(sg_out465), .SG_OUT466(sg_out466), .SG_OUT467(sg_out467), .SG_OUT468(sg_out468), .SG_OUT469(sg_out469),
		//.SG_OUT470(sg_out470), .SG_OUT471(sg_out471), .SG_OUT472(sg_out472), .SG_OUT473(sg_out473), .SG_OUT474(sg_out474), .SG_OUT475(sg_out475), .SG_OUT476(sg_out476), .SG_OUT477(sg_out477), .SG_OUT478(sg_out478), .SG_OUT479(sg_out479),
		//.SG_OUT480(sg_out480), .SG_OUT481(sg_out481), .SG_OUT482(sg_out482), .SG_OUT483(sg_out483), .SG_OUT484(sg_out484), .SG_OUT485(sg_out485), .SG_OUT486(sg_out486), .SG_OUT487(sg_out487), .SG_OUT488(sg_out488), .SG_OUT489(sg_out489),
		//.SG_OUT490(sg_out490), .SG_OUT491(sg_out491), .SG_OUT492(sg_out492), .SG_OUT493(sg_out493), .SG_OUT494(sg_out494), .SG_OUT495(sg_out495), .SG_OUT496(sg_out496), .SG_OUT497(sg_out497), .SG_OUT498(sg_out498), .SG_OUT499(sg_out499),

		//.SG_OUT500(sg_out500), .SG_OUT501(sg_out501), .SG_OUT502(sg_out502), .SG_OUT503(sg_out503), .SG_OUT504(sg_out504), .SG_OUT505(sg_out505), .SG_OUT506(sg_out506), .SG_OUT507(sg_out507), .SG_OUT508(sg_out508), .SG_OUT509(sg_out509),
		//.SG_OUT510(sg_out510), .SG_OUT511(sg_out511),

		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

// Instantiation of Axi Bus Interface S_AXI_INTR
	softGlue_300IO_v1_0_S_AXI_INTR # ( 
		.C_S_AXI_DATA_WIDTH(C_S_AXI_INTR_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S_AXI_INTR_ADDR_WIDTH),
		.C_NUM_OF_INTR(C_NUM_OF_INTR),
		.C_INTR_SENSITIVITY(C_INTR_SENSITIVITY),
		.C_INTR_ACTIVE_STATE(C_INTR_ACTIVE_STATE),
		.C_IRQ_SENSITIVITY(C_IRQ_SENSITIVITY),
		.C_IRQ_ACTIVE_STATE(C_IRQ_ACTIVE_STATE)
	) softGlue_300IO_v1_0_S_AXI_INTR_inst (
		.S_AXI_ACLK(s_axi_intr_aclk),
		.S_AXI_ARESETN(s_axi_intr_aresetn),
		.S_AXI_AWADDR(s_axi_intr_awaddr),
		.S_AXI_AWPROT(s_axi_intr_awprot),
		.S_AXI_AWVALID(s_axi_intr_awvalid),
		.S_AXI_AWREADY(s_axi_intr_awready),
		.S_AXI_WDATA(s_axi_intr_wdata),
		.S_AXI_WSTRB(s_axi_intr_wstrb),
		.S_AXI_WVALID(s_axi_intr_wvalid),
		.S_AXI_WREADY(s_axi_intr_wready),
		.S_AXI_BRESP(s_axi_intr_bresp),
		.S_AXI_BVALID(s_axi_intr_bvalid),
		.S_AXI_BREADY(s_axi_intr_bready),
		.S_AXI_ARADDR(s_axi_intr_araddr),
		.S_AXI_ARPROT(s_axi_intr_arprot),
		.S_AXI_ARVALID(s_axi_intr_arvalid),
		.S_AXI_ARREADY(s_axi_intr_arready),
		.S_AXI_RDATA(s_axi_intr_rdata),
		.S_AXI_RRESP(s_axi_intr_rresp),
		.S_AXI_RVALID(s_axi_intr_rvalid),
		.S_AXI_RREADY(s_axi_intr_rready),
		.int_from_logic(int_from_logic),
		.det_intr_wire(det_intr_wire),
		.intr_rising_edge_wire(intr_rising_edge_wire),
		.irq(irq)
	);

	// Add user logic here

	assign softGlueRegClockOut = softGlueRegClock;

	// User logic ends

	endmodule
