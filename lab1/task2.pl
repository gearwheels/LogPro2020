:- ['one.pl'].
:- encoding(utf8)

writeList([]).
writeList([X|Tail]) :- write(X), writeList(Tail).

add(E,[],[E]).
add(E,[H|T],[H|T1]):-add(E,T,T1).
%Вариант 1
%Получить таблицу групп и средний балл по каждой из групп
sumlist([H|T],Sum):-sumlist(T,Sum1), Sum is H + Sum1.
sumlist([],0).
%(Имя, Средняя оценка студента) находим ср. оценку студента
spM1std(Name,AvMark) :- findall(Y, (grade(Name, _, Y)), Marks), length(Marks,N), sumlist(Marks,S), AvMark is S / N.
% (список учащихся в группе, пром-ый список ср. оценок, список ср. оценок каждого студента)
applist([],[],[]). 
applist([N1|Tail],Out, Out2) :- spM1std(N1,AVM), add(AVM,Out,Out1), applist(Tail,Out1,Out2).
applist([N1],Out, Out2) :- spM1std(N1,AVM), add(AVM,Out,Out2).
%(группа, ср. оценка по группе) входная инф-ия - группа, ищем всех учащихся в группе, получаем список из средних оценок учащихся, получаем сумму этого списка и делим ее на длинну списка.
avMGroup(Group, AV) :- findall(Name,(student(Group,Name)),Names), applist(Names, [], AvMarks), length(AvMarks,N),
 sumlist(AvMarks, Sum), AV is Sum / N.
% (список неповторяющихся групп, список ср. оценок по группам)
func1([Gr|T],L, SpAvMark) :- avMGroup(Gr,A), add(A,L, SpAvMark1), func1(T,SpAvMark1,SpAvMark).
func1([Gr],L, SpAvMark) :- avMGroup(Gr,A), add(A,L, SpAvMark).
%(список групп, список групп без повторений)
nonrecGR([H|T],T1):-member(H,T),nonrecGR(T,T1).
nonrecGR([H|T],[H|T1]):-not(member(H,T)),nonrecGR(T,T1).
nonrecGR([],[]).
% получаем список всех групп
allGroup(Groups) :- findall(G, student(G,_), Groups).
avAllMarksG(OGroups,Spmarks) :- allGroup(Groups), nonrecGR(Groups, OGroups), func1(OGroups,[], Spmarks).
%Для каждого предмета получить список студентов, не сдавших экзамен (grade=2)
%(предмет, список не сдавших)
listDNP(Subj, Names) :- subject(Ss,Subj), bagof(Name ,(grade(Name, Ss, 2)), Names).
%Найти количество не сдавших студентов в каждой из групп
%(список1, второй список, пересечение 2-х списков)
result([],_,[]).
result([Head|Tail],List,[Head|NewTail]):- member(Head,List),result(Tail,List,NewTail),!.
result([_|Tail],List,NewTail):-result(Tail,List,NewTail).
%(группа, кол-во двоишников) находим всех студентов в нужной группе, находим всех двоишников, пересекаем эти два списка получаем третий список, находим его длинну
dvoechnikiout(GR,KLV) :- findall(Stud, student(GR,Stud), Studs), findall(Name, grade(Name,H,2), Names),result(Studs,Names,Out), length(Out, KLV).
