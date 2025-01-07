-ifndef(cfg_godAdorn_hrl).
-define(cfg_godAdorn_hrl, true).

-record(godAdornCfg, {
	%% 阶数
	order,
	%% 神饰类型
	%% 1.左边神饰
	%% 2.右边神饰
	godAdornType,
	%% Key
	index,
	%% 神饰ID
	godAdornID,
	%% 角色穿戴最低等级要求
	lvLimit,
	%% 穿戴转生数要求
	changeRole,
	%% 基础品质
	%% 0白 1蓝 2紫 3橙 4红 5龙 6神  7、龙神
	%% 包装用
	standardQuality,
	%% 基础星数
	%% 包装用
	standardStar,
	%% 升阶消耗
	%% （类型，ID，数量）
	%% 类型：1物品，ID为：道具ID
	%% 类型：2货币，ID为：货币ID
	upStageNeedItem,
	%% 升阶后下一个ID
	nextGodAdorn,
	%% 基础属性
	%% （属性ID，值）
	attribute,
	%% 高级属性
	%% （属性ID，值，品质色）
	%% 0白 1蓝 2紫 3橙 4红 5幻彩
	goodAttribute,
	%% 评分ID
	starScore
}).

-endif.
