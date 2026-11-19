.text

    .globl sum_positive_ints
    .type sum_positive_ints, @function
sum_positive_ints:
    movq $0, %rax
    movq $0, %rcx
    .Lsum_loop:
        cmpq %rsi, %rcx
        jge .Lsum_done
        movq %rcx, %rdx
        imulq $4, %rdx
        addq %rdi, %rdx
        movslq (%rdx), %r8
        cmpq $0, %r8
        jle .Lsum_skip
        addq %r8, %rax
    .Lsum_skip:
        addq $1, %rcx
        jmp .Lsum_loop
    .Lsum_done:
        ret

    .globl reverse_longs
    .type reverse_longs, @function
reverse_longs:
    movq $0, %rcx
    movq %rsi, %rdx
    subq $1, %rdx
.Lrev_loop:
    cmpq %rdx, %rcx
    jge .Lrev_done
    movq %rcx, %r8
    imulq $8, %r8
    addq %rdi, %r8
    movq %rdx, %r9
    imulq $8, %r9
    addq %rdi, %r9
    movq (%r8), %r10
    movq (%r9), %r11
    movq %r11, (%r8)
    movq %r10, (%r9)
    addq $1, %rcx
    subq $1, %rdx
    jmp .Lrev_loop
.Lrev_done:
    ret

    .globl sensor_score
    .type sensor_score, @function
sensor_score:
    movslq (%rdi), %rax
    movq 8(%rdi), %rcx
    movslq 16(%rdi), %rdx
    imulq %rdx, %rcx
    addq %rcx, %rax
    ret

    .globl sensor_array_total
    .type sensor_array_total, @function
sensor_array_total:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp
    movq %rdi, -8(%rbp)
    movq %rsi, -16(%rbp)
    movq $0, -24(%rbp)
    movq $0, -32(%rbp)
.Ltotal_loop:
    movq -24(%rbp), %rcx
    cmpq -16(%rbp), %rcx
    jge .Ltotal_done
    movq %rcx, %rdi
    imulq $24, %rdi
    addq -8(%rbp), %rdi
    call sensor_score
    addq %rax, -32(%rbp)
    addq $1, -24(%rbp)
    jmp .Ltotal_loop
.Ltotal_done:
    movq -32(%rbp), %rax
    leave
    ret

    .globl make_arithmetic_sequence
    .type make_arithmetic_sequence, @function
make_arithmetic_sequence:
    cmpq $0, %rdx
    jg .Lseq_alloc
    movq $0, %rax
    ret
.Lseq_alloc:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp
    movq %rdi, -8(%rbp)
    movq %rsi, -16(%rbp)
    movq %rdx, -24(%rbp)
    movq %rdx, %rdi
    imulq $8, %rdi
    call malloc
    cmpq $0, %rax
    je .Lseq_done
    movq $0, %rcx
    movq -8(%rbp), %r8
.Lseq_loop:
    cmpq -24(%rbp), %rcx
    jge .Lseq_done
    movq %rcx, %r9
    imulq $8, %r9
    addq %rax, %r9
    movq %r8, (%r9)
    addq -16(%rbp), %r8
    addq $1, %rcx
    jmp .Lseq_loop
.Lseq_done:
    leave
    ret

    .globl make_sensor
    .type make_sensor, @function
make_sensor:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp
    movq %rdi, -8(%rbp)
    movq %rsi, -16(%rbp)
    movq %rdx, -24(%rbp)
    movq $24, %rdi
    call malloc
    cmpq $0, %rax
    je .Lmake_done
    movq -8(%rbp), %rcx
    movl %ecx, (%rax)
    movq -16(%rbp), %rcx
    movq %rcx, 8(%rax)
    movq -24(%rbp), %rcx
    movl %ecx, 16(%rax)
.Lmake_done:
    leave
    ret

    .globl sensor_destroy
    .type sensor_destroy, @function
sensor_destroy:
    cmpq $0, %rdi
    je .Ldestroy_done
    pushq %rbp
    movq %rsp, %rbp
    call free
    leave
.Ldestroy_done:
    ret

    .section .note.GNU-stack,"",@progbits
