% nodedef.m
% 
% Defines the hierarchy of nodes for the classifier, the cpc classes
% that are contained in them, and should act as the single reference point to 
% minimise duplication errors.
%
% Author:   Navid Nourani @ ACFR
% Varsion:  1.0 2013-08-01

% The tree will look line this:
%	rootNode
% 	 CPC: <Blank, UNS>
% 		node_PHYSICAL
% 		 CPC: <>
% 			node_PHYSICAL_HARD
% 			 CPC: <ROCK>
% 			node_PHYSICAL_SOFT
% 			 CPC: <SAND>
% 		node_BIOTA
% 		 CPC: <MATR, UNK, BRUB, UNID, NZSS>
% 			node_BIOTA_SPONGES
% 			 CPC: <A1WF, A2GR, A3PT, A4OF, A5W, A6Y, A7PU, A8T, A9OT, A10F, A11OF, A12BT, A13O, A14B, A15WS, A16BT, C1W, C2WF, C3B, C4BT, C5R, C6PT, C7LPFT, C8Y, E1OR, E2OR, E3Y, E4BL, E5BR, E6WH, E7G, F1OR, F2BR, F3OF, F4PI, F5PE, F6Y, F7ORT, F8BT, F9ORT, F10, F11PT, F12BT, F13OF, F14WT, F15OT, G1OR, G2WH, G3BL, G4O, L1PS, L2O, L3W, L4P, L5Y, M1, M2, M3OR, M4DON, M5, M6VEL, M7BL, M8, M9WH, M10BR, M11WH, M12YP, M13WP, M14OR, M15PS, M16P, M17WL, M18OH, M19, M20P, P1SU, P2Y, P3B, P4LO, R1B, T1PI, T2, T3WC, T4T, T5, T6WT, T7PT, T8OR, T9PP, T10OT, T11B, T12PO, T13, T14S>
% 			node_BIOTA_ECHINODERMS
% 			 CPC: <CENOL, HOL, SS, BS, URCH>
% 			node_BIOTA_CNIDARIA
% 			 CPC: <C2S, C3BR, C4BR, C5OS, C6SB, C7SY, G1P, G2R, HYD1, SPEN, SW1, PARA1, ANEM1>
% 			node_BIOTA_BRYOZOA
% 			 CPC: <BRY1, BRY2, BRY3, BRY4, BRY5, BRY6, BRY7, BRY8>
% 			node_BIOTA_OTHER
% 			 CPC: <MOL, ABAL, SCAL, A1Cl, A2Cl, AS3O, A4Sy, A5Sol, A6R, A7Sol, A8O, FISH, TW1, BIOT>
% 			node_BIOTA_ALGAE
% 			 CPC: <BUST, COD, CAL, UNA, DRIFT, RFOL, GO, TURF>
% 				node_BIOTA_ALGAE_CANOPY
% 				 CPC: <>
% 					node_BIOTA_ALGAE_CANOPY_ECK
% 					 CPC: <ECK>
% 					node_BIOTA_ALGAE_CANOPY_OTHER
% 					 CPC: <BOCF, PHY>
% 				node_BIOTA_ALGAE_ERECTBRANCHING
% 				 CPC: <>
% 					node_BIOTA_ALGAE_ERECTBRANCHING_BROWN
% 					 CPC: <SAR>
% 					node_BIOTA_ALGAE_ERECTBRANCHING_RED
% 					 CPC: <THAM>
% 				node_BIOTA_ALGAE_CRUSTOSE
% 				 CPC: <>
% 					node_BIOTA_ALGAE_CRUSTOSE_ECOR
% 					 CPC: <ECOR>
% 					node_BIOTA_ALGAE_CRUSTOSE_SOND
% 					 CPC: <SOND>

