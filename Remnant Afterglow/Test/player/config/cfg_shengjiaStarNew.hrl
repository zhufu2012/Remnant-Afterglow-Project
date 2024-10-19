-ifndef(cfg_shengjiaStarNew_hrl).
-define(cfg_shengjiaStarNew_hrl, true).

-record(shengjiaStarNewCfg, {
	%% 等级
	iD,
	%% 等级上限
	maxLv,
	%% 等级段显示(星级)
	showLv,
	%% 等阶段显示(阶级)
	showStairs,
	%% 名字
	name,
	%% 升下一级消耗
	%% (消耗道具id，数量）
	needItem,
	%% 等级奖励属性
	%% (属性ID，属性值)
	attrAdd,
	%% 圣甲增减参数
	%% (触发范围/米,触发敌人数,衰减延时/秒）
	%% 圣甲增长：在pvp战斗中，触发范围内的敌方玩家数达到要求就开始增长圣甲值-当前前端处理，按玩家视野范围计算，改配置无效
	%% 圣甲衰减1：在pvp战斗中玩家有圣甲值时，若触发范围内的敌方玩家数持续一段时间（衰减延时）不足要求，则开始衰减圣甲值
	%% 圣甲衰减2：一段时间（衰减延时）内玩家未受伤或造成伤害，则开始衰减圣甲值
	shengjiaPar,
	%% 圣甲天赋等级
	talentLv,
	%% 圣甲天赋技能效果
	%% 填buffid，通过【BuffBase】EffectType控制buff效果开关
	talentEffect,
	%% 圣甲天赋技能
	%% 技能位：411~420
	%% 配置格式（技能类型，技能ID，技能位）
	%% 参数1：1.技能
	%%           2.技能修正
	%% 参数2：对应ID
	%% 参数3：技能位
	talentEffectShow,
	%% 圣盾外形
	%% 升阶可改变圣盾外显，填写ShengdunShowNew表的ID
	showID
}).

-endif.
