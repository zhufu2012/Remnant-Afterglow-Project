-ifndef(cfg_meleeBase_hrl).
-define(cfg_meleeBase_hrl, true).

-record(meleeBaseCfg, {
	%% 作者:
	%% ID
	iD,
	%% 作者:
	%% 击杀积分相关参数
	%% 击杀基础积分|时间加成参数|最大加成生存秒数|击杀加成参数|最大加成击杀数|协助基础积分
	intKillPara,
	%% 作者:
	%% 时间积分相关参数
	%% 时间基础积分|时间加成参数|最大加成生存秒数|击杀加成参数|最大加成击杀数|间隔收益时间(S)
	intTimePara,
	%% 作者:
	%% 分配规则参数
	%% 配置1|配置2|配置3|配置4|配置5|配置6
	%% 配置1：人数保底值（人）
	%% 配置2：人数标准值（人）
	%% 配置3：人数高峰值（人）
	%% 配置4：整合保护时间（秒）
	%% 配置5：分线整合倒计时（秒）
	%% 配置6：阵营人数保护比（万分比）
	distPara,
	%% 作者:
	%% 整合时间点（秒，开始战斗为0秒）
	distTimePoint,
	%% 作者:
	%% 排序方式时间点
	%% 多少时间点后，采用对应排序方式
	%% {时间点(s),排序方式}
	%% 排序方式：
	%% 1为战斗力排序
	%% 2为积分排序
	rankWayTP,
	%% 作者:
	%% 麒麟洞的地图id
	mapID,
	%% 作者:
	%% 特殊组buff球刷的初始概率和上浮概率，万分比
	%% 时空整合后累积的概率清空
	specialBuffObjectValue,
	%% 作者:
	%% 任意门混杂密室门的初始概率和上浮概率，万分比
	%% 时空整合后累积的概率清空
	specialTeleporValue,
	%% 作者:
	%% 不同积分区间显示不同的图标：
	%% {积分下限1，积分上限1}|{积分下限2，积分上限2}
	%% 品质从低到高：羊-狼-熊-虎-麒麟
	hUD,
	%% 作者:
	%% 密室关闭时间,毫秒
	roomCloseTime,
	%% 作者:
	%% BOSS刷新时间，单位：秒
	bossTime,
	%% 作者:
	%% 助攻时间，秒
	assitKillTime,
	%% 作者:
	%% 假人数区间，不满足RealPlayer时显示假人数
	cheatPlayer,
	%% 作者:
	%% 假人数区间对应的参数
	%% 公式：区间内随机一个参数*当前真人数+当前真人数
	%% 向下取整（百分比）
	cheatParam,
	%% 时间经验奖励
	%% 参加该玩法每间隔一段时间获得一次经验奖励
	%% (时间间隔，经验参数）
	%% 时间间隔：秒；
	%% 经验参数：获得经验=经验参数*玩家等级对应获得经验标准值
	%% 玩家等级对应获得经验标准值：配置在ExpDistribution表中StandardEXP字段中
	timeExp
}).

-endif.