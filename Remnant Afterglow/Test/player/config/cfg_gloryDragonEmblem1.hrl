-ifndef(cfg_gloryDragonEmblem1_hrl).
-define(cfg_gloryDragonEmblem1_hrl, true).

-record(gloryDragonEmblem1Cfg, {
	%% 活动ID
	iD,
	%% 每日任务类型及奖励
	%% 这里填写：GloryDragonEmblem4_1_光荣战纪4条件达成，ID
	dailyTask,
	%% 每周任务类型及奖励
	%% 这里填写：GloryDragonEmblem4_1_光荣战纪4条件达成，ID
	weeklyTask,
	%% 调用等级奖励
	%% GloryDragonEmblem2_1_光荣战纪2
	promotionTypeX2_ID,
	%% 调用兑换列表
	%% GloryDragonEmblem3_1_光荣战纪3
	promotionTypeX3_ID,
	%% 购买等级
	%% （战纪经验值，货币ID，货币数量）
	%% （10,0,1）:表示每购买10点战纪经验，需要消耗1钻石，不足10点按照10点计算.
	%% 购买等级时，换算成经验为单位购买.
	%% (0,0,0)、或0:表示没有【购买等级】功能，隐藏入口
	buyExp,
	%% 进阶后，每日可领取奖励
	%% 界面上包装成宝箱，这里直接填奖励
	%% 道具/货币
	%% (职业,类型，物品ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID；
	%% 2为货币，填写货币枚举；
	%% 是否绑定：0为非绑 1为绑定
	dailyReward,
	%% 进阶消耗
	%% （货币ID，数量）
	advancedConsume,
	%% 进阶消耗
	%% 直购商品ID
	%% 货币消耗或者直购商品ID只能配置其中一个
	directPurchase,
	%% 进阶特权文字
	advancedtext,
	%% 进阶特权文字
	advancedtext_EN,
	%% 进阶特权文字
	%% 印尼
	advancedtext_IN,
	%% 进阶特权文字
	%% 泰语
	advancedtext_TH,
	%% RU
	advancedtext_RU,
	%% FR
	advancedtext_FR,
	%% GE
	advancedtext_GE,
	%% TR
	advancedtext_TR,
	%% SP
	advancedtext_SP,
	%% PT
	advancedtext_PT,
	%% KR
	advancedtext_KR,
	%% TW
	advancedtext_TW,
	%% JP
	advancedtext_JP,
	%% 进阶时界面展示icon
	%% 道具/货币/装备
	%% (职业，类型，ID，数量，品质，星级，是否绑定)
	%% 职业:0
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	advancedIconItem,
	%% 至尊进阶消耗
	%% （货币ID，数量）
	extremeAdvancedConsume,
	%% 至尊进阶消耗
	%% 直购商品ID
	%% 货币消耗或者直购商品ID只能配置其中一个
	extremeDirectPurchase,
	%% 至尊进阶特权文字
	extremeAdvancedtext,
	%% 至尊进阶特权文字
	extremeAdvancedtext_EN,
	%% 至尊进阶特权文字 印尼
	extremeAdvancedtext_IN,
	%% 至尊进阶特权文字 泰语
	extremeAdvancedtext_TH,
	%% RU
	extremeAdvancedtext_RU,
	%% FR
	extremeAdvancedtext_FR,
	%% GE
	extremeAdvancedtext_GE,
	%% TR
	extremeAdvancedtext_TR,
	%% SP
	extremeAdvancedtext_SP,
	%% PT
	extremeAdvancedtext_PT,
	%% KR
	extremeAdvancedtext_KR,
	%% TW
	extremeAdvancedtext_TW,
	%% JP
	extremeAdvancedtext_JP,
	%% 至尊进阶时界面展示icon
	%% 道具/货币/装备
	%% (职业，类型，ID，数量，品质，星级，是否绑定)
	%% 职业:0
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	extremeAdvancedIconItem,
	%% 主界面模型显示
	%% 大奖预览界面奖励模型的参数配置
	%% （职业，模型ID，缩放，位置X,位置Y，位置Z,旋转X，旋转Y，旋转Z）
	%% 缩放：100表示缩放的100%
	battlePassPic,
	%% 大奖预览界面模型显示
	%% 大奖预览界面奖励模型的参数配置
	%% （职业，模型ID，缩放，位置X,位置Y，位置Z,旋转X，旋转Y，旋转Z）
	%% 缩放：100表示缩放的100%
	battlePassPic1,
	%% 大奖预览文字
	battlePassText,
	%% 大奖预览文字
	battlePassText_EN,
	%% 大奖预览文字
	%% 印尼
	battlePassText_IN,
	%% 大奖预览文字
	%% 泰语
	battlePassText_TH,
	%% RU
	battlePassText_RU,
	%% FR
	battlePassText_FR,
	%% GE
	battlePassText_GE,
	%% TR
	battlePassText_TR,
	%% SP
	battlePassText_SP,
	%% PT
	battlePassText_PT,
	%% KR
	battlePassText_KR,
	%% TW
	battlePassText_TW,
	%% JP
	battlePassText_JP,
	%% 大奖的物品ID
	%% 职业ID，大奖物品ID
	battlePassItem,
	%% 奖励标签
	%% 上面的banner文字
	label_Banner1,
	%% 奖励标签
	%% 上面的banner文字
	%% 英语
	label_Banner1_EN,
	%% 奖励标签
	%% 上面的banner文字
	%% 印尼
	label_Banner1_IN,
	%% 奖励标签
	%% 上面的banner文字
	%% 泰语
	label_Banner1_TH,
	%% RU
	label_Banner1_RU,
	%% FR
	label_Banner1_FR,
	%% GE
	label_Banner1_GE,
	%% TR
	label_Banner1_TR,
	%% SP
	label_Banner1_SP,
	%% PT
	label_Banner1_PT,
	%% KR
	label_Banner1_KR,
	%% TW
	label_Banner1_TW,
	%% JP
	label_Banner1_JP,
	%% 任务标签
	%% 上面的banner文字
	label_Banner2,
	%% 任务标签
	%% 上面的banner文字
	%% 英语
	label_Banner2_EN,
	%% 任务标签
	%% 上面的banner文字
	%% 印尼
	label_Banner2_IN,
	%% 任务标签
	%% 上面的banner文字
	%% 泰语
	label_Banner2_TH,
	%% RU
	label_Banner2_RU,
	%% FR
	label_Banner2_FR,
	%% GE
	label_Banner2_GE,
	%% TR
	label_Banner2_TR,
	%% SP
	label_Banner2_SP,
	%% PT
	label_Banner2_PT,
	%% KR
	label_Banner2_KR,
	%% TW
	label_Banner2_TW,
	%% JP
	label_Banner2_JP,
	%% 兑换标签
	%% 上面的banner文字
	label_Banner3,
	%% 兑换标签
	%% 上面的banner文字
	%% 英语
	label_Banner3_EN,
	%% 兑换标签
	%% 上面的banner文字
	%% 印尼
	label_Banner3_IN,
	%% 兑换标签
	%% 上面的banner文字
	%% 泰语
	label_Banner3_TH,
	%% RU
	label_Banner3_RU,
	%% FR
	label_Banner3_FR,
	%% GE
	label_Banner3_GE,
	%% TR
	label_Banner3_TR,
	%% SP
	label_Banner3_SP,
	%% PT
	label_Banner3_PT,
	%% KR
	label_Banner3_KR,
	%% TW
	label_Banner3_TW,
	%% JP
	label_Banner3_JP
}).

-endif.
