-ifndef(cfg_equipGhostNew_hrl).
-define(cfg_equipGhostNew_hrl, true).

-record(equipGhostNewCfg, {
	%% 守护ID
	iD,
	%% 类型
	%% 1.经验守护
	%% 2.防御守护
	%% 3.3阶守护
	%% 4.4阶守护
	%% ……
	type,
	%% 守护阶数
	%% 1.初始守护
	%% 2.1阶守护
	%% 3.2阶守护
	jiBanType,
	%% 时限单位秒
	time,
	%% 续费花费道具
	%% {组号，道具类型，道具ID，道具数量}
	%% 组号：分组续费花费道具，同一组道具即可续费
	%% 道具类型：1为激活道具，2为进阶道具
	coinCost,
	%% 激活消耗
	activationItem,
	%% 进阶消耗
	advancedItem,
	%% 当所有激活道具都没有的时候，界面上默认显示的激活道具
	activationShow,
	%% 当所有续费道具都没有的时候，界面上默认显示的续费道具组号
	coinShow,
	%% 增加属性{属性id，数值}
	attribute,
	%% 守护技能或修正
	%% (技能类型,ID,学习位)
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 守护被动技能：106
	%% 该字段需要去掉
	skill,
	%% 进阶目标
	%% 填守护ID，没有填0
	advancedTarget,
	%% 极品属性（属性ID，值）
	bestAttribute
}).

-endif.
