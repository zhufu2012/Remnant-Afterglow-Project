-ifndef(cfg_weaponLevelNew_hrl).
-define(cfg_weaponLevelNew_hrl, true).

-record(weaponLevelNewCfg, {
	%% 神兵id
	iD,
	%% 阶数
	level,
	%% 客户端索引
	index,
	%% 最大阶数
	levelMax,
	%% 升阶消耗
	%% (道具id，数量)
	%% 0阶升级1阶，读取0阶配置
	needItem,
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
	skill,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate
}).

-endif.
