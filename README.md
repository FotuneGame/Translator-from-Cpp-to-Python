# Команды для запуска
> перед запуском установите bison, flex, minGW

1) Для main.tab.c и main.tab.h
'''bison -d -v main.y'''

2) Для создания lex.yy.c
'''flex main.l'''

3) Компилируем транслятор
'''gcc lex.yy.c main.tab.c -o [translator-name]'''

4) Запуск транслятора
'''./[translator-name] [-d] [input-file.cpp]'''
> путь до транслятора [translator-name]
> Флаг [-d] отвечает за режим отладки
> путь до входного C++ фалйа [input-file.cpp]
