-ifndef(cfg_mountSoulLvNew_hrl).
-define(cfg_mountSoulLvNew_hrl, true).

-record(mountSoulLvNewCfg, {
	%% 兽灵等级
	iD,
	%% 兽灵最大等级
	maxLv,
	%% 升下一级需要经验
	exp,
	%% 等级奖励属性
	%% {属性ID，属性值}
	attrAdd,
	%% 赠送奖励
	%% 对应的兽灵达到这个等级赠送
	%% （类型，ID，数量）
	%% 类型1：道具
	%% 类型2：货币
	%% MountIDNew做好后，删除MountID字段 
	mountIDNew
}).

-endif.
