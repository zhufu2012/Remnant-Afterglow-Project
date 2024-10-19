-ifndef(cfg_gameGuidanceAccompany_hrl).
-define(cfg_gameGuidanceAccompany_hrl, true).

-record(gameGuidanceAccompanyCfg, {
	%% 目录分页
	%% 填0表示没有分页标签显示，而直接显示内容
	%% 1魔宠
	%% 2坐骑
	%% 3翅膀
	%% 4圣物
	type,
	%% 目录内容子项
	content,
	%% 索引
	%% 界面显示顺序均按对应id从小到大排序，数值不需连续
	index,
	%% 道具id
	accompany,
	%% 获得外显条件
	%% 枚举：
	%% 1-通关魔宠副本收集碎片，TargetNum_1：魔宠对应碎片id，TargetNum_2：激活碎片总数；TargetNum_3：魔宠副本章节
	%% 2-全身宝石总等级，TargetNum_1：等级数
	%% 3-TargetNum_1阶及以上防御装备激活TargetNum_2套装，TargetNum_1：阶数；TargetNum_2:1普通、2完美、3传奇
	%% 4-TargetNum_1件橙色海神装备达到TargetNum_2级，TargetNum_1：件数；TargetNum_2：等级
	%% 5-TargetNum_1件装备强化到TargetNum_2段，TargetNum_1：件数；TargetNum_2：段数
	%% 6-激活TargetNum_1个魔戒，TargetNum_1：数量
	%% 7-激活TargetNum_1个TargetNum_2品质及以上的神灵，TargetNum_1：数量；TargetNum_2:1A、2S、3SS、4SSS、5SSR
	%% 8-全身有TargetNum_1个TargetNum_2以上属性，TargetNum_1：数量；TargetNum_2：品质色
	%% 9-TargetNum_1件装备追加到TargetNum_2级，TargetNum_1：件数；TargetNum_2：级数
	condition,
	%% 参数1
	%% 针对商城可购买外显Conditon=0，TargetNum_1配置为商城中售卖的道具id
	targetNum_1,
	%% 参数2
	targetNum_2,
	%% 参数3
	targetNum_3,
	%% 完成条件对应的功能开启id
	%% 备注：激活魔戒跳转到背包不需要功能开启，约定为0
	openAc,
	%% 商店id
	%% 商店中无售卖的道具填0
	shopId
}).

-endif.
