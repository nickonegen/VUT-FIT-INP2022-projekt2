; Autor reseni: Onegen (xkrame00)

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

                .data
login:          .asciiz         "xkrame00"                  ; login
cipher:         .space          17                          ; miesto pre sifrovany login
params_sys5:    .space          8                           ; miesto pre adresu pociatku retazca

                .text
main:           ADDU            R20, R0, R0                 ; R20 = index v retazci (pocitadlo)
encryptLoop:    ; Ulozenie znaku na aktualnom indexe
                LB              R10, login(R20)             ; R10 = ASCII znak na aktualnej pozicii

                ; Ak znak nie je male pismeno (ASCII 97-122), cyklus konci
                SLTI            R1, R10, 96                 ; R1 = 1 ak je ASCII znak < 96, inak R1 = 0
                BNEZ            R1, encryptEnd
                SLTI            R1, R10, 123                ; R1 = 1 ak je ASCII znak < 123, inak R1 = 0
                BEQZ            R1, encryptEnd

                ; Ziskanie hodnoty kluca pre aktualny index a zasifrovanie znaku
                ANDI            R1, R20, 1                  ; R1 = 0 ak je index parny, inak R1 = 1
                BNEZ            R1, keyIfOdd
                ; Parny index - kluc je 'o' (ASCII 111), posun dopredu (+)
                ADDI            R4, R0, 111
                ADDI            R4, R4, -96                 ; R4 = hodnota kluca
                B               keyIfEnd
keyIfOdd:       ; Neparny index - kluc je 'n' (ASCII 110), posun dozadu (-)
                ADDI            R4, R0, 110
                ADDI            R4, R4, -96
                SUB             R4, R0, R4                  ; R4 = hodnota kluca
keyIfEnd:       ; Zasifrovanie znaku
                ADD             R10, R10, R4                ; R10 = ASCII znak sifrovaneho znaku

                ; Kontrola rozsahu malych pismen (1-26)
                ; Znak je mensi ako 'a'
                SLTI            R4, R10, 97                 ; R4 = 0 ak je znak mensi ako 'a', inak R1 = 1
                BEQZ            R4, noUnderflow
                ADDI            R10, R10, 26                ; Underflow correction
                B               noOverflow
noUnderflow:    ; Znak je vacsi ako 'z'
                SLTI            R4, R10, 123                ; R4 = 0 ak je znak vacsi ako 'z', inak R1 = 1
                BNEZ            R4, noOverflow
                ADDI            R10, R10, -26               ; Overflow correction
noOverflow:     ; Koniec kontroly rozsahu

                ; Vlozenie sifrovaneho znaku do vystupneho retazca
                SB              R10, cipher(R20)            ; vlozenie sifrovaneho znaku do vystupneho retazca
                ; Pokracovanie cyklu
                ADDI            R20, R20, 1                 ; R20 = index++
                B               encryptLoop

encryptEnd:     ; Vypis vystupneho retazca
                DADDI           R4, R0, cipher
                JAL             print_string
                SYSCALL         0

print_string:
                SW              R4, params_sys5(R0)
                DADDI           R14, R0, params_sys5
                SYSCALL         5
                JR              R31