% These are the node numbers:
%
% rootNode: 0
% node_PHYSICAL: 1
% node_PHYSICAL_HARD: 2
% node_PHYSICAL_SOFT: 3
% node_BIOTA: 4
% node_BIOTA_SPONGES: 5
% node_BIOTA_ECHINODERMS: 6
% node_BIOTA_CNIDARIA: 7
% node_BIOTA_BRYOZOA: 8
% node_BIOTA_OTHER: 9
% node_BIOTA_ALGAE: 10
% node_BIOTA_ALGAE_CANOPY: 11
% node_BIOTA_ALGAE_CANOPY_ECK: 12
% node_BIOTA_ALGAE_CANOPY_OTHER: 13
% node_BIOTA_ALGAE_ERECTBRANCHING: 14
% node_BIOTA_ALGAE_ERECTBRANCHING_BROWN: 15
% node_BIOTA_ALGAE_ERECTBRANCHING_RED: 16
% node_BIOTA_ALGAE_CRUSTOSE: 17
% node_BIOTA_ALGAE_CRUSTOSE_ECOR: 18
% node_BIOTA_ALGAE_CRUSTOSE_SOND: 19

node.name = '';
node.labels = '';
node.children = {};

% Algae
node_BIOTA_ALGAE_CANOPY_ECK = node;
node_BIOTA_ALGAE_CANOPY_ECK.name = 'node_BIOTA_ALGAE_CANOPY_ECK';
node_BIOTA_ALGAE_CANOPY_ECK.labels = {
    'ECK'};

node_BIOTA_ALGAE_CANOPY_OTHER = node;
node_BIOTA_ALGAE_CANOPY_OTHER.name = 'node_BIOTA_ALGAE_CANOPY_OTHER';
node_BIOTA_ALGAE_CANOPY_OTHER.labels = {
    'BOCF'; 'PHY'};

node_BIOTA_ALGAE_CANOPY = node;
node_BIOTA_ALGAE_CANOPY.name = 'node_BIOTA_ALGAE_CANOPY';
node_BIOTA_ALGAE_CANOPY.labels = {
    'CANOPY'}; % dummy label
node_BIOTA_ALGAE_CANOPY.children = {
    node_BIOTA_ALGAE_CANOPY_ECK;
    node_BIOTA_ALGAE_CANOPY_OTHER};


node_BIOTA_ALGAE_ERECTBRANCHING_BROWN = node;
node_BIOTA_ALGAE_ERECTBRANCHING_BROWN.name = 'node_BIOTA_ALGAE_ERECTBRANCHING_BROWN';
node_BIOTA_ALGAE_ERECTBRANCHING_BROWN.labels = {
    'SAR'};

node_BIOTA_ALGAE_ERECTBRANCHING_RED = node;
node_BIOTA_ALGAE_ERECTBRANCHING_RED.name = 'node_BIOTA_ALGAE_ERECTBRANCHING_RED';
node_BIOTA_ALGAE_ERECTBRANCHING_RED.labels = {
    'THAM'};

node_BIOTA_ALGAE_ERECTBRANCHING = node;
node_BIOTA_ALGAE_ERECTBRANCHING.name = 'node_BIOTA_ALGAE_ERECTBRANCHING';
node_BIOTA_ALGAE_ERECTBRANCHING.labels = {
    'ERECTBRANCHING'};
node_BIOTA_ALGAE_ERECTBRANCHING.children = {
    node_BIOTA_ALGAE_ERECTBRANCHING_BROWN;
    node_BIOTA_ALGAE_ERECTBRANCHING_RED;};

node_BIOTA_ALGAE_CRUSTOSE_ECOR = node;
node_BIOTA_ALGAE_CRUSTOSE_ECOR.name = 'node_BIOTA_ALGAE_CRUSTOSE_ECOR';
node_BIOTA_ALGAE_CRUSTOSE_ECOR.labels = {
    'ECOR'};

node_BIOTA_ALGAE_CRUSTOSE_SOND = node;
node_BIOTA_ALGAE_CRUSTOSE_SOND.name = 'node_BIOTA_ALGAE_CRUSTOSE_SOND';
node_BIOTA_ALGAE_CRUSTOSE_SOND.labels = {
    'SOND'};

node_BIOTA_ALGAE_CRUSTOSE = node;
node_BIOTA_ALGAE_CRUSTOSE.name = 'node_BIOTA_ALGAE_CRUSTOSE';
node_BIOTA_ALGAE_CRUSTOSE.children = {
    node_BIOTA_ALGAE_CRUSTOSE_ECOR;
    node_BIOTA_ALGAE_CRUSTOSE_SOND};

node_BIOTA_ALGAE = node;
node_BIOTA_ALGAE.name = 'node_BIOTA_ALGAE';
node_BIOTA_ALGAE.labels = {
    'BUST';
    'COD';
    'CAL';
    'UNA';
    'DRIFT';
    'RFOL';
    'GO';
    'TURF'};
