
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
movl %eax, %esi 
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
pushl $0 
call inject_int
movl %eax, %esi 
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
pushl %ebx 
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
pushl %esi 
pushl %ebx 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
call get_subscript
movl %eax, %esi 
addl $8, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl %esi 
call get_fun_ptr
movl %eax, %esi 
addl $4, %esp 
pushl $6 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
call get_free_vars
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
call *%esi
movl %eax, %edi 
addl $8, %esp 
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
movl %eax, -12(%ebp) 
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
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_bool
movl %eax, -12(%ebp) 
addl $4, %esp 
movl -12(%ebp), %eax 
cmpl %edi, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -12(%ebp) 
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
movl %eax, -12(%ebp) 
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
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl %esi 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl -12(%ebp), %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -12(%ebp) 
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
movl %eax, -12(%ebp) 
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
movl %eax, -12(%ebp) 
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
movl %eax, -12(%ebp) 
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
movl %eax, -12(%ebp) 
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
movl %eax, %esi 
addl $4, %esp 
pushl %esi 
pushl %edi 
call equal
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_bool
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif111 
else111: 
endif111: 
jmp endif108 
else108: 
endif108: 
endif104: 
endif100: 
movl -12(%ebp), %eax 
movl %eax, -12(%ebp) 
pushl -12(%ebp) 
call is_true
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call is_true
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else112 
if112: 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
jmp endif112 
else112: 
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
je else113 
if113: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else114 
if114: 
movl %esi, %eax 
cmpl 8(%ebp), %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -16(%ebp) 
addl $4, %esp 
jmp endif114 
else114: 
endif114: 
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
movl %eax, -12(%ebp) 
addl $4, %esp 
movl -12(%ebp), %eax 
cmpl %edi, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -16(%ebp) 
addl $4, %esp 
jmp endif115 
else115: 
endif115: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else116 
if116: 
pushl $0 
call inject_bool
movl %eax, -16(%ebp) 
addl $4, %esp 
jmp endif116 
else116: 
endif116: 
jmp endif113 
else113: 
pushl 8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else117 
if117: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else118 
if118: 
pushl 8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_int
movl %eax, -12(%ebp) 
addl $4, %esp 
movl -12(%ebp), %eax 
cmpl %edi, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -16(%ebp) 
addl $4, %esp 
jmp endif118 
else118: 
endif118: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else119 
if119: 
movl %esi, %eax 
cmpl 8(%ebp), %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -16(%ebp) 
addl $4, %esp 
jmp endif119 
else119: 
endif119: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else120 
if120: 
pushl $0 
call inject_bool
movl %eax, -16(%ebp) 
addl $4, %esp 
jmp endif120 
else120: 
endif120: 
jmp endif117 
else117: 
pushl 8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else121 
if121: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else122 
if122: 
pushl $0 
call inject_bool
movl %eax, -16(%ebp) 
addl $4, %esp 
jmp endif122 
else122: 
endif122: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else123 
if123: 
pushl $0 
call inject_bool
movl %eax, -16(%ebp) 
addl $4, %esp 
jmp endif123 
else123: 
endif123: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else124 
if124: 
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
call equal
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_bool
movl %eax, -16(%ebp) 
addl $4, %esp 
jmp endif124 
else124: 
endif124: 
jmp endif121 
else121: 
endif121: 
endif117: 
endif113: 
movl -16(%ebp), %eax 
movl %eax, -16(%ebp) 
pushl -16(%ebp) 
call is_true
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call is_true
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else125 
if125: 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
jmp endif125 
else125: 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
negl %eax 
movl %eax, %esi 
pushl 8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else126 
if126: 
pushl %esi 
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
pushl %esi 
call project_int
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif127 
else127: 
pushl %esi 
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
pushl %esi 
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
pushl %esi 
call project_bool
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
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
pushl %esi 
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
pushl %esi 
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
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif132 
else132: 
pushl %esi 
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
pushl %esi 
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
pushl %esi 
call project_int
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif135 
else135: 
pushl %esi 
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
pushl %esi 
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
pushl %esi 
call project_bool
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
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
pushl $2 
call inject_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
negl %eax 
movl %eax, %esi 
pushl 8(%ebp) 
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
pushl 8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, %ebx 
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
pushl 8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, %ebx 
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
pushl 8(%ebp) 
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
call add
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %ebx 
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
pushl 8(%ebp) 
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
pushl 8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, %ebx 
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
pushl 8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_bool
movl %eax, %ebx 
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
pushl $0 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
pushl 12(%ebp) 
call get_subscript
movl %eax, %esi 
addl $8, %esp 
pushl %edi 
pushl %esi 
call get_subscript
movl %eax, -12(%ebp) 
addl $8, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl %edi 
pushl 12(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl %esi 
pushl %edi 
call get_subscript
movl %eax, %esi 
addl $8, %esp 
pushl -12(%ebp) 
call get_fun_ptr
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call get_free_vars
movl %eax, %esi 
addl $4, %esp 
pushl %esi 
pushl -8(%ebp) 
call *%edi
movl %eax, -8(%ebp) 
addl $8, %esp 
pushl $0 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
pushl 12(%ebp) 
call get_subscript
movl %eax, %esi 
addl $8, %esp 
pushl %edi 
pushl %esi 
call get_subscript
movl %eax, -12(%ebp) 
addl $8, %esp 
pushl $0 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
pushl 12(%ebp) 
call get_subscript
movl %eax, %esi 
addl $8, %esp 
pushl %edi 
pushl %esi 
call get_subscript
movl %eax, %esi 
addl $8, %esp 
pushl -12(%ebp) 
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
movl %eax, %ebx 
addl $8, %esp 
pushl -8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else150 
if150: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else151 
if151: 
pushl -8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call project_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif151 
else151: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else152 
if152: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif152 
else152: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else153 
if153: 
pushl -8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif153 
else153: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif153: 
endif152: 
endif151: 
jmp endif150 
else150: 
pushl -8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else154 
if154: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else155 
if155: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif155 
else155: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else156 
if156: 
pushl -8(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl %edi 
call add
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif156 
else156: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else157 
if157: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif157 
else157: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif157: 
endif156: 
endif155: 
jmp endif154 
else154: 
pushl -8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else158 
if158: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else159 
if159: 
pushl -8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call project_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif159 
else159: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else160 
if160: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif160 
else160: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else161 
if161: 
pushl -8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif161 
else161: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif161: 
endif160: 
endif159: 
jmp endif158 
else158: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif158: 
endif154: 
endif150: 
movl -4(%ebp), %eax 
movl %eax, -4(%ebp) 
movl -4(%ebp), %edi 
endif125: 
endif112: 
movl %edi, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret

