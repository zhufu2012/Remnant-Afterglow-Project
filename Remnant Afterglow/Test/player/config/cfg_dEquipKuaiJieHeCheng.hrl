-ifndef(cfg_dEquipKuaiJieHeCheng_hrl).
-define(cfg_dEquipKuaiJieHeCheng_hrl, true).

-record(dEquipKuaiJieHeChengCfg, {
	%% 可快捷合成的物品，道具ID
	%% 该列物品配置放入碎片背包
	iD,
	%% 所需数量
	num,
	%% 等级分段
	%% (起始等级、奖励序号）
	%% (1,1)|(100,2)表示：玩家等级为1-99级取序号为1的奖励，等级>=100级取序号为2的奖励.
	%% (1,1)表示：等级>=1级取序号为1的奖励.
	gradeNum,
	%% 合成目标,道具ID
	%% （分段，道具ID)
	item,
	%% 功能类型
	%% 1、合成
	%% 2、合成后自动使用
	type
}).

-endif.
