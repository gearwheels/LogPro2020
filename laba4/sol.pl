transform(Inf,Pref):-reverse(Inf,Inf1),a_expr(Inf1,Pref).

a_number([NS],NS):-number(NS).

myAppend([], L, [L]):- number(L),!.
myAppend(Y, L, [Y,L]):-number(Y),number(L),!.
myAppend(Y, L, [Y|L]):-number(Y),not(number(L)),!.
myAppend([], L, L):- not(number(L)).
myAppend([X | L1], L2, [X | L3]):-myAppend(L1, L2, L3).

a_term(T,V):- a_number(T,V).
a_term(T,V):-append(X,['*'|Y],T),a_number(X,Vx), a_term(Y,Vy),myAppend(Vy, Vx, V1),myAppend(['*'], V1, V).
a_term(T,V):-append(X,['/'|Y],T),a_number(X,Vx), a_term(Y,Vy),myAppend(Vy, Vx, V1),myAppend(['/'], V1, V).

a_expr(T,V):-a_term(T,V).
a_expr(T,V):-append(X,['+'|Y],T),a_term(X,Vx), a_expr(Y,Vy),myAppend(Vy, Vx, V1),myAppend(['+'], V1, V).
a_expr(T,V):-append(X,['-'|Y],T),a_term(X,Vx), a_expr(Y,Vy),myAppend(Vy, Vx, V1),myAppend(['-'], V1, V).