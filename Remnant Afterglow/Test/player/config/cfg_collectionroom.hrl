-ifndef(cfg_collectionroom_hrl).
-define(cfg_collectionroom_hrl, true).

-record(collectionroomCfg, {
	%% 收藏室等级
	iD,
	%% 升级经验(幻化经验道具提供的经验升级)
	%% 填“0”表示已升至最大级
	star,
	%% 所有幻化资质属性增加万分比
	%% 描述 所有幻化资质
	attrIncrease
}).

-endif.
