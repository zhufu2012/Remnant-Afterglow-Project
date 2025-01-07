-ifndef(cfg_fashionShow5_hrl).
-define(cfg_fashionShow5_hrl, true).

-record(fashionShow5Cfg, {
	%% 染色库分类
	%% 1、时装染色
	%% 2、化妆：头发颜色
	%% 3、化妆：纹身颜色
	%% 4、化妆：皮肤颜色（创角）
	%% 5、化妆：皮肤颜色（时装）
	iD,
	%% 颜色序号
	%% ID=1,配置0时,为默认时装色
	oder,
	%% 索引
	index,
	%% RGB
	colour,
	%% 消耗
	%% (类型,ID,数量)
	%% 1、道具
	%% 2、货币
	item,
	%% 消耗2
	%% (类型，ID，数量)
	%% 1、道具
	%% 2、货币
	%% 前端优先显示并消耗Item2的道具
	item2
}).

-endif.
