-ifndef(cfg_blessingBuffBox_hrl).
-define(cfg_blessingBuffBox_hrl, true).

-record(blessingBuffBoxCfg, {
	%% 祝福库ID
	iD,
	%% 品质
	%% 1、白色
	%% 2、蓝色
	%% 3、紫色
	%% 4、橙色
	%% 5、红色
	quarlity,
	%% 祝福强化（类型，ID，参数1）
	%% 类型=1，ID=技能ID
	%% 类型=2，ID=BUFF
	blessAdd,
	%% 职业ID，BlessAdd2添加的效果，只对配置的目标职业生效
	occupation,
	%% 天神ID：装备对应天神，才获得效果
	dragonID,
	%% 祝福强化2（类型，ID，参数1）
	%% 类型=1：技能修正，ID=技能修正，参数1=技能位
	%% 类型=2：BUFF修正，ID=BUFF修正id，参数1=BuffType详细标识对应的buff
	blessAdd2,
	%% 祝福分类（大分类，小分类）
	%% 大分类：
	%% 0、无
	%% 1、天神祝福、天神强化
	%% 2、精灵祝福、技能强化
	%% 3、环境祝福、特定场景增益
	%% 4、勇气祝福、基础强化
	%% 5、自然祝福、克制某种boss技能
	%% 小分类：
	%% 每种不同品质单独类型的祝福为一种小分类
	%% 例：攻击1、2、3、4、5
	type,
	%% 祝福类别文字
	typeName,
	%% 对应采集物ID
	collectionID
}).

-endif.
