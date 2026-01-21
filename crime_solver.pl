% Name: Md. Mahir Uddin
% ID: 0122430022

% ------------ MURDER MYSTERY ------------

% ------ PREDICATES ------
% Suspects
person(sakib).
person(mehedi).
person(sabbir).
person(noman).
person(alvee).
person(nafisa).
person(nanziba).
person(yusuf).
person(dipto).

% Victim
person(mushfiq).
victim(mushfiq).
victim_position_dept(mushfiq, project_manager, pmo).


% Suspect positions and department
suspect_position_dept(mehedi, accounting_manager, accounting).
suspect_position_dept(nanziba, senior_accountant, accounting).
suspect_position_dept(nafisa, senior_executive, hr).
suspect_position_dept(sakib, software_engineer, development).
suspect_position_dept(sabbir, software_engineer, development).
suspect_position_dept(noman, vice_president, development).
suspect_position_dept(yusuf, system_administrator, it).
suspect_position_dept(dipto, ui_designer, design).
suspect_position_dept(alvee, ux_designer, design).


% Crime period (HHMM format)
crime_window(1710, 1740).
crime_location(manager_room).
cctv_erased(1740).
crime_evidence(server_room).


% Exit logs (we assume everyone entered during office hours around 9AM)
exit(mehedi, 1745).
exit(nanziba, 1747).
exit(sakib, 1730).
exit(nafisa, 1742).
exit(yusuf, 1716).
exit(dipto, 1745).
exit(sabbir, 1753).
exit(noman, 1757).
exit(alvee, 1713).


% Motive Evidence
motive_found_in_manager_room(mehedi, accounting_mismanagement).
motive_found_in_manager_room(nanziba, accounting_mismanagement).

motive_found_on_manager_mobile(nafisa, failed_affair).
motive_found_on_manager_mobile(noman, blackmail).

% Fingerprint evidence in crime zone (manager_room, server_room)
found_fingerprint(mehedi, manager_room).
found_fingerprint(nanziba, manager_room).
found_fingerprint(sakib, manager_room).
found_fingerprint(noman, manager_room).
found_fingerprint(nafisa, manager_room).
found_fingerprint(mehedi, server_room).
found_fingerprint(yusuf, server_room).
found_fingerprint(mehedi, server_room).

% Crime zone room departments
room_dept(server_room, it).
room_dept(manager_room, pmo).

% If fingerprint is found in crime zones for outsider then it is evidence against the suspect.
evidence(X):-
    found_fingerprint(X,Crime_zone),
    suspect_position_dept(X, _, X_dept),
    room_dept(Crime_zone, Crime_dept),
    X_dept \= Crime_dept.

% Motives
motive(sakib, promotion).
motive(sabbir, enemity).
motive(X,Y):-
    motive_found_in_manager_room(X,Y).
motive(X,Y):-
    motive_found_on_manager_mobile(X,Y).

% Who backs up who
cover_up(mehedi, nanziba).
cover_up(nanziba, mehedi).
cover_up(sakib, sabbir).
cover_up(sabbir, sakib).
cover_up(dipto, alvee).
cover_up(alvee, dipto).

% Testimonies when asked "where were you during 5:10-5:40 and who were you with?"
location(mehedi, coffee_room, alone).
location(nanziba, account_dept, mehedi).
location(nafisa, hr, alone).
location(sakib, main_office, sabbir).
location(yusuf, server_room, alone).
location(dipto, design, alvee).
location(sabbir, main_office, sakib).
location(noman, sr_manager_cabin, alone).
location(alvee, design, dipto).

% Contradictions in statements
contradiction(X, Y) :-
    location(X, Place, X_with),
    location(Y, Place, _),
    X_with \= Y,
    X \= Y.

contradiction(X, Y):-
    location(X, Place, _),
    location(Y, Place, Y_with),
    Y_with \= X,
    X \= Y.

contradiction(X, Y):-
    location(X, X_place, Y),
    location(Y, Y_place, _),
    X_place \= Y_place.

% If a chain of false statements found, then it is a group crime.
contradiction_chain(X,Z):-
    contradiction(X,Y),
    contradiction(Y,Z).
contradiction_chain(X,Z):-
    contradiction_chain(X,Y),
    contradiction(Y,Z).

% Suspects who gave contradictory statements
contradictors(X):-
    contradiction(X,_).
contradictors(Y):-
    contradiction(_,Y).

    
% ------ RULES ------

% Suspectes who stayed till CCTV footage erase
stayed_till_crime(X):-
    exit(X, Exit_time),
    cctv_erased(Erase_time),
    Exit_time > Erase_time.

