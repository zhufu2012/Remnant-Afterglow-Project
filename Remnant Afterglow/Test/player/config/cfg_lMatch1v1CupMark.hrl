-ifndef(cfg_lMatch1v1CupMark_hrl).
-define(cfg_lMatch1v1CupMark_hrl, true).

-record(lMatch1v1CupMarkCfg, {
	%% 奖杯ID
	iD,
	%% 等级
	lv,
	%% 索引
	index,
	%% 印记最大等级
	lVMax,
	%% 点亮条件
	%% （条件类型，参数1）
	%% 类型1：强化等级，参数1=强化等级
	%% 类型2：品质，参数1=奖杯品质
	%% 类型3：段位，参数1=段位数
	%% 类型4：前置印记全部激活，参数1=0
	%% 配置多个条件则需全部满足
	conditions,
	%% 点亮消耗
	%% （道具ID，数量）
	%% 升到下一级的消耗
	%% 填0表示不需要道具
	consume,
	%% 点亮属性
	%% 叠加
	attrAdd,
	%% 激活技能
	%% （技能类型，ID，学习位)
	%% 类型1为技能，
	%% 类型2为技能修正
	skill,
	%% 技能等级
	skillLv,
	%% 是否公告
	%% 配置印记文字
	%% 0为不公告
	isNoctice
}).

-endif.
