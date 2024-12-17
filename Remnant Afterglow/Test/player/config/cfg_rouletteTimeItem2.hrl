-ifndef(cfg_rouletteTimeItem2_hrl).
-define(cfg_rouletteTimeItem2_hrl, true).

-record(rouletteTimeItem2Cfg, {
	iD,
	%% 序号
	oder,
	index,
	%% 累计寻宝次数
	times,
	%% 最大序号
	oderMax,
	%% 作者:
	%% 奖励物品
	%% （职业,类型,类型ID,品质,星级,是否绑定,数量)
	%% 职业:
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	item,
	%% 显示限制：序号进度达成后才显示
	%% 配置对应Oder字段的序号，达成该序号后，则显示出对应档位
	show
}).

-endif.
