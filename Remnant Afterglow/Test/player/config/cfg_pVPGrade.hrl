-ifndef(cfg_pVPGrade_hrl).
-define(cfg_pVPGrade_hrl, true).

-record(pVPGradeCfg, {
	%% 战力
	iD,
	%%  在各玩法PVP中适用（包括多人PVP，单人PVP，实时和镜像的PVP），PVE不适用 ，远征不适用
	%%  压制之后伤害=压制前伤害*战力压制低战玩家伤害系数/10000       
	%%    战力压制低战玩家伤害计算方式       
	%%    如果自己战力>受击方玩家战力，战力压制低战玩家伤害系数=10000      
	%%    如果自己战力<受击方玩家战力，战力压制低战玩家伤害系数=配置读取      
	%%  配置读取      
	%%    0-10000，比如 800，ID读取1配置     
	%%    10001-20000，比如12000，ID读取10000配置     
	%%    20001-30000，比如23000，ID读取20000配置     
	%%    30001及以上，比如35000，ID读取30000配置     
	%%         
	%%   确定ID之后读取具体的配置      
	%%    如果     
	%%    0%<=受击方战力/自己战力-1<10%，读取Dizhanyazhi0字段     
	%%    10%<=受击方战力/自己战力-1<20%，读取Dizhanyazhi1字段     
	%%    20%<=受击方战力/自己战力-1<30%，读取Dizhanyazhi2字段     
	%%    ……………     
	%%    100%<=受击方战力/自己战力-1<110%，读取Dizhanyazhi10字段     
	%%    依次类推     
	%%    大于最后一个配置就取最后一个配置     
	%%         
	%%    配置支持字段策划添加     
	%%                                          
	dizhanyazhi0,
	%% 对方战力高10%
	dizhanyazhi1,
	%% 对方战力高20%
	dizhanyazhi2,
	%% 对方战力高30%
	dizhanyazhi3,
	%% 对方战力高40%
	dizhanyazhi4,
	%% 对方战力高50%
	dizhanyazhi5,
	%% 对方战力高60%
	dizhanyazhi6,
	%% 对方战力高70%
	dizhanyazhi7,
	%% 对方战力高80%
	dizhanyazhi8,
	%% 对方战力高90%
	dizhanyazhi9,
	%% 对方战力高100%
	dizhanyazhi10,
	%% 对方战力高110%
	dizhanyazhi11,
	%% 对方战力高120%
	dizhanyazhi12,
	%% 对方战力高130%
	dizhanyazhi13,
	%% 对方战力高140%
	dizhanyazhi14,
	%% 对方战力高150%
	dizhanyazhi15,
	%% 对方战力高160%
	dizhanyazhi16,
	%% 对方战力高170%
	dizhanyazhi17,
	%% 对方战力高180%
	dizhanyazhi18,
	%% 对方战力高190%
	dizhanyazhi19,
	%% 对方战力高200%
	dizhanyazhi20,
	%% 对方战力高210%
	dizhanyazhi21,
	%% 对方战力高220%
	dizhanyazhi22,
	%% 对方战力高230%
	dizhanyazhi23,
	%% 对方战力高240%
	dizhanyazhi24,
	%% 对方战力高250%
	dizhanyazhi25,
	%% 对方战力高260%
	dizhanyazhi26,
	%% 对方战力高270%
	dizhanyazhi27,
	%% 对方战力高280%
	dizhanyazhi28,
	%% 对方战力高290%
	dizhanyazhi29,
	%% 对方战力高300%
	dizhanyazhi30
}).

-endif.
