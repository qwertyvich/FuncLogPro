% Предикат вычисления длины списка
my_length([], 0).
my_length([_|T], X):- my_length(T, X1), X is X1+1.

% Предикат проверки вхождения элемента в список
my_member(X, [X|_]).
my_member(X, [_|T]):- my_member(X, T).

% Предикат конкатенации списков
my_append([], X, X).
my_append([A|X], Y, [A|Z]):- my_append(X, Y, Z).

% Предикат удаления элемента из списка
remove(X, [X|T], T).
remove(X, [Y|T], [Y|T1]):- remove(X, T, T1).

% Предикат перестановок списка
permute([], []).
permute(L, [X|T]):- remove(X, L, R), permute(R, T).

% Предикат подсписка
sublist([], _).
sublist(S, L):- my_append(_, L1, L), my_append(S, _, L1).

% Предикат подсчета количества вхождений элемента в список
counter([], _, 0).
counter([X|T], X, N):- counter(T, X, N1), N is N1+1.
counter([_|T], X, N):- counter(T, X, N).

% Предикат выполнения циклического сдвига списка вправо с использованием стандартных предикатов
shift_right(L, ShiftedL) :-
    append(Init, [Last], L),
    ShiftedL = [Last|Init].

% Циклический сдвиг вправо без использования стандартных предикатов
my_shift_right(L, ShiftedL) :-
    my_reverse(L, RevL),
    my_remove_first(RevL, Last, RevRest),
    my_reverse(RevRest, Init),
    ShiftedL = [Last|Init].

% Предикат переворота списка
my_reverse([], []).
my_reverse([H|T], RevL) :-
    my_reverse(T, RevT),
    my_append(RevT, [H], RevL).

% Предикат удаления первого элемента списка
my_remove_first([H|T], H, T).

% Предикат объединения двух списков (уже определен выше как my_append)

% Предикат нахождения минимального элемента списка с использованием стандартного предиката
find_min(L, Min) :-
    min_list(L, Min).

% Предикат нахождения минимального элемента списка без использования стандартных предикатов
my_min([H|T], Min) :-
    my_min(T, H, Min).

% Вспомогательный предикат для my_min/2
my_min([], Min, Min).
my_min([H|T], CurrentMin, Min) :-
    ( H < CurrentMin ->
        NewMin = H
    ;
        NewMin = CurrentMin
    ),
    my_min(T, NewMin, Min).


% Предикат вращения списка до появления минимального элемента на первом месте
rotate_to_min(L, Result) :-
    my_min(L, Min),
    rotate_to_min_helper(L, Min, Result).

% Вспомогательный предикат %rotate_to_min([4, 2, 5, 1, 3], Result).
rotate_to_min_helper([Min|Rest], Min, [Min|Rest]) :- !.
rotate_to_min_helper(L, Min, Result) :-
    shift_right(L, ShiftedL),
    rotate_to_min_helper(ShiftedL, Min, Result).