option casemap:none
WriteConsoleA proto
ReadConsoleA proto
ExitProcess proto
GetStdHandle proto
Sleep proto
.data
characters_writen QWORD ?
handle_input QWORD ?
handle_output QWORD ?
hello DB "Enter String: ",0
M DB 4096 DUP(0)
J QWORD ?
i QWORD ?
c Qword ?
L QWORD ?
C DB 16 DUP(0)
X DB 48 DUP(0)
result DB 32 DUP(0)
S DB 41,46,67,201,162,216,124,1,61,54,84,161,236,240,6,19
  DB 98,167,5,243,192,199,115,140,152,147,43,217,188,76,130,202
  DB 30,155,87,60,253,212,224,22,103,66,111,24,138,23,229,18
  DB 190,78,196,214,218,158,222,73,160,251,245,142,187,47,238,122
  DB 169,104,121,145,21,178,7,63,148,194,16,137,11,34,95,33
  DB 128,127,93,154,90,144,50,39,53,62,204,231,191,247,151,3
  DB 255,25,48,179,72,165,181,209,215,94,146,42,172,86,170,198
  DB 79,184,56,210,150,164,125,182,118,252,107,226,156,116,4,241
  DB 69,157,112,89,100,113,135,32,134,91,207,101,230,45,168,2
  DB 27,96,37,173,174,176,185,246,28,70,97,105,52,64,126,15
  DB 85,71,163,35,221,81,175,58,195,92,249,206,186,197,234,38
  DB 44,83,13,110,133,40,132,9,211,223,205,244,65,129,77,82	
  DB 106,220,55,200,108,193,171,250,36,225,123,8,12,189,177,74
  DB 120,136,149,139,227,99,232,109,233,203,213,254,59,0,29,57
  DB 242,239,183,14,102	,88	,208,228,166,119,114,248,235,117,75,10
  DB 49	,68	,80	,180,143,237,31	,26	,219,153,141,51,159,17,131,20
