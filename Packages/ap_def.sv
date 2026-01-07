/*
This package is built based on my understanding of the specifications.
*/
package ap_pkg;

typedef struct packed {
        logic clz;  // done
                       logic ctz;  // done
                       logic cpop;
                       logic siext_b;
                       logic siext_h;
                       logic min;
                       logic max;
                       logic pack;
                       logic packu;
                       logic packh;
                       logic rol; // done
                       logic ror; // done
                       logic grev;
                       logic gorc;
                       logic zbb;
                       logic bset;
                       logic bclr;
                       logic binv;
                       logic bext;
                       logic sh1add; // done
                       logic sh2add; // done
                       logic sh3add; // done
                       logic zba; // done
                       logic land; // done
                       logic lor; // done
                       logic lxor; // done
                       logic sll; // done
                       logic srl; // done
                       logic sra; // done
                       logic beq;
                       logic bne;
                       logic blt;
                       logic bge;
                       logic add;    // done
                       logic sub;    // done
                       logic slt;    // done
                       logic unsign; // done
                       logic jal;
                       logic predict_t;
                       logic predict_nt;
                       logic csr_write;
                       logic csr_imm;

    
} ap_t;
endpackage // ap_pkg
