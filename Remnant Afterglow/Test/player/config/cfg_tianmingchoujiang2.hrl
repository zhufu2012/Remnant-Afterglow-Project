-ifndef(cfg_tianmingchoujiang2_hrl).
-define(cfg_tianmingchoujiang2_hrl, true).

-record(tianmingchoujiang2Cfg, {
	%% 抽奖ID
	iD,
	%% 单级抽奖积分消耗
	consWay,
	%% 奖励抽取规则
	%% （次数，次数，库ID）|（次数，次数，库ID）
	%% 如：(1,2,1)|(3,4,2)|(5,6,3)
	%% 第1-3次在库1中抽取奖励，第3-4次在库2中抽取奖励，第5-6次在库3中抽取奖励
	%% 注意：
	%% 1.库编号对应Award中的库；
	%% 2.库中的道具抽取采用不放回原则，比如库1中配置了3个物品，配置1-3次在库1中抽取，那么第一次抽取出1个物品后，第二次只能在剩余的两个物品中抽取，第三次只能在剩余的一个物品中抽取.
	rule,
	%% 奖励库物品权重
	%% （库ID,物品编号,权值）
	%% 各奖励库权重独立计算
	%% 例：(1,1,10)|(1,2,100)|(1,3,20)|(1,4,100)|(1,5,100)|(1,6,5)
	%% 对库1内的物品来说抽到的几率为库ID为1的物品权重/库ID为1的物品权重和，如库1编号为1的物品抽到的概率=10/110
	%% ·不同库中的物品编号也不能重复，拉通了进行配置.
	weight,
	%% 奖励库
	%% （物品编号，职业，类型，物品ID，数量，装备品质，装备星级，是否绑定）
	%% 物品编号：在库中该物品的编号
	%% 职业：0、1004,1005,1006,1007
	%% 物品类型：1.道具  2.货币  3.装备
	%% 是否绑定：0.非绑  1.绑定，货币和积分不使用此参数
	%% 装备品质、装备星级：除装备以外默认填0
	%% 星级：1-3
	%% 品质：0白 1蓝 2紫 3橙 4红
	%% ·不同库中的物品编号也不能重复，拉通了进行配置.
	%% ·物品编号的数值，约定配置为1-6，方便位置处理.
	%% ·根据物品编号显示道具的位置，物品编号为1时放在转盘顶部，物品编号2/3/4/5/6顺时针依次对应2/3/4/5/6的位置.
	award,
	%% 极品标签、全服记录
	%% (物品编号，极品标签，是否全服记录）
	%% 1、是
	%% 0、否
	notice,
	%% 概率公示文本内容
	%% 配置0或空，则不显示概率公示的入口.
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
