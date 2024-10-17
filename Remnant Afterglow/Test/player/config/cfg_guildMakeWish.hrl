-ifndef(cfg_guildMakeWish_hrl).
-define(cfg_guildMakeWish_hrl, true).

-record(guildMakeWishCfg, {
	%% 宠物碎片ID
	iD,
	%% OB+4不用
	%% 图鉴碎片ID（道具表）
	%% *删去
	pieceID,
	%% OB+4不用
	%% 个人转生限制条件
	changeRole,
	%% OB+4不用
	%% 对应品质
	%% 0 N白
	%% 1 R蓝
	%% 2 SR紫
	%% 3 SSR橙
	%% 4 SP 红
	%% 5 UR 粉
	pieceType,
	%% OB+4不用
	%% 可被赠送的数量上限
	%% (优化后去掉该字段）
	beGivenTimes,
	%% OB+4不用
	%% 每次赠送可送多少个，对应会扣除相同的碎片
	givenNum,
	%% 赠送成功后获得的奖励货币类型,数量
	%% 货币类型通用
	rewards,
	%% OB+4不用
	%% 可赠送图鉴碎片，所需该图鉴星级
	%% *删去
	givenNeedStar
}).

-endif.
