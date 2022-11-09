; Autor reseni: Onegen (xkrame00)

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; Moje registre
; R0  ($zero) - nulova konstanta
; R1  ($at)   - unsafe temp.      - pomocny register
; R4  ($a0)   - function arg.     - ukazatel na retazec
; R10 ($t2)   - temp. reg.        - pomocny register
; R20 ($s4)   - saved reg.        - index v retazci (pocitadlo)
; R29 ($sp)   - stack pointer


; DATA SEGMENT
                .data
login:          .asciiz         "xkrame00"                  ; login
key:            .asciiz         "on"                        ; sifrovaci kluc
cipher:         .space          17                          ; miesto pre sifrovany login
params_sys5:    .space          8                           ; miesto pre adresu pociatku retazca

; CODE SEGMENT
                .text
main:
                DADDI           R4, R0, login               ; R4 = adresa retazca na sifrovanie
                DADDI           R20, R0, 0                  ; R20 = index v retazci (pocitadlo)

encryptLoop:
                ANDI            R1, R20, 1                  ; R1 = 0 ak je index parny, inak R1 = 1
                DADDI           R10, R0, key                ; R10 = adresa kluca
                ADD             R1, R1, R10
                LB              R10, 0(R1)                  ; R10 = znak kluca na pozicii R1

end:
                JAL             print_string
                SYSCALL         0

print_string:
                SW              R4, params_sys5(r0)
                DADDI           R14, R0, params_sys5
                SYSCALL         5
                JR              R31
