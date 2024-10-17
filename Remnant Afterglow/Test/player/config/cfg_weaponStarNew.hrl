-ifndef(cfg_weaponStarNew_hrl).
-define(cfg_weaponStarNew_hrl, true).

-record(weaponStarNewCfg, {
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
	star,
	%% 客户端索引
	index,
	%% 最大星级
	starMax,
	%% 所需部位星级
	%% (部位序号,星级)
	%% 读当前级，0升1，读0
	needStar,
	%% 升级所需
	%% (道具ID，数量)
	%% 读下当前级，0升1，读0
	%% 一种材料，多种材料需优化
	needItem,
	%% 属性加值
	%% (属性id,属性值)
	attrAdd,
	%% 额外增加神兵基础万分比
	%% 对WeaponBaseNew_1_基础表AttrBase字段进行万分比加成，这里也是配置的累加值
	additionBaseAttr,
	%% 属性技等级
	%% 0为未激活
	skillLv,
	%% 属性技属性
	%% (属性id,属性值)
	%% 这里配0表示没有属性技，神兵主体要取消对应的属性技
	skillAttr,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate,
	%% 被动触发技的技能等级
	%% 0为未激活
	skillLv2,
	%% 神兵触发技能或修正
	%% (技能类型1,ID1,学习位1)
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得；神兵学习位119-123(应该不会用)
	skill
}).

-endif.
