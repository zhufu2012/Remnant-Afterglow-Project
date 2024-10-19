-ifndef(cfg_mountEquipStar_hrl).
-define(cfg_mountEquipStar_hrl, true).

-record(mountEquipStarCfg, {
	%% 装备ID
	iD,
	%% 对应等级
	%% 这里有个全局字段：MountEquipStarMax，控制最大提升等级
	star,
	%% 对应进度
	num1,
	%% 对应星级
	num2,
	%% 升至下一星级消耗材料
	%% （道具ID，数量）
	nextNedd,
	%% 下一星级装备ID
	%% 配0表示已达当前品质最大星级
	nextID,
	%% 当前星级分解返还材料 
	%% (道具ID，数量）
	%% 有星级拆解成对应0星ID与道具
	resolve,
	%% 对应0星装备ID
	equipID,
	%% 基础属性万分比
	%% 对应MountEquip_1_坐骑装备表Attribute字段
	baseAdd,
	%% 卓越属性万分比
	%% 对应MountEquip_1_坐骑装备表StarRule及StarAttribute1/2/3字段
	starAttributeAdd
}).

-endif.
