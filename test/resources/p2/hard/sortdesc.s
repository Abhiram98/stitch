
.globl main
main: 
pushl %ebp 
movl %esp, %ebp 
subl $24, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call create_list
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call inject_big
movl %eax, %esi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
pushl %edi 
pushl %esi 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call create_list
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call inject_big
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
pushl %edi 
pushl -4(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl -4(%ebp), %eax 
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
pushl %ebx 
pushl %esi 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call create_list
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call inject_big
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
pushl %edi 
pushl %ebx 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl %ebx, %eax 
pushl %eax 
pushl $__func2 
call create_closure
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %ebx 
addl $4, %esp 
pushl $10 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl $11 
call inject_int
movl %eax, -16(%ebp) 
addl $4, %esp 
pushl $8 
call inject_int
movl %eax, -20(%ebp) 
addl $4, %esp 
pushl $9 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl $5 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl $4 
call inject_int
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl $6 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call create_list
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call inject_big
movl %eax, -24(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
pushl %edi 
pushl -24(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -16(%ebp) 
pushl %edi 
pushl -24(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $2 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -20(%ebp) 
pushl %edi 
pushl -24(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $3 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
pushl %edi 
pushl -24(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $4 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -8(%ebp) 
pushl %edi 
pushl -24(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $5 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -12(%ebp) 
pushl %edi 
pushl -24(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl -24(%ebp), %esi 
pushl $6 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
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
subl $16, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl 8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else100 
if100: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else101 
if101: 
movl %ebx, %eax 
cmpl 8(%ebp), %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif101 
else101: 
endif101: 
pushl %ebx 
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
pushl %ebx 
call project_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
cmpl %edi, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif102 
else102: 
endif102: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else103 
if103: 
pushl $0 
call inject_bool
movl %eax, -4(%ebp) 
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
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else105 
if105: 
pushl 8(%ebp) 
call project_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %ebx 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl -4(%ebp), %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif105 
else105: 
endif105: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else106 
if106: 
movl %ebx, %eax 
cmpl 8(%ebp), %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif106 
else106: 
endif106: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else107 
if107: 
pushl $0 
call inject_bool
movl %eax, -4(%ebp) 
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
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else109 
if109: 
pushl $0 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif109 
else109: 
endif109: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else110 
if110: 
pushl $0 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif110 
else110: 
endif110: 
pushl %ebx 
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
pushl %ebx 
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
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif111 
else111: 
endif111: 
jmp endif108 
else108: 
endif108: 
endif104: 
endif100: 
movl -4(%ebp), %eax 
movl %eax, -4(%ebp) 
pushl -4(%ebp) 
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
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl 12(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else113 
if113: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else114 
if114: 
movl %ebx, %eax 
cmpl 12(%ebp), %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif114 
else114: 
endif114: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else115 
if115: 
pushl 12(%ebp) 
call project_int
movl %eax, %esi 
addl $4, %esp 
pushl %ebx 
call project_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl %esi, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif115 
else115: 
endif115: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else116 
if116: 
pushl $0 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif116 
else116: 
endif116: 
jmp endif113 
else113: 
pushl 12(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else117 
if117: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else118 
if118: 
pushl 12(%ebp) 
call project_bool
movl %eax, %esi 
addl $4, %esp 
pushl %ebx 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl %esi, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif118 
else118: 
endif118: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else119 
if119: 
movl %ebx, %eax 
cmpl 12(%ebp), %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif119 
else119: 
endif119: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else120 
if120: 
pushl $0 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif120 
else120: 
endif120: 
jmp endif117 
else117: 
pushl 12(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else121 
if121: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else122 
if122: 
pushl $0 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif122 
else122: 
endif122: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else123 
if123: 
pushl $0 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif123 
else123: 
endif123: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else124 
if124: 
pushl 12(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
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
movl %eax, %esi 
addl $4, %esp 
jmp endif124 
else124: 
endif124: 
jmp endif121 
else121: 
endif121: 
endif117: 
endif113: 
pushl %esi 
call is_true
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else125 
if125: 
pushl $0 
call inject_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
jmp endif125 
else125: 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
pushl 16(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl %ebx 
pushl %edi 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl $1 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
negl %eax 
movl %eax, -4(%ebp) 
pushl $1 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
negl %eax 
movl %eax, %esi 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -16(%ebp) 
addl $4, %esp 
pushl %ebx 
pushl 16(%ebp) 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl -16(%ebp) 
pushl %ebx 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl %edi 
call get_fun_ptr
movl %eax, -16(%ebp) 
addl $4, %esp 
pushl 8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else126 
if126: 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else127 
if127: 
pushl 8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif127 
else127: 
pushl -4(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else128 
if128: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif128 
else128: 
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else129 
if129: 
pushl 8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
call project_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif129 
else129: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif129: 
endif128: 
endif127: 
jmp endif126 
else126: 
pushl 8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else130 
if130: 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else131 
if131: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif131 
else131: 
pushl -4(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else132 
if132: 
pushl 8(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
call project_big
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -4(%ebp) 
pushl %edi 
call add
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif132 
else132: 
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else133 
if133: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif133 
else133: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif133: 
endif132: 
endif131: 
jmp endif130 
else130: 
pushl 8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else134 
if134: 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else135 
if135: 
pushl 8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif135 
else135: 
pushl -4(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else136 
if136: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif136 
else136: 
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else137 
if137: 
pushl 8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
call project_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
addl %edi, %eax 
pushl %eax 
call inject_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif137 
else137: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif137: 
endif136: 
endif135: 
jmp endif134 
else134: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif134: 
endif130: 
endif126: 
movl -8(%ebp), %eax 
movl %eax, -8(%ebp) 
pushl 12(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else138 
if138: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else139 
if139: 
pushl 12(%ebp) 
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
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif139 
else139: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else140 
if140: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif140 
else140: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else141 
if141: 
pushl 12(%ebp) 
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
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif141 
else141: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif141: 
endif140: 
endif139: 
jmp endif138 
else138: 
pushl 12(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else142 
if142: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else143 
if143: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif143 
else143: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else144 
if144: 
pushl 12(%ebp) 
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
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif144 
else144: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else145 
if145: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif145 
else145: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif145: 
endif144: 
endif143: 
jmp endif142 
else142: 
pushl 12(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else146 
if146: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else147 
if147: 
pushl 12(%ebp) 
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
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif147 
else147: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else148 
if148: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif148 
else148: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else149 
if149: 
pushl 12(%ebp) 
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
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif149 
else149: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif149: 
endif148: 
endif147: 
jmp endif146 
else146: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif146: 
endif142: 
endif138: 
movl -12(%ebp), %eax 
movl %eax, -12(%ebp) 
pushl %ebx 
call get_free_vars
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl -12(%ebp) 
pushl -8(%ebp) 
call *-16(%ebp)
movl %eax, %edi 
addl $12, %esp 
movl %edi, %eax 
endif125: 
endif112: 
movl %eax, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret


__func2: 
pushl %ebp 
movl %esp, %ebp 
subl $12, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $0 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
negl %eax 
movl %eax, %edi 
pushl 12(%ebp) 
call project_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl %edi 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl -8(%ebp), %eax 
pushl %eax 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
movl %eax, -8(%ebp) 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else251 
if251: 
pushl -8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else252 
if252: 
movl -8(%ebp), %eax 
cmpl %esi, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif252 
else252: 
endif252: 
pushl -8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else253 
if253: 
pushl %esi 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl -4(%ebp), %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif253 
else253: 
endif253: 
pushl -8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else254 
if254: 
pushl $1 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif254 
else254: 
endif254: 
jmp endif251 
else251: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else255 
if255: 
pushl -8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else256 
if256: 
pushl %esi 
call project_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl -4(%ebp), %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif256 
else256: 
endif256: 
pushl -8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else257 
if257: 
movl -8(%ebp), %eax 
cmpl %esi, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif257 
else257: 
endif257: 
pushl -8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else258 
if258: 
pushl $1 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif258 
else258: 
endif258: 
jmp endif255 
else255: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else259 
if259: 
pushl -8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else260 
if260: 
pushl $1 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif260 
else260: 
endif260: 
pushl -8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else261 
if261: 
pushl $1 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif261 
else261: 
endif261: 
pushl -8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else262 
if262: 
pushl %esi 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl -8(%ebp) 
call project_big
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -4(%ebp) 
pushl %edi 
call not_equal
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif262 
else262: 
endif262: 
jmp endif259 
else259: 
endif259: 
endif255: 
endif251: 
movl -4(%ebp), %eax 
movl %eax, -4(%ebp) 
pushl -4(%ebp) 
call is_true
movl %eax, %edi 
addl $4, %esp 
while201: 
movl %edi, %eax 
cmpl $0, %eax 
je endwhile201
loop201: 
pushl $0 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
pushl 16(%ebp) 
call get_subscript
movl %eax, -4(%ebp) 
addl $8, %esp 
pushl %edi 
pushl -4(%ebp) 
call get_subscript
movl %eax, -8(%ebp) 
addl $8, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %edi 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl -4(%ebp), %eax 
pushl %eax 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -12(%ebp) 
pushl 16(%ebp) 
call get_subscript
movl %eax, -12(%ebp) 
addl $8, %esp 
pushl -4(%ebp) 
pushl -12(%ebp) 
call get_subscript
movl %eax, -4(%ebp) 
addl $8, %esp 
pushl -8(%ebp) 
call get_fun_ptr
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl %esi 
pushl 8(%ebp) 
call get_subscript
movl %eax, -12(%ebp) 
addl $8, %esp 
pushl %edi 
pushl 8(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl -4(%ebp) 
call get_free_vars
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -4(%ebp) 
pushl %edi 
pushl -12(%ebp) 
call *-8(%ebp)
movl %eax, %edi 
addl $12, %esp 
pushl %edi 
call is_true
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else263 
if263: 
pushl %esi 
pushl 8(%ebp) 
call get_subscript
movl %eax, -4(%ebp) 
addl $8, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl %edi 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl -8(%ebp), %eax 
pushl %eax 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl 8(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
pushl %esi 
pushl 8(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_int
movl %eax, %esi 
addl $4, %esp 
pushl %edi 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl %esi, %eax 
pushl %eax 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
pushl %edi 
pushl 8(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
negl %eax 
movl %eax, %esi 
jmp endif263 
else263: 
pushl $0 
call inject_int
movl %eax, %eax 
addl $4, %esp 
endif263: 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_int
movl %eax, %esi 
addl $4, %esp 
pushl %edi 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl %esi, %eax 
pushl %eax 
call inject_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %esi 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
negl %eax 
movl %eax, %edi 
pushl 12(%ebp) 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %edi 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl -4(%ebp), %eax 
pushl %eax 
call inject_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, -4(%ebp) 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else264 
if264: 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else265 
if265: 
movl -4(%ebp), %eax 
cmpl %esi, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif265 
else265: 
endif265: 
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else266 
if266: 
pushl %esi 
call project_int
movl %eax, %ebx 
addl $4, %esp 
pushl -4(%ebp) 
call project_bool
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
jmp endif266 
else266: 
endif266: 
pushl -4(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else267 
if267: 
pushl $1 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif267 
else267: 
endif267: 
jmp endif264 
else264: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else268 
if268: 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else269 
if269: 
pushl %esi 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
call project_int
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
jmp endif269 
else269: 
endif269: 
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else270 
if270: 
movl -4(%ebp), %eax 
cmpl %esi, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif270 
else270: 
endif270: 
pushl -4(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else271 
if271: 
pushl $1 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif271 
else271: 
endif271: 
jmp endif268 
else268: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else272 
if272: 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else273 
if273: 
pushl $1 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif273 
else273: 
endif273: 
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else274 
if274: 
pushl $1 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif274 
else274: 
endif274: 
pushl -4(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else275 
if275: 
pushl %esi 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl -4(%ebp) 
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
jmp endif275 
else275: 
endif275: 
jmp endif272 
else272: 
endif272: 
endif268: 
endif264: 
movl %ebx, %eax 
pushl %eax 
call is_true
movl %eax, %edi 
addl $4, %esp 
jmp while201 
endwhile201: 
movl 8(%ebp), %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret

