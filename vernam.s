; Autor reseni: Onegen (xkrame00)

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; Moje registre
; R0  ($zero) - nulova konstanta
; R1  ($at)   - assembler temp.
; R4  ($a0)   - function arg.
; R10 ($t2)   - temp. reg.
; R20 ($s4)   - saved reg.
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
                ; Ziskanie hodnoty kluca pre aktualny index
                ANDI            R1, R20, 1                  ; R1 = 0 ak je index parny, inak R1 = 1
                DADDI           R10, R0, key                ; R10 = adresa kluca
                ADD             R1, R1, R10
                LB              R10, 0(R1)                  ; R10 = ASCII znak kluca na pozicii R1
                DADDI           R10, R10, -96               ; R10 = hodnota kluca

                ; Scitanie hodnoty kluca s aktualnym ASCII znakom v retazci
                DADDI           R4, R0, login               ; R4 = adresa retazca na sifrovanie
                ADD             R1, R4, R20
                LB              R1, 0(R1)                   ; R1 = ASCII znak na aktualnej pozicii
                ADD             R10, R10, R1                ; R10 = ASCII znak na aktualnej pozicii + hodnota kluca
                ; Ak je vysledok mimo rozsah ASCII malych pismen (97-122), tak sa znak posunie o 26 znakov
                XOR             R4, R4, R4                  ; R4 = 0
                DADDI           R10, R10, -122
                SLTI            R4, R10, 1
                XORI            R4, R4, 1                   ; R4 = 1 ak je vysledok mimo rozsahu, inak R4 = 0
                DADDI           R1, R0, -26
                DMULT           R4, R1
                MFLO            R4                          ; R4 = -26 ak je vysledok mimo rozsahu, inak R4 = 0
                DADDI           R10, R10, 122               ; R10 = povodny sifrovany znak
                DADD            R10, R10, R4                ; R10 = sifrovany znak s modulom

end:
                JAL             print_string
                SYSCALL         0

print_string:
                SW              R4, params_sys5(r0)
                DADDI           R14, R0, params_sys5
                SYSCALL         5
                JR              R31
