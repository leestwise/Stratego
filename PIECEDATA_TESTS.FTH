\ PIECE array creation for Stratego in FbForth

\ Strategy: create a meta language to manage the 
\           data structures for game pieces

\ Version 2 creates 2 sets of PIECEs
\ Each piece is row in an array of pieces
\ The 1 .. 12 are the human's pieces
\ The 13.. 25 are the computer's pieces

\ the programmer pre-selects which set to use with the
\ words: MY  for human  and HIS for computer.
\ These  are aliased as HUMAN   COMPUTER

\ ==================================================
\ a few helpers
: BOUNDS ( addr len -- addr2 addr1)  OVER + SWAP ; \ Handy
: CELLS  ( n -- n')  1 SLA ;  ( 2* )
: CHARS ;
: WITHIN  ( n lo hi -- ?) OVER - >R - R> U< ;
: $!  ( adr adr -- ) OVER C@ 1+ CMOVE ;
: CELL+   2+ ;
: CELLS   1 SLA ;
: CHARS ;
: WITHIN  ( n lo hi -- ?) \ n2<=n1<n3?
          OVER - >R - R> U< ;

: 2! ( n1 n2 adr -- )   ROT OVER 2+ !  ! ;
: 2@ ( adr -- n1 n2 )   DUP 2+ @ SWAP @ ;

HEX
: SPLIT      ( n -- c c )  DUP 00FF AND SWAP FF00 AND SWPB ;

\ ==========================
\ forth 2012 structures
\ A.15 The optional Facility word set

DECIMAL
: +FIELD  \ n <"name"> -- ; Exec: addr -- 'addr
   <BUILDS OVER , +
   DOES> @  + ;

\ using +field you can make your own field desciptors.
: FIELD:    ( n1 "name" -- n2 ; addr1 -- addr2 ) 1 CELLS +FIELD ;
: 2FIELD:   ( d1 "name" -- d2 ; addr1 -- addr2 ) 2 CELLS +FIELD ;
: CFIELD:   ( n1 "name" -- n2 ; addr1 -- addr2 ) 1 CHARS +FIELD ;
: CELLS:    ( n1 "name" -- n2 ; addr1 -- addr2 )   CELLS +FIELD ;

\ we can add string size tests for a CHARS: field
\ : ?STRING   ( n -- n) DUP 1 256 WITHIN 0= ABORT" bad string length" ;
\ : CHARS:    ( n -- ) ?STRING CHARS +FIELD ;  ( CHARS is a NOOP on 9900)
\ =========================

\ named character patterns (used with DCHAR)
: PATTERN: ( n --  addr n)
            <BUILDS ( length) ,
            DOES> DUP CELL+  SWAP @  ;
HEX
8 PATTERN: BOMBPAT   000C , 1238 , 747C , 3800 , \ 96
8 PATTERN: FLAGPAT   0078 , 4E7A , 4E42 , 4000 ,
8 PATTERN: SPYPAT    0038 , 343C , BD7E , 0000 ,
8 PATTERN: GENPAT    0A05 , 0618 , 3C5E , FF00 ,
8 PATTERN: MARSHPAT  0106 , 0C1E , 2E7E , FF00 , \ 100
8 PATTERN: COLOPAT   0808 , 1C3D , 3E5E , 7E00 ,
8 PATTERN: MAJORPAT  020C , 3C74 , EC5C , 7E00 ,
8 PATTERN: CAPTPAT   020C , 1E3A , 366E , 7F00 ,
8 PATTERN: LIEUTPAT  0018 , 3C66 , DBFF , 7E00 ,
8 PATTERN: SARGPAT   0C3E , EE76 , 3A3E , 1C00 ,
8 PATTERN: MINERPAT  040C , 3E67 , 79FF , 1E00 ,
8 PATTERN: SCOUTPAT  041C , 3E73 , CFF8 , C000 ,
8 PATTERN: 10PAT     0099 , FF91 , D5D5 , D5D1 ,
8 PATTERN: 2PAT      0099 , FFC3 , FBC3 , DFC3 ,
8 PATTERN: 3PAT      0099 , FFC3 , FBF3 , FBC3 ,
8 PATTERN: 4PAT      0099 , FFF3 , EBDB , C3FB ,
8 PATTERN: 5PAT      0099 , FFC3 , DFC3 , FBC3 ,
8 PATTERN: 6PAT      0099 , FFC3 , DFC3 , DBC3 ,
8 PATTERN: 7PAT      0099 , FFC3 , FBF7 , EFDF ,
8 PATTERN: 8PAT      0099 , FFC3 , DBC3 , DBC3 ,
8 PATTERN: 9PAT      0099 , FFC3 , DBC3 , FBFB ,
8 PATTERN: BPAT      0099 , FFC7 , DBC3 , DBC7 ,
8 PATTERN: FPAT      0099 , FFC3 , DFC7 , DFDF ,
8 PATTERN: SPAT      0099 , FFE3 , DFE3 , FBC7 , \ 'S'
8 PATTERN: ULCNRPAT  0040 , 6D5F , 5F5F , 5F5F , \ upleft
8 PATTERN: URCNRPAT  0002 , B6FA , FAFA , FAFA , \ upright
8 PATTERN: LLCNRPAT  5F5F , 5F5F , 5F5F , 7F00 , \ lowleft
8 PATTERN: LRCNRPAT  FAFA , FAFA , FAFA , FE00 , \ lowright
8 PATTERN: '|'PAT    0010 , 1010 , 0010 , 1010 ,

GRAPHICS

\ *** OPTIONAL ***
\ character definition assistance.
\ assign the first character, the rest follow
0 VARIABLE 1ST         \

: %%   ( -- 8 char) 8  1ST @  1 1ST +! ;
DECIMAL
\ USAGE:
\        96 1ST !   ( ** 1ST CHAR ** )
\        BOMBPAT %% DCHAR

\ write character patterns to Pattern Table
: DEFALLCHARS
  BOMBPAT      96 DCHAR
  FLAGPAT      97 DCHAR  \ +1
  SPYPAT       98 DCHAR  \ +2
  GENPAT       99 DCHAR
  MARSHPAT    100 DCHAR
  COLOPAT     101 DCHAR
  MAJORPAT    102 DCHAR
  CAPTPAT     103 DCHAR
  LIEUTPAT    104 DCHAR
  SARGPAT     105  DCHAR
  MINERPAT    106 DCHAR
  SCOUTPAT    107 DCHAR
  10PAT       108 DCHAR \ +12
  2PAT        109 DCHAR
  3PAT        110 DCHAR
  4PAT        111 DCHAR
  5PAT        112 DCHAR
  6PAT        113 DCHAR
  7PAT        114 DCHAR
  8PAT        115 DCHAR
  9PAT        116 DCHAR
  BPAT        117 DCHAR  \ +20
  FPAT        118 DCHAR
  SPAT        119 DCHAR
  ULCNRPAT    120 DCHAR  \ +23
  URCNRPAT    121 DCHAR  \ +24
  LLCNRPAT    122 DCHAR  \ +25
  LRCNRPAT    123 DCHAR  \ +26
  '|'PAT      124 DCHAR  \ +27
;

\ debug word to see the characters
: .CHARS  ( start stop -- )
   1+ SWAP
   DO   CR I DUP     3 .R  SPACE EMIT  10 SPACES
           I 1+ DUP  3 .R  SPACE  EMIT
   2 +LOOP ;


\ ============================================
\ SHAPE: A container to hold  chars that define a game PIECE
\        Stratego shapes are a counted string (6 bytes>)

: SHAPE:  ( length -- )  <BUILDS C, DOES>   ;

DECIMAL
\                        =TOP ROW=           =BOT ROW=
\                     UL     CHR    UR         LL   CHR    LR
6 SHAPE: ABOMB       120 C, 117 C, 121 C, 122 C,  96 C, 123 C,
6 SHAPE: AMARSHAL    120 C, 108 C, 121 C, 122 C, 100 C, 123 C,
6 SHAPE: AGENERAL    120 C, 116 C, 121 C, 122 C,  99 C, 123 C,
6 SHAPE: ACOLONEL    120 C, 115 C, 121 C, 122 C, 101 C, 123 C,
6 SHAPE: AMAJOR      120 C, 114 C, 121 C, 122 C, 102 C, 123 C,
6 SHAPE: ACAPTAIN    120 C, 113 C, 121 C, 122 C, 103 C, 123 C,
6 SHAPE: ALIEUT      120 C, 112 C, 121 C, 122 C, 104 C, 123 C,
6 SHAPE: ASERGEANT   120 C, 111 C, 121 C, 122 C, 105 C, 123 C,
6 SHAPE: AMINER      120 C, 110 C, 121 C, 122 C, 106 C, 123 C,
6 SHAPE: ASCOUT      120 C, 109 C, 121 C, 122 C, 107 C, 123 C,
6 SHAPE: ASPY        120 C, 119 C, 121 C, 122 C,  98 C, 123 C,
6 SHAPE: AFLAG       120 C, 118 C, 121 C, 122 C,  97 C, 123 C,

: EMIT++  ( addr -- addr++ ) 1+ DUP C@ EMIT ;

 : .DRAW ( shape -- )
         CR EMIT++ EMIT++  EMIT++
         CR EMIT++ EMIT++  EMIT++
         DROP  ;

\ debug word shows ascii chars and draws game piece
: .SHAPE ( shape -- )
         CR DUP COUNT BOUNDS  DO  I C@ . LOOP
         .DRAW CR ;

\ =========================================
\ ENUM  made with CONSTANT. From Neil Baud's Toolbox
: ENUM  ( n <text> -- n') DUP CONSTANT  1+ ;

\ create named INDEX for each piece.
\ These are PIECE ID#s that go into the BOARD matrix
\ NIL (0) is use for an un-occupied board position
DECIMAL
0 ENUM NIL
ENUM BOMB     ENUM MARSHAL  ENUM GENERAL
ENUM COLONEL  ENUM MAJOR    ENUM CAPTAIN
ENUM LIEUT    ENUM SERGEANT ENUM MINER
ENUM SCOUT    ENUM SPY      ENUM FLAG
( -- n ) 1- CONSTANT #PIECES  \ total number of pieces


\ ==========================================
\ PIECE:  holds all information about a game piece
\ DOC:
\  PIECEs have 7 named fields  shown in the structure
\  Each piece has a unique ID
\  Pieces exist on the 10x10 board as their ID field
\  Piece IDs exist in two teams COMPUTER and HUMAN
\  A team is an array of 40 pieces


\ Define PIECE DATA structure
 0
 2FIELD: XY]       \ double cell, TI xy coordinates. Use 2@ 2!
  FIELD: RANK]
  FIELD: MOTION]
  FIELD: RULE]
  FIELD: SHAPE]    \ SHAPE address
  FIELD: ID]       \ INDEX number in the piece array
  FIELD: QTY]      \ No. of BOMBs left to use
   CONSTANT PIECE_STRUC

