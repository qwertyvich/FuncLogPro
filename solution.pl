solve :-
    People = [kondratyev, davydov, fedorov],  
    Professions = [joiner, painter, plumber], 
    permutation(People, [Person1, Person2, Person3]),
    permutation(Professions, [Prof1, Prof2, Prof3]),
    Person1 \= Person3, 
    Person2 \= Person3, 
    (Person1 \= fedorov ; Person2 \= davydov ; Person3 \= davydov),
    write(Person1), write(' is '), write(Prof1), nl,
    write(Person2), write(' is '), write(Prof2), nl,
    write(Person3), write(' is '), write(Prof3), nl.
