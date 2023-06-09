;; ---------------------------------------------------- ;;
;; ЗАДАНИЕ 15.2                                         ;;
;; Напишите программу, которая в последовательности     ;;
;; натуральных чисел определяет сумму чётных чисел,     ;;
;; меньших 30. Программа получает на вход количество    ;;
;; чисел в последовательности, а затем сами числа. В    ;;
;; последовательности всегда имеется чётное число,      ;;
;; меньшее 30.                                          ;;
;;                                                      ;;
;; Количество чисел не превышает 1000. Введённые числа  ;;
;; не превышают 30 000.                                 ;;
;;                                                      ;;
;; Программа должна вывести одно число: сумму чётных    ;;
;; чисел, меньших 30.                                   ;;
;;                                                      ;;
;; ---------------------------------------------------- ;;
;; ПРИМЕЧАНИЯ К РЕАЛИЗАЦИИ                              ;;
;; - Работает в 32-х битном режиме ос Windows           ;;
;; - Размер одного вводимого числа - 4 байта            ;;
;; - Входной поток начинается с адреса, помеченного как ;;
;;   "input", секции data                               ;;
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
;; Возвращает следующее число из входного потока        ;;
;; Увеличивает edx. Результат в eax.                    ;;
;; ---------------------------------------------------- ;;
next_input:
        mov     eax, [ input + edx ]                    ; Результат в eax
        add     edx, 4                                  ; Увеличиваем индекс
        ret

;; ---------------------------------------------------- ;;
;; Возвращает 1 в случае если число нужно суммировать,  ;;
;; иначе 0.                                             ;;
;; ---------------------------------------------------- ;;
is_target:
        mov     edi, eax                                ; Копируем аргумент в промежуточный регистр
        and     edi, 1                                  ; Смотрим только на последний бит
        test    edi, edi                                ; Ставим флаги
        jnz     .no                                     ; Нечётное - не засчитываем

        cmp     eax, 30                                 ; Сравниваем с 30
        jg      .no                                     ; Если больше - не засчитываем
        
        mov     eax, 1                                  ; Надо суммировать
        ret

.no:
        mov     eax, 0                                  ; Не надо суммировать
        ret

;; ---------------------------------------------------- ;;
;; Точка входа в программу                              ;;
;; ---------------------------------------------------- ;;
_start:
        mov     edx, 0                                  ; Обнуляем индекс
        call    next_input                              ; Получаем количество чисел
        mov     ecx, eax                                ; Сохраняем количество чисел в ecx

.process_begin:                                         ; Начало обработки чисел
        call    next_input                              ; Очередное число
        mov     esi, eax                                ; Сохраняем в промежуточный регистр
        call    is_target                               ; Проверяем число
        cmp     eax, 1                                  ; Ставим флаги
        je      .sum                                    ; Если надо суммировать, переходим к .sum
        jmp     .not_sum                                ; Иначе к .not_sum

.sum:                                                   ; Суммируем
        add     DWORD [ result ], esi

.not_sum:                                               ; Не суммируем
        sub     ecx, 1                                  ; Одно число было проверено, отнимаем
        jnz     .process_begin                          ; Если остались ещё числа, обрабатываем их

.process_end:                                           ; Конец обработки чисел
        int3                                            ; Прерывание для динамического отладчика
        push    0                                       ; Код выхода - 0
        call    ExitProcess                             ; Выходим из программы

section .data
    input : dd 5, 100, 10, 27, 18, 55                   ; Входные данные
    result : dd 0                                       ; Результат работы программы