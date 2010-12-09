%
% Relations servant a implanter l'addition
%

add(X,Y,Z) :- nonvar(X), nonvar(Y), X>=0, Y>=0, Z is X+Y.
add(X,Y,Z) :- nonvar(X), var(Y), nonvar(Z), X>=0, Z>=0, Y is Z-X, Y>=0.
add(X,Y,Z) :- var(X), nonvar(Y), nonvar(Z), Y>=0, Z>=0, X is Z-Y, X>=0.
add(X,Y,Z) :- var(X), var(Y), nonvar(Z), notabove(Z,X), add(X,Y,Z).
add(X,Y,Z) :- var(X), nonvar(Y), var(Z), nonneg(X), add(X,Y,Z).
add(X,Y,Z) :- nonvar(X), var(Y), var(Z), nonneg(Y), add(X,Y,Z).
add(X,Y,Z) :- var(X), var(Y), var(Z), X==Y, Y==Z, X = 0.
add(X,Y,Z) :- var(X), var(Y), var(Z), X==Y, Y\==Z, addloop(X,Y,Z).
add(X,Y,Z) :- var(X), var(Y), var(Z), X\==Y, Y==Z, addloop(X,Y,Z).
add(X,Y,Z) :- var(X), var(Y), var(Z), X\==Y, X==Z, addloop(X,Y,Z).
add(X,Y,Z) :- var(X), var(Y), var(Z), X\==Y, Y\==Z, X\==Z, addloop(X,Y,Z).

addloop(X,Y,Z) :- nonneg(Z), notabove(Z,X), add(X,Y,Z).

nonneg(X) :- nonnegloop(0,X).
nonnegloop(N,N).
nonnegloop(N,X) :- M is N+1, nonnegloop(M,X).

notabove(Hi,X) :- notaboveloop(Hi,0,X).
notaboveloop(_,N,N).
notaboveloop(Hi,N,X) :- N<Hi, M is N+1, notaboveloop(Hi,M,X).

%
% Relations de comparaisons
%

between(Lo,X,Hi) :- add(Lo,_,Hi), add(X,_,Hi), add(Lo,_,X).

lesseq(X,Y) :- add(X,_,Y).

less(X,Y) :- nonvar(X), lesseq(X,Y), A is X+1, lesseq(A,Y).
less(X,Y) :- var(X), nonvar(Y), lesseq(X,Y), A is X+1, lesseq(A,Y).
less(X,Y) :- var(X), var(Y), X\==Y, lesseq(X,Y), A is X+1, lesseq(A,Y).

greatereq(X,Y) :- lesseq(Y,X).

greater(X,Y) :- less(Y,X).

equal(X,Y) :- add(X,0,Y).

noteq(X,Y) :- nonvar(Y), noteqloop(X,Y).
noteq(X,Y) :- var(Y), nonvar(X), nonneg(Y), noteqloop(X,Y).
noteq(X,Y) :- var(Y), var(X), X\==Y, nonneg(Z), add(X,Y,Z), noteqloop(X,Y).

noteqloop(X,Y) :- less(X,Y).
noteqloop(X,Y) :- greater(X,Y).

%
% Relations sur des listes
%

longueur(L,N) :- nonvar(N), longueurloop1(L,N).
longueur(L,N) :- var(N), nonvar(L), longueurloop2(L,N).
longueur(L,N) :- var(N), var(L), nonneg(N), longueurloop1(L,N).

longueurloop1([],0).
longueurloop1([_|Q],N) :- add(M,1,N), longueur(Q,M).

longueurloop2([],0).
longueurloop2([_|Q],N) :- longueur(Q,M), add(M,1,N).

%
% Exemples de labyrinthes
%

labyrinthe(
        [[t,f,t,t,t,t,t,t,t],
        [t,f,t,f,f,f,t,f,t],
        [t,f,t,f,t,f,t,f,t],
        [t,f,t,f,t,f,t,f,t],
        [t,t,t,t,t,f,t,f,t],
        [f,f,t,f,t,f,t,f,f],
        [t,t,t,f,t,f,t,t,t],
        [f,f,f,f,f,f,t,f,t],
        [t,t,t,t,t,t,t,f,t]]).

labyrinthe(
        [[t,f,t,t,t,t,t,t,t,t,t,f,t,t,t,t,t],
        [t,f,f,f,t,f,f,f,f,f,f,f,t,f,f,f,f],
        [t,t,t,f,t,t,t,t,t,f,t,t,t,t,t,t,t],
        [t,f,t,f,f,f,t,f,f,f,t,f,t,f,t,f,f],
        [t,f,t,t,t,t,t,t,t,f,t,f,t,f,t,t,t],
        [f,f,t,f,t,f,t,f,t,f,f,f,t,f,t,f,f],
        [t,t,t,f,t,f,t,f,t,t,t,f,t,f,t,t,t],
        [f,f,t,f,f,f,f,f,f,f,t,f,t,f,f,f,t],
        [t,f,t,t,t,t,t,f,t,f,t,t,t,f,t,t,t],
        [t,f,f,f,t,f,f,f,t,f,t,f,t,f,t,f,t],
        [t,t,t,t,t,f,t,t,t,t,t,f,t,f,t,f,t]]).