% Filter who has motive
has_motive(X) :- 
    motive(X, _).

% Who stayed late and had motive are strong suspects
strong_suspect(X) :- 
    stayed_till_crime(X), 
    has_motive(X).

% Strong suspects who gave contradictory statements or have evidence are the possible killers.
possible_killer(X):-
    strong_suspect(X),
    contradictors(X),
    evidence(X).
    
% Possible killer pair if two possible killers covers up each other
possible_killer_pair(X, Y):-
    possible_killer(X),
    possible_killer(Y),
    cover_up(X,Y).

% After elimination from the suspect pool, if there is only one possible killer, then that person is the killer
killer(X) :-
    setof(K, possible_killer(K), [X]).
% if there is only one possible killer pair, then they are the killers.
killer_pair(X, Y) :-
    setof((A, B), ( possible_killer_pair(A, B), A @< B), [(X, Y)] ).

% Find out if the crime was committed by a group who are connected with each other.
killer_group_chain(X,Z):-
    possible_killer_pair(X,Y),
    possible_killer_pair(Y,Z),
	X \= Z.
killer_group_chain(X,Z):-
    killer_pair(X,Y),
    killer_group_chain(Y,Z).

% --- Get information about possible killers ---

% Motive of possible killers
possible_killers_motive(Killer, Motive):-
    possible_killer(Killer),
    motive(Killer, Motive).
    
% Evidence of possible killers
possible_killers_evidence(Killer, Fingerprint):-
    possible_killer(Killer),
    found_fingerprint(Killer, Fingerprint).

possible_killer_contradiction(Killer, Contradiction_with):-
    possible_killer(Killer),
    contradiction(Killer, Contradiction_with).

possible_killer_coverup(Killer, Coverup):-
    killer(Killer),
    cover_up(Killer, Coverup).

% --- Get information about killer ---

% Killer motive
killer_motive(Killer, Motive):-
    killer(Killer),
    motive(Killer, Motive).

% Killer evidence
killer_evidence(Killer, Fingerprint):-
    killer(Killer),
    found_fingerprint(Killer, Fingerprint).

% Killers statements contradiction
killer_contradiction(Killer, Contradiction_with):-
    killer(Killer),
    contradiction(Killer, Contradiction_with).

% Killer coverups
killer_coverup(Killer, Coverup):-
    killer(Killer),
    cover_up(Killer, Coverup).

% --- Get information about killer pair ---

% Killer pair motives
killer_pair_motives(X, Motive):-
    killer_pair(X, _),
    motive(X, Motive).
killer_pair_motives(Y, Motive):-
    killer_pair(_, Y),
    motive(Y, Motive).

% Killer pair evidence
killer_pair_evidence(X, Fingerprint):-
    killer_pair(X, _),
    found_fingerprint(X, Fingerprint).
killer_pair_evidence(Y, Fingerprint):-
    killer_pair(_, Y),
    found_fingerprint(Y, Fingerprint).

% Killer pair coverups
killer_pair_coverup(X, Coverup):-
    killer_pair(X, _),
    cover_up(X, Coverup).
killer_pair_coverup(Y, Coverup):-
    killer_pair(_, Y),
    cover_up(Y, Coverup).

% ------------ SAMPLE QUERIES ------------
% --- Suspect Evaluation ---
% ?- has_motive(X).
% ?- stayed_till_crime(X).
% ?- strong_suspect(X).
% ?- contradiction(X, Y).
% ?- contradictors(X).
% ?- evidence(X).
% ?- possible_killer(X).
% 
% --- Collaborative Crime Detection ---
% ?- cover_up(X, Y).
% ?- possible_killer_pair(X, Y).
% ?- killer_pair(X, Y).
% ?- killer_group_chain(X, Z).
% 
% --- Final Deduction ---
% ?- killer(X).
% 
% --- Information Retrieval ---
% ?- possible_killers_motive(Killer, Motive).
% ?- possible_killers_evidence(Killer, Fingerprint).
% ?- possible_killer_coverup(Killer, Coverup).
% ?- possible_killer_contradiction(Killer, Contradiction_with).
% 
% ?- killer_motive(Killer, Motive).
% ?- killer_evidence(Killer, Fingerprint).
% ?- killer_contradiction(Killer, Contradiction_with).
% ?- killer_coverup(Killer, Coverup).
% 
% ?- killer_pair_motives(X, Motive).
% ?- killer_pair_evidence(X, Fingerprint).
% ?- killer_pair_coverup(X, Coverup).
