%%
%% IFT2035 Concepts de langages -- A10
%%
%% TP3
%% Eric Thivierge (THIE09016601)
%% Vincent Foley-Bourgon (FOLV08078309)
%%

%%
%% Relations utilitaires
%%

%% Relation de concatenation de deux listes.
append( [], L, L ).
append( [X|R1], L, [X|R2] ) :-
    append( R1, L, R2 ).

%% Extrait le Ie élément d'une liste (1 based).
%% nth(1, [0,1,2,3], T) -> T = 0.
nth(1, [T|_], T).
nth(I, [_|R], T) :- add(I2, 1, I), nth(I2, R, T).

%% Relation d'insertion d'un élément dans une liste.
insere(X, L1, L2) :-
    append(A, B, L1),
    append(A, [X|B], L2).

%% Relation de permutation des éléments d'une liste.
perm([], []).
perm([X|R], L) :-
    perm(R, RP),
    insere(X, RP, L).

%% Relation de creation de liste de valeurs entre L et U.
%% interval(0, 4, R) -> R = [0, 1, 2, 3, 4].
interval(U, U, [U]).
interval(L, U, [L|R]) :-
    less(L, U),
    add(L, 1, L1),
    interval(L1, U, R).

%% Relation de distance entre deux points en X1, X2.
%% dX([1, _], [3, _], D) -> D = 2; dX([3, _], [1, _], D) -> D = 2
dX([X1, _], [X2, _], D) :-
    lesseq(X1, X2),
    add(X1, D, X2).
dX([X1, _], [X2, _], D) :-
    greater(X1, X2),
    add(X2, D, X1).

%% Relation de distance entre deux points en Y1, Y2.
%% dX([_, 1], [_, 3], D) -> D = 2; dX([_, 3], [_, 1], D) -> D = 2
dY([_, Y1], [_, Y2], D) :-
    lesseq(Y1, Y2),
    add(Y1, D, Y2).
dY([_, Y1], [_, Y2], D) :-
    greater(Y1, Y2),
    add(Y2, D, Y1).

%%
%% Labyrinthe
%%

%% Vérifie que l'élément en coord (I, J) dans le tableau M est E.
elem(M, I, J, E) :-
    add(I, 1, IP1),
    add(J, 1, JP1),
    nth(IP1, M, Lig),
    nth(JP1, Lig, E).

%% Extrait la dimension du labyrinthe.
dimensions(Lab, [M, N]) :-
    longueur(Lab, Mp),
    add(M, 1, Mp),
    nth(1, Lab, Lig),
    longueur(Lig, Np),
    add(N, 1, Np).

%% Détermine lesquels des 4 cases voisines sont libres et non déjà visitées.
voisins(M, [X1, Y1], [X1, Y2]) :-
    add(Y1, 1, Y2),
    elem(M, X1, Y2, t).
voisins(M, [X1, Y1], [X1, Y2]) :-
    add(Y2, 1, Y1),
    elem(M, X1, Y2, t).
voisins(M, [X1, Y1], [X2, Y1]) :-
    add(X1, 1, X2),
    elem(M, X2, Y1, t).
voisins(M, [X1, Y1], [X2, Y1]) :-
    add(X2, 1, X1),
    elem(M, X2, Y1, t).

%% Relation auxilliaire pour le produit cartésien deux listes.
%% prodAux(0, [0,1,2,3], R) -> R = [[0,0], [0,1], [0,2], [0,3]]
prodAux(_, [], []).
prodAux(I, [J|Js], [[I, J]|R]) :-
    prodAux(I, Js, R).

%% Produit cartésien de deux listes.
prodCartesien([], _, []).
prodCartesien([I|Is], Js, R) :-
    prodAux(I, Js, R1),
    prodCartesien(Is, Js, R2),
    append(R1, R2, R).

%% Produit récursivement les chemins intermédiaires entre une position
%% donnée et la position finale.
cheminInt(_, _, Y, Y, [Y]).
cheminInt(L, NV, X, Y, C) :-
    voisins(L, X, X1),
    member(X1, NV),
    delete(NV, X, NV1),
    delete(NV1, X1, NV2),
    cheminInt(L, NV2, X1, Y, C1),
    append([X], C1, C).

%% Recherche le chemin dans le labyrinthe L entre les positions
%% [M-1, N-1] et [0, 0], pour un labyrinthe de dimension MxN.
traverser(L, C) :-
    dimensions(L, [M, N]),
    interval(0, M, Is),
    interval(0, N, Js),
    prodCartesien(Is, Js, NV),    % NV: Non Visitees
    cheminInt(L, NV, [M, N], [0, 0], C).

%%
%% N Dames
%%

%% Recherche les solutions possibles pour un plateau NxN.
ndames(N, S) :-
    interval(1, N, R),
    perm(R, S),
    secure(1, 2, S).

%% Relation vérifiant si la liste de positions donnée
%% est valide.
%% P1: position en x du premier élément de la liste
%% P2: position en x du deuxième élément de la liste
%% [R1, R2|Rs]: la (sous-)liste de positions à vérifier.
secure(_, _, [_]).
secure(P1, P2, [R1, R2|Rs]) :-
    secureAux((P1, R1), (P2, R2)),
    add(P2, 1, P3),
    secure(P1, P3, [R1|Rs]),
    secure(P2, P3, [R2|Rs]).

%% Relation auxilliaire vérifiant que deux positions données
%% ne s'attaquent pas.
secureAux((X1, Y1), (X2, Y2)) :-
    noteq(X1, X2),
    noteq(Y1, Y2),
    dX([X1, Y1], [X2, Y2], DX),
    dY([X1, Y1], [X2, Y2], DY),
    noteq(DX, DY).
