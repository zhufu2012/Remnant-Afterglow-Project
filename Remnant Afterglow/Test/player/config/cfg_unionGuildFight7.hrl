-ifndef(cfg_unionGuildFight7_hrl).
-define(cfg_unionGuildFight7_hrl, true).

-record(unionGuildFight7Cfg, {
	%% 鼓舞类型
	%% 1士气大振
	%% 2视死如归
	iD,
	%% 次数上限
	numLimit,
	%% 鼓舞消耗消耗
	%% (消耗类型，参数1，参数2)
	%% 类型1为道具，参数1为道具ID，参数2为道具数量
	%% 类型2为货币，参数1为货币类型，参数2为货币数量
	inspireCost,
	%% 可鼓舞的战盟成员职位：
	%% 职位ID：
	%% 5盟主、4执法者（太上长老）、3副盟主、2长老、1精英、0其他成员；
	position,
	%% 鼓舞buff
	%% 鼓舞效果针对全战盟成员
	inspireBuff
}).

-endif.
