-ifndef(cfg_continuousRecharge1_hrl).
-define(cfg_continuousRecharge1_hrl, true).

-record(continuousRecharge1Cfg, {
	%% 活动入口表类型为24.
	%% TypeID[ActiveBase]=24.
	iD,
	%% 填写PromotionReach_1_达成条件活动条件表的达成id
	activitys,
	%% 额外奖励：累计天数序号
	%% （序号,累计天数）
	order,
	%% 累计天数额外奖励（显示只有2个，所以只能配置2个）
	%% (职业，类型，ID，数量，品质，星级，是否绑定，是否显示转圈特效是否装备}
	%% 序号：Order字段的奖励序号.
	%% 职业:
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	%% 是否显示转圈特效：1.显示  0.不显示
	itemNew,
	%% 大奖预览界面奖励模型的参数配置
	%% （类型，ID，缩放，位置X,位置Y，位置Z,旋转X，旋转Y，旋转Z）
	%% 类型：0，ID=模型ID；
	%% 类型：1，ID=道具ID,通过道具ID去找模型和其他信息。
	%% 缩放，位置X,位置Y，位置Z，配置*100来配
	%% 缩放：100表示缩放的100%
	show,
	%% 大奖道具信息读取
	%% 该字段配置道具ID，读取到大奖道具信息，显示；
	%% 该字段配置为0时，则隐藏道具信息显示。
	show1
}).

-endif.
