-ifndef(cfg_shengjiaactivate_hrl).
-define(cfg_shengjiaactivate_hrl, true).

-record(shengjiaactivateCfg, {
	%% 圣甲阶数
	iD,
	%% 当前激活消耗
	%% （道具ID，数量）
	needItem,
	%% 名字
	name,
	%% 激活前置条件
	%% （圣甲阶数，需要的圣甲等级）
	%% 填空则为无激活条件限制
	needShengjiaLv,
	%% 对应的圣甲天赋序号
	skillNum,
	%% 圣盾外形
	%% 升阶可改变圣盾外显，填写ShengjiaShowNew表的ID
	showID,
	%% 激活属性（所有激活累计值）
	%% (属性ID，属性值)
	attrAdd,
	%% 激活属性，额外属性
	%% ·用于增加固定战力，后端增加，前端在界面上不显示出来该属性。但属性的战力计算需要增加上。
	powerSupplement,
	%% 圣甲增减参数
	%% (触发范围/米,触发敌人数,衰减延时/秒）
	%% 圣甲增长：在pvp战斗中，触发范围内的敌方玩家数达到要求就开始增长圣甲值-当前前端处理，按玩家视野范围计算，改配置无效
	%% 圣甲衰减1：在pvp战斗中玩家有圣甲值时，若触发范围内的敌方玩家数持续一段时间（衰减延时）不足要求，则开始衰减圣甲值
	%% 圣甲衰减2：一段时间（衰减延时）内玩家未受伤或造成伤害，则开始衰减圣甲值
	shengjiaPar,
	%% 评价值
	%% 累计值
	point
}).

-endif.
