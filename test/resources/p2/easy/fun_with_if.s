
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
movl %eax, %esi 
addl $4, %esp 
call eval_input_pyobj 
movl %eax, %edi 
movl %edi, %eax 
movl %eax, %ebx 
pushl %esi 
call get_fun_ptr
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call get_free_vars
movl %eax, %esi 
addl $4, %esp 
pushl %esi 
pushl %ebx 
call *%edi
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call is_true
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call is_true
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else0 
if0: 
pushl $10 
call inject_int
movl %eax, %edi 
addl $4, %esp 
jmp endif0 
else0: 
pushl $20 
call inject_int
movl %eax, %edi 
addl $4, %esp 
endif0: 
movl %edi, %eax 
pushl %eax 
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
    
pushl $1 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
pushl 8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else100 
if100: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else101 
if101: 
movl %esi, %eax 
cmpl 8(%ebp), %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif101 
else101: 
endif101: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else102 
if102: 
pushl 8(%ebp) 
call project_int
movl %eax, %ebx 
addl $4, %esp 
pushl %esi 
call project_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl %ebx, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif102 
else102: 
endif102: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else103 
if103: 
pushl $0 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif103 
else103: 
endif103: 
jmp endif100 
else100: 
pushl 8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else104 
if104: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else105 
if105: 
pushl 8(%ebp) 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
pushl %esi 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl %ebx, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif105 
else105: 
endif105: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else106 
if106: 
movl %esi, %eax 
cmpl 8(%ebp), %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif106 
else106: 
endif106: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else107 
if107: 
pushl $0 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif107 
else107: 
endif107: 
jmp endif104 
else104: 
pushl 8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else108 
if108: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else109 
if109: 
pushl $0 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif109 
else109: 
endif109: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else110 
if110: 
pushl $0 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif110 
else110: 
endif110: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else111 
if111: 
pushl 8(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl %edi 
call equal
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif111 
else111: 
endif111: 
jmp endif108 
else108: 
endif108: 
endif104: 
endif100: 
pushl %ebx 
call is_true
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else112 
if112: 
pushl $1 
call inject_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax

jmp endif112 
else112: 
pushl $0 
call inject_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax

endif112: 
popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret

