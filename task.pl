% task.pl

% Операции перемещения
prolong([X|T], [Y,X|T]) :- move(X,Y), not(member(Y, [X|T])).

% поиск в глубину 
dfs_path([X|T], X, [X|T]).
dfs_path(Path, Y, ResultPath) :- 
    prolong(Path, NewPath), 
    dfs_path(NewPath, Y, ResultPath).
dfs(Method, Goal, Path) :- 
    dfs_path([Method], Goal, Path).

% поиск в ширину
bfs_path([[X|T]|_], X, [X|T]).
bfs_path([Path|Queue], Goal, ResultPath) :- 
    findall(NewPath, (prolong(Path, NewPath), \+ member(NewPath, Queue)), ExtendedPaths),
    append(Queue, ExtendedPaths, NewQueue),
    bfs_path(NewQueue, Goal, ResultPath).
bfs(Method, Goal, Path) :- 
    bfs_path([[Method]], Goal, Path).

% поиск с итерационным заглублением 
id_path([X | T], X, [X | T], _).
id_path(Path, Goal, ResultPath, Depth) :- 
    Depth > 0, 
    prolong(Path, NewPath), 
    NewDepth is Depth - 1, 
    id_path(NewPath, Goal, ResultPath, NewDepth).
iddfs(State, Goal, Path) :- 
    length(State, L), 
    N is 3 * L / 2, 
    id_path([State], Goal, Path, N).

% проверка чередования вагонов на правой стороне
bw(Y) :- b(Y); w(Y).

b([]).
b([black, white | T]) :- b(T).

w([]).
w([white, black | T]) :- w(T).

% получаю первый элемента списка
first([], []).
first([X|_], X).

% реверс
reverse_lists([], []).
reverse_lists([s(X, Y, Z)|T], [s(P, Q, R)|RT]) :- 
    reverse(X, P), 
    reverse(Y, Q), 
    reverse(Z, R), 
    reverse_lists(T, RT).

% определяю переходов между состояниями
move(s([A|AT], B, C), s(AT, B, [A|C])) :- 
    first(C, X), 
    X \= A.
move(s(A, [B|BT], C), s(A, BT, [B|C])) :- 
    first(C, X), 
    X \= B.
move(s([A|AT], B, C), s(AT, [A|B], C)) :- 
    first(C, X), 
    X == A.

solve(Method, InitialList, R) :- 
    reverse(InitialList, X1), 
    permutation(X1, Y), 
    bw(Y),
    get_time(Start), 
    (
        Method = dfs -> 
            dfs(s(X1, [], []), s([], [], Y), W)
        ;
        Method = bfs ->
            bfs(s(X1, [], []), s([], [], Y), W)
        ;
        Method = iddfs ->
            iddfs(s(X1, [], []), s([], [], Y), W)
        ;
            write('Неизвестный метод поиска'), nl, fail
    ),
    get_time(End), 
    T is End - Start,
    write('run time: '), write(T), write('\n'),
    reverse_lists(W, W1), 
    reverse(W1, R), !.

run :- 
    write('Выберите метод поиска (dfs, bfs, iddfs): '),
    read(Method),
    write('Введите начальное состояние (список вагонов, например [black, white, black, white]): '),
    read(InitialList),
    solve(Method, InitialList, R),
    write('Решение: '), write(R), nl.
