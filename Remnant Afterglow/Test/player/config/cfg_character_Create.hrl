-ifndef(cfg_character_Create_hrl).
-define(cfg_character_Create_hrl, true).

-record(character_CreateCfg, {
	iD,
	%% 职业枚举
	%% 1004为战士，1005为法师，1006为弓手
	career,
	%% 创建角色时发放的道具，items中的ID，道具数量类型（1是个数，2是时长），道具数量，items1,数量类型,道具数量|…|itemsN,数量类型,道具数量
	creat_Item,
	%% 需要装备在装备栏中的装备，都是Creat_Item已有的ID，没有填写了没有的ID，不创建该道具
	creat_Equipped,
	%% 创建角色时发放的货币，现在为三种，元宝、绑元、金币
	%% 0、元宝
	%% 1、铜币
	%% 2、魂玉
	%% 3、声望
	%% 4、荣誉
	%% 5、战魂
	%% 6、铸魂
	%% 7、帮会贡献
	%% 货币奖励
	%% {货币类型，数量}
	creat_Currency
}).

-endif.
