-ifndef(cfg_dungeon_Arti).
-define(cfg_dungeon_Arti, 1).

-record(dungeon_ArtiCfg, {
	%% 作者:
	%% 推图id
	iD,
	%% 作者:
	%% 章节ID
	scene_ID,
	%% 作者:
	%% 章节名称
	scene_Name,
	%% 作者:
	%% 关卡序号,用来判断同一区域下的关卡顺序
	dungeon_ID,
	%% 作者:
	%% 文字唯一标签
	%% 在这个表内策划使用
	artiDungeonNameIndex,
	%% 作者:
	%% 关卡名称
	dungeon_Name,
	%% 作者:
	%% 通过关卡解锁下一个章节的ID
	scene_Next,
	%% 作者:
	%% 通过关卡解锁下一个关卡的ID
	dungeon_Next,
	%% 作者:
	%% 各难度对应的副本ID
	%% 普通，精英
	%% （可能只有普通副本）
	mapID_Det,
	%% 作者:
	%% 挑战推荐战力显示
	recommend_battlepoint,
	%% 关卡图标上显示的怪物模型
	model,
	%% 作者:
	%% 怪物模型的缩放比例
	scale,
	%% 奖励显示道具
	item,
	%% 作者:
	%% 通关消耗
	%% {消耗类型，消耗量}
	%% 消耗类型：
	%% 0代表空
	%% 1代表消耗体力
	%% 2代表消耗公用次数
	%% {普通副本}|{精英副本}精英副本可能为空
	costFatigue,
	%% 作者:
	%% 难度区分
	%% 人物经验系数
	%% 通关经验=人物等级*消耗体力消耗*人物经验系数
	teamExpPara,
	%% 作者:
	%% 铜币万分比系数
	%% 通过获得铜币(四舍五入)=铜币系数/10000*消耗体力*MoneyUnit[team_base]
	moneyPara
}).

-endif.
