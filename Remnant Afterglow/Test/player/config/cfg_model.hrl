-ifndef(cfg_model_hrl).
-define(cfg_model_hrl, true).

-record(modelCfg, {
	%% 模型ID:共7位数
	%% 【第1-2位数】 【第3位数】 【第4位数】 【第5/6/7位】
	%% 【11主角装备】 【1战士装备；2法师装备；3弓手装备】 【1武器；2护手；3战甲；4头盔；5护肩；6战靴；7裤子；8身体低模；9武器低模】 【按照各个装备阶级依次排序：001-999】
	%% 【12时装】 【第3/4/5位 按照序号依次排序：000-999】 【0】【0武器；1头部；2身体；3副武】
	%% 【13翅膀】 【0】 【0】 【按照序号依次排序：001-999】
	%% 【14坐骑】 【0】 【0】 【按照序号依次排序：001-999】
	%% 【15宠物】 【0】 【0】 【按照序号依次排序：001-999】
	%% 【16圣物】 【1.火灵展示高模；2.土灵展示高模；3.水灵展示高模；4.雷灵展示高模】 【0】 【按照序号依次排序：001-999】
	%% 【17龙神】 【1主战龙神龙；2主战龙神人；3主战龙神武器；4助战龙神；5龙神秘典】 【0】 【按照序号依次排序：001-999】
	%% 【18怪物】 【1.小怪；2.BOSS；】 【0】 【按照序号依次排序：001-999】
	%% 【19NPC】 【0】 【0】 【按照序号依次排序：001-999】
	%% 【20其他】 【0】 【0】 【按照序号依次排序：001-999】
	%% 【21守护】 【0】 【0】 【按照序号依次排序：001-999】
	iD,
	%% 胶囊提半径
	semidiameter,
	%% 模型ID
	%% 填写Model表中的ID
	modelEx,
	%% 额外模型的低模
	lowModelEx,
	%% 挂点
	slot
}).

-endif.