node_BIOTA_ALGAE.children = {
    node_BIOTA_ALGAE_CANOPY;
    node_BIOTA_ALGAE_ERECTBRANCHING;
    node_BIOTA_ALGAE_CRUSTOSE;};

% Biota
node_BIOTA_BRYOZOA = node;
node_BIOTA_BRYOZOA.name = 'node_BIOTA_BRYOZOA';
node_BIOTA_BRYOZOA.labels = {
    'BRY1'; %"Bryozoan 1 Steginoprella like", "B"
    'BRY2'; %"Bryozoan 2 soft Amathia like", "B"
    'BRY3'; %"Bryozoan 3 Cantinicella like", "B"
    'BRY4'; %"Bryozoan 4 soft brown", "B"
    'BRY5'; %"Bryozoan 5 soft Orthoscuticella like", "B"
    'BRY6'; %"Bryozoan 6 hard Celleporaria like", "B"
    'BRY7'; %"Bryozoan 7 Kelp", "B"
    'BRY8'; %"Bryozoan 8 lace", "B"
    };

node_BIOTA_CNIDARIA = node;
node_BIOTA_CNIDARIA.name = 'node_BIOTA_CNIDARIA';
node_BIOTA_CNIDARIA.labels = {
    'C2S'; %"Coral 2 soft Capnella like", "C"
    'C3BR';%"bramble Acabaria sp", "C"
    'C4BR'; %"bramble Asperaxis kareni", "C"
    'C5OS'; %"orange solitary coral", "C"
    'C6SB'; %"Coral 6 soft blue", "C"
    'C7SY'; %"Coral 7 soft coral", "C"
    'G1P'; %"Gorgonian pink 1", "C"
    'G2R'; %"Gorgonian red 2", "C"
    'HYD1';%"Hydroid 1", "C"
    'SPEN';%"Sea Pen","C"
    'SW1';%"sea whip 1", "C"
    'PARA1'; %"Parazoanthus 1", "C"
    'ANEM1';%"Anemone sp1","AN"
    };

node_BIOTA_ECHINODERMS = node;
node_BIOTA_ECHINODERMS.name = 'node_BIOTA_ECHINODERMS';
node_BIOTA_ECHINODERMS.labels = {
    'CENOL';%"Cenolia spp", "E
    'HOL';%"Holothuroidea", "E"
    'SS';%"Sea star", "E"
    'BS';%"Brittle star", "E"
    'URCH'; %"Urchins", "E"
    };

