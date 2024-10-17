-ifndef(cfg_talismanBase_hrl).
-define(cfg_talismanBase_hrl, true).

-record(talismanBaseCfg, {
	%% 作者:
	%% 翅膀ID
	iD,
	%% 作者:
	%% 是否开启翅膀
	open,
	%% 翅膀名字
	name,
	%% 作者:
	%% 法宝类型
	%% 1为火
	%% 2为水
	%% 3为雷
	type,
	%% 作者:
	%% 阶级
	class,
	%% 法宝模型
	model,
	%% 战场模型
	baseModel,
	%% 1001萝莉职业位移、缩放
	%% 作者:
	%% 主角角色ID
	%% 1001、萝莉
	%% 1002、道士
	%% 1003、双刀女
	%% 1004、猴子
	%% 1005、明王
	tranformInfo1,
	%% 作者:
	%% 1002道士职业位移、缩放
	%% 作者:
	%% 主角角色ID
	%% 1001、萝莉
	%% 1002、道士
	%% 1003、双刀女
	%% 1004、猴子
	%% 1005、明王
	tranformInfo2,
	%% 1003罗刹 职业位移、缩放
	%% 作者:
	%% 主角角色ID
	%% 1001、萝莉
	%% 1002、道士
	%% 1003、双刀女
	%% 1004、猴子
	%% 1005、明王
	tranformInfo3,
	%% 1004 猴子 职业位移、缩放
	%% 作者:
	%% 主角角色ID
	%% 1001、萝莉
	%% 1002、道士
	%% 1003、双刀女
	%% 1004、猴子
	%% 1005、明王
	tranformInfo4,
	%% 1005 明王 职业位移、缩放
	%% 作者:
	%% 主角角色ID
	%% 1001、萝莉
	%% 1002、道士
	%% 1003、双刀女
	%% 1004、猴子
	%% 1005、明王
	tranformInfo5,
	%% UI循环特效
	uIShow,
	%% UI一次特效
	uIShow1,
	%% 场景循环特效
	baseShow,
	%% 场景一次特效
	baseShow1,
	%% 战场低模特效
	baseShow_low,
	%% 消失特效
	changeShow,
	%% 出生特效
	bornShow
}).

-endif.
