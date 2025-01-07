-ifndef(cfg_titlePromotionNew_hrl).
-define(cfg_titlePromotionNew_hrl, true).

-record(titlePromotionNewCfg, {
	%% 职业ID
	%% 职业1004为战士，1005为魔法师，1006为弓箭手
	iD,
	%% 头衔等级
	strengthLv,
	%% 索引
	index,
	%% 名字
	name,
	%% 最大头衔等级
	maxLv,
	%% 提升玩家等级需求
	lv,
	%% 头衔icon
	headPic,
	%% 到下一级消耗道具
	%% {道具id，数量}
	consumeItem,
	%% 头衔文字颜色
	%% 第一个是字体自身颜色
	%% 第二个是字体外发光的颜色
	%% （仅全球版使用）
	color,
	%% 当前等级附带属性
	%% {属性id，数量}
	%% 累计属性
	attribute,
	%% 属性技能ID
	%% 读取【TitlePromotionAttrSkill_1_属性技能】的ID
	skillID,
	%% 等级奖励物品
	%% （类型，ID，是否绑定，数量）
	%% 类型1，道具
	%% 类型2，货币
	%% 3，属性技能
	reward
}).

-endif.
