-ifndef(cfg_lMatch1v1CupModel_hrl).
-define(cfg_lMatch1v1CupModel_hrl, true).

-record(lMatch1v1CupModelCfg, {
	%% 奖杯ID
	%% 与1v1赛季对应
	iD,
	%% 品质
	%% 1为铜
	%% 2为银
	%% 3为金
	%% 4铂金
	%% 5钻石
	rareType,
	%% 索引
	index,
	%% 是否显示
	isShow,
	%% 奖杯模型ID
	modelID,
	%% 主界面模型参数
	%% （缩放，x，y，z，旋转x，y，z）
	%% 缩放：为值/100，填100表示1倍
	model,
	%% Tips界面模型
	%% （缩放，x，y，z，旋转x，y，z）
	%% 缩放：填1表示1倍
	tipsModel,
	%% 升品界面模型
	%% （缩放，x，y，z，旋转x，y，z）
	%% 缩放：为值/100，填100表示1倍
	gradeUpModel,
	%% 恭喜获得界面模型参数
	%% （缩放，x，y，z，旋转x，y，z）
	%% 缩放：填表示1倍
	getModel,
	%% 恭喜升品界面模型参数
	%% （缩放，x，y，z，旋转x，y，z）
	%% 缩放：为值/100，填100表示1倍
	qualityModel,
	%% 展示界面冠军奖励模型
	%% （缩放，x，y，z，旋转x，y，z）
	%% 缩放：为值/100，填100表示1倍
	championModel,
	%% 展示界面32强奖励模型
	%% （缩放，x，y，z，旋转x，y，z）
	%% 缩放：为值/100，填100表示1倍
	secondModel
}).

-endif.
