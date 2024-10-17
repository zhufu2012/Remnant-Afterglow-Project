-ifndef(cfg_weaponBaseNew_hrl).
-define(cfg_weaponBaseNew_hrl, true).

-record(weaponBaseNewCfg, {
	%% 神兵ID
	iD,
	%% 职业
	%% 1004：战士
	%% 1005：法师
	%% 1006：弓手
	%% 1007：圣职
	profession,
	%% 是否生效
	open,
	%% 神兵分组
	%% 策划备注：
	%% 10*：战士
	%% 20*：法师
	%% 30*：弓手
	%% 40*：圣职
	%% 一主一副
	%% 为一组
	group,
	%% 主手还是副手
	%% 战士，法师
	%% 主手为2
	%% 副手为1
	%% 弓手
	%% 主手为1
	%% 副手为2
	part,
	%% 品质
	%% （稀有度）
	%% 0为S
	%% 1为SS
	%% 2为SSS
	%% 3为SSR
	rareType,
	%% 达到对应条件才在列表上显示出来：
	%% (转职数，玩家等级）
	lvShow,
	%% 分组名字
	groupName,
	%% 名字
	name,
	%% 解锁条件
	%% (条件类型,参数)
	%% 条件类型0：默认解锁
	%% 条件类型1：激活指定神兵，参数为神兵id
	%% 解锁的神兵才能激活（包括道具激活）
	unsealCondi,
	%% 激活条件
	%% (条件类型,参数1,参数2)
	%% 条件类型1：道具激活，参数1为道具id，参数2为消耗数量
	%% 条件类型2：打造激活，参数为打造id，参数2默认0
	activeCondi,
	%% 激活后初始阶数
	stepIniti,
	%% 能否升星
	%% 默认0星
	canStar,
	%% 能否解封
	%% 默认0级
	canReopen,
	%% 基础属性
	%% (属性ID，属性值)
	attrBase,
	%% 卓越属性
	%% (属性ID，属性值)
	attrOutst,
	%% 被动触发技的技能等级
	%% 0为未激活
	skillLv,
	%% 神兵触发技能或修正
	%% (技能类型1,ID1,学习位1)
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得；神兵学习位119-123(应该不会用)
	%% 此字段已废弃
	skill,
	%% 传奇属性
	%% 填写成长属性表GrowAtrr的id
	%% 绑定神兵，激活即生效不要中途修改
	attrLeg,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate
}).

-endif.
