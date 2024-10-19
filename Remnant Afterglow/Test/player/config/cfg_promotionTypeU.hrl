-ifndef(cfg_promotionTypeU_hrl).
-define(cfg_promotionTypeU_hrl, true).

-record(promotionTypeUCfg, {
	%% ID
	iD,
	%% 兑换跳转到SwitchBase表的ID
	switchBase_Id,
	%% 这里配置【SwitchBase】表ID
	%% 转盘A表的ID配到【SwitchBase】表中
	turnplate,
	%% 兑换活动的道具
	%% (职业,类型，物品ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID；
	%% 2为货币，填写货币枚举；
	%% 掉落是否绑定：0为非绑 1为绑定，货币和积分不使用此参数
	item,
	%% 大奖
	%% 装备
	%% （职业，装备ID，装备品质，装备星级，是否绑定，数量)
	%% 职业：0=所有职业的人均可看到该，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会看到职业二的奖励，但是可以获得不分职业的奖励）
	%% 品质0白1蓝2紫3橙4红5粉6神
	%% 星级0-3
	%% 是否绑定：0为非绑 1为绑定
	awardEquip,
	%% 大奖
	%% 道具/货币
	%% (职业,类型，物品ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID；
	%% 2为货币，填写货币枚举；
	%% 掉落是否绑定：0为非绑 1为绑定，货币和积分不使用此参数
	awardItem,
	%% 模型展示偏移缩放（枚举，职业，模型ID，缩放，偏移X，Y，Z，旋转X，Y,Z）
	%% 枚举：0表模型ID，1表示道具id(翅膀神兵这些模型涉及变形的动画，所以必须填1类型)
	model,
	%% 个人累计奖励
	%% (奖励序号，所需次数)
	condPara,
	%% 个人累计奖励
	%% 装备
	%% （奖励序列，职业，装备ID，装备品质，装备星级，是否绑定，数量)
	%% 职业：0=所有职业的人均可看到该，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会看到职业二的奖励，但是可以获得不分职业的奖励）
	%% 品质0白1蓝2紫3橙4红5粉6神
	%% 星级0-3
	%% 是否绑定：0为非绑 1为绑定
	awardEquipNew1,
	%% 个人累计奖励：道具/货币
	%% (奖励序列,职业，类型，类型ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.(如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励)
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 是否绑定：0为非绑 1为绑定(货币没有绑定或非绑的说法)
	%% 数量：奖励道具的数量
	awardParaNew1
}).

-endif.