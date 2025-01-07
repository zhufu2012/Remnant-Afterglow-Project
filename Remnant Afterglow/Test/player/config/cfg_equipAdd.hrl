-ifndef(cfg_equipAdd_hrl).
-define(cfg_equipAdd_hrl, true).

-record(equipAddCfg, {
	%% 装备部位
	iD,
	%% 追加等级
	addLv,
	%% 索引
	index,
	%% 到下一级消耗道具
	%% {道具id，数量}
	consumeItem,
	%% 到下一级消耗货币
	%% {货币id，数量}
	consumeCoin,
	%% 祝福石ID
	blessID,
	%% 最低保底数量
	blessNeedMin,
	%% 升满需要的祝福石个数
	blessNeedMax,
	%% 最低保底祝福石
	%% {道具id，数量}
	%% *放了这么多颗祝福石就不会掉
	blessingItem,
	%% 升到满级祝福石数量{道具id，数量}
	blessingItemUp,
	%% 下一阶段等级
	breakLv,
	%% 展示成功率万分比
	showRate,
	%% 实际成功率万分比
	realRate,
	%% 当前等级失败跌落到XX等级
	downLv,
	%% 附带当前等级属性
	%% (属性id，数量)
	attribute,
	%% 阶段属性
	%% （属性ID，数量）
	%% （这里填的是累计值）
	%% 没用了
	stageAttr,
	%% 附带当前部位的装备强化万分比
	%% 万分比值
	attributeStage,
	%% 附带当前等级基础属性的万分比
	%% 万分比值
	attributeNormal,
	%% 追加大师附带当前等级属性
	%% (属性id，数量)
	attribute2,
	%% 追加大师等级，客户端显示用
	lvShow
}).

-endif.
