-ifndef(cfg_functionGuide_hrl).
-define(cfg_functionGuide_hrl, true).

-record(functionGuideCfg, {
	%% MapAI
	iD,
	%% 界面第一张图
	leftImage,
	%% 第一张图下方描述
	leftDesc,
	%% 界面第二张图
	rightImage,
	%% 第二张图下方描述
	rightDesc,
	%% 界面第三张图
	thirdImage,
	%% 第三张图下方描述
	thirdDesc,
	%% 规则描述文字，“本王知道了”按钮上方显示
	desc,
	%% 是否需要加入仙盟
	%% 填0：不需要
	%% 填1：需要，显示加入仙盟按钮（需判断有无仙盟
	isJoinGuild,
	%% 大于这个等级不再弹出
	level,
	%% 玩法内播放引导ID
	guideNum,
	%% 引导播出等级区间
	guideLV
}).

-endif.
