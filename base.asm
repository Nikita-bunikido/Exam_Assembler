;; ---------------------------------------------------- ;;
;; ФАЙЛ С ОБЪЯСНЕНИЯМИ ИНСТРУКЦИЙ                       ;;
;; Файл НЕ создан для ассемблирования.                  ;;
;;                                                      ;;
;; Каждая инструкция описывается такой структурой :     ;;
;;  МНЕМОНИКА       ОПЕРАНД, ОПЕРАНД, ...               ;;
;;  ПРИМЕР                                  ; КОД НА СИ ;;
;;  ПРИМЕР                                  ; КОД НА СИ ;;
;;                                                      ;;
;; Типы операндов :                                     ;;
;;      r - Register ( Регистр )                        ;;
;;      m - Memory   ( Адрес в памяти )                 ;;
;;      c - Const    ( Константа )                      ;;
;;                                                      ;;
;; Типы данных :                                        ;;
;;      BYTE/db  - БАЙТ ( 1 байт )                      ;;
;;      WORD/dw  - СЛОВО ( 2 байта )                    ;;
;;      DWORD/dd - ДВОЙНОЕ СЛОВО ( 4 байта )            ;;
;;      QWORD/dq - ЧЕТЫРЕ СЛОВА ( 8 байт )              ;;
;; ---------------------------------------------------- ;;

; Однострочные комментарии начинаются с ';'
; Это комментарий
;
; И это тоже
;
;; --------------------------------------- ;;

bits        32

section .text
    global      _start

_start:
        mov     r/m, r/m/c

        mov     eax, 5                  ; eax = 5;
        mov     eax, ebx                ; eax = ebx;
        mov     edx, 10                 ; edx = 10;

        mov     DWORD [ 100 ], eax      ; *(DWORD *)100 = eax;
        mov     DWORD [ eax ], ebx      ; *(DWORD *)eax = ebx;

        mov     eax, [ 100 ]            ; eax = *(DWORD *)100;
        mov     ebx, [ eax ]            ; ebx = *(DWORD *)eax;

        ;; ------------------------------------------------------- ;;

        add     r/m, r/m/c
        sub     r/m, r/m/c              ; Выполняет вычитание, вызов такой же как у add

        add     eax, 5                  ; eax = eax + 5; | eax += 5;
        add     eax, ebx                ; eax = eax + ebx; | eax += ebx;
        add     edx, 10                 ; edx = edx + 10; | edx += 10;

        add     DWORD [ 100 ], eax      ; *(DWORD *)100 += eax;
        add     DWORD [ eax ], ebx      ; *(DWORD *)eax += ebx;

        add     eax, [ 100 ]            ; eax += *(DWORD *)100;
        add     ebx, [ eax ]            ; ebx += *(DWORD *)eax;

        ;; ------------------------------------------------------- ;;

        mul     r/m                     ; Беззнаковое

        mov     eax, 5
        mov     ebx, 10
        mul     ebx                     ; eax = eax * ebx; | eax *= ebx;

        mov     eax, 100
        mov     DWORD [ 10 ], 5
        mul     DWORD [ 10 ]            ; eax = eax * *(DWORD *)10; | eax *= *(DWORD *)10;

        ;; ------------------------------------------------------- ;;

        div     r/m                     ; Беззнаковое

        mov     eax, 5
        mov     ebx, 10
        cdq                             ; edx:eax = eax
        div     ebx                     ; edx:eax = edx:eax / ebx; | edx:eax /= ebx;

        mov     eax, 100
        mov     DWORD [ 10 ], 5
        cdq                             ; edx:eax = eax
        div     DWORD [ 10 ]            ; edx:eax = edx:eax / *(DWORD *)10; | edx:eax /= *(DWORD *)10;

        ;; ------------------------------------------------------- ;;

        cmp     r/m, r/m                ; Устанавливает флаги в регистр флагов

        cmp     eax, edx                ; eax == edx
        cmp     eax, DWORD [ 100 ]      ; eax == *(DWORD *)100
        cmp     eax, 100                ; eax == 100
        cmp     DWORD [ 5 ], ecx        ; *(DWORD *)5 == ecx

        ; Регистр флагов
        ; CF - Carry Flag
        ; PF - Parity Flag
        ; ZF - Zero Flag
        ; SF - Sign Flag
        ; IF - Interrupt Flag           ; Только для прерываний
        ; DF - Direction Flag           ; Для строковых операций
        ; OF - Overflow Flag

        ;; ------------------------------------------------------- ;;

        jmp     address                 ; Без условия

        jmp     10                      ; goto 10;
        jmp     eax                     ; goto eax;
        jmp     100500                  ; goto 100500;

        ;; ------------------------------------------------------- ;;

        jc      address                 ; Условие CF == 1
        jp      address                 ; Условие PF == 1
        jz      address                 ; Условие ZF == 1
        js      address                 ; Условие SF == 1
        jo      address                 ; Условие OF == 1

        jnc     address                 ; Условие CF != 1
        jnp     address                 ; Условие PF != 1
        jnz     address                 ; Условие ZF != 1
        jns     address                 ; Условие SF != 1
        jno     address                 ; Условие OF != 1

        jc      10                      ; if (CF) goto 10;
        jc      eax                     ; if (CF) goto eax;
        jc      100500                  ; if (CF) goto 100500;

        ;; ------------------------------------------------------- ;;

        jecxz   address                 ; Условие ecx == 0

        jecxz   10                      ; if (!ecx) goto 10;

        ;; ------------------------------------------------------- ;;

        push    r/m/c

        push    eax                     ; *--esp = eax;
        push    DWORD [ 100 ]           ; *--esp = *(DWORD *)100;
        push    10                      ; *--esp = *(DWORD *)10;

        ;; ------------------------------------------------------- ;;

        pop     r/m

        pop     eax                     ; eax = *esp++;
        pop     DWORD [ 50 ]            ; *(DWORD *)50 = *esp++;

        ;; ------------------------------------------------------- ;;

        cdq                             ; Конвертирует eax из DWORD в QWORD

        ;; ------------------------------------------------------- ;;

        call    address                 ; Перейти к подпрограмме

        call    10                      ; ((int (*)())10)();
        call    eax                     ; ((int (*)())10)();

        ;; ------------------------------------------------------- ;;

        ret                             ; Возврат из подпрограммы