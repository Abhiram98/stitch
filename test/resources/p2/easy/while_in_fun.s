
.globl main
main: 
pushl %ebp 
movl %esp, %ebp 
subl $4, %esp 
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
movl %eax, %ebx 
addl $4, %esp 
call eval_input_pyobj 
movl %eax, %edi 
movl %edi, %eax 
movl %eax, %esi 
call eval_input_pyobj 
movl %eax, %edi 
movl %edi, %eax 
movl %eax, -4(%ebp) 
pushl %ebx 
call get_fun_ptr
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call get_free_vars
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl -4(%ebp) 
pushl %esi 
call *%edi
movl %eax, %edi 
addl $12, %esp 
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
    
pushl 8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else100 
if100: 
pushl 12(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else101 
if101: 
movl 8(%ebp), %ecx 
movl 12(%ebp), %eax 
cmpl %ecx, %eax 
setne %al 
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
pushl 12(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else102 
if102: 
pushl 8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl 12(%ebp) 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl %edi, %eax 
setne %al 
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
pushl 12(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else103 
if103: 
pushl $1 
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
pushl 12(%ebp) 
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
pushl 12(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl %ebx, %eax 
setne %al 
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
pushl 12(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else106 
if106: 
movl 8(%ebp), %ecx 
movl 12(%ebp), %eax 
cmpl %ecx, %eax 
setne %al 
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
pushl 12(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else107 
if107: 
pushl $1 
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
pushl 12(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else109 
if109: 
pushl $1 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif109 
else109: 
endif109: 
pushl 12(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else110 
if110: 
pushl $1 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif110 
else110: 
endif110: 
pushl 12(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else111 
if111: 
pushl 8(%ebp) 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl 12(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
call not_equal
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
while100: 
movl %edi, %eax 
cmpl $0, %eax 
je endwhile100
loop100: 
pushl $1 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl 8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else112 
if112: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else113 
if113: 
pushl 8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_int
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, 8(%ebp) 
addl $4, %esp 
jmp endif113 
else113: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else114 
if114: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif114 
else114: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else115 
if115: 
pushl 8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_bool
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, 8(%ebp) 
addl $4, %esp 
jmp endif115 
else115: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif115: 
endif114: 
endif113: 
jmp endif112 
else112: 
pushl 8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else116 
if116: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else117 
if117: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif117 
else117: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else118 
if118: 
pushl 8(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_big
movl %eax, %esi 
addl $4, %esp 
pushl %esi 
pushl %edi 
call add
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, 8(%ebp) 
addl $4, %esp 
jmp endif118 
else118: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else119 
if119: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif119 
else119: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif119: 
endif118: 
endif117: 
jmp endif116 
else116: 
pushl 8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else120 
if120: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else121 
if121: 
pushl 8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_int
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, 8(%ebp) 
addl $4, %esp 
jmp endif121 
else121: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else122 
if122: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif122 
else122: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else123 
if123: 
pushl 8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_bool
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
addl %edi, %eax 
pushl %eax 
call inject_bool
movl %eax, 8(%ebp) 
addl $4, %esp 
jmp endif123 
else123: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif123: 
endif122: 
endif121: 
jmp endif120 
else120: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif120: 
endif116: 
endif112: 
movl 8(%ebp), %eax 
movl %eax, 8(%ebp) 
pushl %ebx 
call is_true
movl %eax, %edi 
addl $4, %esp 
jmp while100 
endwhile100: 
movl 8(%ebp), %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret

