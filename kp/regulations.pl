male('Anatoly Timofeev1').
female('Irina  Timofeeva').
female('Antonina Timofeeva').
male('Ivan Timofeev1').
male('Ivan Zaitsev').
female('Maria Zaitseva').
male('Ivan Timofeev').
female('Praskovya Timofeeva').
female('Ulyana Myakinkova').
male('Ivan Myakinkov').
male('Michael Timofeev').
female('Ludmila Timofeev').
female('Elena Timofeev').
male('Alexey Timofeev').
female('Svetlana Timofeeva').
male('Vladimir Timofeev').
female('Nadezhda Timofeeva').
male('Anatoly Timofeev').
female('Anna Timofeeva').
male('Egor Timofeev').
child('Anatoly Timofeev', 'Ivan Timofeev1').
child('Anatoly Timofeev', 'Antonina Timofeeva').
child('Ludmila Timofeev', 'Ivan Timofeev1').
child('Ludmila Timofeev', 'Antonina Timofeeva').
child('Nadezhda Timofeeva', 'Ivan Zaitsev').
child('Nadezhda Timofeeva', 'Maria Zaitseva').
child('Egor Timofeev', 'Ivan Timofeev').
child('Egor Timofeev', 'Praskovya Timofeeva').
child('Anna Timofeeva', 'Ivan Myakinkov').
child('Anna Timofeeva', 'Ulyana Myakinkova').
child('Alexey Timofeev', 'Vladimir Timofeev').
child('Alexey Timofeev', 'Svetlana Timofeeva').
child('Michael Timofeev', 'Vladimir Timofeev').
child('Michael Timofeev', 'Svetlana Timofeeva').
child('Irina  Timofeeva', 'Anatoly Timofeev').
child('Irina  Timofeeva', 'Nadezhda Timofeeva').
child('Svetlana Timofeeva', 'Anatoly Timofeev').
child('Svetlana Timofeeva', 'Nadezhda Timofeeva').
child('Anatoly Timofeev1', 'Egor Timofeev').
child('Anatoly Timofeev1', 'Anna Timofeeva').
child('Vladimir Timofeev', 'Egor Timofeev').
child('Vladimir Timofeev', 'Anna Timofeeva').
child('Elena Timofeev', 'Egor Timofeev').
child('Elena Timofeev', 'Anna Timofeeva').

add(E,[],[E]).
add(E,[H|T],[H|T1]):-add(E,T,T1).

zolovka(J,Z):-female(J),check(husband, Husband, J),sibling(Husband, Z),female(Z),!.

sibling(Per, Sib):-child(Per, P),child(Sib, P),Per \= Sib.

check(husband, Husband, Wife):-child(Child, Husband),child(Child, Wife),Husband \= Wife,male(Husband).

check(wife, Wife, Husband):-child(Child, Husband),child(Child, Wife),Husband \= Wife,female(Wife).

check(brother, Brother, Y):-sibling(Brother, Y),male(Brother).

check(sister, Sister, Y):-sibling(Sister, Y),female(Sister).

check(father, Father, Child):-child(Child, Father),male(Father).

check(mother, Mother, Child):-child(Child, Mother),female(Mother).

check(parent, Parent, Child):-child(Child, Parent).

check(son, Child, Parent):-child(Child, Parent),male(Child).

check(daughter, Child, Parent):-child(Child, Parent),female(Child).

check(child, Child, Parent):-child(Child, Parent).

relation(X):-member(X, [father, mother, sister, parent, child, brother, son, daughter, husband, wife]).

/*          Степень родства          */
relatives(X, Y, Out):- searchBdth(X, Y, Out).% цепочка людей, через которых связаны 2 человека

askRelationship(X, Y, Out):-relation(Out), !,check(Out, X, Y).% цепочка родства, через которую связаны 2 человека

relationship(X, Y, Out):-searchBdth(X, Y, Out1), !,transform(Out1,[] ,Out).

transform([_],Tmp,Tmp). % переделевает цепочку родственников в цепочку родства
transform([First,Second|Tail],Tmp,OutList):-check(Relation,First,Second),add(Relation,Tmp,TmpOut),transform([Second|Tail],TmpOut,OutList),!.

prolong([X|T],[Y,X|T]):-move(X,Y), not(member(Y,[X|T])).

move(X,Y):-check(_,X,Y).

searchBdth(X,Y,P):-bdth([[X]],Y,L),reverse(L,P).
bdth([[X|T]|_],X,[X|T]).
bdth([P|QI],X,R):-findall(Z,prolong(P,Z),T),append(QI,T,Q0),bdth(Q0,X,R),!.
bdth([_|T],Y,L):-bdth(T,Y,L).