-ifndef(cfg_geniusLv_hrl).
-define(cfg_geniusLv_hrl, true).

-record(geniusLvCfg, {
	%% 天赋类型
	%% 1为攻击
	%% 2为防御
	%% 3为通用
	iD,
	%% 天赋序号
	num,
	%% 等级
	lv,
	%% 客户端索引
	index,
	%% 提升至下级所需点数
	%% 填0表示无法再继续升级
	%% 神级天赋升星天赋消耗不在这
	%% 天赋升级限制：
	%% 1、高神位主天赋等级不得高于低神位主天赋等级
	%% 2、同层天赋，右侧天赋等级不得高于左侧天赋等级
	cons,
	%% 战士
	%% 天赋技能或修正
	%% (技能类型,ID,学习位)
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	skill1004,
	%% 战士buff修正
	%% (修正类型,修正参数,修正ID)
	%% 修正类型：
	%% 1为BuffType[BuffBase]参数3;修正参数=BuffType[BuffBase]参数3,
	%% 2为修正BuffID,修正参数=BUFFID
	%% 修正ID为ID[BuffCorr](BUFF修正ID)
	buffCorr1004,
	%% 法师
	%% 天赋技能或修正
	%% (技能类型,ID,学习位)
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	skill1005,
	%% 法师buff修正
	%% (修正类型,修正参数,修正ID)
	%% 修正类型：
	%% 1为BuffType[BuffBase]参数3;修正参数=BuffType[BuffBase]参数3,
	%% 2为修正BuffID,修正参数=BUFFID
	%% 修正ID为ID[BuffCorr](BUFF修正ID)
	buffCorr1005,
	%% 弓手
	%% 天赋技能或修正
	%% (技能类型,ID,学习位)
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	skill1006,
	%% 弓手buff修正
	%% (修正类型,修正参数,修正ID)
	%% 修正类型：
	%% 1为BuffType[BuffBase]参数3;修正参数=BuffType[BuffBase]参数3,
	%% 2为修正BuffID,修正参数=BUFFID
	%% 修正ID为ID[BuffCorr](BUFF修正ID)
	buffCorr1006,
	%% 双剑
	%% 天赋技能或修正
	%% (技能类型,ID,学习位)
	%% 技能类型：
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位：为0时不可直接获得
	skill1007,
	%% 双剑buff修正
	%% (修正类型,修正参数,修正ID)
	%% 修正类型：
	%% 1为BuffType[BuffBase]参数3;修正参数=BuffType[BuffBase]参数3,
	%% 2为修正BuffID,修正参数=BUFFID
	%% 修正ID为ID[BuffCorr](BUFF修正ID)
	buffCorr1007,
	%% 属性天赋ID
	%% 注：
	%% GeniusAttr表ID；
	%% 与Skill1004/Skill1005/Skill1006字段互斥
	geniusAttr,
	%% 生效技能字段
	%% 1表示：Skill1004/Skill1005/Skill1006字段；
	%% 2表示：GeniusAttr字段
	geniusSkill,
	%% 神级天赋升星消耗
	%% （道具ID,数量）
	%% 主天赋升星限制：高级神位星级不得高于低级神位星级，例：若3级神位主天赋为5星，则2级神最高可升至5星
	godStarNeed,
	%% 神级天赋升级/升星前置条件
	%% (条件类型,参数1,参数2)
	%% 条件类型：
	%% 当前只有枚举效果4、5
	%% 1为转职,参数1为转职等级
	%% 2为玩家等级,参数1为等级
	%% 3为天赋累计点数
	%% 参数1为天赋类型(0为所有累计消耗)
	%% 参数2为累计点数
	%% 4为天赋前置点数
	%% 参数1为当前天赋中序号,参数2为消耗点数
	%% 5为神位等级（神级天赋）
	%% 参数1为神位等级（高神位兼容低神位）
	condition
}).

-endif.
