entity mealy_4s is

	port
	(
		clk		 		: in	std_logic;
		opcode			: in	std_logic_vector(3 downto 0);
		op_type 		: in 	std_logic ;
		reset	 		: in	std_logic;
		carry,zero,valid: in 	std_logic;
		control_store 	: out 	std_logic_vector (19 downto 0);
		data_out		: out	std_logic_vector(1 downto 0)
	);
	
end entity;

architecture rtl of mealy_4s is

	-- Build an enumerated op_type for the state machine
	type state_op_type is (s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19);
	
	-- Register to hold the current state
	signal state, next_state : state_type;

begin

SYNC_PROC : process (clk)
begin
 if rising_edge(clk) then
 if (reset = '1') then
 state <= S1;
 else
 state <= next_state;
 end if;
end process;

CONTROL_STORE_DECODE : process (state)
begin
	case state is
				when s1=>
					control_store <= '10000000010010010001';
					
				when s2=>
					control_store <= '01011010000000000010';
					
				when s3=>
					control_store <= '00101100000000000000';
					
				when s4 =>
					control_store <= '00000000000000000011';	
				
				when s5 =>
					control_store <= '00000000000000000100';	
					
				when s6 =>
					control_store <= '00001000000000001011';	
				
				when s7 =>
					control_store <= '00001100000000110000';	
					
				when s8 =>
					control_store <= '00110100100101000000';	
					
				when s9 =>
					control_store <= '00000000000000000110';	
					
				when s10 =>
					control_store <= '01101000000001010111';	
					
				when s11 =>
					control_store <= '01010000000110000000';	
					
				when s12 =>
					control_store <= '00000000000000001000';	
					
				when s13 =>
					control_store <= '00011000000000000101';	
					
				when s14 =>
					control_stoer <= '00100000001000000100';
					
				when s15 =>
					control_store <= '00100011001010000000';
					
				when s16 =>
					control_store <= '00000000000001010000';	
					
				when s17 =>
					control_store <= '10000000000001100000';	
					
				when s18 =>
					control_store <= '00000100000011101001';	
					
				when s19 =>
					control_store <= '00000000000000001010';	
					
			end case;
			
		end if;
	end process;
NEXT_STATE_DECODE : process (state, opcode,op_type,carry,zero,valid)
begin
	case state is
				when s1=>
					if (opcode = '0000') and ((op_type = '01' and zero = '0') or (op_type = '10' and carry = '0')) then
						state <= s5;
					else if opcode = '0010' and ((op_type = '10' and carry = '0') or (op_type = '01' and zero = '0')) then
						state <= s5;
					else if opcode = '0011' then
						state <= s9;
					else if opcode = '1000' then
						state <= s18;
					else if opcode = '1001' then
						state <= s13;
					else
						state <= s2;
					end if;
					
				when s2=>
					if opcode = '0001' or opcode = '0100' then
						state <= s7;
					else if opcode = '0110' or opcode = '0111' then					then
						state <= s8;
					else 
						state <= s3;
					end if;
				
				when s3=>
					if opcode = '0100' then
						state <= s12;
					if opcode = '1100' then
						if zero = '0' then
							state <= s5;
						else 
							state <= s17;
					else
						state <= s4;
				
				when s4 =>
					state <= s5;
				
				when s5 =>
					state <= s1;
					
				when s6 =>
					state <= s1;
				
				when s7 =>
					if opcode = '0001' then
						state <= s4;
					else if opcode = '0100' then	
						state <= s11;
					else if opcode = '0101' then
						state <= s14;
					end if;
					
				when s8 =>
					if ((opcode = '0110') or (opcode = '0111')) 
						if valid = '0' then
							state <= s5;
						else
							state <= s10;
					end if;
					
				when s9 =>
					state <= s5;
				
				when s10 =>
					if opcode = '0110' then
						state <= s8;
					else if opcode = '0111' then
						state <= s15;
					end if;
					
				when s11 =>
					state <= s3;
					
				when s12 =>
					state <= s5;
					
				when s13 =>
					state <= s6;
					
				when s15 =>
					state <= s16;
					
				when s16 =>
					state <= s8;
				
				when s17 =>
					state <= s5;
					
				when s18 =>
					state <= s19;
				
				when s19 =>
					state <= s1;
									
			end case;
			
		end if;
	end process;