\ create memory for 2 Armies of pieces
: BUFFER:      <BUILDS ALLOT DOES> ; 

PIECE_STRUC #PIECES 1+ 2 * * BUFFER: PIECES[]

\ ** ARMY controls which set of pieces is indexed **
\ 1..12  or  13..25
0 VARIABLE ARMY

\ expose pieces as an indexed array of structures
: ]PIECE ( n -- piece_address ) ARMY @ +  PIECE_STRUC * PIECES[] + ;


\ ARMY selectors
: MY      0 ARMY ! ;           \ pieces  1 .. 12
: HIS     #PIECES 1+ ARMY ! ;  \ pieces 13 .. 25

\ aliases
: HUMAN      MY ;
: COMPUTER   HIS ;

\ ==========================================
\  Name                 ndx   arrayofstruct
: [BOMB     ( -- addr) BOMB     ]PIECE ;
: [MARSHAL  ( -- addr) MARSHAL  ]PIECE ;
: [GENERAL  ( -- addr) GENERAL  ]PIECE ;
: [COLONEL  ( -- addr) COLONEL  ]PIECE ;
: [MAJOR    ( -- addr) MAJOR    ]PIECE ;
: [CAPTAIN  ( -- addr) CAPTAIN  ]PIECE ;
: [LIEUT    ( -- addr) LIEUT    ]PIECE ;
: [SERGEANT ( -- addr) SERGEANT ]PIECE ;
: [MINER    ( -- addr) MINER    ]PIECE ;
: [SCOUT    ( -- addr) SCOUT    ]PIECE ;
: [SPY      ( -- addr) SPY      ]PIECE ;
: [FLAG     ( -- addr) FLAG     ]PIECE ;


