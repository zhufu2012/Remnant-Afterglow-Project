-ifndef(cfg_ornamentStrengthAward_hrl).
-define(cfg_ornamentStrengthAward_hrl, true).

-record(ornamentStrengthAwardCfg, {
	iD,
	%% 需要佩饰件数
	number,
	%% 需要最低品质和星级（品质，星级）0白色，1蓝色，2紫色，3橙色，4红色，5粉色。0-3：0-3星
	charAndStar,
	%% 需要阶数
	strengthLv,
	%% 属性（属性ID，属性值）
	attribute
}).

-endif.
