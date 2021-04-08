fishers(['Сергеев', 'Панин', 'Борисов', 'Леднев']).
fishes([['Судак',5],['Лещ',4],['Окунь',2],['Ёрш',1]]).
fishes1(['Судак','Лещ','Окунь','Ёрш']).
fact1([B,P,S,L]) :- B + P =:= S + L.
fact3([B,P,S,L]) :- B > P, B > S, B > L, P < S, P < L, S =\= L.
% сумма очков всех рыбаков
fact(List) :- sumlist(List,Sum), Sum =:= 18.

factPoint(Points,P) :- Points > 0 ,!, p(Points,X), slagList(X,P,0).
factPoint(0,P,Out).
slagList([H|Tail],P,O) :- length(H, Len), P>Len, slagList1(H), !, slagList([],P,1).
slagList([H|Tail],P,0) :- slagList(Tail,P,0).
slagList([],P,1). 

slagList1([1|T]) :- slagList1(T).
slagList1([2|T]) :- slagList1(T).
slagList1([4|T]) :- slagList1(T).
slagList1([5|T]) :- slagList1(T).
slagList1([]).

add(E,[],[E]).
add(E,[H|T],[H|T1]):-add(E,T,T1).

number_compositions(0, _PreviousAddend, []):-!.
number_compositions(Number, PreviousAddend, [Addend|TailComprosition]):-
  between(PreviousAddend, Number, Addend),
  TailNumber is Number - Addend,
  number_compositions(TailNumber, Addend, TailComprosition).

writeList([]).
writeList([X|Tail]) :- write(','), write(' '), write(X), writeList(Tail).

sumlist([H|T],Sum):-sumlist(T,Sum1), Sum is H + Sum1.
sumlist([],0).

for(A,A,_).
for(X,A,B) :- A < B, A1 is A+1, for(X,A1,B).
%решение через перебор
solve(BO,PO,SO,LO) :- for(S,5,8), for(P,1,8), for(L,1,8), for(B,1,8), check([B,P,S,L]),!,kolvofishes(P,B,3,OutB,OstOkun),kolvofishes(P,S,OstOkun,OutSer,OstOkun1),
kolvofishes(P,L,OstOkun1,OutL,OstOkun2), listfishesout(OutB, OstOkun2, BO), listfishesout(OutSer, OstOkun2, SO), 
listfishesout(OutL, OstOkun, LO), fishesPanin(P,[],PO).
%проверка фактов
check([B,P,S,L]) :- fact([B,P,S,L]), fact1([B,P,S,L]), fact3([B,P,S,L]), factPoint(B,P), factPoint(S,P), factPoint(L,P).

p(N,L):-setof(R,number_compositions(N,1,R),L).
% конечный список где позиции числа соответствует название рыбы в fishes1(['Судак','Лещ','Окунь','Ёрш']) число обозначает шт рыбы, оставшиеся окуни)
kolvofishes(P,Points,Okynb,Out,OutOk) :- !, p(Points,X), slag(X, Okynb, WSp, P, Out, OutOk).
%проверяем список слагаемых (двойной список слагаемых, кол во окуней, вспомогательный список, Кол-во рыб у панина, конечный список, конечное кол-во окуней)
slag([H|Tail], Okynb, WSp, P, Out,OutOk) :- length(H, Len), P > Len, slag1(H, Okynb, Out1, Oku),!,slag(Tail, Oku, Out1, P, Out,OutOk). % отрицание 
slag([H|Tail], Okynb, WSp, P, Out, OutOk) :- slag(Tail, Okynb, WSp, P, Out,OutOk).
slag([], Okynb, WSp, P, WSp, Okynb).
%(список слагаемых, кол во окуней, конечный список слагаемых, осталось окуней)
slag1([], O, [0, 0, 0, 0], O).
slag1([1|Tail1], Okynb, [M5, M4, M2, M1], Oku) :- slag1(Tail1, Okynb, [M5, M4, M2, M11], Oku), M1 is M11 + 1.
slag1([2|Tail1], Okynb, [M5, M4, M2, M1], Oku) :- Okynb > 0, Okynb1 is Okynb - 1, slag1(Tail1, Okynb1, [M5, M4, M22, M1], Oku),M2 is M22 + 1.
slag1([4|Tail1], Okynb, [M5, M4, M2, M1], Oku) :- slag1(Tail1, Okynb, [M5, M44, M2, M1], Oku),M4 is M44 + 1.
slag1([5|Tail1], Okynb, [M5, M4, M2, M1], Oku) :- slag1(Tail1, Okynb, [M55, M4, M2, M1], Oku), M5 is M55 + 1.
%(список рыб типа [0,1,0,1], вспомогательный список, конечный список, кол-во окуней) из списка где отмеченно сколько какой рыбы поймал рыбак получаем список из названий рыбы
listfishesout(SpR,Oku,Out) :- ifok(SpR,Oku,Out1),!,listfishes(Out1, [], Out).
listfishesout(SpR,Oku,Out) :- listfishes(SpR, WList, Out).

