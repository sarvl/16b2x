#include <iostream>
#include <fstream>

#include <vector>
#include <string>

#include <utility> //move

struct Label{
	std::string name;
	int position;

	Label(const std::string& n_name, const int n_pos)
		: name(n_name), position(n_pos) {}
};

struct Instruction{
	char opcode;
	char r0;
	bool is_imm;
	
	union{
		int  imm;
		char r1;
	} second_operand;

	Instruction(const char n_opcode, const char n_r0, const char n_is_imm, const char n_r1, const int n_imm)
		: opcode(n_opcode), r0(n_r0), is_imm(n_is_imm)
	{
		if(is_imm)
			second_operand.imm = n_imm;
		else
			second_operand.r1 = n_r1;
	}
};

void print_Error(const std::string& str, const int line_num)
{
	std::cout << "ERROR: " << str << "\n";
	std::cout << "\tline: " << line_num << '\n';
}

int main(int argc, char* argv[])
{
	if(argc == 1)
	{
		std::cout << "Not Enough Arguments\n";
		return 1;
	}

	std::ifstream read(argv[1]);

	if(read.is_open() == false)
	{
		std::cout << "File Does Not Exist\n";
		return 2;
	}
	
	std::vector<Instruction> instructions;
	std::vector<Label> labels;
	std::vector<Label> to_fill;

	std::string line;
	
	std::vector<std::string> contents;
	int line_num = 0;
	while(std::getline(read, line))
	{
		line_num++;

		contents.clear();
		std::string cur;

		for(int i = 0; i < line.size(); i++)
		{
			if(line[i] == '#')
				break;

			if(line[i] == ' '
			|| line[i] == ','
			|| line[i] == '\t')
			{
				if(cur.size() != 0)
				{
					contents.push_back(std::move(cur));
					cur.clear();
				}
				continue;
			}

			cur += line[i];
		}
		if(cur.size() != 0)
		{
			contents.push_back(std::move(cur));
			cur.clear();
		}

		if(contents.size() == 0)
			continue;

		if(contents[0].back() == ':')
		{
			contents[0].pop_back();
			
			if(contents[0].size() == 0)
			{
				print_Error("label cannot be empty", line_num);
				continue;
			}

			labels.emplace_back(std::move(contents[0]), instructions.size());
			continue;
		}

		char opcode = -1;
		//i dont think there is better method since this is so small
		//hash table would have significant overhead
		     if("mov" == contents[0]) opcode = 0x0;
		else if("ldw" == contents[0]) opcode = 0x1;
		else if("stw" == contents[0]) opcode = 0x2;
		else if("rdw" == contents[0]) opcode = 0x3;
		else if("wrw" == contents[0]) opcode = 0x4;
		else if("jmp" == contents[0]) opcode = 0x5;
		else if("jnz" == contents[0]) opcode = 0x6;
		else if("jz"  == contents[0]) opcode = 0x7;
		else if("add" == contents[0]) opcode = 0x8;
		else if("sub" == contents[0]) opcode = 0x9;
		else if("not" == contents[0]) opcode = 0xA;
		else if("and" == contents[0]) opcode = 0xB;
		else if("or"  == contents[0]) opcode = 0xC;
		else if("xor" == contents[0]) opcode = 0xD;
		else if("sll" == contents[0]) opcode = 0xE;
		else if("slr" == contents[0]) opcode = 0xF;

		if(opcode == -1)
		{
			print_Error("invalid instruction", line_num);
			continue;
		}
		
		if(opcode == 0x5)
		{
			if(contents.size() != 2)
			{
				print_Error("invalid argument count", line_num);
				continue;
			}

			char r0 = 0;
			char r1 = 0;
			int imm = 0;
			bool is_imm = false;
			if(contents[1][0] == 'R'
			|| contents[1][0] == 'r')
			{
				if( 2  != contents[1].size()
				|| '0' >  contents[1][1]
				|| '7' <  contents[1][1])
				{
					print_Error("second argument is not valid register identifier", line_num);
					continue;
				}
				
				r1 = contents[1][1] - '0';
			}
			else
			{
				is_imm = true;
				if(contents[1][0] >= '0'
				&& contents[1][0] <= '9')
				{
					try{
					imm = std::stoi(contents[1]);
					} catch(std::exception& e) {
						print_Error("invalid integer", line_num);
						continue;
					}

					if(imm >= 256)
					{
						print_Error("integer doesnt fit in 8 bits", line_num);
						continue;
					}
				}
				else
				{
					imm = -1;
					to_fill.emplace_back(contents[1], instructions.size());
				}
			}	
		

			instructions.emplace_back(opcode, r0, is_imm, r1, imm);
			continue;
		}
		if(contents.size() != 3)
		{
			print_Error("invalid argument count", line_num);
			continue;
		}
	
		if( 2  != contents[1].size()
		|| ('R' != contents[1][0] && 'r' != contents[1][0])
		|| '0' >  contents[1][1]
		|| '7' <  contents[1][1])
		{
			print_Error("first argument is not valid register identifier", line_num);
			continue;
		}

		char r0 = contents[1][1] - '0';
	
		char r1 = 0;
		int imm = 0;
		bool is_imm = false;
		if(contents[2][0] == 'R'
		|| contents[2][0] == 'r')
		{
			if( 2  != contents[2].size()
			|| '0' >  contents[2][1]
			|| '7' <  contents[2][1])
			{
				print_Error("second argument is not valid register identifier", line_num);
				continue;
			}
			
			r1 = contents[2][1] - '0';
		}
		else
		{
			is_imm = true;
			if(contents[2][0] >= '0'
			&& contents[2][0] <= '9')
			{
				try{
				imm = std::stoi(contents[2]);
				} catch(std::exception& e) {
					print_Error("invalid integer", line_num);
					continue;
				}

				if(imm >= 256)
				{
					print_Error("integer doesnt fit in 8 bits", line_num);
					continue;
				}
			}
			else
			{
				imm = -1;
				to_fill.emplace_back(contents[2], instructions.size());
			}
		}	
		

		instructions.emplace_back(opcode, r0, is_imm, r1, imm);
	}


	//to be changed
	for(int i = 0; i < to_fill.size(); i++)
	{
		for(int j = 0; j < labels.size(); j++)
		{
			if(to_fill[i].name == labels[j].name)
			{
				instructions[to_fill[i].position].second_operand.imm = labels[j].position;

				goto cont;
			}
		}
		print_Error("label not defined", to_fill[i].position);
cont:
		continue;
	}

	std::ofstream write("out.bin");
	write << std::hex;
	for(const auto& instr : instructions)
	{
		write.fill('0');
		write.width(4);
		
		uint32_t out = (static_cast<int>(instr.opcode) << 12)
		             + (static_cast<int>(instr.r0)     <<  9)
					 + (static_cast<int>(instr.is_imm) <<  8);
		
		if(instr.is_imm)
			out += static_cast<int>(instr.second_operand.imm);
		else
			out += static_cast<int>(instr.second_operand.r1);
			
		write << out << '\n';
	}
}
