-ifndef(cfg_elementStrAddMaster_hrl).
-define(cfg_elementStrAddMaster_hrl, true).

-record(elementStrAddMasterCfg, {
	%% 追加大师等级
	iD,
	%% 大师条件：
	%% 全身部位的攻/防追加等级均达到配置等级
	%% 需要的部位数，配置在全局表【globalSetup_4_养成玩法】ElementAddNumber
	strengLevel,
	%% 大师等级属性
	%% (属性ID，属性值)
	%% 等级属性叠加，后端汇总已激活的奖励
	attrAdd
}).

-endif.
