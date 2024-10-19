-ifndef(cfg_groupActiveBase_hrl).
-define(cfg_groupActiveBase_hrl, true).

-record(groupActiveBaseCfg, {
	%% 入口组ID
	%% 这里的ID就是ActiveBase的teamType字段配置的分组数值
	iD,
	%% 是否显示独立汇总界面
	%% 0=关闭，点击入口会直接打开活动
	%% 1=开启，点击入口先打开汇总界面，再能点击进入活动
	switch,
	%% 背景框ID
	pic,
	%% 主界面活动icon
	iconID,
	%% 主界面活动icon上是否挂特效
	%% 1、挂特效
	%% 0、不挂特效
	iconID_Show,
	%% 主界面活动icon上是否挂角标
	%% 0、不挂角标
	%% 1、角标“限定”，00_YYHD_Tag1
	%% 2、角标“聯動”，00_YYHD_Tag2
	iconID_Mark,
	%% 主界面活动入口名称
	teamName,
	%% 英语
	teamName_EN,
	%% 印尼
	teamName_IN,
	%% 泰语
	teamName_TH,
	%% RU
	teamName_RU,
	%% FR
	teamName_FR,
	%% GE
	teamName_GE,
	%% TR
	teamName_TR,
	%% SP
	teamName_SP,
	%% PT
	teamName_PT,
	%% KR
	teamName_KR,
	%% TW
	teamName_TW,
	%% JP
	teamName_JP,
	%% 活动界面左上角标题文字
	toptitle,
	%% 英语
	toptitle_EN,
	%% 印尼
	toptitle_IN,
	%% 泰语
	toptitle_TH,
	%% RU
	toptitle_RU,
	%% FR
	toptitle_FR,
	%% GE
	toptitle_GE,
	%% TR
	toptitle_TR,
	%% SP
	toptitle_SP,
	%% PT
	toptitle_PT,
	%% KR
	toptitle_KR,
	%% TW
	toptitle_TW,
	%% JP
	toptitle_JP
}).

-endif.