node_BIOTA_SPONGES = node;
node_BIOTA_SPONGES.name = 'node_BIOTA_SPONGES';
node_BIOTA_SPONGES.labels = {
    'A1WF'; %'Arborescent 1 white flat'; 'SP'
    'A2GR'; %'Arborescent 2 grey'; 'SP'
    'A3PT'; %'Arborescent 3 purple thin'; 'SP'
    'A4OF'; %'Arborescent 4 orange flat'; 'SP'
    'A5W'; %'Arborescent 5 white'; 'SP'
    'A6Y'; %'Arborescent 6 yellow'; 'SP'
    'A7PU'; %'Arborescent 7 purple'; 'SP'
    'A8T'; %'Arborescent 8 tan'; 'SP'
    'A9OT'; %'Arborescent 9 orange thin'; 'SP'
    'A10F'; %'Arborescent 10 orange/brown fingers'; 'SP'
    'A11OF'; %'Arborescent 11 orange fan'; 'SP'
    'A12BT'; %'Arborescent 12 brown thorny'; 'SP'
    'A13O'; %'Arborescent 13 orange'; 'SP'
    'A14B'; %'Arborescent 14 black'; 'SP'
    'A15WS'; %'Arborescent 15 white short'; 'SP'
    'A16BT'; %'Arborescent 16 brown thick'; 'SP'
    'C1W'; %'Cup 1 white'; 'SP'
    'C2WF'; %'Cup 2 white frilly'; 'SP'
    'C3B'; %'Cup 3 blue'; 'SP'
    'C4BT'; %'Cup 4 blue thick'; 'SP'
    'C5R'; %'Cup 5 red'; 'SP'
    'C6PT'; %'Cup 6 pink thick'; 'SP'
    'C7LPFT'; %'Cup 7 light pink flat thick'; 'SP'
    'C8Y'; %'Cup 8 yellow'; 'SP'
    'E1OR'; %'Encrusting 1 orange'; 'SP'
    'E2OR'; %'Encrusting 2 light orange'; 'SP'
    'E3Y'; %'Encrusting 3 yellow'; 'SP'
    'E4BL'; %'Encrusting 4 blue'; 'SP'
    'E5BR'; %'Encrusting 5 brown'; 'SP'
    'E6WH'; %'Encrusting 6 white'; 'SP'
    'E7G'; %'Encrusting 7 green'; 'SP'
    'F1OR'; %'Fan 1 orange'; 'SP'
    'F2BR'; %'Fan 2 brown'; 'SP'
    'F3OF'; %'Fan 3 orange flat'; 'SP'
    'F4PI'; %'Fan 4 pink'; 'SP'
    'F5PE'; %'Fan 5 peach'; 'SP'
    'F6Y'; %'Fan 6 yellow'; 'SP'
    'F7ORT'; %'Fan 7 orange thin blade'; 'SP'
    'F8BT'; %'Fan 8 blue thick'; 'SP'
    'F9ORT'; %'Fan 9 orange thick'; 'SP'
    'F10'; %'Fan 10 thick large oscules'; 'SP'
    'F11PT'; %'Fan 11 thick pink'; 'SP'
    'F12BT'; %'Fan 12 browm thin'; 'SP'
    'F13OF'; %'Fan 13 orange frilly'; 'SP'
    'F14WT'; %'Fan 14 white thin'; 'SP'
    'F15OT'; %'Fan 15 orange thorny'; 'SP'
    'G1OR'; %'Globular 1 orange Tethya like'; 'SP'
    'G2WH'; %'Globular 2 white Tethya like'; 'SP'
    'G3BL'; %'Globular 3 blue'; 'SP'
    'G4O'; %'Globular 4 orange'; 'SP'
    'L1PS'; %'Lumpy 1 purple stumps';'SP'
    'L2O'; %'Lumpy 2 orange'; 'SP'
    'L3W'; %'Lumpy 3 white'; 'SP'
    'L4P'; %'Lumpy 4 pink'; 'SP'
    'L5Y'; %'Lumpy 5 yellow'; 'SP'
    'M1'; %'Massive 1'; 'SP'
    'M2'; %'Massive 2'; 'SP'
    'M3OR'; %'Massive 3 orange'; 'SP'
    'M4DON'; %'Massive 4 donut'; 'SP'
    'M5'; %'Massive 5 fungi'; 'SP'
    'M6VEL'; %'Massive 6 velet'; 'SP'
    'M7BL'; %'Massive 7 blue'; 'SP'
    'M8'; %'Massive 8'; 'SP'
    'M9WH'; %'Massive 9 white'; 'SP'
    'M10BR'; %'Massive 10 brown'; 'SP'
    'M11WH'; %'Massive 11 white holey'; 'SP'
    'M12YP'; %'Massive 12 yellow papillate'; 'SP'
    'M13WP'; %'Massive 13 white papillate'; 'SP'
    'M14OR'; %'Massive 14 orange shapeless'; 'SP'
    'M15PS'; %'Massive 15 shapeless'; 'SP'
    'M16P'; %'Massive 16 purple'; 'SP'
    'M17WL'; %'Massive 17 white lumpy'; 'SP'
    'M18OH'; %'Massive 18 orange holey'; 'SP'
    'M19'; %'Massive 19 yellow shapeless'; 'SP'
    'M20P'; %'Massive 20 pink'; 'SP'
    'P1SU'; %'Papillate 1 Suberites like'; 'SP'
    'P2Y'; %'Papillate 2 yellow'; 'SP'
    'P3B'; %'Papillate 3 black'; 'SP'
    'P4LO'; %'Papillate 4 light orange'; 'SP'
    'R1B'; %'Repent 1 brown'; 'SP'
    'T1PI'; %'Tubular 1 pink'; 'SP'
    'T2'; %'Tubular 2 apricot'; 'SP'
    'T3WC'; %'Tubular 3 white colony'; 'SP'
    'T4T'; %'Tubular 4 tan'; 'SP'
    'T5'; %'Tubular 5 tan singular'; 'SP'
    'T6WT'; %'Tubular 6 white thorny'; 'SP'
    'T7PT'; %'Tubualr 7 pink thorny'; 'SP'
    'T8OR'; %'Tubular 8 orange'; 'SP'
    'T9PP'; %'Tubular 9 pink small oscules'; 'SP'
    'T10OT';% 'Tubular 10 orange thorny'; 'SP'
    'T11B'; %'Tubular 11 blue'; 'SP'
    'T12PO'; %'Tubular 12 pale orange'; 'SP'
    'T13'; %'Tubular 13 Sycon'; 'SP'
    'T14S'; %'Tubular 14 solitary'; 'SP'
    };

