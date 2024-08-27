
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY computer IS 
END ENTITY computer;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY alu IS 
	PORT(
		i0 : IN  std_logic_vector(15 DOWNTO 0);
		i1 : IN  std_logic_vector(15 DOWNTO 0);
		op : IN  std_logic_vector(2  DOWNTO 0);
		o0 : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY alu;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY adder_16bit IS
	PORT(
		i0 : IN  std_logic_vector(15 DOWNTO 0);
		i1 : IN  std_logic_vector(15 DOWNTO 0);
		ic : IN  std_logic;
		o0 : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY adder_16bit;
	
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY sll_16bit IS 
	PORT(
		i0 : IN  std_logic_vector(15 DOWNTO 0);
		ic : IN  std_logic_vector(3 DOWNTO 0);
		o0 : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY sll_16bit;


LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY slr_16bit IS 
	PORT(
		i0 : IN  std_logic_vector(15 DOWNTO 0);
		ic : IN  std_logic_vector(3 DOWNTO 0);
		o0 : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY slr_16bit;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY full_adder IS
	PORT(
		i0 : IN  std_logic;
		i1 : IN  std_logic;
		ic : IN  std_logic;
		o0 : OUT std_logic;
		oc : OUT std_logic);
END ENTITY full_adder;


ARCHITECTURE RTL OF full_adder IS 
BEGIN
	o0 <= i0 xor i1 xor ic;
	oc <= (i0 and i1) or (i0 and ic) or (i1 and ic);
END ARCHITECTURE RTL;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY clock IS
	PORT(
		clk : out std_logic);
END ENTITY clock;

ARCHITECTURE clock OF clock IS
BEGIN
	PROCESS IS
		CONSTANT half_period : time := 2 ns;
	BEGIN
		clk <= '0';
		WAIT FOR half_period;
		clk <= '1';
		WAIT FOR half_period;

	END PROCESS;
END ARCHITECTURE;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg_16bit IS 
	PORT(
		clk : IN  std_logic;
		i0  : IN  std_logic_vector(15 DOWNTO 0);
		o0  : OUT std_logic_vector(15 DOWNTO 0);
		we  : IN  std_logic);
END ENTITY reg_16bit;

ARCHITECTURE rtl OF reg_16bit IS
	SIGNAL internal : std_logic_vector(15 DOWNTO 0) := x"0000";
BEGIN
	internal <= i0 WHEN rising_edge(clk) AND we = '1' ELSE internal; 
	o0 <= internal;
END ARCHITECTURE rtl;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY full_adder_test_bench IS 
END ENTITY full_adder_test_bench;


LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY adder_16bit_test_bench IS 
END ENTITY adder_16bit_test_bench;


LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY alu_test_bench IS 
END ENTITY alu_test_bench;


LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg_16bit_tb IS
END ENTITY;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg_file IS 
	PORT(
		r0 : IN  std_logic_vector(2 DOWNTO 0);
		r1 : IN  std_logic_vector(2 DOWNTO 0);

		i0 : IN  std_logic_vector(15 DOWNTO 0);
		o0 : OUT std_logic_vector(15 DOWNTO 0);
		o1 : OUT std_logic_vector(15 DOWNTO 0);

		we : IN  std_logic;
		clk: IN  std_logic);
END ENTITY;


ARCHITECTURE beh OF reg_file IS
	COMPONENT reg_16bit IS
		PORT(
			clk : IN  std_logic;
			i0  : IN  std_logic_vector(15 DOWNTO 0);
			o0  : OUT std_logic_vector(15 DOWNTO 0);
			we  : IN  std_logic);
	END COMPONENT;

	SIGNAL r0i, r0o : std_logic_vector(15 DOWNTO 0);
	SIGNAL r1i, r1o : std_logic_vector(15 DOWNTO 0);
	SIGNAL r2i, r2o : std_logic_vector(15 DOWNTO 0);
	SIGNAL r3i, r3o : std_logic_vector(15 DOWNTO 0);
	SIGNAL r4i, r4o : std_logic_vector(15 DOWNTO 0);
	SIGNAL r5i, r5o : std_logic_vector(15 DOWNTO 0);
	SIGNAL r6i, r6o : std_logic_vector(15 DOWNTO 0);
	SIGNAL r7i, r7o : std_logic_vector(15 DOWNTO 0);

BEGIN
	--                           in   out
	r00: reg_16bit PORT MAP(clk, r0i, r0o, we);
	r01: reg_16bit PORT MAP(clk, r1i, r1o, we);
	r02: reg_16bit PORT MAP(clk, r2i, r2o, we);
	r03: reg_16bit PORT MAP(clk, r3i, r3o, we);
	r04: reg_16bit PORT MAP(clk, r4i, r4o, we);
	r05: reg_16bit PORT MAP(clk, r5i, r5o, we);
	r06: reg_16bit PORT MAP(clk, r6i, r6o, we);
	r07: reg_16bit PORT MAP(clk, r7i, r7o, we);

	WITH r0 SELECT o0 <= 
		r0o WHEN "000",
		r1o WHEN "001",
		r2o WHEN "010",
		r3o WHEN "011",
		r4o WHEN "100",
		r5o WHEN "101",
		r6o WHEN "110",
		r7o WHEN OTHERS;
	
	WITH r1 SELECT o1 <= 
		r0o WHEN "000",
		r1o WHEN "001",
		r2o WHEN "010",
		r3o WHEN "011",
		r4o WHEN "100",
		r5o WHEN "101",
		r6o WHEN "110",
		r7o WHEN OTHERS;

	
	r0i <= i0 WHEN r0 = "000" and we = '1' ELSE r0o;
	r1i <= i0 WHEN r0 = "001" and we = '1' ELSE r1o;
	r2i <= i0 WHEN r0 = "010" and we = '1' ELSE r2o;
	r3i <= i0 WHEN r0 = "011" and we = '1' ELSE r3o;
	r4i <= i0 WHEN r0 = "100" and we = '1' ELSE r4o;
	r5i <= i0 WHEN r0 = "101" and we = '1' ELSE r5o;
	r6i <= i0 WHEN r0 = "110" and we = '1' ELSE r6o;
	r7i <= i0 WHEN r0 = "111" and we = '1' ELSE r7o;
END ARCHITECTURE beh;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg_file_tb IS
END ENTITY;

ARCHITECTURE test of reg_file_tb IS 
	COMPONENT reg_file IS 
		PORT(
			r0 : IN  std_logic_vector(2 DOWNTO 0);
			r1 : IN  std_logic_vector(2 DOWNTO 0);
	
			i0 : IN  std_logic_vector(15 DOWNTO 0);
			o0 : OUT std_logic_vector(15 DOWNTO 0);
			o1 : OUT std_logic_vector(15 DOWNTO 0);
	
			we : IN  std_logic;
			clk: IN  std_logic);
	END COMPONENT;

	signal clk : std_logic;
	
	signal r0, r1 : std_logic_vector(2 DOWNTO 0);
	signal i0, o0, o1 : std_logic_vector(15 DOWNTO 0);

	signal we : std_logic;

BEGIN
	dut: reg_file PORT MAP(r0, r1, i0, o0, o1, we, clk);

	
	PROCESS IS

		TYPE input IS RECORD 
			r0 : std_logic_vector(2 DOWNTO 0);
			r1 : std_logic_vector(2 DOWNTO 0);

			i0 : std_logic_vector(15 DOWNTO 0);

			we : std_logic;
		END RECORD;

		TYPE arr_input IS ARRAY(NATURAL RANGE<>) OF input;

		CONSTANT inputs : arr_input := 
		(("000", "000", x"0000", '1'),
		 ("001", "000", x"0001", '1'),
		 ("010", "000", x"0000", '1'),
		 ("011", "000", x"0010", '1'),
		 ("100", "000", x"0000", '1'),
		 ("101", "000", x"0100", '1'),
		 ("110", "000", x"0000", '1'),
		 ("111", "000", x"1000", '1'),

		 --dummy
		 ("000", "000", x"0000", '1'));
	
	BEGIN

		FOR i in inputs'range LOOP
			clk <= '0';
			r0 <= inputs(i).r0;
			r1 <= inputs(i).r1;

			i0 <= inputs(i).i0;

			we <= inputs(i).we;

			WAIT FOR 5 ns;
			clk <= '1';
			WAIT FOR 5 ns;
		END LOOP;
		
		FOR i in inputs'range LOOP
			clk <= '0';
			r0 <= inputs(i).r1;
			r1 <= inputs(i).r0;

			i0 <= inputs(i).i0;
			
			we <= '0'; 

			WAIT FOR 5 ns;
			clk <= '1';
			WAIT FOR 5 ns;
		END LOOP;

		WAIT;

	END PROCESS;

END ARCHITECTURE test;

ARCHITECTURE test OF reg_16bit_tb IS 
	COMPONENT reg_16bit IS
		PORT(
			clk : IN  std_logic;
			i0  : IN  std_logic_vector(15 DOWNTO 0);
			o0  : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT;

	SIGNAL clk : std_logic;
	SIGNAL i0  : std_logic_vector(15 DOWNTO 0);
	SIGNAL o0  : std_logic_vector(15 DOWNTO 0);

BEGIN
	
	DUT: reg_16bit PORT MAP(clk, i0, o0);

	PROCESS IS 

		TYPE arr_input IS ARRAY(NATURAL RANGE<>) OF std_logic_vector(15 DOWNTO 0);

		CONSTANT inputs : arr_input :=
		(x"FFFF",
		 x"1234",
		 x"0000");

	BEGIN
		FOR i IN inputs'range LOOP
			clk <= '1';
			WAIT FOR 5 ns;
			i0 <= inputs(i);
			clk <= '0';
			WAIT FOR 5 ns;
		END LOOP;

		WAIT;
	END PROCESS;

END ARCHITECTURE test;

ARCHITECTURE test OF full_adder_test_bench IS
	COMPONENT full_adder IS
		PORT (
			i0 : IN  std_logic;
			i1 : IN  std_logic;
			ic : IN  std_logic;
			o0 : OUT std_logic;
			oc : OUT std_logic);
	END COMPONENT;


	SIGNAL i0, i1, ic, o0, oc : std_logic;
BEGIN 
	DUT: full_adder PORT MAP(
		i0 => i0,
		i1 => i1,
		ic => ic,
		o0 => o0,
		oc => oc);
		
	PROCESS IS
		
		TYPE pattern IS RECORD
			i0, i1, ic : std_logic;
			o0, oc : std_logic;
		END RECORD pattern;
		
		TYPE arr_pattern IS ARRAY (NATURAL RANGE<>) OF pattern;
		constant patterns : arr_pattern :=
		(('0', '0', '0', '0', '0'),
		 ('0', '0', '1', '1', '0'),
		 ('0', '1', '0', '1', '0'),
		 ('0', '1', '1', '0', '1'),
		 ('1', '0', '0', '1', '0'),
		 ('1', '0', '1', '0', '1'),
		 ('1', '1', '0', '0', '1'),
		 ('1', '1', '1', '1', '1'));
	BEGIN
		FOR i IN patterns'range lOOP
			i0 <= patterns(i).i0;
			i1 <= patterns(i).i1;
			ic <= patterns(i).ic;

			WAIT FOR 1 ns;

			ASSERT o0 = patterns(i).o0
				REPORT "bad output sum " & integer'image(i) SEVERITY error;
			ASSERT oc = patterns(i).oc
				REPORT "bad output carry " & integer'image(i) SEVERITY error;
		END LOOP;

		WAIT;
	END PROCESS;

END ARCHITECTURE test;

ARCHITECTURE RTL OF adder_16bit IS
	COMPONENT full_adder IS
		PORT (
			i0 : IN  std_logic;
			i1 : IN  std_logic;
			ic : IN  std_logic;
			o0 : OUT std_logic;
			oc : OUT std_logic);
	END COMPONENT;

	--carry birdge to
	SIGNAL cbt : std_logic_vector(15 DOWNTO 0);

BEGIN
	cbt(0) <= ic;

	--                        i0,     i1,     ic,      o0,     oc
	fa00: full_adder PORT MAP(i0(00), i1(00), cbt(00), o0(00), cbt(01));
	fa01: full_adder PORT MAP(i0(01), i1(01), cbt(01), o0(01), cbt(02));
	fa02: full_adder PORT MAP(i0(02), i1(02), cbt(02), o0(02), cbt(03));
	fa03: full_adder PORT MAP(i0(03), i1(03), cbt(03), o0(03), cbt(04));
	fa04: full_adder PORT MAP(i0(04), i1(04), cbt(04), o0(04), cbt(05));
	fa05: full_adder PORT MAP(i0(05), i1(05), cbt(05), o0(05), cbt(06));
	fa06: full_adder PORT MAP(i0(06), i1(06), cbt(06), o0(06), cbt(07));
	fa07: full_adder PORT MAP(i0(07), i1(07), cbt(07), o0(07), cbt(08));
	fa08: full_adder PORT MAP(i0(08), i1(08), cbt(08), o0(08), cbt(09));
	fa09: full_adder PORT MAP(i0(09), i1(09), cbt(09), o0(09), cbt(10));
	fa10: full_adder PORT MAP(i0(10), i1(10), cbt(10), o0(10), cbt(11));
	fa11: full_adder PORT MAP(i0(11), i1(11), cbt(11), o0(11), cbt(12));
	fa12: full_adder PORT MAP(i0(12), i1(12), cbt(12), o0(12), cbt(13));
	fa13: full_adder PORT MAP(i0(13), i1(13), cbt(13), o0(13), cbt(14));
	fa14: full_adder PORT MAP(i0(14), i1(14), cbt(14), o0(14), cbt(15));
	fa15: full_adder PORT MAP(i0(15), i1(15), cbt(15), o0(15), OPEN);
	
END ARCHITECTURE RTL;


ARCHITECTURE test OF adder_16bit_test_bench IS
	COMPONENT adder_16bit IS
		PORT(
			i0 : IN  std_logic_vector(15 DOWNTO 0);
			i1 : IN  std_logic_vector(15 DOWNTO 0);
			ic : IN  std_logic;
			o0 : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT;


	SIGNAL i0, i1, o0 : std_logic_vector(15 DOWNTO 0);

	SIGNAL void : std_logic;
BEGIN
	void <= '0';

	DUT: adder_16bit PORT MAP(
		i0 => i0,
		i1 => i1,
		ic => void, 
		o0 => o0);

	PROCESS IS 
		TYPE pattern IS RECORD
			i0, i1 : std_logic_vector(15 DOWNTO 0);
			o0 : std_logic_vector(15 DOWNTO 0);
		END RECORD pattern;

		TYPE arr_pattern IS ARRAY (NATURAL RANGE<>) OF pattern;
	
		constant patterns : arr_pattern := 
			(("0000000000000000", "0000000000000000", "0000000000000000"),
			 ("0000000000000001", "0000000000000000", "0000000000000001"),
			 ("1111111111111111", "0000000000000001", "0000000000000000"),
			 ("1010101010101010", "0101010101010101", "1111111111111111"),
			 ("1111111100000000", "0000000011111111", "1111111111111111"),
			 ("0000000011111111", "1111111100000001", "0000000000000000"),
			 ("1111111111111111", "1111111111111111", "1111111111111110"),
			 ("1111111111111111", "1111000000001111", "1111000000001110"),
			 ("0000000000000000", "0000000000000000", "0000000000000000"));

	BEGIN
		FOR i IN patterns'range LOOP
			i0 <= patterns(i).i0;
			i1 <= patterns(i).i1;

			WAIT FOR 5 ns;

			ASSERT o0 = patterns(i).o0
				REPORT "invalid output for " & integer'image(i) SEVERITY error;

		END LOOP;

		REPORT "tests done";
		WAIT;
	END PROCESS;
END ARCHITECTURE test;




ARCHITECTURE RTL OF alu IS
	COMPONENT adder_16bit IS
		PORT(
			i0 : IN  std_logic_vector(15 DOWNTO 0);
			i1 : IN  std_logic_vector(15 DOWNTO 0);
			ic : IN  std_logic;
			o0 : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT;


	COMPONENT sll_16bit IS 
		PORT(
			i0 : IN  std_logic_vector(15 DOWNTO 0);
			ic : IN  std_logic_vector(3 DOWNTO 0);
			o0 : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT;
	
	COMPONENT slr_16bit IS 
		PORT(
			i0 : IN  std_logic_vector(15 DOWNTO 0);
			ic : IN  std_logic_vector(3 DOWNTO 0);
			o0 : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT;


	SIGNAL add_res : std_logic_vector(15 DOWNTO 0);
	SIGNAL add_2nd : std_logic_vector(15 DOWNTO 0);

	SIGNAL shf_lft : std_logic_vector(15 DOWNTO 0);
	SIGNAL shf_rgh : std_logic_vector(15 DOWNTO 0);
BEGIN

	add_2nd(00) <= i1(00) xor op(0);
	add_2nd(01) <= i1(01) xor op(0);
	add_2nd(02) <= i1(02) xor op(0);
	add_2nd(03) <= i1(03) xor op(0);
	add_2nd(04) <= i1(04) xor op(0);
	add_2nd(05) <= i1(05) xor op(0);
	add_2nd(06) <= i1(06) xor op(0);
	add_2nd(07) <= i1(07) xor op(0);
	add_2nd(08) <= i1(08) xor op(0);
	add_2nd(09) <= i1(09) xor op(0);
	add_2nd(10) <= i1(10) xor op(0);
	add_2nd(11) <= i1(11) xor op(0);
	add_2nd(12) <= i1(12) xor op(0);
	add_2nd(13) <= i1(13) xor op(0);
	add_2nd(14) <= i1(14) xor op(0);
	add_2nd(15) <= i1(15) xor op(0);


	add: adder_16bit PORT MAP(
		i0 => i0,
		i1 => add_2nd,
		ic => op(0),
		o0 => add_res);

	sl: sll_16bit PORT MAP(
		i0 => i0,
		ic => i1(3 DOWNTO 0),
		o0 => shf_lft);

	sr: slr_16bit PORT MAP(
		i0 => i0,
		ic => i1(3 DOWNTO 0),
		o0 => shf_rgh);

	with op select o0 <=
		  add_res  WHEN "000", --add
		  add_res  WHEN "001", --sub
		   not i1  WHEN "010",
		i0 and i1  WHEN "011",
		i0 or  i1  WHEN "100",
		i0 xor i1  WHEN "101",
		  shf_lft  WHEN "110", 
		  shf_rgh  WHEN "111", 
		  x"FFFF"  WHEN OTHERS;

END ARCHITECTURE RTL;


ARCHITECTURE test OF alu_test_bench IS 
	COMPONENT alu IS 
		PORT(
			i0 : IN  std_logic_vector(15 DOWNTO 0);
			i1 : IN  std_logic_vector(15 DOWNTO 0);
			op : IN  std_logic_vector(2  DOWNTO 0);
			o0 : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT;

	SIGNAL i0, i1, o0 : std_logic_vector(15 DOWNTO 0);
	SIGNAL op         : std_logic_vector(2 DOWNTO 0);
BEGIN 

	DUT: alu PORT MAP(
		i0 => i0,
		i1 => i1,
		op => op,
		o0 => o0);

	PROCESS IS 
		TYPE pattern IS RECORD
			i0, i1 : std_logic_vector(15 DOWNTO 0);
			op : std_logic_vector(2 DOWNTO 0);
			o0 : std_logic_vector(15 DOWNTO 0);
		END RECORD pattern;

		TYPE arr_pattern IS ARRAY(NATURAL RANGE<>) OF pattern;

		constant patterns : arr_pattern := (
			--addition
			(x"0000", x"0000", "000", x"0000"),
			(x"FFFF", x"FFFF", "000", x"FFFE"),
			(x"FFFF", x"0001", "000", x"0000"),
			(x"0001", x"FFFF", "000", x"0000"),
			(x"0001", x"0010", "000", x"0011"),
			--subtraction
			(x"0000", x"0000", "001", x"0000"),
			(x"FFFF", x"FFFF", "001", x"0000"),
			(x"FFFF", x"0001", "001", x"FFFE"),
			(x"0001", x"FFFF", "001", x"0002"),
			(x"1010", x"0101", "001", x"0F0F"),
			--not
			(x"0000", x"0000", "010", x"FFFF"),
			(x"0000", x"FFFF", "010", x"0000"),
			
			--and
			(x"FFFF", x"AAAA", "011", x"AAAA"),
			(x"5555", x"FFFF", "011", x"5555"),
			
			--or 
			(x"5555", x"AAAA", "100", x"FFFF"),
			(x"F00F", x"0000", "100", x"F00F"),
			
			--xor
			(x"5555", x"AAAA", "101", x"FFFF"),
			(x"FFFF", x"FFFF", "101", x"0000"),

			--sll
			(x"5555", x"0001", "110", x"AAAA"),
			(x"FFFF", x"0004", "110", x"FFF0"),
			
			--slr
			(x"AAAA", x"0001", "111", x"5555"),
			(x"FFFF", x"0004", "111", x"0FFF"),


			--dummy to avoid annoyINg comma
			(x"0000", x"0000", "000", x"0000")
		);
	BEGIN
		FOR i IN patterns'range LOOP
			i0 <= patterns(i).i0;
			i1 <= patterns(i).i1;
			op <= patterns(i).op;

			WAIT FOR 5 ns;

			ASSERT o0 = patterns(i).o0 
				REPORT "failed at " & integer'image(i) SEVERITY error;

		END LOOP;
		REPORT "tests done" SEVERITY note;
		WAIT;
	END PROCESS;

END ARCHITECTURE test;


ARCHITECTURE barrel_shifter OF sll_16bit IS
	SIGNAL t0, t1, t2 : std_logic_vector(15 DOWNTO 0);
BEGIN
	t0 <= i0 WHEN ic(0) = '0' ELSE i0(14 DOWNTO 0) &        "0";
	t1 <= t0 WHEN ic(1) = '0' ELSE t0(13 DOWNTO 0) &       "00";
	t2 <= t1 WHEN ic(2) = '0' ELSE t1(11 DOWNTO 0) &     "0000";
	o0 <= t2 WHEN ic(3) = '0' ELSE t2(07 DOWNTO 0) & "00000000";
END ARCHITECTURE barrel_shifter;

ARCHITECTURE barrel_shifter OF slr_16bit IS
	SIGNAL t0, t1, t2 : std_logic_vector(15 DOWNTO 0);
BEGIN
	t0 <= i0 WHEN ic(0) = '0' ELSE        "0" & i0(15 DOWNTO 1);
	t1 <= t0 WHEN ic(1) = '0' ELSE       "00" & t0(15 DOWNTO 2);
	t2 <= t1 WHEN ic(2) = '0' ELSE     "0000" & t1(15 DOWNTO 4);
	o0 <= t2 WHEN ic(3) = '0' ELSE "00000000" & t2(15 DOWNTO 8);
END ARCHITECTURE barrel_shifter;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY is_not_zero IS
	PORT(
		i0 : IN  std_logic_vector(15 DOWNTO 0);
		o0 : OUT std_logic);
END ENTITY is_not_zero;

ARCHITECTURE rtl OF is_not_zero IS
BEGIN
	o0 <= '0' WHEN i0 = x"0000" ELSE '1';
END ARCHITECTURE rtl;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ROM IS
	PORT(
		a0 : IN  std_logic_vector(15 DOWNTO 0);
		o0 : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY ROM;

ARCHITECTURE behavior OF ROM IS
BEGIN
	WITH a0 SELECT o0 <= 
		x"0100" WHEN x"0000",
		x"0301" WHEN x"0001",
		x"0F09" WHEN x"0002",
		x"7F0A" WHEN x"0003",
		x"2100" WHEN x"0004",
		x"0400" WHEN x"0005",
		x"0001" WHEN x"0006",
		x"8202" WHEN x"0007",
		x"9f01" WHEN x"0008",
		x"6f04" WHEN x"0009",
		x"0000" WHEN OTHERS;
END ARCHITECTURE behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY RAM IS
	PORT(
		a0 : IN  std_logic_vector(15 DOWNTO 0);
		i0 : IN  std_logic_vector(15 DOWNTO 0);
		o0 : OUT std_logic_vector(15 DOWNTO 0);

		we : IN  std_logic);
END ENTITY RAM;

ARCHITECTURE behavior OF RAM is 
	TYPE arr IS ARRAY(65535 DOWNTO 0) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL data : arr;
BEGIN
	data(to_integer(unsigned(a0))) <= i0 WHEN we = '1';

	o0 <= data(to_integer(unsigned(a0)));

END ARCHITECTURE behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;


ARCHITECTURE behavior OF computer IS 
	COMPONENT alu IS 
		PORT(
			i0 : IN  std_logic_vector(15 DOWNTO 0);
			i1 : IN  std_logic_vector(15 DOWNTO 0);
			op : IN  std_logic_vector(2  DOWNTO 0);
			o0 : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT alu;

	COMPONENT adder_16bit IS
		PORT(
			i0 : IN  std_logic_vector(15 DOWNTO 0);
			i1 : IN  std_logic_vector(15 DOWNTO 0);
			ic : IN  std_logic;
			o0 : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT adder_16bit;

	COMPONENT reg_16bit IS 
		PORT(
			clk : IN  std_logic;
			i0  : IN  std_logic_vector(15 DOWNTO 0);
			o0  : OUT std_logic_vector(15 DOWNTO 0);
			we  : IN  std_logic);
	END COMPONENT reg_16bit;

	COMPONENT reg_file IS 
		PORT(
			r0 : IN  std_logic_vector(2 DOWNTO 0);
			r1 : IN  std_logic_vector(2 DOWNTO 0);
	
			i0 : IN  std_logic_vector(15 DOWNTO 0);
			o0 : OUT std_logic_vector(15 DOWNTO 0);
			o1 : OUT std_logic_vector(15 DOWNTO 0);
	
			we : IN  std_logic;
			clk: IN  std_logic);
	END COMPONENT;

	COMPONENT is_not_zero IS
		PORT(
			i0 : IN  std_logic_vector(15 DOWNTO 0);
			o0 : OUT std_logic);
	END COMPONENT;

	COMPONENT ROM IS
		PORT(
			a0 : IN  std_logic_vector(15 DOWNTO 0);
			o0 : OUT std_logic_vector(15 DOWNTO 0));
	END COMPONENT ROM;

	COMPONENT RAM IS
		PORT(
			a0 : IN  std_logic_vector(15 DOWNTO 0);
			i0 : IN  std_logic_vector(15 DOWNTO 0);
			o0 : OUT std_logic_vector(15 DOWNTO 0);
	
			we : IN  std_logic);
	END COMPONENT RAM;

	SIGNAL clk : std_logic := '0';


	SIGNAL ipi : std_logic_vector(15 DOWNTO 0);
	SIGNAL ipt : std_logic_vector(15 DOWNTO 0);
	SIGNAL ipo : std_logic_vector(15 DOWNTO 0) := x"0000";
	SIGNAL ipw : std_logic := '0';


	SIGNAL instr : std_logic_vector(15 DOWNTO 0);

	TYPE control IS RECORD 
		src : std_logic_vector(1 DOWNTO 0);
		we  : std_logic;
		st  : std_logic;
		wrw : std_logic;
		jmp : std_logic;
		jnz : std_logic;
		jz  : std_logic;
	END RECORD control;

	SIGNAL consig : control;

	SIGNAL opcode : std_logic_vector(3 DOWNTO 0);
	SIGNAL r0     : std_logic_vector(2 DOWNTO 0);
	SIGNAL r1     : std_logic_vector(2 DOWNTO 0);
	SIGNAL is_imm : std_logic;
	SIGNAL imm8   : std_logic_vector(7 DOWNTO 0);
	SIGNAL aluop  : std_logic_vector(2 DOWNTO 0);


	SIGNAL zero : std_logic := '0';
	SIGNAL one  : std_logic_vector(15 DOWNTO 0) := x"0001";


	SIGNAL d0  : std_logic_vector(15 DOWNTO 0);
	SIGNAL d1  : std_logic_vector(15 DOWNTO 0);

	SIGNAL op2 : std_logic_vector(15 DOWNTO 0);
	SIGNAL res : std_logic_vector(15 DOWNTO 0);
	
	SIGNAL aluout : std_logic_vector(15 DOWNTO 0);
	SIGNAL ramout : std_logic_vector(15 DOWNTO 0);


	SIGNAL inz : std_logic;

BEGIN
	ipr: reg_16bit   PORT MAP(clk, ipi, ipo, ipw); 
	ipa: adder_16bit PORT MAP(ipo, one, zero, ipt);
	irm: ROM         PORT MAP(ipo, instr);
	drm: RAM         PORT MAP(op2, d0, ramout, consig.st);
	rfl: reg_file    PORT MAP(r0, r1,  res, d0, d1, consig.we, clk);  
	aru: alu         PORT MAP(d0, op2, aluop, aluout);
	zer: is_not_zero PORT MAP(d0, inz);

	PROCESS IS
	BEGIN
		clk <= '0';
		WAIT FOR 10 ns;
		clk <= '1';
		WAIT FOR 10 ns;
	END PROCESS;


	PROCESS IS
	BEGIN	
		WAIT UNTIL falling_edge(clk);
		WAIT FOR 5 ns;
		
		
		ipw <= '1';
		WAIT UNTIL rising_edge(clk);
		WAIT FOR 5 ns;
		ipw <= '0';
	END PROCESS;


	opcode <= instr(15 DOWNTO 12);
	r0     <= instr(11 DOWNTO 9);
	is_imm <= instr(8);
	r1     <= instr(2  DOWNTO 0);
	imm8   <= instr(7  DOWNTO 0);
	aluop  <= instr(14 DOWNTO 12);

	WITH opcode SELECT consig <= 
		("00", '1', '0', '0', '0', '0', '0') WHEN x"0",
		("10", '1', '0', '0', '0', '0', '0') WHEN x"1",
		("00", '0', '1', '0', '0', '0', '0') WHEN x"2",
		("11", '1', '0', '0', '0', '0', '0') WHEN x"3",
		("00", '0', '0', '1', '0', '0', '0') WHEN x"4",
		("00", '0', '0', '0', '1', '0', '0') WHEN x"5",
		("00", '0', '0', '0', '0', '1', '0') WHEN x"6",
		("00", '0', '0', '0', '0', '0', '1') WHEN x"7",
		("01", '1', '0', '0', '0', '0', '0') WHEN OTHERS;

	op2 <= x"00" & imm8 WHEN is_imm = '1' ELSE d1;

	WITH consig.src SELECT res <=
		op2  	WHEN "00",   
		aluout	WHEN "01",   --aluout
		ramout  WHEN "10",   --ram
		x"FFF3"	WHEN OTHERS; --unused


	ipi <= op2 WHEN consig.jmp = '1'
	  ELSE op2 WHEN consig.jz  = '1' AND inz = '0' 
	  ELSE op2 WHEN consig.jnz = '1' AND inz = '1'
	  ELSE ipt;


END ARCHITECTURE behavior;
