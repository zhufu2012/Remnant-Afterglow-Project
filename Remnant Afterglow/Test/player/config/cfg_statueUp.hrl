-ifndef(cfg_statueUp_hrl).
-define(cfg_statueUp_hrl, true).

-record(statueUpCfg, {
	%% 神像id
	iD,
	%% 星数
	lv,
	%% 升级到下一级所需要的经验值
	%% 这里只是当级的值
	%% 0表示已经达到最大等级
	needExp,
	%% 提供的属性，这里配置的是累计值，程序直接读取
	%% （属性ID,值）
	attrAdd,
	%% 对当前雕像增加的基础属性万分比
	%% 这里配置的是累计值
	%% 仅针对：DragonStatueBase_1_神像翅膀基础属性表中BaseAttribute字段
	baseAdd
}).

-endif.
