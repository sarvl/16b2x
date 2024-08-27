#include <iostream>
#include <fstream>

#include <string>
#include <vector>

#include <cstring> //memset


#define MOV 0x0
#define LDW 0x1
#define STW 0x2
#define RDW 0x3
#define WRW 0x4
#define JMP 0x5
#define JNZ 0x6
#define JZ  0x7
#define ADD 0x8
#define SUB 0x9
#define NOT 0xA
#define AND 0xB
#define OR  0xC
#define XOR 0xD
#define SLL 0xE
#define SLR 0xF


int hex_val(const char hex)
{
	if(hex <= '9')
		return hex - '0';
	else
		return hex - 'a' + 10;
}

struct Instruction{
	uint8_t opcode;
	uint8_t r0;
	bool is_imm;
	
	union{
		uint8_t imm;
		uint8_t r1;
	} second_operand;

	Instruction(const uint8_t n_opcode, const uint8_t n_r0, const uint8_t n_is_imm, const uint8_t n_r1, const uint8_t n_imm)
		: opcode(n_opcode), r0(n_r0), is_imm(n_is_imm)
	{
		if(is_imm)
			second_operand.imm = n_imm;
		else
			second_operand.r1 = n_r1;
	}
};

uint16_t memory[0x10000];
uint16_t registers[0x8];

int main(int argc, char* argv[])
{
	if(argc < 2)
	{
		std::cout << "not enough arguments\n";
		return 1;
	}

	std::ifstream read(argv[1]);
	if(false == read.is_open())
	{
		std::cout << "file does not exist\n";
		return 2;
	}

	memset(memory,    0, sizeof(memory));
	memset(registers, 0, sizeof(registers));
	std::vector<Instruction> instructions;

	std::string line;
	while(std::getline(read, line))
	{
		uint8_t opcode = hex_val(line[0]);
		uint8_t r0     = hex_val(line[1]) >> 1;
		bool    is_imm = hex_val(line[1]) & 0b1;
		uint8_t r1     = hex_val(line[3]);
		uint8_t imm    = (hex_val(line[2]) << 4)
		               + (hex_val(line[3]) << 0);


		instructions.emplace_back(opcode, r0, is_imm, r1, imm);

	//	std::cout << static_cast<int>(opcode) << ' '
	//	          << static_cast<int>(r0)     << ' ' 
	//	          << static_cast<int>(is_imm) << ' ';
	//	if(is_imm)
	//		std::cout << static_cast<int>(imm);
	//	else
	//		std::cout << static_cast<int>(r1);
	//	std::cout << '\n';
	}

	int instruction_pointer = 0;


	while(instruction_pointer < instructions.size())
	{

		const auto& instr = instructions[instruction_pointer];

		const int first = instr.r0;
		const int secnd = instr.is_imm ? instr.second_operand.imm : registers[instr.second_operand.r1];

		std::cout << instruction_pointer << ' ' << static_cast<int>(instr.opcode) << '\n';
		
		switch(instr.opcode)
		{
		case MOV:
			registers[first] = secnd;
			break;
		case LDW: 
			registers[first] = memory[secnd];
			break;
		case STW: 
			memory[secnd] = registers[first];
			break;
		case RDW:
			//no effect for now
			break;
		case WRW: 
			//no effect for now
			break;
		case JMP: 
			instruction_pointer = secnd;
			continue;
		case JNZ:
			if(0 != registers[first]) 
			{
				instruction_pointer = secnd;
				continue;
			}
			break;
		case JZ: 
			if(0 == registers[first]) 
			{
				instruction_pointer = secnd;
				continue;
			}
			break;
		case ADD:
			registers[first] += secnd;
			break;
		case SUB: 
			registers[first] -= secnd;
			break;
		case NOT: 
			registers[first] = ~secnd;
			break;
		case AND: 
			registers[first] &= secnd;
			break;
		case OR: 
			registers[first] |= secnd;
			break;
		case XOR: 
			registers[first] ^= secnd;
			break;
		case SLL: 
			registers[first] <<= secnd;
			break;
		case SLR: 
			registers[first] >>= secnd;
			break;
		}

		instruction_pointer++;

//		std::cin.get();
	}

	std::cout << memory[0] << '\n';
}
