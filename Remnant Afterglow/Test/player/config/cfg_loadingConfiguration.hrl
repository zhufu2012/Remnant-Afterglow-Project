-ifndef(cfg_loadingConfiguration_hrl).
-define(cfg_loadingConfiguration_hrl, true).

-record(loadingConfigurationCfg, {
	%% ID|ID=1固定为进入游戏时的loading
	iD,
	%% 等级段
	levelInterval,
	%% 随机背景图
	%% {a,b,c}代表此图是有图片a、标识b构成,没有b则标识只有图片没有文字组、c代表职业（0：无职业；1：战士；2：法师；3：弓手）
	%% b参数 根据文字表Loading页签下的文字ID对应 LoadingImageText1_b
	%% 重复组为增加概率;调整时等极段类型不动,只处理本类型下的显示
	loadingImage,
	%% {Loading文字，权重}
	%% 登录默认读LoadingTip_Txt101
	starCoin,
	%% 贡献获得的描述：随机显示：ReminderTip_Txt&
	reminder
}).

-endif.
