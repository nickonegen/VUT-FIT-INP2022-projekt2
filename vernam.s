; Autor reseni: Onegen (xkrame00)

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; DATA SEGMENT
               .data
login:         .asciiz        "xkrame00"               ; sem doplnte vas login
cipher:        .space         17                       ; misto pro zapis sifrovaneho loginu
params_sys5:   .space         8                        ; misto pro ulozeni adresy pocatku
                                                       ; retezce pro vypis pomoci syscall 5
                                                       ; (viz nize "funkce" print_string)

; CODE SEGMENT
               .text
main:          DADDI          R4, R0, login            ; vzorovy vypis: adresa login: do r4
               JAL            print_string             ; vypis pomoci print_string - viz nize


               SYSCALL        0                        ; halt

print_string:                                          ; adresa retezce se ocekava v r4
               SW             R4, params_sys5(r0)
               DADDI          R14, R0, params_sys5     ; adr pro syscall 5 musi do r14
               SYSCALL        5                        ; systemova procedura - vypis retezce na terminal
               JR             R31                      ; return - r31 je urcen na return address
