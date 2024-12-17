-ifndef(cfg_promotionBase_hrl).
-define(cfg_promotionBase_hrl, true).

-record(promotionBaseCfg, {
	iD,
	name,
	name_EN,
	%% 印尼
	name_IN,
	%% 泰语
	name_TH,
	%% 该字段配置已经移到SB表
	%% 策划分组用，可将精彩活动分好组，不同组不同入口；不同入口只能看到本组的活动
	%% teamType=0：常规活动，固定在右方
	%% teamType>0：放主界面顶部
	teamType,
	%% 界面顶条的标题文字
	teamName,
	%% 界面顶条的标题文字
	teamName_EN,
	%% 印尼
	teamName_IN,
	%% 泰语
	teamName_TH,
	%% 是否显示推荐标签
	%% 1：显示
	%% 0：不显示
	pushTitle,
	%% 作者:
	%% 精彩活动类型（使用UI类型1）：
	%% 1.条件达成类
	%% 2.多倍奖励类
	%% 3.限时购买类
	%% 4.兑换类
	%% 5.排行类型
	%% 6.副本类型
	%% 7为四海BOSS
	%% 8为天魔重生修正
	%% 9 占位预留
	%% 10 门票活动
	%% 11 满减促销
	%% 12 累冲兑换；通过活动id+1联系兑换活动，若其不为兑换类活动，则为单独的每累充活动；次数只支持无限制和每日限制，且活动结束后不会邮件发奖(A表数据状态)
	%% 13 节日工资
	%% 17 开服礼包
	%% 18 幸运转盘
	%% 19 鸿运当头转盘
	%% 精彩活动类型（使用UI类型2）：
	%% 101.庆典累充（活动内累充，仅一档）
	%% 102.庆典排行（有子类型）
	%% 103.庆典任务（多种任务得积分，积分达成领奖品）
	%% 104.庆典基金
	%% 105.庆典商店
	%% 106.资源盛典（消耗道具获取资源点）：activitys列配RoulAConsP.xlsm表ID
	%% 107.特权周卡
	%% 108.云购活动
	%% 109.门票活动
	%% 110.龙神777
	%% 111.恶魔之海
	%% 112.达成类资源盛典
	%% 113.节日签到
	%% 114.神秘商店
	%% 115.新烟花
	%% 116.首充重置
	type,
	%% 作者:
	%% {type,param1,param2}
	%% type:
	%% 0.无
	%% 1.等级段{1,1,20}
	%%    X等级以下，param1填0，param2填X
	%%    X等级以上，param1填X，param2填0
	%% 2、VIP
	%% 3、战力
	%% 4、战盟创建者且为该战盟队长
	joinCustom,
	%% {玩法结算ID，DropLimit表里的掉落ID}|{玩法结算ID，DropLimit表里的掉落ID}……
	%% 没有世界掉落填0
	%% 玩法ID：
	%% 1. 主线副本
	%% 2 通天塔
	%% 3 夺宝
	%% 4 竞技场击败
	%% 5 组队试炼 
	%% 6 闯天关
	%% 7 妖魔来袭
	%% 8 野外挂机BOSS
	%% 9 野外挂机小怪
	worldDrop,
	%% Type=9时，填PromotionTypeA.xlsm表ID
	%% Type=10时，填PromotionTypeN.xlsm表ID
	%% type=11时，填PromotionTypeO表ID
	%% type=13时，填PromotionTypeT表ID
	%% Type=102时，填PromotionTypeK.xlsm表ID
	%% Type=103时，填PromotionTypeA.xlsm表ID
	%% Type=104时，填PromotionTypeJ.xlsm表ID
	%% Type=106时，填RoulAConsP.xlsm表ID
	%% Type=107时，填PromotionTypeL.xlsm表ID
	%% type=108是，填PromotionTypeM表ID
	%% type=109是，填PromotionTypeA.xlsm表ID
	%% Type=110时，填PromotionTypeP.xlsm表ID
	%% Type=111时，填PromotionTypeQ.xlsm表ID
	%% Type=113时，填PromotionTypeR表ID
	%% Type=114时，填PromotionTypeS表ID
	%% Type=114时，填PromotionTypeU表ID
	activitys,
	%% 概率公示文本内容
	brobabilityText,
	%% 概率公示文本内容
	brobabilityText_EN,
	%% 印尼
	brobabilityText_IN,
	%% 泰语
	brobabilityText_TH
}).

-endif.
