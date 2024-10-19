-ifndef(cfg_dHallowsBaseNew_hrl).
-define(cfg_dHallowsBaseNew_hrl, true).

-record(dHallowsBaseNewCfg, {
	%% 圣物ID
	iD,
	%% 名字
	name,
	%% 是否为圣物幻化道具
	%% 1、是
	%% 0、否
	dHallowsStar,
	%% 默认是否开启
	%% 1，开启
	%% 0，不开启(如果激活了，就自动开启)【圣物默认都是开启】
	open,
	%% 圣物类型1火2水3风4土
	element,
	%% 职业调用圣物
	%% 职业ID|
	%% 职业1004为战士，1005为魔法师，1006为弓箭手,1007为第4个职业
	%% 配置0表示：无任何职业调用
	occupation,
	%% 对应转生数（1即是1转）
	transfer,
	%% 新增
	%% 对应品质
	%% 0 N白
	%% 1 R蓝
	%% 2 SR紫
	%% 3 SSR橙
	%% 4 SP 红
	%% 5 UR 粉
	rareType,
	%% 圣物组别（为了公选觉醒技做区分）
	dhallowsGroup,
	%% 圣物重复获得时，分解成货币
	%% (货币类型，货币数量)
	recount,
	%% （对应圣物幻化升星ID,消耗ID）
	%% 对应表DHallowsStar_1_圣物幻化升星的ID
	dHallowsStarID
}).

-endif.
