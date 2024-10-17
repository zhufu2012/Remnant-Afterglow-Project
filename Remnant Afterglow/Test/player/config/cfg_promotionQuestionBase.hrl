-ifndef(cfg_promotionQuestionBase_hrl).
-define(cfg_promotionQuestionBase_hrl, true).

-record(promotionQuestionBaseCfg, {
	iD,
	%% 作者:
	%% 奖励物品
	%% {序号，职业，类型，ID，数量，品质，星级，是否绑定，是否显示转圈特效是否装备}
	%% 序号，从1开始，选择性，序号填不一样的
	%% 职业:
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	%% 是否显示转圈特效：1.显示  0.不显示
	%% 注：显示的前后顺序，按照配置的顺序
	%% 做好后“coin、item”两字字段删除
	itemNew,
	%% 问卷问题列表
	question,
	%% 活动主界面的文字描述
	text,
	%% 英语
	text_EN,
	%% 印尼
	text_IN,
	%% 泰语
	text_TH,
	%% RU
	text_RU,
	%% FR
	text_FR,
	%% GE
	text_GE,
	%% TR
	text_TR,
	%% SP
	text_SP,
	%% PT
	text_PT,
	%% KR
	text_KR,
	%% TW
	text_TW,
	%% JP
	text_JP
}).

-endif.
