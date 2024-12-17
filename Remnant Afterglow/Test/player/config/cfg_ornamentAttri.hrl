-ifndef(cfg_ornamentAttri_hrl).
-define(cfg_ornamentAttri_hrl, true).

-record(ornamentAttriCfg, {
	%% 属性ID
	iD,
	%% 阶数
	order,
	%% 索引
	index,
	%% 属性ID，属性值
	attribute,
	%% 属性品质色
	%% 0白色，1蓝色，2紫色，3橙色，4红色，5龙装，6神装，7龙神装
	character,
	%% 判断是否公告（海神祝福用）
	%% 0.不公告
	%% 1.高级属性公告
	%% 2.专属属性公告
	notice,
	%% 评分ID，到EquipScoreIndex表中查询评分值
	starScore,
	%% 配饰淬炼属性前缀文字名称
	%% 没有就填“0”
	prefix,
	%% 祝福属性评分
	point
}).

-endif.
