-ifndef(cfg_expeditionWeakCamp_hrl).
-define(cfg_expeditionWeakCamp_hrl, true).

-record(expeditionWeakCampCfg, {
	%% 弱阵营等级
	iD,
	%% 最大等级
	maxLv,
	%% 激活弱阵营条件：
	%% 被其他阵营占领的城池数量
	%% 附件中立区域各自独立计算
	condition,
	%% 弱阵营玩家进入弱势区域的首领地图时，一段时间内免疫被单挑，离开地图失效
	%% （持续时间，CD时间，BUFF_id）
	%% 时间单位：秒
	%% BUFF：主要用于前端展示，时间效果为新功能，由前面的参数确定
	freeTime,
	%% 弱阵营玩家进入弱势区域的首领地图时，获得对首领的伤害buff，离开地图失效
	%% （活跃度，BUFF_id）
	%% 活跃度：同首领防守buff，取上一远征活动天内参与了该玩法的人数和，同一个角色多次参与取1次.
	addBuff
}).

-endif.
