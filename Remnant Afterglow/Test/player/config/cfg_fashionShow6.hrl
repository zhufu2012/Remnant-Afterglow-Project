-ifndef(cfg_fashionShow6_hrl).
-define(cfg_fashionShow6_hrl, true).

-record(fashionShow6Cfg, {
	%% 分类
	%% 1、面部纹身
	%% 2、身高
	%% （范围80%-120%，刻度1%，调整1次记1次消耗）
	%% 3、面纹透明度
	%% （范围20%-100%，刻度1%，面纹透明度和面纹，改其一或全改算一次消耗）
	iD,
	%% 序号
	oder,
	%% 索引
	index,
	%% 所属职业
	%% 1004战士
	%% 1005法师
	%% 1006弓箭手
	%% 0不区分职业
	character,
	%% 纹身符号
	%% 显示的icon
	%% 路径：Client\Assets\Resources\Textures\png\itemicon
	icon,
	%% 纹身符号
	%% 实际效果图
	%% 路径：Client\Assets\Resources\Textures\png\effect\tattoo
	image,
	%% 消耗
	%% (类型，ID，数量)
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
