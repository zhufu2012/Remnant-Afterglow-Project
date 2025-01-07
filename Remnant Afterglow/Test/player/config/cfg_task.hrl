-ifndef(cfg_task_hrl).
-define(cfg_task_hrl, true).

-record(taskCfg, {
	%% 任务id 
	%% 主线任务：3100001-3109999
	%% 日常任务：3000001-3009999
	%% 支线任务：3200001-3209999
	%% 仙盟任务：3300001-3309999
	%% 节日任务：3400001-3409999
	%% 活动任务：3500001-3509999
	%% 赏金任务：
	%% 3600001-3609999
	%% 战盟任务：（周环）
	%% 3610000-3619999
	%% 转职任务：3620000-3629999
	%% 引导任务：4000001-？
	%% 等级任务：5000001-？
	iD,
	%% 类型
	%% 0主线
	%% 1日常
	%% 2支线
	%% 3仙盟
	%% 4节日
	%% 5活动
	%% 6赏金
	%% 7战盟任务
	type,
	%% 赏金任务组id
	%% 只有type为2的任务才读取此项
	%% 1为通关副本任务
	task_groupid,
	%%  
	task_orderid,
	%% 天数限制
	%% （类型，天数）
	%% 类型1：累计登录天数
	%% 类型2：开服天数
	day_get,
	%% 等级限制
	%% 没有限制填0
	%% 用于赏金和日常任务
	%% 等级下限（含）
	lv_min,
	%% 等级限制
	%% 没有限制填0
	%% 用于赏金和日常任务
	%% 等级上限（含）
	lv_max,
	%% 是否显示为转职任务
	%% 1是
	%% 0不是
	task_name,
	%% 需要达成几转才能接取该任务
	lv_get,
	%% vip等级
	%% 只有达到特定vip等级才能接任务
	%% 没有限制填0
	%% 用于赏金和日常任务
	vip,
	%% 限制当前任务在所填任务完成后才可见，没有限制填0
	task_pre,
	%% 完成当前任务后自动接受的任务，没有后续填0
	task_next,
	%% 是否有接取额外条件
	%% 1、是（是的话，根据【TaskCondition_1_任务接取额外条件】表判断.
	%% 0、否
	condition,
	%% 填1表示角色出生就开始任务计数，否则填0。这个与该任务是否接受是否可见都没有关系
	born_task,
	%% 目标类型：
	%% 对话 0
	%% 杀怪 1
	%% （寻路找trigger）完成副本 2
	%% 收集 3,target_num要收集的道具数量，target_num1要收集的道具ID
	%% 探索 4
	%% 主角等级 5
	%% 播放剧情动画 6
	%% 引导任务 7
	%% 传送任务 8
	%% 对话+副本（不会找副本trigger） 9
	%% 自动弹奖励的引导任务 10
	%% 对话＋探索 11
	%% 12通关引导副本   target_num:数量；target_num1:0；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% D3杀怪14
	%% 75激活4转命星，target_num为需要激活的数量
	%% 76激活6转的龙魂，target_num为需要激活的龙魂数，target_num1为龙魂阶段ID
	%% 78激活7转的龙魂，target_num为需要激活的龙魂数，target_num1为龙魂阶段ID
	%% 77激活8转的元素，target_num为需要激活的元素数，target_num1为元素ID
	%% 78点亮龙魂水晶，target_num为需要激活的水晶数
	%% 79点亮魔源，target_num为需要激活的魔源
	%% 80点亮神火，target_num为需要点亮的神火
	%% 81一转收集材料需要阶段，target_num为阶段数
	%% 82二转点亮图纸，target_num为需要点亮的图纸数量
	%% 83三转收集道具，target_num为需要点亮的道具数量
	%% 84四转收集道具，target_num为需要点亮的道具数量
	%% 103翅膀升级   target_num为数量   target_num1为翅膀的等级   target_num2为0   target_num3为0   target_num4为0
	%% 106翅膀炼魂   target_num为数量   target_num1为翅膀的炼魂等级   target_num2为0   target_num3为0   target_num4为0
	%% 108翅膀翼灵   target_num为翼灵的等级   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 110翅膀激活   target_num为数量   target_num1为品质   target_num2为0   target_num3为0   target_num4为0
	%% 112坐骑升级   target_num为数量   target_num1为坐骑的等级   target_num2为0   target_num3为0   target_num4为0
	%% 115坐骑炼魂   target_num为数量   target_num1为坐骑的炼魂等级   target_num2为0   target_num3为0   target_num4为0
	%% 117坐骑兽灵   target_num为兽灵的等级   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 118坐骑激活   target_num为数量   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 119魔宠升级   target_num为数量   target_num1为魔宠的等级   target_num2为0   target_num3为0   target_num4为0
	%% 122魔宠炼魂   target_num为数量   target_num1为魔宠的炼魂等级   target_num2为0   target_num3为0   target_num4为0
	%% 124魔宠魔灵   target_num为魔灵的等级   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 125魔宠激活   target_num为数量   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 126装备强化   target_num为数量   target_num1为强化等级   target_num2为0   target_num3为0   target_num4为0
	%% 127装备追加   target_num为数量   target_num1为追加等级   target_num2为0   target_num3为0   target_num4为0
	%% 128装备洗炼   target_num为洗练属性的条数   target_num1为洗练属性的品质   target_num2为0   target_num3为0   target_num4为0
	%% 129装备镶嵌   target_num为数量   target_num1为宝石等级   target_num2为0   target_num3为0   target_num4为0
	%% 130装备精炼   target_num为部位数量   target_num1为宝石精炼等级   target_num2为0   target_num3为0   target_num4为0
	%% 131装备套装   target_num为套装件数   target_num1为装备阶数   target_num2为套装攻防类型（1,攻击类 2 防御类）   target_num3为套装级别（1普通，2完美）   target_num4为0
	%% 132装备穿戴   target_num为装备的品质   target_num1为装备的星级   target_num2为0   target_num3为0   target_num4为0
	%% 134圣物升级   target_num为数量   target_num1为圣物的等级   target_num2为0   target_num3为0   target_num4为0
	%% 138圣物激活   target_num为数量   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 139圣物圣灵   target_num为数量   target_num1为圣灵的等级   target_num2为0   target_num3为0   target_num4为0
	%% 140龙神唤醒   target_num为数量   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 141龙神升阶   target_num为数量   target_num1为主战龙神的等级   target_num2为0   target_num3为0   target_num4为0
	%% 143精灵龙神激活   target_num为数量   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 144精灵龙神升阶   target_num为数量   target_num1为精灵龙神的等级   target_num2为0   target_num3为0   target_num4为0
	%% 146龙神武器激活   target_num为数量   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 148龙神秘典激活   target_num为数量   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 149龙神秘典觉醒   target_num为数量   target_num1为龙神秘典的等级   target_num2为0   target_num3为0   target_num4为0
	%% 150龙印装配   target_num为数量   target_num1为品质   target_num2为0   target_num3为0   target_num4为0
	%% 151龙印升级   target_num为数量   target_num1为龙印等级   target_num2为0   target_num3为0   target_num4为0
	%% 155聚魂装配   target_num为数量   target_num1为聚魂等级   target_num2为0   target_num3为0   target_num4为0
	%% 156聚魂升级   target_num为数量   target_num1为品质   target_num2为0   target_num3为0   target_num4为0
	%% 158图鉴激活   target_num为图鉴的激活数量   target_num1为图鉴的星级   target_num2为图鉴的品质   target_num3为0   target_num4为0
	%% 165神祇装备强化   target_num为神祇的装备强化等级   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 166激活神祇   target_num为神祇的激活数量   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 168龙神塔层数   target_num为通关最高层数   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 168通关魔宠副本  target_num:次数   target_num1:副本ID   target_num2为星级   target_num3为0   target_num4为0
	%% 170通关坐骑副本  target_num:次数   target_num1:副本ID   target_num2为星级   target_num3为0   target_num4为0
	%% 171通关翅膀副本   target_num:次数   target_num1:副本ID   target_num2为星级   target_num3为0   target_num4为0
	%% 172通关龙神材料本   target_num:次数   target_num1:副本ID   target_num2为星级   target_num3为0   target_num4为0
	%% 173圣物副本   target_num为副本ID   target_num1为次数   target_num2为星级   target_num3为0   target_num4为0
	%% 174通关龙神秘典副本   target_num为副本ID   target_num1为次数   target_num2为星级   target_num3为0   target_num4为0
	%% 175通关矮人宝藏   target_num为副本ID   target_num1为次数   target_num2为星级   target_num3为0   target_num4为0
	%% 176通关精灵宝库   target_num为副本ID   target_num1为次数   target_num2为星级   target_num3为0   target_num4为0
	%% 177竞技场胜利   target_num为竞技场胜利次数   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 180通关地精宝库   target_num为副本ID   target_num1为次数   target_num2为星级   target_num3为0   target_num4为0
	%% 181埋骨之地建塔   target_num为塔的数量   target_num1为塔的类型（塔ID）   target_num2为0   target_num3为0   target_num4为0
	%% 193战盟周环任务   target_num为数量   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 203赏金任务   target_num为数量   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 206好友数   target_num为头衔等级   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 206好友数   target_num为好友数量   target_num1为亲密度等级   target_num2为0   target_num3为0   target_num4为0
	%% 207恶魔广场完成次数   target_num为完成次数   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 211恶魔入侵   target_num为击杀boss数   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 212个人恶魔   target_num为完成次数   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 214恶魔禁地   target_num为击杀boss数   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 215神魔战场   target_num为击杀boss数   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 216神魔战场（联服）   target_num为击杀boss数   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 219日常   target_num为天数（可以不连续）   target_num1为活跃度   target_num2为0   target_num3为0   target_num4为0
	%% 221炼金   target_num为炼金等级   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 222魔宠装备   target_num为魔宠装备件数   target_num1为魔宠装备品质，0白1蓝2紫3橙4红5粉6神,-1任意品质   target_num2为0   target_num3为0   target_num4为0
	%% 223坐骑装备   target_num为坐骑装备件数   target_num1为坐骑装备品质，0白1蓝2紫3橙4红5粉6神,-1任意品质   target_num2为0   target_num3为0   target_num4为0
	%% 224翅膀装备   target_num为翅膀装备件数   target_num1为翅膀装备品质，0白1蓝2紫3橙4红5粉6神,-1任意品质   target_num2为0   target_num3为0   target_num4为0
	%% 225加入战盟   target_num为加入战盟   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 232阅读信件    target_num为1   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 233对话+互动任务   target_num为1为解锁石碑 2为七弦琴 3为擦拭水晶   4为锚定命星 5为信件擦血
	%% 1001 人物全身{0}件{1}或者{2}阶{3}品质{4}星以上装备任务完成   target_num为满足数量   target_num1为条件1品质，0白1蓝2紫3橙4红5粉6神,-1任意品质   target_num2为条件2阶数   target_num3为条件2品质   target_num4为装备星数
	%% 1002击杀打宝玩法XXX级以上boss数   target_num为数量   target_num1为等级下限（含）   target_num2为0   target_num3为0   target_num4为0，要计算的玩法恶魔入侵、个人恶魔、恶魔之家、恶魔禁地、神魔战场、世界BOSS
	%% 1010竞技场次数到达规定的有奖励次数   target_num为数量   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 1011商船运送次数到达规定的有奖励次数   target_num为最低商船品质品质   target_num1为数量   target_num2为0   target_num3为0   target_num4为0
	%% 1012通过副本且等级到达要求 target_num为等级要求   target_num1为0   target_num2为0   target_num3为0   target_num4为0
	%% 2001提交货币  target_num:数量   target_num1为货币ID
	%% 2002指定数量技能升级到指定等级  target_num:技能数量   target_num1为目标等级
	%% 2003激活指定守护  target_num:守护数量   target_num1为守护ID
	%% 2004传带龙饰  target_num:穿戴数量
	%% 2005主线副本进度 target_num为完成目标任务副本ID
	%% 2006坐骑副本完成次数 target_num为完成次数
	%% 2007协助达到次数 target_num为完成次数
	%% 2008翅膀副本完成次数 target_num为完成次数
	%% 2009提交道具  target_num:数量   target_num1为道具ID
	%% 2010龙神副本完成次数 target_num为完成次数
	%% 2011情侣试炼完成次数 target_num为完成次数
	%% 2012XO大作战完成次数 target_num为完成次数
	%% D3新增及修改
	%% 2013购买指定技能书 target_num:数量target_num1:技能位target_num2:角色顺序target_num3:0target_num4:0target_num5:0
	%% 2014激活指定技能 target_num:数量target_num1:技能位target_num2:角色顺序target_num3:0target_num4:0target_num5:0
	%% 1041领取觉醒之路指定奖励 target_num:数量target_num1:DragonIllustrationsGift表IDtarget_num2:target_num3:0target_num4:0target_num5:0
	%% 2016完成勇者试炼引导副本 target_num:数量target_num1:0target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2017创建第二职业 target_num:数量target_num1:0target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2018激活龙神雕像 target_num:数量target_num1:道具idtarget_num2:target_num3:0target_num4:0target_num5:0
	%% 2019派遣赏金任务（派遣即完成） target_num:次数target_num1:任务品质:0=A,1=S,2=SS,3=SSS,4=SSS特权,target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2021创建第三职业 target_num:数量target_num1:0target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2022通关魔宠试炼副本 target_num:数量target_num1:0target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2023坐骑激活 target_num:数量target_num1:idtarget_num2:0target_num3:0target_num4:0target_num5:0
	%% 2024翅膀激活 target_num:数量target_num1:idtarget_num2:0target_num3:0target_num4:0target_num5:0
	%% 2025魔宠激活 target_num:数量target_num1:idtarget_num2:0target_num3:0target_num4:0target_num5:0
	%% 2026天神激活 target_num:数量target_num1:idtarget_num2:0target_num3:0target_num4:0target_num5:0
	%% 2027激活神晶 target_num:数量target_num1:道具idtarget_num2:天神idtarget_num3:0target_num4:0target_num5:0
	%% 231快速讨伐 target_num:次数target_num1:0target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2028转职任务用（同时满足激活多个技能） target_num:ChangeRoleMutiTask_1_转职多角色任务表ID   target_num1:技能位ID target_num2:技能位ID target_num3:技能位ID target_num4:技能位ID 
	%% 2029完成法老宝库 target_num:次数target_num1:0target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2020穿戴一件神饰 target_num:数量target_num1:阶数target_num2:展示用道具IDtarget_num3:0target_num4:0target_num5:0
	%% 2030购买一件神饰 target_num:数量target_num1:0target_num2:0target_num3:0target_num4:0target_num5:0
	%% 158镶嵌卡片 target_num:数量target_num1:星级target_num2:品质target_num3:0target_num4:0target_num5:0
	%% 2034完成神谕 target_num:数量；target_num1:角色顺序；target_num2:预言之书ID；target_num3:0；target_num4:0；target_num5:0
	%% 2035守护激活 target_num:数量；target_num1:守护阶数；target_num2:角色顺序；target_num3:0；target_num4:0；target_num5:0
	%% 2038公会高级捐献次数 target_num:次数target_num1:0target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2039公会晚宴龙火辣酒喝酒次数 target_num:次数target_num1:0target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2040完成商船任务次数（派遣即完成） target_num:次数target_num1:商船品质（0白1蓝2紫3橙4红）target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2041竞技场次数（战斗秒杀扫荡） target_num:次数target_num1:0target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2042激活圣物 target_num:数量target_num1:道具ID target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2043领取指定日常任务奖励 target_num:数量target_num1:DailyActivityNew表IDtarget_num2:0target_num3:0target_num4:0target_num5:0
	%% 2044领取指定明日领取奖励 target_num:数量；target_num1:LoginRewardNew表ID；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2045装备指定装备 target_num:数量 target_num1:装备部位；target_num2:装备品质；target_num3:装备星级；target_num4:角色序号；target_num5:0
	%% 2046激活指定神馈 target_num:数量target_num1:神馈idtarget_num2:0target_num3:0target_num4:0target_num5:0
	%% 2047参加精英副本 target_num:数量target_num1:精英副本id（进入即完成任务）target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2048强化对应装备（成功强化就完成） target_num:数量 target_num1:0target_num2:角色顺序（仅前端使用）target_num3:0target_num4:0target_num5:0
	%% 2049天神升级 target_num:数量target_num1:天神等级target_num2:0target_num3:0target_num4:0target_num5:0
	%% 2050参加法老宝库（进入即完成） target_num:数量target_num1:副本idtarget_num2:0target_num3:0target_num4:0target_num5:0
	%% 2051升级技能（2014是激活技能） target_num:数量target_num1:技能位target_num2:角色顺序target_num3:目标等级target_num4:0target_num5:0
	%% 2053领取等级礼包中对应奖励  target_num:数量 target_num1:ID target_num2:1=免费奖励，2=额外奖励 target_num3:0 target_num4:0 target_num5:0
	%% 2055击杀世界BOSS  target_num:数量 target_num1:BOSS ID(0表示任意BOSS)；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2056领取月卡每日赠礼  target_num:数量 target_num1:0；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2057完成寻宝 target_num:数量 target_num1:寻宝ID；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2058坐骑突破 target_num:数量 target_num1:突破数；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2059坐骑升星 target_num:数量 target_num1:星级数；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2060坐骑觉醒 target_num:数量 target_num1:觉醒数；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2061任一血脉升级激活 target_num:数量 target_num1:等级数；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2062商店购买 target_num:数量 target_num1:商店ID；target_num2:序列Snum；target_num3:位置序列Seat；target_num4:0；target_num5:0
	%% 2063镶嵌卡片 target_num:数量 target_num1:星级；target_num2:品质；target_num3:部位(装备基础表part)；target_num4:0；target_num5:0
	%% 2064任一角色完成转职 target_num:数量 target_num1:转职数；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2065坐骑触发技能装配 target_num:数量 target_num1:技能格子ID；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2066任一角色接受转职试炼 target_num:数量 target_num1:转职任务ID；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2067任一角色镶嵌宝石 target_num:数量 target_num1:副本ID；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2068通关XX副本(taskflash生效)  target_num:数量 target_num1:副本ID；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2069 购买圣物
	%% 2070 七日盛典领取奖励
	%% ﻿target_type=2071：主塔层数到达XXX；target_num=层数        
	%% target_type=2072：XX副塔层数到达XXX；target_num=层数，target_num1=副塔编号（1战士塔，2法师塔，3弓手塔，4新职业塔）        
	%% target_type=2073：符文寻宝次数到达XXX；target_num=寻宝次数        
	%% target_type=2074：镶嵌XX品质以上符文XX个；target_num=数量，target_num1=品质（1蓝、2紫、3橙色、4红色、5粉）
	%% 2075运行小助手 target_num:运行数量 target_num1:0；target_num2:0；target_num3:0；target_num4:0；target_num5:0
	%% 2125未知召唤次数，target_num为具体次数
	%% 2126上阵英雄数量，target_num为英雄上阵的数量；target_num1为对应的品质需求（0 N白  1 R蓝  2 SR紫  3 SSR橙  4 SP 红  5 UR 粉，品质条件都是及以上就满足）
	%% target_type 2127，target_num为英雄接取任务后需要提升的等级；其余参数为0
	%% 如果判断玩家身上没有经验书道具或者已解锁出战位的英雄都无法突破的情况就直接完成
	target_type,
	%% 任务打开功能界面和寻找NPC对话对应的trigerid，
	trigerid,
	%% 触发剧情对话id
	%% 没有填0
	task_cutsenceid,
	%% 怪物id+W:WO:XN93O:UO:YN93OO:AO
	monsterid,
	%% 副本id，没有填0
	mapid,
	%% 地图ID。杀怪任务通过这个字段限制地图。填0无限制
	scenes,
	%% 目标数量
	target_num,
	%% （封印副本开启后的天数，目标数量，下限值）
	%% 转生点任务的目标参数统一读这里，开服天数向下取
	sealOpenNum,
	%% 目标参数1
	target_num1,
	%% 目标参数2
	target_num2,
	%% 目标参数3
	target_num3,
	%% 目标参数4
	target_num4,
	%% 完成任务是否弹出奖励，1为弹出，0为不弹
	isreward,
	%% 任务x坐标
	%% 探索任务和杀怪任务寻路坐标
	pos_x,
	%% 任务z坐标探索任务和杀怪任务寻路坐标
	pos_z,
	%% h
	rot_y,
	%% kefu-1:
	%% 探索任务播放的动作
	act1,
	%% kefu-1:
	%% 探索任务播放的动作
	act2,
	%% kefu-1:
	%% 探索任务播放的动作
	act3,
	%% 肖岚:
	%% 读条开始后延迟播放探索动作的延迟时间（毫秒）
	act_delay,
	%% admin:
	%% 探索任务触发的特效
	showvfx,
	%% 肖岚:
	%% 特效播放的x坐标|y坐标|z坐标
	vfx_pos,
	%% kefu-1:
	%% 探索任务读条时间
	time,
	%% kefu-1:
	%% 剧情动画
	animation,
	%% 任务名字
	task_nameid,
	%% admin:
	%% 任务名
	task_namestring,
	%% 面板上的任务说明
	task_desid,
	%% kefu-1:
	%% 快捷任务说明
	task_desstring,
	%% 接取任务触发guide表id
	guide_gettask,
	%% 完成任务触发guide表id
	guide_finishtask,
	%% {1，50，2}第几章、总共多少个任务、第几个
	%% 填0为不计入章节
	%% 章节对应到TaskChapter查看
	reward_chapter,
	%% 任务标题格式，填写textID 填0为不使用
	task_typenameid,
	%% 是否自动进行任务
	%% 剧情副本自动进行，其余类型程序判断是否可以自动完成
	%% 0为关闭 1为开启 
	battleauto,
	%% 控制完成任务后是否自动进入领奖流程
	%% 0为关闭 1为开启
	rewardauto,
	%% 指定领奖triger 没有填0
	rewardtrigerid,
	%% 指定领奖对话 没有填写0
	reward_cutsenceid,
	%% 控制领奖对话最后一段是否显示本任务奖励
	%% 0为关闭 1为显示
	reward_cutsenceshow,
	%% 任务完成奖励自动领取开关
	%% 0为关闭 1为开启
	award_auto,
	%% {10000，2，2，10}第1位表示增加的倍数万分比，第2位表示消耗类型（1道具、2货币），第3位表示道具ID或者货币类型，第4位为数量
	%% 填0为不使用
	reward_buy,
	%% 采集任务需要显示的采集图标（后缀加_Hand为手动），没有填0
	collectionImage,
	%% （参数1，参数2）任务经验
	%% 填“0”表示：该任务没有任务经验
	%%  参数1=1时，固定经验，获得经验=参数2
	%%  参数1=2时，动态经验，获得经验=参数2*玩家等级对应获得经验标准值
	%% 玩家等级对应获得经验标准值：配置在ExpDistribution表中StandardEXP字段中
	exp,
	%% （参数1，参数2）任务金币
	%% 填“0”表示：该任务没有任务奖励金币
	%%  参数1=1时，固定金币，获得金币=参数2
	%%  参数1=2时，动态金币，获得金币=参数2*玩家等级对应获得金币标准值。
	%% 玩家等级对应获得金币标准值：配置在ExpDistribution表中StandardMoney字段中
	coinNew,
	%% 装备Item中没有品质和星级，走单独的掉落包，其他走直接配置
	%% （角色顺序，职业，掉落ID，掉落是否绑定,掉落数量，掉落概率）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 掉落是否绑定：0为非绑 1为绑定
	%% 掉落数量为掉落包的个数，开启时每个包独立开启
	%% 掉落概率值为万分比，上限为10000，下限为0
	%% 只在后端奖励装备等需要使用
	equipAward,
	%% 作者:
	%% 其他产出，用掉落包太费
	%% (角色顺序，职业,类型，物品ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手(0,如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	%% 掉落是否绑定：0为非绑 1为绑定，货币不使用此参数
	%% 这里前端显示和掉落非装备类型的道具都用这字段
	itemAward,
	%% 做任务时跳转的界面
	jumpId,
	%% 分组
	%% ·分组，值越低显示在前面
	%% 同组内的任务接取后只会显示1个
	seat1,
	%% 同组内优先级
	%% ·值越小优先级越高
	%% ·当前优先级最高的任务显示在最前面
	%% ·已完成了的支线任务都显示出来，领取奖励后消失.
	%% ·已完成了的任务显示在最前面，当有多个已完成就根据优先级判断
	dragonNewId,
	%% 接受任务时是否需要根据玩家目前状态刷新任务进度
	taskFlash,
	%% 战盟资金奖励
	guildExp,
	%% 成员战盟贡献贡献值
	contribute,
	%% 每日刷新任务
	%% 仅用于type=2 的支线任务
	%% 0：普通任务
	%% 1：每日刷新支线任务
	dailyRefreshTask,
	%% 任务完成最低等级
	%% 配置不等于0则在该任务完成后判断若玩家低于该等级则补齐经验
	%% 配置=0则不判断等级
	expOffset
}).

-endif.
