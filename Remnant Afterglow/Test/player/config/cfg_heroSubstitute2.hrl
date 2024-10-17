-ifndef(cfg_heroSubstitute2_hrl).
-define(cfg_heroSubstitute2_hrl, true).

-record(heroSubstitute2Cfg, {
	%% 宠物类别：
	%% 1、风
	%% 2、火
	%% 3、土
	iD,
	%% 序号
	oder,
	index,
	%% 权重
	weight,
	%% 可被置的宠物ID
	%% 默认5星SSR宠物
	%% 被置换时，不能随机到本身
	pet,
	%% 加入置换和被置换的条件
	%% {条件类型，参数1，参数2，…}
	%% 填0表示：默认加入，没有条件
	%% 条件类型1：获得过后面参数中配置英雄之一，参数1=英雄ID，参数2=英雄ID，参数3=英雄ID}
	%% 条件类型2：
	condition
}).

-endif.
