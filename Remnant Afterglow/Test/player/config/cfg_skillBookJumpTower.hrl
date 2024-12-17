-ifndef(cfg_skillBookJumpTower_hrl).
-define(cfg_skillBookJumpTower_hrl, true).

-record(skillBookJumpTowerCfg, {
	%% 技能书道具ID
	iD,
	%% 职业塔ID
	%% 1、永恒之塔-主塔
	%% 2、勇气之塔-战士
	%% 3、魔法之塔-法师
	%% 4、自然之塔-弓手
	%% 5、裁决之塔-圣职
	towerID,
	%% 技能书奖励所在的位置
	%% 填阶段奖励的Order
	towerFloors
}).

-endif.
