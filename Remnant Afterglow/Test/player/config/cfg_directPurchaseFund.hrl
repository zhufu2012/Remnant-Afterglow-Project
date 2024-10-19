-ifndef(cfg_directPurchaseFund_hrl).
-define(cfg_directPurchaseFund_hrl, true).

-record(directPurchaseFundCfg, {
	%% 商品价格ID
	%% 相同ID的价格是一样的.
	%% 目前最多配置10个ID
	iD,
	%% 直购项目ID
	%% 1.项目1（指定周卡使用，秒杀2以此判断，不要更改）
	%% 2.项目2
	%% 3.项目3
	%% …
	%% （根据配置动态增减）
	%% （商品价格和配置项目对应上）
	directPurchaseID,
	%% 个人等级
	lv,
	%% 奖励天数ID
	%% 购买后第几天可以领取该奖励
	%% 0代表购买后立即获得
	%% 1代表购买的第1天可以领取
	%% （有效期奖励天数也动态读取，每个等级可以配置不一样；0天配置必需要有，等级通用参数是读取的0天）
	dayID,
	index,
	%% 可见等级
	%% 1、可见等级达到了，无论功能是否开启都显示出来.
	%% 2、可购买限制，通过功能ID判断出功能开启等级，将可购买等级显示出来.
	showLv,
	%% 伴随以下功能开启ID开启
	%% 只需要读取ID字段的第一条数据
	openactionId,
	%% 后台开关ID
	functionSwitchId,
	%% 直购项目标题名称索引
	id_Name,
	%% 奖励
	%% (职业,类型，物品ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	%% 掉落是否绑定：0为非绑 1为绑定，货币不使用此参数
	weekGift,
	%% 分组
	groupID,
	%% 返利比（%）
	%% 百分号由前端处理
	rebate
}).

-endif.