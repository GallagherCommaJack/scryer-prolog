
:- module(gensym, [gensym/2,
		   reset_gensym/1]).

:- use_module(library(error)).
:- use_module(library(lists)).
:- use_module(library(non_iso)).
:- use_module(library(si)).

append_id(Base, UniqueID, Unique) :-
    atom_chars(Base, BaseChars),
    number_chars(UniqueID, IDChars),
    append(BaseChars, IDChars, AtomChars),
    atom_chars(Unique, AtomChars).

gensym(Base, Unique) :-
    must_be(var, Unique),
    atom_si(Base),    
    (  bb_get(Base, UniqueID0) ->
       UniqueID is UniqueID0 + 1,
       bb_put(Base, UniqueID),
       append_id(Base, UniqueID, Unique)
    ;  bb_put(Base, 1),
       append_id(Base, 1, Unique)
    ).

reset_gensym(Base) :-
    atom_si(Base),
    bb_put(Base, 0).
