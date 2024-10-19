-ifndef(cfg_actiKnightsBase_hrl).
-define(cfg_actiKnightsBase_hrl, true).

-record(actiKnightsBaseCfg, {
	%% 活动ID
	iD,
	%% 最终结算时间倒计时
	%% 活动结束前多少秒进行最终排名结算
	%% 最终结算后，不再进行临时结算
	finalRankTime,
	%% 战盟排名的每天结算时间点/秒
	%% 最终结算及之前，每天结算
	%% 82800=23点
	guildRankTime,
	%% 战盟内排名结算时间间隔/秒
	%% 最终结算之前：从获得战盟排名开始计算，直至下次战盟排名结算时间点
	%% 3600=1小时
	memberRankTime,
	%% 每日登陆奖励
	%% （职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	freeAward,
	%% 战盟内获奖成员排名数
	memberNum,
	%% 战盟内获奖成员排名分段
	memberSection,
	%% 战盟排名界面，奖励预览的+号后面的图片资源名称
	%% （分段，图片ID）
	%% 图片读取散图，默认前缀LSQS_
	rewardPic,
	%% 活动说明
	actiDesc,
	%% 进入活动的广告图文字1
	advertDesc1,
	%% 英文
	advertDesc1_EN,
	%% 印尼
	advertDesc1_IN,
	%% 泰语
	advertDesc1_TH,
	%% RU
	advertDesc1_RU,
	%% FR
	advertDesc1_FR,
	%% GE
	advertDesc1_GE,
	%% TR
	advertDesc1_TR,
	%% SP
	advertDesc1_SP,
	%% PT
	advertDesc1_PT,
	%% KR
	advertDesc1_KR,
	%% TW
	advertDesc1_TW,
	%% JP
	advertDesc1_JP,
	%% 进入活动的广告图文字2
	advertDesc2,
	%% 英文
	advertDesc2_EN,
	%% 印尼
	advertDesc2_IN,
	%% 泰语
	advertDesc2_TH,
	%% RU
	advertDesc2_RU,
	%% FR
	advertDesc2_FR,
	%% GE
	advertDesc2_GE,
	%% TR
	advertDesc2_TR,
	%% SP
	advertDesc2_SP,
	%% PT
	advertDesc2_PT,
	%% KR
	advertDesc2_KR,
	%% TW
	advertDesc2_TW,
	%% JP
	advertDesc2_JP,
	%% 进入活动的广告图文字3
	advertDesc3,
	%% 英文
	advertDesc3_EN,
	%% 印尼
	advertDesc3_IN,
	%% 泰语
	advertDesc3_TH,
	%% RU
	advertDesc3_RU,
	%% FR
	advertDesc3_FR,
	%% GE
	advertDesc3_GE,
	%% TR
	advertDesc3_TR,
	%% SP
	advertDesc3_SP,
	%% PT
	advertDesc3_PT,
	%% KR
	advertDesc3_KR,
	%% TW
	advertDesc3_TW,
	%% JP
	advertDesc3_JP,
	%% 进入活动的广告图文字4
	advertDesc4,
	%% 英文
	advertDesc4_EN,
	%% 印尼
	advertDesc4_IN,
	%% 泰语
	advertDesc4_TH,
	%% RU
	advertDesc4_RU,
	%% FR
	advertDesc4_FR,
	%% GE
	advertDesc4_GE,
	%% TR
	advertDesc4_TR,
	%% SP
	advertDesc4_SP,
	%% PT
	advertDesc4_PT,
	%% KR
	advertDesc4_KR,
	%% TW
	advertDesc4_TW,
	%% JP
	advertDesc4_JP,
	%% 进入活动的广告图文字5
	advertDesc5,
	%% 英文
	advertDesc5_EN,
	%% 印尼
	advertDesc5_IN,
	%% 泰语
	advertDesc5_TH,
	%% RU
	advertDesc5_RU,
	%% FR
	advertDesc5_FR,
	%% GE
	advertDesc5_GE,
	%% TR
	advertDesc5_TR,
	%% SP
	advertDesc5_SP,
	%% PT
	advertDesc5_PT,
	%% KR
	advertDesc5_KR,
	%% TW
	advertDesc5_TW,
	%% JP
	advertDesc5_JP,
	%% 进入活动的广告图文字6
	advertDesc6,
	%% 英文
	advertDesc6_EN,
	%% 印尼
	advertDesc6_IN,
	%% 泰语
	advertDesc6_TH,
	%% RU
	advertDesc6_RU,
	%% FR
	advertDesc6_FR,
	%% GE
	advertDesc6_GE,
	%% TR
	advertDesc6_TR,
	%% SP
	advertDesc6_SP,
	%% PT
	advertDesc6_PT,
	%% KR
	advertDesc6_KR,
	%% TW
	advertDesc6_TW,
	%% JP
	advertDesc6_JP,
	%% 进入活动的广告图文字7
	advertDesc7,
	%% 英文
	advertDesc7_EN,
	%% 印尼
	advertDesc7_IN,
	%% 泰语
	advertDesc7_TH,
	%% RU
	advertDesc7_RU,
	%% FR
	advertDesc7_FR,
	%% GE
	advertDesc7_GE,
	%% TR
	advertDesc7_TR,
	%% SP
	advertDesc7_SP,
	%% PT
	advertDesc7_PT,
	%% KR
	advertDesc7_KR,
	%% TW
	advertDesc7_TW,
	%% JP
	advertDesc7_JP,
	%% 进入活动的广告图文字8
	advertDesc8,
	%% 英文
	advertDesc8_EN,
	%% 印尼
	advertDesc8_IN,
	%% 泰语
	advertDesc8_TH,
	%% RU
	advertDesc8_RU,
	%% FR
	advertDesc8_FR,
	%% GE
	advertDesc8_GE,
	%% TR
	advertDesc8_TR,
	%% SP
	advertDesc8_SP,
	%% PT
	advertDesc8_PT,
	%% KR
	advertDesc8_KR,
	%% TW
	advertDesc8_TW,
	%% JP
	advertDesc8_JP
}).

-endif.
