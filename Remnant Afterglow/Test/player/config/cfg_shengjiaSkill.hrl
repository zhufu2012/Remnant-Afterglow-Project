-ifndef(cfg_shengjiaSkill_hrl).
-define(cfg_shengjiaSkill_hrl, true).

-record(shengjiaSkillCfg, {
	%% 天赋序号
	stairs,
	%% 天赋等级
	lv,
	%% Key
	index,
	%% 天赋等级上限
	lvMax,
	%% 天赋升到下级的前置条件
	%% （天赋序号，天赋等级）
	%% 对应的天赋序号；天赋等级
	%% 这里配多个表示且的关系
	needSkillLv,
	%% 对应天赋位置
	%% （组别，位置序号）
	%% 位置序号：1：左下角
	%% 2：右下角
	%% 3：上方
	%% 4：中心
	position,
	%% 激活/升级消耗
	%% （道具ID，数量）
	%% 配空则为无消耗点亮
	%% 到下一级的消耗量
	needItem,
	%% 圣甲天赋buff触发效果
	%% D3新修改
	%% （类型，值，buffID）
	%% 类型1.当前神甲值固定值触发
	%% 类型2.当前神甲值达到万分比值触发
	talentEffect,
	%% 圣甲天赋技能
	%% 技能位：411~420
	%% 配置格式（技能类型，技能ID，技能位）
	%% 参数1：1.技能
	%%           2.技能修正
	%% 参数2：对应ID
	%% 参数3：技能位
	talentEffectShow,
	%% 评价值
	%% 累计值
	point
}).

-endif.
