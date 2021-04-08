    % Реализация стандартных предикатов обработки списков
    writeList([]).
    writeList([X|Tail]) :- write(X), writeList(Tail).
    % Принадлежность элемента списку
    % (элемент, список)
    myMember(X, [X | _]).
    myMember(X, [_ | T]):-myMember(X, T).
    
    % Длина списка
    % (список, длина)
    myLength([], 0).
    myLength([_ | L], N):-myLength(L, M), N is M + 1.
    
    % Конкатенация списков
    % (список1, список2, список1+2)
   myAppend([], L, L).
   myAppend([X | L1], L2, [X | L3]):-myAppend(L1, L2, L3).
    
    % Удаление элемента из списка
    % (элемент, список, список без элемента)
    myRemove(X, [X | T], T).
    myRemove(X, [Y | T], [Y | Z]):-myRemove(X, T, Z).

    % Перестановки элементов в списке
    % (список, перестановка)
    myPermutation([], []).
    myPermutation(L, [X | T]):-myRemove(X, L, Y), myPermutation(Y, T).
    
    % Подсписки списка
    % (подсписок, список)
	mySubl(S, L):-myAppend(_, L1, L), myAppend(S, _, L1).

% задание 1.1 Удаление N последних элементов
% Со стандартными 
% (входные данные (список), выходные данные, длина которую нужно отсечь)
removeLN(L,Y,N):-append(Y,X,L), length(X, N).
% без встроенных предикатов
get_first_elements(_,N,[]):-N=<0.
get_first_elements(X,0,[]).
get_first_elements([X|Xt],N,[X|Yt]):-N>0,N1 is N-1, get_first_elements(Xt,N1,Yt).
%(Список, количество элементов к удалению, список-результат)
removelast([],_,[]).
removelast(S,N,L) :- myLength(S,D),N1 is D-N, get_first_elements(S,N1,L).

% задание 1,2 Лексикографическое сравнение 2 списков
%с использованием стандартных предикатов
lcom([],[]).
lcom([X|Tail],Y) :- delete(Y,X,Y1), lcom(Tail,Y1).
% без встроенных предикатов 
lcomp1([X|Tail],[Y|Tail1]) :- X =:= Y, lcomp1(Tail, Tail1).
lcomp1([X],[Y]) :- X =:= Y.

% задание 1.3
%(список 1, список 2, кол-во элементов которые нужно отсечь)
headcomp1(S1,S2,K) :- removelast(S1,K,L1), removelast(S2,K,L2), lcomp1(L1,L2).