:- op(400, yfx, /).

:- module(builtins, [(=)/2, (+)/2, (*)/2, (-)/2, (/)/2, (/\)/2,
	(\/)/2, (is)/2, (xor)/2, (div)/2, (//)/2, (rdiv)/2, (<<)/2,
	(>>)/2, (mod)/2, (rem)/2, (>)/2, (<)/2, (=\=)/2, (=:=)/2, (-)/1,
	(>=)/2, (=<)/2, (->)/2, (;)/2, catch/3, throw/1, true/0, false/0]).

% arithmetic operators.
:- op(700, xfx, is).
:- op(500, yfx, +).
:- op(500, yfx, -).
:- op(400, yfx, *).
:- op(500, yfx, /\).
:- op(500, yfx, \/).
:- op(500, yfx, xor).
:- op(400, yfx, div).
:- op(400, yfx, //).
:- op(400, yfx, rdiv).
:- op(400, yfx, <<).
:- op(400, yfx, >>).
:- op(400, yfx, mod).
:- op(400, yfx, rem).
:- op(200, fy, -).

% arithmetic comparison operators.
:- op(700, xfx, >).
:- op(700, xfx, <).
:- op(700, xfx, =\=).
:- op(700, xfx, =:=).
:- op(700, xfx, >=).
:- op(700, xfx, =<).

% conditional operators.
:- op(1050, xfy, ->).
:- op(1100, xfy, ;).

% unify.
:- op(700, xfx, =).

% unify.
X = X.

true.

false :- '$fail'.

% conditions.
/*
','(G1, G2) :- get_cp(B), ','(G1, G2, B).

','(!, ','(G1, G2), B) :- set_cp(B), ','(G1, G2, B).
','(!, !, B) :- set_cp(B).
','(!, G, B) :- set_cp(B), G.
','(G, ','(G2, G3), B) :- !, G, ','(G2, G3, B).
','(G, !, B) :- !, G, set_cp(B).
','(G1, G2, _) :- G1, G2.

;(G1, G2) :- get_cp(B), ;(G1, G2, B).

;(G1 -> G2, _, B) :- ->(G1, G2, B).
;(_  -> _ , G, B) :- set_cp(B), G.
;(!, _, B) :- set_cp(B).
;(_, !, B) :- set_cp(B).
;(G, _, _) :- G.
;(_, G, _) :- G.

G1 -> G2 :- get_cp(B), ->(G1, G2, B).

->(G1, !, B)  :- call(G1), set_cp(B).
->(G1, G2, B) :- call(G1), set_cp(B), call(G2).
*/

% exceptions.
catch(G,C,R) :- '$get_current_block'(Bb), catch(G,C,R,Bb).

catch(G,C,R,Bb) :- '$install_new_block'(NBb), call(G), end_block(Bb, NBb).
catch(G,C,R,Bb) :- '$reset_block'(Bb), '$get_ball'(Ball), handle_ball(Ball, C, R).

end_block(Bb, NBb) :- '$clean_up_block'(NBb), '$reset_block'(Bb).
end_block(Bb, NBb) :- '$reset_block'(NBb), '$fail'.

handle_ball(Ball, C, R) :- Ball = C, !, '$erase_ball', call(R).
handle_ball(_, _, _) :- '$unwind_stack'.

throw(Ball) :- '$set_ball'(Ball), '$unwind_stack'.
