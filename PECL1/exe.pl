%consult('/Users/mr.blissfulgrin/Documents/UAH_2018_2019/RAZONAMIENTO/LAB/PECL1/exe.pl').
:-consult('./knoledge_base.pl').

%Inicio del programa
akinator:-nl,write('Akinator!!!'), nl,nl,
    caracteristicas(ListaPreguntas),length(ListaPreguntas,LongitudPreguntas),
    build(n,LongitudPreguntas,ListaRespuestas),lenguajes(ListaLenguajes),
    gameLoop(ListaPreguntas,ListaRespuestas,ListaLenguajes,0),
    nl,write('Game Over!!!'),nl,!.

%Bucle del juego
gameLoop(ListaPreguntas,ListaRespuestas,ListaLenguajes,Indice):-
    question(ListaPreguntas,ListaRespuestas,ListaLenguajes,Indice).

question([PrimeraPregunta|RestoPreguntas],ListaRespuestas,ListaLenguajes,Indice):-
    write('Su lenguaje '),write(PrimeraPregunta),write('?'),
    read(Answer),
    (Answer==e -> ! ;
    reemplazar(ListaRespuestas,Indice,Answer,NuevaListaRespuestas),
    write(NuevaListaRespuestas),nl,
    Indice1 is Indice+1,
    validar(NuevaListaRespuestas,ListaLenguajes,[],NuevaListaLenguajes),
    write(NuevaListaLenguajes),nl,
    length(NuevaListaLenguajes,N),(N=:=1 -> write('Su lenguaje es '),[Solucion|_]=NuevaListaLenguajes,write(Solucion),!;
    (N=:=0 -> write('No se ha podido encontrar su lenguaje'),!;
    gameLoop(RestoPreguntas,NuevaListaRespuestas,NuevaListaLenguajes,Indice1)))).
    
question(_,_,_,_):-write('No quedan preguntas').


%Mostrar elementos de dos listas a la vez
rlist(Lista1,Lista2):-[C1|Cola1]=Lista1,[C2|Cola2]=Lista2, write(C1), write(C2),rlist(Cola1,Cola2).

%Comparar caracteristicas y quitar lenguaje de la lista general
validar(ListaRespuestas,[Lenguaje1|RestoLenguajes],FinalAnterior,Final):-
    lenguaje(Lenguaje1,ListaCaract),
    validarAux(ListaRespuestas,ListaCaract,Lenguaje1,FinalAnterior,Resultado),
    validar(ListaRespuestas,RestoLenguajes,Resultado,Final).
    
validar(_,_,FinalAnterior,FinalAnterior).

validarAux([Respuesta1|RestoRespuestas],[Caracteristica1|RestoCaracteristicas],Lenguaje1,FinalAnterior,Final):-
    (Respuesta1==n ->validarAux(RestoRespuestas,RestoCaracteristicas,Lenguaje1,FinalAnterior,Final);
    (Respuesta1==Caracteristica1 -> validarAux(RestoRespuestas,RestoCaracteristicas,Lenguaje1,FinalAnterior,Final);validarAux([],[],FinalAnterior,Final))).
    %write(C1), write(C2),validarAux(Cola1,Cola2,).

validarAux(_,_,Lenguaje1,FinalAnterior,[Lenguaje1|FinalAnterior]).
validarAux(_,_,FinalAnterior,FinalAnterior).

%Reemplazar valor de una lista en una cierta posici�n
reemplazar([_|T], 0, X, [X|T]).
reemplazar([H|T], I, X, [H|R]):- I > -1, NI is I-1, reemplazar(T, NI, X, R), !.
reemplazar(L, _, _, L).
    
%Construir lista de longitud N con valor X en sus posiciones
build(X, N, List)  :-
    length(List, N),
    maplist(=(X), List).

%Funci�n que devuelve una lista con nombres de los lenguajes
lenguajes(Y):- lenguajes_aux([], Y).
lenguajes_aux(Z,Y):- lenguaje(X1,_), not(member(X1,Z)), lenguajes_aux([X1|Z], Y), !.
lenguajes_aux(X,X).

%Funcione que obtiene una pregunta dado un indice
obtenerPregunta(I, X):-caracteristicas(L), nth1(I, L, X).