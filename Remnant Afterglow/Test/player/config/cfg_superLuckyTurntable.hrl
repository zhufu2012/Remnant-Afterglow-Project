-ifndef(cfg_superLuckyTurntable_hrl).
-define(cfg_superLuckyTurntable_hrl, true).

-record(superLuckyTurntableCfg, {
	%% ID
	%% 活动type 29
	iD,
	%% 抽奖次数获得条件
	%% 充值绿钻数量
	condition,
	%% 奖励
	%% （奖励数量，奖励倍数，权重，保底次数)
	%% 保底次数：保底次数达到后这组数据才加入奖励库，才有可能抽中；抽中后重置保底次数。
	awardWeight,
	%% 暴击值获得概率
	%% 暴击值满后，下一次抽奖获得的钻石数量翻倍
	%% （权重，每次抽奖后获得的暴击值)
	doubleAward,
	%% 暴击总值
	doubleAwardTotal,
	%% 作用1：暴击公告条件
	%% 作用2：中奖记录处暴击时，文字额外加特效的条件
	%% ·暴击时本次获得钻石数量达到该配置才进行公告，未达到该值就不公告
	%% ·文字额外加特效，本次获得钻石数量达到该配置才加，未达到该值就不加
	doubleNotice,
	%% 转盘外圈钻石数量
	award,
	%% 转配内圈倍数
	multiple,
	%% 奖励货币类型
	%% 11：绿钻
	%% 0：钻石
	currency,
	%% 抽奖次数上限
	maxChance,
	%% 走马灯阈值
	%% 当获得的总钻石数达到目标则显示走马灯
	notice,
	%% 概率公示文本内容
	%% 配置=0时，不显示概率公式入口
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
