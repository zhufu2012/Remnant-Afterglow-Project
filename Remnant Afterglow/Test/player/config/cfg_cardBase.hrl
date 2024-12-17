-ifndef(cfg_cardBase_hrl).
-define(cfg_cardBase_hrl, true).

-record(cardBaseCfg, {
	%% 图鉴ID
	iD,
	%% 属性
	%% (属性ID，值）
	cardAttr,
	%% 类型判断
	typeID,
	%% 可以镶嵌的部位
	%% 1为武器，2为项链，3为护手，4为戒指，5衣服，6头盔，7肩甲，14副手，9裤子，10护符
	part,
	%% 合成至下一个图鉴ID所需数量
	needCardNum,
	%% 合成至下一个ID
	%% （填0表示无法继续往下合成）
	nextCardId,
	%% 对应品质
	%% 品质0白 1蓝 2紫 3橙 4红 5幻彩
	%% 2对SR 3对SSR 4对SP 5对UR 
	cardBasic,
	%% 对应位序
	cardNum,
	%% 被动技：
	%% (技能类型,技能ID,学习位,技能等级)
	%% 技能类型：
	%% 1为技能(skillBase)；2为技能修正(SkillCorr)
	%% 学习位:为0时不可直接获得，……
	skill
}).

-endif.
