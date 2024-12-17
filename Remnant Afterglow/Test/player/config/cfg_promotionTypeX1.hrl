-ifndef(cfg_promotionTypeX1_hrl).
-define(cfg_promotionTypeX1_hrl, true).

-record(promotionTypeX1Cfg, {
	%% 活动ID
	iD,
	%% 每日任务类型及奖励
	%% 这里填写：PB表ID，通过此ID调用PromotionTypeA_1_达成条件活动
	dailyTask,
	%% 每周任务类型及奖励
	%% 这里填写：PB表ID，通过此ID调用PromotionTypeA_1_达成条件活动
	weeklyTask,
	%% 调用等级奖励
	%% PromotionTypeW2_1_荣耀龙徽2
	promotionTypeX2_ID,
	%% 调用兑换列表
	%% PromotionTypeW3_1_荣耀龙徽3
	promotionTypeX3_ID,
	%% 购买等级
	%% （龙徽经验值，货币ID，货币数量）
	%% （10,11,1）:表示没购买10点龙徽经验，需要消耗1非绑，不足10点按照10点计算.
	%% 购买等级时，换算成经验为单位购买.
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
	advancedtext_TW,
	%% 进阶特权文字
	advancedtext_KR,
	%% 进阶特权文字
	advancedtext_EN,
	%% 法语:
	advancedtext_FR,
	%% 德语:
	advancedtext_GE,
	%% 俄语:
	advancedtext_RU,
	%% 西班牙语:
	advancedtext_SP,
	%% 葡萄牙语:
	advancedtext_PT,
	%% 土耳其语:
	advancedtext_TR,
	%% 波兰：
	advancedtext_PL,
	%% 意大利：
	advancedtext_IT,
	%% 进阶时界面展示icon
	%% 装备
	%% （职业，装备ID，装备品质，装备星级，是否绑定，数量)
	%% 职业：0=所有职业的人均可看到该，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会看到职业二的奖励，但是可以获得不分职业的奖励）
	%% 品质0白1蓝2紫3橙4红5粉6神
	%% 星级0-3
	%% 是否绑定：0为非绑 1为绑定
	advancedIconEquip,
	%% 进阶时界面展示icon
	%% 道具/货币
	%% (职业,类型，物品ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID；
	%% 2为货币，填写货币枚举；
	%% 是否绑定：0为非绑 1为绑定
	advancedIconItem,
	%% 至尊进阶消耗
	%% （货币ID，数量）
	extremeAdvancedConsume,
	%% 至尊进阶消耗
	%% 直购商品ID
	%% 货币消耗或者直购商品ID只能配置其中一个
	extremeDirectPurchase,
	%% 进阶特权文字
	extremeAdvancedtext,
	%% 进阶特权文字
	extremeAdvancedtext_TW,
	%% 进阶特权文字
	extremeAdvancedtext_KR,
	%% 进阶特权文字
	extremeAdvancedtext_EN,
	%% 法语:
	extremeAdvancedtext_FR,
	%% 德语:
	extremeAdvancedtext_GE,
	%% 俄语:
	extremeAdvancedtext_RU,
	%% 西班牙语:
	extremeAdvancedtext_SP,
	%% 葡萄牙语:
	extremeAdvancedtext_PT,
	%% 土耳其语:
	extremeAdvancedtext_TR,
	%% 波兰：
	extremeAdvancedtext_PL,
	%% 意大利：
	extremeAdvancedtext_IT,
	%% 进阶时界面展示icon
	%% 装备
	%% （职业，装备ID，装备品质，装备星级，是否绑定，数量)
	%% 职业：0=所有职业的人均可看到该，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会看到职业二的奖励，但是可以获得不分职业的奖励）
	%% 品质0白1蓝2紫3橙4红5粉6神
	%% 星级0-3
	%% 是否绑定：0为非绑 1为绑定
	extremeAdvancedIconEquip,
	%% 进阶时界面展示icon
	%% 道具/货币
	%% (职业,类型，物品ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID；
	%% 2为货币，填写货币枚举；
	%% 是否绑定：0为非绑 1为绑定
	extremeAdvancedIconItem,
	%% 大奖预览界面奖励模型的参数配置
	%% （职业，模型ID，缩放，位置X,位置Y，位置Z,旋转X，旋转Y，旋转Z）
	%% 缩放：100表示缩放的100%
	battlePassPic,
	%% 大奖预览文字
	battlePassText,
	%% 大奖预览文字
	battlePassText_TW,
	%% 大奖预览文字
	battlePassText_KR,
	%% 大奖预览文字
	battlePassText_EN,
	%% 法语:
	battlePassText_FR,
	%% 德语:
	battlePassText_GE,
	%% 俄语:
	battlePassText_RU,
	%% 西班牙语:
	battlePassText_SP,
	%% 葡萄牙语:
	battlePassText_PT,
	%% 土耳其语:
	battlePassText_TR,
	%% 波兰：
	battlePassText_PL,
	%% 意大利：
	battlePassText_IT,
	%% 大奖的物品ID
	%% 职业ID，大奖物品ID
	battlePassItem
}).

-endif.
