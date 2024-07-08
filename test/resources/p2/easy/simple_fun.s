
.globl main
main: 
pushl %ebp 
movl %esp, %ebp 
subl $0, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call create_list
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call inject_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
pushl %eax 
pushl $__func1 
call create_closure
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call get_fun_ptr
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
call get_free_vars
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call *%ebx
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call print_any 
addl $4, %esp 
popl %edi 
popl %esi
popl %ebx
movl $0, %eax 
movl %ebp, %esp 
popl %ebp 
ret


__func1: 
pushl %ebp 
movl %esp, %ebp 
subl $0, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $42 
call inject_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret

