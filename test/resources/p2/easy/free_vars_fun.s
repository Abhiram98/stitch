
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
movl %esi, %ebx 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $1 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl %esi 
call create_list
movl %eax, %esi 
addl $4, %esp 
pushl %esi 
call inject_big
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl %edi 
pushl %esi 
pushl -4(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl -4(%ebp), %eax 
movl %eax, -4(%ebp) 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $2 
call inject_int
movl %eax, %esi 
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
pushl $3 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %esi 
pushl -4(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $2 
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
pushl -4(%ebp) 
pushl %edi 
pushl %esi 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
pushl %edi 
pushl %esi 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl %esi, %eax 
pushl %eax 
pushl $__func1 
call create_closure
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %eax 
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
subl $8, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %edi 
pushl 8(%ebp) 
call get_subscript
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
pushl 8(%ebp) 
call get_subscript
movl %eax, %esi 
addl $8, %esp 
pushl -4(%ebp) 
pushl -8(%ebp) 
call get_subscript
movl %eax, -4(%ebp) 
addl $8, %esp 
pushl %edi 
pushl %esi 
call get_subscript
movl %eax, %esi 
addl $8, %esp 
pushl -4(%ebp) 
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
pushl -4(%ebp) 
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
jmp endif101 
else101: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else102 
if102: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif102 
else102: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else103 
if103: 
pushl -4(%ebp) 
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
jmp endif103 
else103: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif103: 
endif102: 
endif101: 
jmp endif100 
else100: 
pushl -4(%ebp) 
call is_big
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
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif105 
else105: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else106 
if106: 
pushl -4(%ebp) 
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
jmp endif106 
else106: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else107 
if107: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif107 
else107: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif107: 
endif106: 
endif105: 
jmp endif104 
else104: 
pushl -4(%ebp) 
call is_bool
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
pushl -4(%ebp) 
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
jmp endif109 
else109: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else110 
if110: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif110 
else110: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else111 
if111: 
pushl -4(%ebp) 
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
jmp endif111 
else111: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif111: 
endif110: 
endif109: 
jmp endif108 
else108: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif108: 
endif104: 
endif100: 
movl %ebx, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret

