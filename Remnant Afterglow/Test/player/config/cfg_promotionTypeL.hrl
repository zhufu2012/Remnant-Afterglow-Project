-ifndef(cfg_promotionTypeL_hrl).
-define(cfg_promotionTypeL_hrl, true).

-record(promotionTypeLCfg, {
	iD,
	%% 特权周卡累充元宝数量
	conditions,
	%% {第几天，类型，ID，数量，是否绑定，是否显示转圈特效}
	%% 第几天：第1天…第7天
	%% 类型：1道具
	%%       2货币（货币ID通用：0绑元，1铜币 … 15灵玉）
	%% 周卡激活不确定，奖励应以通用奖励为主，暂不考虑装备类型
	%% ID：道具或者货币的ID
	%% 数量：道具或者货币的数量
	%% 是否绑定：0非绑，1绑定
	%% 是否显示转圈特效：
	%%       1显示
	%%       0不显示
	reward
}).

-endif.
