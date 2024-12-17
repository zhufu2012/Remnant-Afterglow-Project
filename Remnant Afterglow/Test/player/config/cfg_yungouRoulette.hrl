-ifndef(cfg_yungouRoulette_hrl).
-define(cfg_yungouRoulette_hrl, true).

-record(yungouRouletteCfg, {
	%% 作者:
	%% 转盘
	iD,
	%% 一次调用次数
	%% {调用方式编号,调用次数}
	%% {1,1}|{2,10}表示：单抽，十连抽
	%% 每一次抽都优先走1次特殊掉落，如果没中，再走普通掉落.
	%% 连抽：后端循环单次抽取，最后汇总结果一起发送前端
	useWay,
	%% {类型,参数1,参数2}
	%% 类型：1为消耗道具；参数1：道具ID；参数2：单次数量
	%% 类型：2为消耗货币；参数1：货币ID；参数2：单次数量
	consWay,
	%% 购买【ConsWay字段】中的消耗。
	%% ·ConsWay字段消耗不足时，可用该字段购买
	%% ·当该字段配置为0时，表示不可购买，无购买的途径显示。
	%% {货币ID，单次购买消耗}
	purchase,
	%% 特殊条件掉落概率
	%% {特殊奖编号,所需奖金积分（整个奖池中）,掉落万分比，所需累计次数（个人）}
	%% 2019/4/26修改：“所需累计次数（个人）”，绑定到“编号（个人”上，如果随中，个人的该编号上的累计次数清0，重新计次数。
	specWeight,
	%% 特殊奖励
	%% (特殊奖编号，职业，类型，ID，数量，品质，星级，是否绑定)
	%% 职业:
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	specAwardItem,
	%% 普通权值
	%% {普通编号,权值}
	commWeight,
	%% (普通编号，职业，类型，ID，数量，品质，星级，是否绑定)
	%% 职业:
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	commAwardItem,
	%% 作者:
	%% 转盘道具暂时顺序
	showOrder,
	%% （物品序号，是否转圈特效，是否系统公告，是否掉落记录）
	%% 物品序号：没有该序号表示没有转圈特效、没有掉落公告
	%% 是否转圈特效，是否系统公告，是否掉落记录：1是，0否
	%% 是否掉落记录：0否，1是，2大奖掉落记录，会优先显示在记录最上方
	show,
	%% 概率公示文本内容
	brobabilityText,
	%% 英文
	brobabilityText_EN,
	%% 印尼
	brobabilityText_IN,
	%% 泰语
	brobabilityText_TH,
	%% RU
	brobabilityText_RU,
	%% FR
	brobabilityText_FR,
	%% GE
	brobabilityText_GE,
	%% TR
	brobabilityText_TR,
	%% SP
	brobabilityText_SP,
	%% PT
	brobabilityText_PT,
	%% KR
	brobabilityText_KR,
	%% TW
	brobabilityText_TW,
	%% JP
	brobabilityText_JP
}).

-endif.
