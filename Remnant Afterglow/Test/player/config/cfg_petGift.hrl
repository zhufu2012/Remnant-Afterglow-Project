-ifndef(cfg_petGift_hrl).
-define(cfg_petGift_hrl, true).

-record(petGiftCfg, {
	%% 副本ID
	iD,
	%% 全服首杀奖励，填0则无（玩家实际获得）
	%% （类型，道具ID，是否绑定,数量）
	firstItem,
	%% 三星奖励
	%% (类型，道具ID，是否绑定,数量）
	starReward3,
	%% 二星奖励
	%% （类型，道具ID，是否绑定,数量）
	starReward2,
	%% 一星奖励
	%% （类型，道具ID，是否绑定,数量）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	%% 掉落是否绑定：0为非绑 1为绑定，货币不使用此参数
	starReward1,
	%% 副本模型
	%% (怪物ID,X偏移,Y偏移,Z偏移,X旋转,Y旋转,Z旋转,缩放值)
	modelTransform,
	%% 领取奖励世界红包
	%% （货币类型，货币总量，数量参数)
	%% ·货币类型：通用，一般配绑钻；
	%% ·红包由系统直接发放
	%% ·红包只有当首名玩家领取了全服首杀奖励的时候才发
	%% ·填0没有
	guildRedBag,
	%% 推荐英雄
	%% 填：英雄ID
	pet
}).

-endif.
