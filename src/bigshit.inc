;                               BigShit v0.99 by jopas
;                              http://www.jopas.prv.pl/
;                                  mail:jopas@o2.pl

bs_create       proto :dword                            ;value
bs_destroy      proto :dword                            ;big1

bs_biglen       proto :dword                            ;big1
bs_zero         proto :dword                            ;big1
bs_is_zero      proto :dword                            ;big1
bs_copy         proto :dword,:dword                     ;big1,big2
bs_compare      proto :dword,:dword                     ;big1,big2
bs_compare32    proto :dword,:dword                     ;big1,value
bs_val32        proto :dword,:dword                     ;big1,value

bs_str2big      proto :dword,:dword                     ;offset str,big1
bs_big2str      proto :dword,:dword                     ;big1,offset str
bs_byte2big     proto :dword,:dword,:dword              ;size,offset data,big1
bs_big2byte     proto :dword,:dword                     ;big1,offset data

bs_shl1         proto :dword,:dword                     ;big1,big2              -> 2=<<1
bs_shr1         proto :dword,:dword                     ;big1,big2              -> 2=>>1

bs_add          proto :dword,:dword,:dword              ;big1,big2,big3         -> 3=1+2
bs_add32        proto :dword,:dword,:dword              ;big1,value,big2        -> 2=1+val32
bs_sub          proto :dword,:dword,:dword              ;big1,big2,big3         -> 3=1-2
bs_sub32        proto :dword,:dword,:dword              ;big1,value,big2        -> 2=1-val32

bs_mul          proto :dword,:dword,:dword              ;big1,big2,big3         -> 3=1*2
bs_div          proto :dword,:dword,:dword,:dword       ;big1,big2,big3,big4    -> 3=1/2 4=1%2
bs_mod          proto :dword,:dword,:dword              ;big1,big2,big3         -> 3=1%2
bs_modmul       proto :dword,:dword,:dword,:dword       ;big1,big2,big3,big4    -> 4=1*2%3
bs_powmod       proto :dword,:dword,:dword,:dword       ;big1,big2,big3,big4    -> 4=1^2%3
bs_sqrt         proto :dword,:dword                     ;big1,big2              -> 2=sqrt(1)