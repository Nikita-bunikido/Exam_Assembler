;; ---------------------------------------------------- ;;
;; ЗАДАНИЕ 15.2                                         ;;
;; Напишите программу, которая для введённого           ;;
;; натурального числа N (N > 2) определяет максимальное ;;
;; число M, так что 2^M < N. Программа получает на вход ;;
;; десятичное число.                                    ;;
;;                                                      ;;
;; Введённое число не превышает 30 000.                 ;;
;;                                                      ;;
;; Программа должна вывести одно число: максимальное    ;;
;; число M, удовлетворяющее условию 2^M < N.            ;;
;;                                                      ;;
;; ---------------------------------------------------- ;;
;; ПРИМЕЧАНИЯ К РЕАЛИЗАЦИИ                              ;;
;; - Работает в 32-х битном режиме ос Windows           ;;
;; - Размер вводимого числа - 4 байта                   ;;
;; - Входное число находится в ячейке размером 4 байта, ;;
;;   с адресом помеченным как dest, секции data         ;;
;; - Результат программы по завершению сохраняется в    ;;
;;   ячейку размером 4 байта, с адресом помеченным как  ;;
;;   "result", секции data                              ;;
;; - В реализации отсутствует проверка на диапозон      ;;
;;   ( не обязательна )                                 ;;
;;                                                      ;;
;; ---------------------------------------------------- ;;

bits        32                                          ; Работаем в 32-х битном режиме

section     .text
    global      _start                                  ; Глобальный символ точки входа

extern      ExitProcess                                 ; Подключаем символ из kernel32.dll

;; ---------------------------------------------------- ;;
;; Возвращает 2 в степени eax                           ;;
;; ---------------------------------------------------- ;;
power_two:
        cmp     eax, 1                                  ; Сравниваем аргумент с 1
        je      .done                                   ; Если степень 1, то возвращаем 2

        mov     ecx, eax                                ; Сохраняем степень в ecx
        sub     ecx, 2
        mov     eax, 2                                  ; Начинаем с двойки
        mov     ebx, 2                                  ; Множитель - 2

.power_loop:                                            ; Цикл вычисления степени
        mul     ebx                                     ; eax *= 2
        test    ecx, ecx                                ; Если итерации закончились
        jz      .power_loop_end                         ; То выходим из цикла
        sub     ecx, 1                                  ; Уменьшаем итерации на одну
        jmp     .power_loop                             ; Следующая итерация

.power_loop_end:                                        ; Конец цикла вычисления степени
        ret

.done:
        mov     eax, 2                                  ; Результат - 2
        ret

;; ---------------------------------------------------- ;;
;; Точка входа в программу                              ;;
;; ---------------------------------------------------- ;;
_start:
        mov     eax, 1                                  ; Начинаем с первой степени

.loop:
        push    eax                                     ; Сохраняем предыдущий eax в стек
        call    power_two                               ; Вычисляем степень двойки
        cmp     eax, DWORD [ dest ]                     ; Сравниваем с исходным числом
        jg      .loop_end                               ; Выходим из цикла если больше
        pop     eax                                     ; Возвращаем eax из стека
        add     eax, 1                                  ; Берём следующую степень
        jmp     .loop                                   ; Следующая итерация

.loop_end:
        pop     eax                                     ; Возвращаем eax из стека
        sub     eax, 1                                  ; Уменьшаем результат
        mov     DWORD [ result ], eax                   ; Сохраняем

        int3                                            ; Прерывание для динамического отладчика
        push    0                                       ; Код выхода - 0
        call    ExitProcess                             ; Выходим из программы

section .data
        dest   : dd 69
        result : dd 0