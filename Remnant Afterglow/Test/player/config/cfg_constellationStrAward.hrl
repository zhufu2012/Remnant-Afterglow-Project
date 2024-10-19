-ifndef(cfg_constellationStrAward_hrl).
-define(cfg_constellationStrAward_hrl, true).

-record(constellationStrAwardCfg, {
	%% 阶数
	level,
	%% 品质
	quality,
	%% 攻防类型
	%% 1攻击类型（部件枚举0-4）
	%% 2防御类型（部件枚举5-9）
	type,
	%% 数量
	number,
	%% 索引
	index,
	%% 属性（属性ID，属性值）
	attribute,
	%% 边境远征 -羁绊属性
	%% （属性ID，属性值）
	%% 边境远征玩法中，会使用玩家当前赛季对应星座属性
	expeditionAttri
}).

-endif.