ifok([0,0,2,0],Oku,[0,0,2,0]) :- !.
ifok([0,1,0,0],Oku,Out) :- Oku =:= 2, !, ifok([0,0,2,0],Oku,Out).

listfishes([], Out, Out) :- !.
listfishes([H|T], WList, OutList) :- H > 0, length([H|T], N), fishes1(ListNF), nameF(H, ListNF, N, WL, Out1), add(Out1,WList,Out),
 listfishes(T, Out, OutList),!.
listfishes([H|T], WList, OutList) :- listfishes(T, WList, OutList).
% ( кол во рыбы одного вида, список из названий рыб,длинна списка, вспомогательный список, вывод)
nameF(0, [HNF|TNF], 0, WL, WL) :- !.
nameF(H, [HNF|TNF], N, [], Out) :- length([HNF|TNF],NNF), NNF > N, !, nameF(H, TNF, N, [], Out).
nameF(H, [HNF|TNF], N, WL, Out) :- H > 0, H1 is H - 1, add(HNF, WL, Out1), !,nameF(H1, [HNF], 0, Out1, Out).

% рыбы панина(панин, вспомогательный список, конечный список)
fishesPanin(0,Sp,Sp).
fishesPanin(P,Sp,Out) :- P > 0, P1 is P - 1, fishes([Sud, Lesh, Ok, [Ersh,_]]), add(Ersh,Sp,Out1), fishesPanin(P1,Out1,Out),!.
% формируем подходящий список баллов (очков у сергея, конечный список)
serchpointsout(S,OutSp) :- serchpoints1(S, Sp, Out),serchpoints(1, Out, OutSp).
% распределяем очки между Борисовым и Паниным (вспомогательный параметр ,вспомогательный список, конечный список)
serchpoints(0, [B,P,S,L], [B,P,S,L]).
serchpoints(1, [B,P,S,L], Out) :- check([B,P,S,L]),!,
 serchpoints(0, [B,P,S,L], Out).
serchpoints(1, [B,P,S,L], Out) :- P > 0, B1 is B + 1, P1 is P - 1, serchpoints(1, [B1,P1,S,L], Out).
% распределяем очки между парами (вспомогательный параметр ,вспомогательный список, конечный список)
serchpoints1(0, [S,4,S,4], [S,4,S,4]) :- !.
serchpoints1(S, [OB1,OP1,OS1,OL1], Out) :- serchpoints1(0, [S,4,S,4], Out).

main(S1, BO,PO,SO,LO) :- serchpointsout(S1,[B,P,S,L]),kolvofishes(P,B,3,OutB,OstOkun),kolvofishes(P,S,OstOkun,OutSer,OstOkun1),
 kolvofishes(P,L,OstOkun1,OutL,OstOkun2), listfishesout(OutB, OstOkun2, BO), listfishesout(OutSer, OstOkun2, SO), 
 listfishesout(OutL, OstOkun, LO), fishesPanin(P,[],PO).% main([B1,P1,S1,L1], [BO,PO,SO,LO]).

mainmain(BO,PO,SO,LO) :- main(5, BO,PO,SO,LO).
