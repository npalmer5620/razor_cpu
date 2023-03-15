`ifndef OPCODES
    `define OPCODES 1
    
    // Opcodes
    `define OP_LUI       7'b0110111
    `define OP_AUIPC     7'b0010111
    `define OP_JAL       7'b1101111
    `define OP_JALR      7'b1100111
    `define OP_BRANCH    7'b1100011
    `define OP_LOAD      7'b0000011
    `define OP_STORE     7'b0100011
    `define OP_ARITH_IMM 7'b0010011
    `define OP_ARITH     7'b0110011
    `define OP_FENCE     7'b0001111
    `define OP_SYS       7'b1110011
    
    // funct3
    // Branch Instructions
    `define FUNCT_BEQ  3'b000
    `define FUNCT_BNE  3'b001
    `define FUNCT_BLT  3'b100
    `define FUNCT_BGE  3'b101
    `define FUNCT_BLTU 3'b110
    `define FUNCT_BGEU 3'b111
    
    // Load Instructions
    `define FUNCT_LB  3'b000
    `define FUNCT_LH  3'b001
    `define FUNCT_LW  3'b010
    `define FUNCT_LBU 3'b100
    `define FUNCT_LHU 3'b101
    
    // Store Instructions
    `define FUNCT_SB  3'b000
    `define FUNCT_SH  3'b001
    `define FUNCT_SW  3'b010
    
    // Arith Instructions
    `define FUNCT_ADD_SUB 3'b000
    `define FUNCT_SLL  3'b001
    `define FUNCT_SLT  3'b010
    `define FUNCT_SLTU  3'b011
    `define FUNCT_XOR  3'b100
    `define FUNCT_OR  3'b110
    `define FUNCT_AND  3'b111
    `define FUNCT_SRL_SRA  3'b101
    
    

    
    
