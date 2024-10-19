-ifndef(cfg_fortuneCat1_hrl).
-define(cfg_fortuneCat1_hrl, true).

-record(fortuneCat1Cfg, {
	%% 招财活动ID
	iD,
	%% 抽奖次数调用
	%% (次数，调用ID）
	drawnTimes,
	%% 抽中返还的货币ID.
	%% 实际返还数量 = 消耗数量*倍率/10
	%% 全局的：针对ID字段，同一个ID只以第一行的数据为准
	return,
	%% 招财猫倍率
	%% (编号,倍率,是否显示大奖标识，钻石图片编号）
	%% 编号：倍率编号、及在转盘中的位置顺序（1标识最上面中间位置，依次顺时针表示位置.）；
	%% 倍率：这里乘以10，（实际计算要除以10，显示上也要除以10，并显示到小数点后一位数.）；
	%% 是否显示大奖标识：1是，0否；
	%% 钻石图片编号：从1-8，依次越来越稀有
	multiple,
	%% 概率公示文本内容
	brobabilityText,
	%% 英文
	brobabilityText_EN,
	%% 印尼
	brobabilityText_IN,
	%% 泰语
	brobabilityText_TH,
	%% RU
	brobabilityText_RU,
	%% FR
	brobabilityText_FR,
	%% GE
	brobabilityText_GE,
	%% TR
	brobabilityText_TR,
	%% SP
	brobabilityText_SP,
	%% PT
	brobabilityText_PT,
	%% KR
	brobabilityText_KR,
	%% TW
	brobabilityText_TW,
	%% JP
	brobabilityText_JP
}).

-endif.
