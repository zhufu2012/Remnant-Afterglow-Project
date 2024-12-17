-ifndef(cfg_danmuGifts_hrl).
-define(cfg_danmuGifts_hrl, true).

-record(danmuGiftsCfg, {
	iD,
	name,
	%% 类型
	%% 1=结婚礼物，结婚弹幕时调用
	type,
	%% 贺礼消耗
	%% {消耗方式,消耗类型,参数1,参数2}
	%% 优先消耗消耗方式小的
	%% 消耗类型：1为物品；参数1：道具ID，参数2：道具数量；
	%% 2为货币；参数1：货币类型，参数2：货币数量
	cons,
	%% 赠送者获得道具
	%% {奖励类型,参数1,参数2}
	%% 奖励类型：
	%% 1为道具,参数1：道具ID，参数2：道具数量
	%% 2为货币,参数1：货币ID，参数2：货币数量
	award1,
	%% 被赠送者获得道具
	%% 夫妻各获得1份
	%% {奖励类型,参数1,参数2}
	%% 奖励类型：
	%% 1为道具,参数1：道具ID，参数2：道具数量
	%% 2为货币,参数1：货币ID，参数2：货币数量
	award2,
	%% 贺礼的价值
	%% 1块=100
	giftsValue,
	%% 次数限制
	%% 每场可以赠送的次数
	timeLimit,
	%% 侧边出名的保底时间和最长时间，毫秒
	famousTime,
	%% 侧边出名每增加1连击，增加的保底时间和最长时间，毫秒，以及最多能累积次数
	famousAddTime,
	%% 全屏特效
	%% 默认路径下的特效名，没有则填0
	%% 路径：Prefabs/VFX/UI/heli
	uiEff,
	%% 全屏特效的音效
	%% 默认路径：\Client\Assets\Resources\Sounds\UI
	effSound,
	%% 左侧礼物信息推送范围
	%% 0=没有推送
	%% 1=全服
	%% 2=本房间
	noticeType,
	%% 贺礼公告特效
	%% 路径：Prefabs/VFX/UI/heli
	noticeEff,
	%% 对应text表里sever页的ID
	%% 0=无公告
	%% 1=DanmuNotice1
	%% 2=DanmuNotice2
	%% 3=DanmuNotice3
	%% 4=DanmuNotice4
	%% 要添加新ID，必须找后端进行代码定义@张仁杰
	noticeText,
	%% 点击事件：
	%% 0=无事件
	%% 1=索要请柬
	%% 2=进入房间观战（暂规划）
	%% 3=跳转泡澡（暂规划）
	clickEvent
}).

-endif.
