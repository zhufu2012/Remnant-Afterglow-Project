-ifndef(cfg_dragonWeapon_hrl).
-define(cfg_dragonWeapon_hrl, true).

-record(dragonWeaponCfg, {
	%% 和item表中的神像装备id一一对应
	iD,
	%% 部位
	%% 1.主手
	%% 2.副手
	type,
	%% 装备是否是祝福类型主手/副手
	%% 1.是
	%% 0.否
	ifBless,
	%% 对应的神像ID
	dragonHave,
	%% 装备品质
	%% 品质0白1蓝2紫3橙4红5龙6神7神像
	order,
	%% 基础值（属性ID，数值）
	baseAttribute,
	%% 基础值评分ID
	basePoint,
	%% 极品属性
	%% （属性id，值，品质，评分ID）
	%% 品质0白1蓝2紫3橙4红5龙6神7神像
	onlyAttribute,
	%% 技能修正1
	%% (技能类型1,ID1,学习位1)|
	%% (技能类型2,ID2,学习位2)
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	skill1,
	%% 对应的套装ID1
	%% 祝福的套装ID
	comboID,
	%% 对应的套装ID2
	%% 普通的套装ID
	comboIDMin,
	%% 成长属性ID（成长属性表）
	%% 女神武器特有的成长属性
	growID
}).

-endif.
