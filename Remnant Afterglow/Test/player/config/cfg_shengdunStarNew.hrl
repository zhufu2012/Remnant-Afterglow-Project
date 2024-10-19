-ifndef(cfg_shengdunStarNew_hrl).
-define(cfg_shengdunStarNew_hrl, true).

-record(shengdunStarNewCfg, {
	%% 等级
	iD,
	%% 等级上限
	maxLv,
	%% 升下一级需要经验
	exp,
	%% 等级段显示(星级)
	showLv,
	%% 等阶段显示(阶级)
	showStairs,
	%% 等级奖励属性
	%% (属性ID，属性值)
	%% 属性“圣盾比”（枚举157）为隐藏属性，不在界面上显示
	attrAdd,
	%% 单次点击需要材料及个数要求
	%% (消耗道具id，数量）
	%% 0升1，读取0配置
	%% 钻石补足材料消耗，单价配置在：ShengdunExpItemNew_1_升级经验道具
	needItem,
	%% 单次点击增加属性
	addClickAttr,
	%% 圣盾外形
	%% 升阶可改变圣盾外显，填写ShengdunShowNew表的ID
	showID,
	%% 圣盾评分，为累计值
	rank
}).

-endif.