\ WORDS with a leading ':" are actions on data.
: :INIT]  ( n n n n n n n PIECEaddr -- ) \ data -> PIECEaddress
         >R
\         DEPTH 8 < ABORT" Missing args"
         R QTY] !
         R ID]   !
         R SHAPE] !
         R RULE] !
         R MOTION] !
         R RANK] !
         R XY] 2!
         R> DROP
;

\ From Wikipedia
\ RANK          NAME    COUNT RULE/Unique Feature
\ ---------------------------------------------
\ B	        BOMB	   6  1. Immovable; defeats any attacking piece except Miner
\ 10 or 1	Marshal	   1  2. Can be captured by the Spy
\ 9 or 2	General	   1
\ 8 or 3	Colonel	   2
\ 7 or 4	Major	   3
\ 6 or 5	Captain    4
\ 5 or 6	Lieutenant 4
\ 4 or 7	Sergeant   4
\ 3 or 8	Miner	   5  3. Can defuse BOMBs
\ 2 or 9	Scout	   8  4. moves any distance in a straight line,
\                                can't jump pieces OR lakes

\ 1 or S	Spy        1  5. Can defeat the Marshal,
\                                but only if the Spy makes the attack
\ F             Flag       1

\ Special RANKS
ASCII B CONSTANT 'B'    \ BOMB rank
ASCII F CONSTANT 'F'    \ Spy rank
ASCII S CONSTANT 'S'    \ Flag rank

