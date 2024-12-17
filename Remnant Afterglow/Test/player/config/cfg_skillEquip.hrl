-ifndef(cfg_skillEquip_hrl).
-define(cfg_skillEquip_hrl, true).

-record(skillEquipCfg, {
	%% 技能装配相关
	%% 0转3-6
	%% 1转后主动200+
	%% 该字段的学习位的技能只有被装配了才生效
	iD,
	%% 装配类型
	%% 1为普通技能
	%% 学习字段：SkillActi[Character_Ambit]
	%% (当职业技能开启后,就可以放在自动释放里面,最多放4个)
	%% 2为被动技能
	%% 没有动作，无法装配
	%% 3 付费群体技能，显示付费技能界面，也无法装配
	%% 4.付费单体技能，要显示奥义技能标签
	type,
	%% 是否可以装配普攻自动释放(最多勾选4个)
	autoEquip,
	%% 转数
	%% 0为0转
	changeRole
}).

-endif.