op DB 3 dup(0)
welcome DB "Message Digest Algorithm 2 (MD2)",10,0
enter_message DB "Enter a message for encrypt hash: ",0
string_encypted DB "The Hash by MD2: ",0
string_ask_again DB 10,"Again ? yes = 1, Other exit",10,0
string_good_bay DB "GOOD BAY",0
.code
	main proc
		mov rcx,-10
		call GetStdHandle
		mov handle_input,rax
		mov rcx,-11
		call GetStdHandle
		mov handle_output,rax
		call play
		mov rcx,5000
		call Sleep
		mov rcx,0
		call ExitProcess
	main endp
	
	print_string proc
		mov rcx,handle_output
		mov rdx,rsi
		mov r8,rbx
		lea r9,characters_writen
		push 0H
		call WriteConsoleA
		pop r9
		ret
	print_string endp

	input_string proc
		mov rcx,handle_input
		mov rdx,rsi
		mov r8,rbx
		lea r9,characters_writen
		push 0H
		call ReadConsoleA
		pop r9
		ret
	input_string endp

	clean_arr proc
		mov rcx,rbx
		run_clean:
			mov byte ptr[rsi],0
			inc rsi
			loop run_clean
		ret
	clean_arr endp
		
	play proc
		mov rsi,offset welcome
		mov rbx,33
		call print_string
		run_play:
			mov rbx,4096
			lea rsi,M
			call clean_arr
			lea rsi,offset enter_message
			mov rbx,34
			call print_string
			lea rsi,M
			mov rbx,4000
			call input_string
			mov rsi,offset M
			call remove_enter_character
			mov rsi,offset string_encypted
			mov rbx,18
			call print_string
			call hash
			mov rsi,offset string_ask_again
			mov rbx,30
			call print_string
			mov rsi,offset op
			mov rbx,3
			call input_string
			cmp op,'1'
			je run_play
		lea rsi,string_good_bay
		mov rbx,9
		call print_string
		ret
	play endp

	len_arr proc
		mov rbx,0
		run_len:
			cmp byte ptr [rsi],0
			je end_len_arr
			inc rsi
			inc rbx
			jmp run_len
		end_len_arr:
		ret
	len_arr endp

	hash proc
		call hash_part1
		call hash_part2
		call hash_part3
		mov rsi,offset result
		mov rbx,32
		call print_string
		ret
	hash endp
	
	hash_part1 proc
		mov rbx,16
		lea rsi,C
		call clean_arr
		mov rbx,48
		lea rsi,X
		call clean_arr
		mov rbx,32
		lea rsi,result
		call clean_arr
		mov L,0
		mov J,0
		mov i,0
		mov c,0
		lea rsi,M
		call len_arr
		mov rax,rbx
		mov rdx,0
		mov rbx,16
		div rbx
		inc rax
		mov J,rax
		mov rbx,16
		mov r11,0
		run_hp1_1:
			mov r12,0
			run_hp1_2:
				mov rdx,0
				mov rax,r11
				mul rbx
				add rax,r12
				lea rsi,M
				add rsi,rax
				mov rax,0
				mov al,[rsi]
				mov c,rax
				xor rax,L
				mov rsi,offset C
				mov rdi,offset S
				add rdi,rax
				add rsi,r12
				mov rax,0
				mov rdx,0
				mov al,[rsi]
				mov dl,[rdi]
				xor al,dl
				mov [rsi],al
				mov L,rax
				inc r12
				cmp r12,16
				jl run_hp1_2
			inc r11
			cmp r11,J
			jl run_hp1_1
		lea rsi,C
		lea rdi,M
		mov rax,J
		mov rdx,0
		mul rbx
		add rdi,rax
		mov rcx,rbx
		run_hp1_3:
			mov al,[rsi]
			mov [rdi],al
			inc rdi
			inc rsi
			loop run_hp1_3
		inc J
		ret
	hash_part1 endp

	hash_part2 proc
		mov rbx,16
		mov r11,0
		run_hp2_1:
			mov r12,0
			run_hp2_2:
				lea rsi,X
				lea rdi,M
				add rsi,16
				add rsi,r12
				mov rax,r11
				mov rdx,0
				mul rbx
				add rax,12
				add rdi,rax
				mov al,[rdi]
				mov [rsi],al
				mov al,[rsi]
				sub rsi,16
				xor al,[rsi]
				add rsi,32
				mov [rsi],al
				inc r12
				cmp r12,16
				jl run_hp2_2
			inc r11
			cmp r11,J
			jl run_hp2_1
		mov rbx,256
		mov r15,0
		mov r11,0
		run_hp2_3:
			mov r12,0
			run_hp2_4:
				lea rsi,X
				lea rdi,S
				add rsi,r12
				add rdi,r15
				mov al,[rsi]
				mov ah,[rdi]
				xor al,ah
				mov [rsi],al
				mov rcx,0
				mov cl,al
				mov r15,rcx
				inc r12
				cmp r12,48
				jl run_hp2_4
			add r15,r11
			mov rax,r15
			mov rdx,0
			div rbx
			mov r15,rdx
			inc r11
			cmp r11,18
			jl run_hp2_3
		ret
	hash_part2 endp

	hash_part3 proc
		lea rsi,X
		lea rdi,result
		mov rbx,16
		run_part3:
			mov al,[rsi]
			shr al,4
			mov [rdi],al
			inc rdi
			mov al,[rsi]
			and al,0FH
			mov [rdi],al
			inc rdi
			inc rsi
			dec rbx
			jnz run_part3
		mov rbx,32
		lea rdi,result
		run_part3_2:
			mov al,[rdi]
			cmp al,10
			jl digit
			add al,55
			jmp end_part3_2
			digit:
			add al,48
			end_part3_2:
			mov [rdi],al
			inc rdi
			dec rbx
			jnz run_part3_2
		ret
	hash_part3 endp
	remove_enter_character proc
		call len_arr
		dec rsi
		mov byte ptr[rsi],0
		dec rsi
		mov byte ptr[rsi],0
		ret
	remove_enter_character endp
end