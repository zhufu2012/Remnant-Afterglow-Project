-ifndef(cfg_recoveryVitality_hrl).
-define(cfg_recoveryVitality_hrl, true).

-record(recoveryVitalityCfg, {
	%% 资源找回ID
	%% 13.耐力
	%% 14.活力
	iD,
	%% 转换的点数下限
	changeNumber,
	%% 不足转换下限每点折合具体物品
	%% （类型，ID，数量）
	%% 类型：1.道具
	%% 2.货币
	changeItem,
	%% 等级分段
	%% (起始等级、奖励序号）
	%% (1,1)|(100,2)表示：玩家等级为1-99级取序号为1的奖励，等级>=100级取序号为2的奖励.
	%% (1,1)表示：等级>=1级取序号为1的奖励.
	gradeNum,
	%% 具体换算奖励
	%% (序号，类型，ID，数量）
	%% 类型：1.道具
	%% 2.货币
	getItem
}).

-endif.
