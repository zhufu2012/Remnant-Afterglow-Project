-ifndef(cfg_newLevelLimitGift_hrl).
-define(cfg_newLevelLimitGift_hrl, true).

-record(newLevelLimitGiftCfg, {
	%% 序号ID
	iD,
	%% 所需点数
	%% 这里填的是单级值
	%% （这里取得值是用来升下一级的数量）
	needNum,
	%% 单次注入的所需点数
	%% （这里取得是本级单次点的时候消耗的数量）
	addNum,
	%% 单次点击增加属性
	addAttribute,
	%% 最后一次注入额外获得的属性
	%% 与AddAttribute字段的属性相同
	specialAddAttribute,
	%% 技能组数
	%% 同一组数技能替换，不同组数技能叠加，0为不学习技能
	group,
	%% 技能等级
	skillLv,
	%% 技能或修正
	%% (区分主角和英雄,职业,技能类型1,ID1,学习位1)
	%% 区分主角和英雄
	%% 1主角获得，2英雄获得
	%% 职业
	%% 如果是主角，职业 0不区分，1004战士，1005法师，1006弓手，1007是圣职
	%% 如果是英雄，填0，不分类
	%% 技能类型
	%% 1为技能(skillBase);
	%% 2为技能修正(SkillCorr)
	%% 学习位
	%% 为0时不可直接获得
	%% 专用技能位69~75
	%% 14为英雄普攻学习位
	skill,
	%% 封印之证buff修正
	%% 用于封印之证中的特殊buff修正
	%% (修正类型1,参数1,参数2)
	%% |(修正类型2,参数1,参数2)
	%% 1为根据类型（详细标识）修正buff
	%%   参数1为被修正的Buff类型(BuffType参数3详细标识)
	%%   参数2为buff修正ID（buffCorr）
	%% 2为根据buffID修正buff
	%%    参数1为被修正的buffID（BuffBase）
	%%    参数2为buff修正ID（buffCorr）
	%% 3为根据类型（Buff分类）修正buff
	%%   参数1为被修正的Buff类型(BuffType参数2)
	%%   参数2为buff修正ID（buffCorr）
	buff,
	%% (属性ID，值，上限值)
	%% 这里填的是累计值
	attribute
}).

-endif.
