% Салихов Р.Р. М8О-203Б-23

% Определить, сдал ли студент экзамены (все оценки >= 4)
passed(Student) :-
    findall(Grade, grade(Student, _, Grade), Grades),
    min_list(Grades, MinGrade),
    MinGrade >= 4.

% Вычислить средний балл студента
average_grade(Student, Avg) :-
    findall(Grade, grade(Student, _, Grade), Grades),
    sum_list(Grades, Sum),
    length(Grades, Count),
    Count > 0,  % Проверка, что есть оценки
    Avg is Sum / Count.

% Вывести студентов, их средний балл и факт, сдали ли они экзамен
student_result :-
    findall(Student, grade(Student, _, _), Students),
    sort(Students, UniqueStudents),
    forall(member(Student, UniqueStudents),
        (
            average_grade(Student, Avg),
            (passed(Student) -> Status = 'сдал'; Status = 'не сдал'),
            format('~w: Средний балл = ~2f, Статус = ~w~n', [Student, Avg, Status])
        )).

% Определить, сдал ли студент экзамен по конкретному предмету (оценка >= 4)
passed_subject(Student, Subject) :-
    grade(Student, Subject, Grade),
    Grade >= 4.

% Найти количество студентов, не сдавших предмет
failed_students(Subject, Count) :-
    findall(Student, (grade(Student, Subject, Grade), Grade < 4), FailedStudents),
    sort(FailedStudents, UniqueFailed),
    length(UniqueFailed, Count).

% Вывести количество не сдавших студентов по каждому предмету
subject_fail_count :-
    findall(Subject, grade(_, Subject, _), Subjects),
    sort(Subjects, UniqueSubjects),
    forall(member(Subject, UniqueSubjects),
        (
            failed_students(Subject, Count),
            format('Предмет: ~w, Не сдали: ~d студентов~n', [Subject, Count])
        )).

% Для каждой группы определить студента с максимальным средним баллом
max_grade_in_group(Group) :-
    findall(Student, group(Student, Group), Students),
    findall(Avg-Student, (member(Student, Students), average_grade(Student, Avg)), AvgStudents),
    max_member(MaxAvg-_, AvgStudents),
    findall(Student, member(MaxAvg-Student, AvgStudents), TopStudents),
    format('Группа: ~w, Максимальный средний балл: ~2f~n', [Group, MaxAvg]),
    format('Лучшие студенты: ~w~n', [TopStudents]).

% Вывести студентов с максимальным средним баллом по каждой группе
group_max_avg :-
    findall(Group, group(_, Group), Groups),
    sort(Groups, UniqueGroups),
    forall(member(Group, UniqueGroups),
        max_grade_in_group(Group)).
