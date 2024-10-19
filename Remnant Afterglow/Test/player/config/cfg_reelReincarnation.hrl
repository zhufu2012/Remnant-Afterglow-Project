-ifndef(cfg_reelReincarnation_hrl).
-define(cfg_reelReincarnation_hrl, true).

-record(reelReincarnationCfg, {
	%% 神像ID
	iD,
	%% 类型
	%% 1、1次转生
	%% 2、2次转生
	type,
	%% 索引
	index,
	%% 最大转生等级
	reinMax,
	%% 可转生的条件
	%% (分组，条件类型，参数)
	%% 分组：同组条件必须同时满足，不同组是“或”的关系.
	%% 条件类型1：升阶，参数=阶；
	%% 条件类型2：升星等级，参数=星级；
	condition,
	%% 转生消耗
	%% (类型，ID，数量)
	%% 类型1：道具，ID=道具ID；
	%% 类型2：货币，ID=货币ID。
	consume,
	%% 转生成功后增加的属性奖励，为累计属性值
	%% (属性ID，属性值)
	attrAdd,
	%% 转生前后升阶等级限制
	%% (转生前，转生后)
	%% 最大升阶等级
	levelMax,
	%% 转生前后升星等级限制
	%% (转生前，转生后)
	%% 最大升星等级
	starMax
}).

-endif.