DECIMAL
\ Initialize the pieces per Wikipedia table
\ XY  rnk  mtn Rule Shape     ID  Qty
\ --  --- ---- ---- -----     --  ---
HUMAN
 1 2  'B'  00   1  ABOMB       1  6 [BOMB     :INIT]
 0 0  10   00   2  AMARSHAL    2  1 [MARSHAL  :INIT]
 0 0   9   00   0  AGENERAL    3  1 [GENERAL  :INIT]
 0 0   8   00   0  ACOLONEL    4  2 [COLONEL  :INIT]
 0 0   7   00   0  AMAJOR      5  3 [MAJOR    :INIT]
 0 0   6   00   0  ACAPTAIN    6  4 [CAPTAIN  :INIT]
 0 0   5   00   0  ALIEUT      7  4 [LIEUT    :INIT]
 0 0   4   00   0  ASERGEANT   8  4 [SERGEANT :INIT]
 0 0   3   00   3  AMINER      9  5 [MINER    :INIT]
 0 0   2   00   4  ASCOUT     10  8 [SCOUT    :INIT]
 0 0  'S'  00   5  ASPY       11  1 [SPY      :INIT]
 0 0  'F'  00   0  AFLAG      12  1 [FLAG     :INIT]

COMPUTER
 0 0  'B'  00   1  ABOMB      13  6 [BOMB     :INIT]
 0 0  10   00   2  AMARSHAL   14  1 [MARSHAL  :INIT]
 0 0   9   00   0  AGENERAL   15  1 [GENERAL  :INIT]
 0 0   8   00   0  ACOLONEL   16  2 [COLONEL  :INIT]
 0 0   7   00   0  AMAJOR     17  3 [MAJOR    :INIT]
 0 0   6   00   0  ACAPTAIN   18  4 [CAPTAIN  :INIT]
 0 0   5   00   0  ALIEUT     19  4 [LIEUT    :INIT]
 0 0   4   00   0  ASERGEANT  20  4 [SERGEANT :INIT]
 0 0   3   00   3  AMINER     21  5 [MINER    :INIT]
 0 0   2   00   4  ASCOUT     22  8 [SCOUT    :INIT]
 0 0  'S'  00   5  ASPY       23  1 [SPY      :INIT]
 0 0  'F'  00   0  AFLAG      24  1 [FLAG     :INIT]

\ operations on a "PIECE"

\ Debug word
: :VIEW] ( piece -- )
    >R
   CR ." Piece ID#:"  R ID] ?
   SPACE  ." Quant:"  R QTY] ?

   CR ." X/Y      :"  R XY] 2@ SWAP     . ." ," .
   CR ." Rank1    :"  R RANK] ?
   CR ." Motion   :"  R MOTION] @ SPLIT . ." ," .
   CR ." Rule #   :"  R RULE] ?
   CR ." Shape    :"  R SHAPE] @ .SHAPE
   CR
   R> DROP ;

\ Debug word:  HUMAN REPORT  -or  COMPUTER REPORT
: REPORT ( -- )
         #PIECES 1+ 1
          DO
             I ]PIECE :VIEW]
             ?TERMINAL ABORT" Report halted"
          LOOP ;
