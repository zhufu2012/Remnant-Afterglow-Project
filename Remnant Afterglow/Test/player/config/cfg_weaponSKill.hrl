-ifndef(cfg_weaponSKill_hrl).
-define(cfg_weaponSKill_hrl, true).

-record(weaponSKillCfg, {
	%% 神兵id
	iD,
	%% 部位
	%% 1、主体
	%% 2：剑柄/弓臂/杖体
	%% 3：剑格/弓耳/杖头
	%% 4、剑脊/弓玄/杖尾
	%% 5、剑刃/箭台/魔石
	part,
	%% 星级
	%% 取不到按下取
	star,
	%% 客户端索引
	index,
	%% 属性技等级
	%% 0为未激活
	skillLv,
	%% 属性技属性
	%% (属性id,属性值)
	%% 这里配0表示没有属性技，神兵主体要取消对应的属性技
	skillAttr
}).

-endif.
