-ifndef(cfg_bossAi_hrl).
-define(cfg_bossAi_hrl, true).

-record(bossAiCfg, {
	%% 怪物id
	iD,
	%% 策划用来备注的字段
	name,
	%% 策划用来备注的字段
	dis,
	%% 怪物是否有激活小怪的Ai
	%% 0否
	%% 1是
	callAI,
	%% 首次执行Ai的血量万分比
	call_hp,
	%% 再次触发的时间（毫秒）
	call_cd,
	%% 进入阶段后，给boss加的虚化buffid
	call_buff,
	%% 执行召唤Ai和陷阱AI时boss移动的坐标
	pos_xz,
	%% 激活的怪物在地图配置文件中的id（不是dataid，是地图文件中的怪物点的id）
	call_monster,
	%% boss是否具有加buff的AI
	buffAI,
	%% 首次执行Ai的血量万分比
	buff_hp,
	%% 再次触发的时间（毫秒）
	buff_cd,
	%% boss加buff的buffid
	buffID,
	%% 怪物是否有陷阱的AI
	%% 0否
	%% 1是
	xJAI,
	%% 首次执行Ai的血量万分比
	xJ_hp,
	%% 再次触发的时间（毫秒）
	xJ_cd,
	%% 进入阶段后，给boss加的虚化buffid
	xJ_buff,
	%% 陷阱trigger组1
	xJ_trigger1,
	%% 陷阱trigger组2
	xJ_trigger2,
	%% 陷阱trigger组3
	xJ_trigger3,
	%% 陷阱的技能id
	xJ_skill,
	%% 陷阱波数冷却时间（毫秒）
	xJ_skillcd,
	%% 每次执行AI时需要使用技能波数
	xJ_skillnum,
	%% 怪物是否有狂暴的AI
	%% 0否
	%% 1是
	kB_AI,
	%% 狂暴时间（毫秒）出生后进行倒数
	kB_time,
	%% 再次进入狂暴的间隔时间（毫秒）
	kB_cd,
	%% 开始狂暴时给boss加的buffid
	kB_buff,
	%% 每次狂暴的持续时间（毫秒）
	kB_last,
	%% 该数组中为BOSS血量万分比，当BOSS血量每次到达数组中某一个血量万分比时触发技能
	%% 填0代表无此AI
	useSkill_Hp,
	%% 触发时使用技能ID
	useSkill_SkillID,
	%% 达到条件触发刷buff球，只触发1次（可以和其他Ai一起触发）
	%% {波数,触发类型,触发参数,MapObjectID}
	%% 触发类型：
	%% 1boss血量
	%% 2上波触发后时间
	%% 触发参数：
	%% 类型1参数：血量万分比
	%% 类型2参数：毫秒
	%% 注意：第一波只能填血量触发
	mapObject
}).

-endif.
