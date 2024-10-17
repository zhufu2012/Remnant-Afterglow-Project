-ifndef(seven_gift_define_hrl).
-define(seven_gift_define_hrl, true).

%%---------- 枚举 ----------						%% 功能编号		模块		调用					参数1		参数2		参数3		参数4		参数5
-define(Seven_Type_Level, 1).                       %% 1			等级		升级					人物等级
-define(Seven_Type_BattleValue, 2).                 %% 2			战力		战力改变					战力值
-define(Seven_Type_CareerLv, 3).                    %% 3			转职		转职					转职次数		角色数
-define(Seven_Type_Reincarnate, 4).                 %% 4			转生		转生					转生等级
-define(Seven_Type_SkillLv, 5).                     %% 5			技能		技能升级					技能数量		技能等级		角色数
-define(Seven_Type_EqEquip, 6).                     %% 6			装备		装备穿戴					件数		品质		星数		装备阶数		角色数
-define(Seven_Type_EqIntensify, 7).                 %% 7			装备		装备强化					数量		强化等级		角色数
-define(Seven_Type_EqAdd, 8).                       %% 8			装备		装备追加					数量		追加等级		角色数
-define(Seven_Type_EqGem, 9).                       %% 9			装备		装备宝石					宝石总等级	角色数
-define(Seven_Type_EqSuit, 10).                     %% 10			装备		装备打造	套装			套装件数		装备阶数		套装级别		角色数
-define(Seven_Type_Honor, 11).                      %% 11			头衔		头衔升级					等级		角色数
-define(Seven_Type_GDMainLv, 12).                   %% 12			龙神		主战龙神	升阶			数量		主战龙神阶数
-define(Seven_Type_MountLv, 13).                    %% 13			坐骑		坐骑升级					数量		坐骑等级
-define(Seven_Type_WingLv, 14).                     %% 14			翅膀 		翅膀升级					数量		翅膀等级
-define(Seven_Type_PetLv, 15).                      %% 15			宠物		宠物升级					数量		宠物等级
-define(Seven_Type_DemonSquare, 16).                %% 16	恶魔广场(勇者试炼）	恶魔广场完成				完成次数
-define(Seven_Type_BountyTask, 17).                 %% 17			赏金任务		赏金任务					完成次数		品质
-define(Seven_Type_ArenaCount, 18).                 %% 18			竞技场		开始竞技场				完成次数
-define(Seven_Type_DungeonMountCount, 19).          %% 19			副本		坐骑副本					通关次数
-define(Seven_Type_DungeonWingCount, 20).           %% 20			副本		翅膀副本					通关次数
-define(Seven_Type_DungeonGDCount, 21).             %% 21			副本		天神（龙神）副本			通关次数
-define(Seven_Type_DungeonPetCount, 22).            %% 22			副本		英雄（宠物）副本			扫荡次数
-define(Seven_Type_DungeonEquipMaterial, 23).       %% 23			副本		法老宝库					通关次数
-define(Seven_Type_PersonalBoss, 24).               %% 24			个人Boss	击杀					击杀数
-define(Seven_Type_WorldBossJoin, 25).              %% 25			世界BOSS	处理奖励					参与数
-define(Seven_Type_CursePlace, 26).                 %% 26			诅咒禁地		击杀Boss				击杀Boss数
-define(Seven_Type_DemonsInvasionBoss, 27).         %% 27			打宝	击杀恶魔入侵（死亡地狱）Boss	击杀boss数
-define(Seven_Type_DemonsLairBoss, 28).             %% 28			打宝	击杀恶魔巢穴（死亡森林）Boss	击杀boss数
-define(Seven_Type_AshuraJoin, 29).                 %% 29	血色广场（血色争霸）	完成血色广场				完成次数
-define(Seven_Type_DungeonYanmoCount, 30).          %% 30 		世界树（炎魔）	完成炎魔试炼				完成次数
-define(Seven_Type_GuildFire, 31).                  %% 31 			公会篝火		完成公会篝火				完成次数
-define(Seven_Type_GuildBoss, 32).                  %% 32 	公会Boss（篝火Boss）	完成公会Boss				完成次数
-define(Seven_Type_GuildShip, 33).                  %% 33 			公会商船		完成公会商船				运输次数		商船品质
-define(Seven_Type_GuildDonation, 34).              %% 34 			公会捐赠		完成公会捐赠				次数		捐赠品质
-define(Seven_Type_DailyTaskActivity, 35).          %% 35  			日常		更新日常任务进度			天数（可以不连续）	活跃度
-define(Seven_Type_QuickHang, 36).                	%% 36  			快速讨伐		获取快速讨伐奖励			完成次数
-define(Seven_Type_MainTask, 37).                   %% 37  			主线任务		主线任务通关				副本ID
-define(Seven_Type_Excellence, 38).                	%% 38 			精英副本		精英副本通关				副本ID
-define(Seven_Type_RechargeFirst, 39).            	%% 39			首充		完成首充
-define(Seven_Type_Card, 40).                       %% 40			装备		镶嵌卡片					数量		品质		星级			角色数
-define(Seven_Type_TotalDailyActivity, 41).         %% 41			日常		更新日常任务进度			累计活跃度
-define(Seven_Type_CareerTowerLayer, 42).			%% 42			副本		职业塔					主塔通关层数
-define(Seven_Type_CareerTowerAllLayer, 43).		%% 43			副本		职业塔					已解锁职业塔通关总进度
-define(Seven_Type_RuneQuality, 44).				%% 44			装备		符文法阵					数量		品质（1蓝，2.紫 3.橙 4.红，5粉）
-define(Seven_Type_PetAtlas, 45).					%% 45			英雄		图鉴激活					数量		品质（0、N；1、R；2、SR；3、SSR；4、SP；5、UR）
-define(Seven_Type_PetNewLv, 46).					%% 46			英雄		升级					数量		等级
-define(Seven_Type_PetStar, 47).					%% 47			英雄		星级					数量		星级
-define(Seven_Type_ShouLingLv, 48).					%% 48			坐骑		兽灵升级					等级
-define(Seven_Type_YiLingLv, 49).					%% 49			翅膀		翼灵升级					等级
-define(Seven_Type_AstrolabeNum, 50).				%% 50			黄金契约		助战数量					数量
-define(Seven_Type_Melee, 51).						%% 51			牛怪迷宫		参与次数					参与次数
-define(Seven_Type_DomainFight, 52).				%% 52			公会争霸		次数					次数
-define(Seven_Type_ShenMo, 53).						%% 53			黄金秘境		击杀boss				击杀boss数
-define(Seven_Type_XunBao13, 54).					%% 54			宝石寻宝		次数					次数
-define(Seven_Type_XunBao14, 55).					%% 55			卡片寻宝		次数					次数
-define(Seven_Type_PetNormalDraw, 56).				%% 56			英雄召唤		次数					次数
-define(Seven_Type_PetSeniorDraw, 57).				%% 57			命运召唤		次数					次数
-define(Seven_Type_RingLv, 58).						%% 信物升级	信物系统	信物-升级	数量	信物的等级
-define(Seven_Type_Buy, 99).                        %% 99			七日礼		购买物品					货币类型	原价	现价
%% ---------- end ----------

%% 七天奖任务进度
-record(seven_gift_task_progress, {
	key = {0, 0, 0, 0},    %% {group, day, page, id}
	group = 0,            %% 活动组
	day = 0,            %% 天数
	page = 0,            %% 分页
	id = 0,                %% 任务id
	progress = [],        %% 进度 若多角色 则按照创建顺序传对应进度
	today_progress = 0    %% 当天完成进度
}).

%% 七天奖任务完成
-record(seven_gift_task_complete, {
	key = {0, 0, 0, 0},    %% {group, day, page, id}
	group = 0,        %% 活动组
	day = 0,        %% 天数
	page = 0,        %% 分页
	id = 0,            %% 任务id
	is_get = 0        %% 是否领取
}).

%% 七天奖奖励
-record(seven_gift_award, {
	key = {0, 0},    %% {group, id}
	group = 0,        %% 活动组
	id = 0            %% 奖励id
}).

%% 每日奖励
-record(seven_gift_daily, {
	key = {0, 0},
	group = 0,      %% 活动组
	day = 0,        %% 天数
	score = 0,      %% 积分
	get_list = []   %% 领取列表
}).


-endif.