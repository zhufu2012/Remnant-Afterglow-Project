-ifndef(cfg_pantheonBase_hrl).
-define(cfg_pantheonBase_hrl, true).

-record(pantheonBaseCfg, {
	iD,
	name,
	%% 新增
	%% 对应品质
	%% 0 N白
	%% 1 R蓝
	%% 2 SR紫
	%% 3 SSR橙
	%% 4 SP 红
	%% 5 UR 粉
	rare,
	%% 对应神灵的展示条件（功能ID，后台ID）
	%% 配0表示初始展示
	ifShow,
	%% 评分
	score,
	%% 激活该神兽需要的最低神兽装备条件
	%% {兽装部位类型，品质}
	%% 部位字段在item的DetailedType字段中
	%% 品质在item的Character字段
	%% 白 蓝 紫 橙 红 龙 神 龙神
	require,
	%% 激活固定属性
	%% {属性ID，值}
	attribute,
	%% 被动技能属性，技能这边如果是对当前神格属性和当前神格装备进行加成的属性在这里配置，前端不进行处理
	%% (属性ID，值)
	attribute1,
	%% 神兽技能或修正
	%% (技能类型1,ID1,学习位1)|
	%% (技能类型2,ID2,学习位2)
	%% 技能类型：1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	%% 神兽出战技54-68
	%% 如果是对前端神格或者当前神格装备进行加成的属性放到Attribute1中配置，这里就配置一个空技能
	skill
}).

-endif.