node_BIOTA_OTHER = node;
node_BIOTA_OTHER.name = 'node_BIOTA_OTHER';
node_BIOTA_OTHER.labels = {
    'MOL'; %'Mollusc'; 'M'
    'ABAL';%'Abalone';'M'
    'SCAL';%'Scallop';'M'
    'A1Cl';%'Ascidian 1 Clavelina like'; 'A'
    'A2Cl';%'Ascidian 2 Clavelina like'; 'A'
    'AS3O';%'Ascidian 3 orange'; 'A'
    'A4Sy';%'Ascidian 4 Sycozoa like'; 'A'
    'A5Sol';%'Ascidian 5 Solitary'; 'A'
    'A6R';%'Ascidian 6 Red throated'; 'A'
    'A7Sol'; %'Ascidian 7 Solitary'; 'A'
    'A8O'; %'Ascidian 8 Others'; 'A'
    'FISH';  %'Fish';'F'
    'TW1';  %'Tube Worm sp1'; 'T'
    'BIOT';%'Bioturbation';'SU'
    };

node_BIOTA = node;
node_BIOTA.name = 'node_BIOTA';
node_BIOTA.labels = {
    'MATR';%"Biogenic Matrix", "BM"
    'UNK';%"Unknown Biology", "UN"
    'BRUB'; %"Biological Rubble", "SU"
    'UNID';%"unidentified sp","UN"
    'NZSS';%"Screw Shell","M"
    };
node_BIOTA.children = {
    node_BIOTA_SPONGES;
    node_BIOTA_ECHINODERMS;
    node_BIOTA_CNIDARIA;
    node_BIOTA_BRYOZOA;
    node_BIOTA_OTHER;
    node_BIOTA_ALGAE};

% physical
node_PHYSICAL_HARD = node;
node_PHYSICAL_HARD.name = 'node_PHYSICAL_HARD';
node_PHYSICAL_HARD.labels = {
    'ROCK'};

node_PHYSICAL_SOFT = node;
node_PHYSICAL_SOFT.name = 'node_PHYSICAL_SOFT';
node_PHYSICAL_SOFT.labels = {
    'SAND'};

node_PHYSICAL = node;
node_PHYSICAL.name = 'node_PHYSICAL';
node_PHYSICAL. children = {
    node_PHYSICAL_HARD;
    node_PHYSICAL_SOFT
    };

% root
rootNode = node;
rootNode.name = 'rootNode';
rootNode.labels = {
    'Blank'; %"Blank","Blank"
    'UNS'; % "Unscorable", "UN"
    };
rootNode.children = {
    node_PHYSICAL;
    node_BIOTA'
    };

clear node_PHYSICAL node_PHYSICAL_SOFT node_PHYSICAL_HARD node_BIOTA 
clear node_BIOTA_ALGAE node_BIOTA_ALGAE_CANOPY node_BIOTA_ALGAE_CANOPY_ECK
clear node_BIOTA_ALGAE_CANOPY_OTHER node_BIOTA_ALGAE_CRUSTOSE
clear node_BIOTA_ALGAE_CRUSTOSE_ECOR node_BIOTA_ALGAE_CRUSTOSE_SOND
clear node_BIOTA_ALGAE_ERECTBRANCHING node_BIOTA_ALGAE_ERECTBRANCHING_BROWN
clear node_BIOTA_ALGAE_ERECTBRANCHING_RED node_BIOTA_BRYOZOA 
clear node_BIOTA_CNIDARIA node_BIOTA_ECHINODERMS node_BIOTA_OTHER
clear node_BIOTA_SPONGES node

% Calculate tree level and node numbers

