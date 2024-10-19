-ifndef(cfg_bountyTaskBase_hrl).
-define(cfg_bountyTaskBase_hrl, true).

-record(bountyTaskBaseCfg, {
	%% 序号
	iD,
	%% 每日可派遣上限
	%% 普通|特权
	maxDispatch,
	%% 每日首次显示任务数量
	%% &
	%% 每次刷新的固定任务数量
	flashNum,
	%% SSS可存储上限
	%% 规则：每次刷新任务数量固定，不足即会新增新的任务，当SSS任务总数达到配置的数量时，再次点击刷新会提示“已达到可存储SSS任务上限，请先完成任务”
	maxStoreTask,
	%% SS可存储上限
	%% 规则：不需要像SSS那样到达上限后不能刷新（SS储存到10个之后再刷新就做替换）
	maxStoreTask1,
	%% 任务等级区间编号
	levelSeg,
	%% 每日免费刷新次数
	freeRefresh,
	%% 额外刷新消耗
	%% （类型，ID，数量）
	%% 类型1：道具
	%% 类型2：货币
	refresh,
	%% 必定次数
	%% (必然随不中SSS的次数，必然出SSS的次数）
	%% 举例(2,6):
	%% 前2次必定不出SSS，第3次开始按照3-5次按照规则随机，如果前5次都不中SSS，那么第6次必定出SSS.
	%% 祝福值显示：按照(2,6)的配置表示，第5次满，第1次为1/5，第6次必定出SSS。
	%% ·必定不出时，也需要增加失败增长几率
	%% ·刷到SSS才清次数，从第1次开始；跨天或到重置玩法时间不清次数.
	%% ·次数记录到玩家个人身上.
	mustHit,
	%% 特殊
	%% （品质，出现个数，概率万分比，失败次数增长万分比）
	%% 品质：0、A；1、S；2、SS；3、SSS
	%% 随中之后，增加万分比重置.
	freeProbability,
	%% 普通
	%% 免费刷新,其他品质权重
	%% （品质,权重）
	%% 品质：0、A；1、S；2、SS；3、SSS
	freeWeight,
	%% 特权任务库ID
	%% BountyaskRandom中的任务库id
	specialTaskId,
	%% 直购ID
	directPurchase,
	%% 购买特权后立即获得的奖励
	%% （类型，ID，数量）
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	awardItem,
	%% 特权刷新：特殊
	%% （品质，出现个数，概率万分比，失败次数增长万分比）
	%% 品质：0、A；1、S；2、SS；3、SSS
	%% 随中之后，增加万分比重置.
	payProbability,
	%% 特权刷新：普通
	%% 手动刷新,其他品质权重
	%% （品质,权重）
	%% 品质：0、A；1、S；2、SS；3、SSS
	payWeight,
	%% 首次刷新:初始5个任务必定为1个SSS，3个SS和1个A
	%% (品质，个数）
	%% 品质：0、A；1、S；2、SS；3、SSS
	firstReplace
}).

-endif.
