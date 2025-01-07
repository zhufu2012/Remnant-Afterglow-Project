%%%-------------------------------------------------------------------
%%% @author xiexiaobo
%%% @copyright (C) 2018, Double Game
%%% @doc 数据表定义
%%% @end
%%% Created : 2018-05-12 15:50
%%%-------------------------------------------------------------------
-ifndef(db_table_hrl).
-define(db_table_hrl, true).

%% 第一个字段为唯一Id，组合唯一Id不存库

%% 数据表缓存配置
-record(table_config, {table_ref, load_field_pos, free_pos, worker_module, worker_args}).

%% Id生成
-record(db_id_generator, {
	type, %% 唯一Id
	integer = 0
}).

%% 世界变量
-record(db_variable_world, {
	key, %% 唯一Id
	value = 0
}).

%% 玩家变量
-record(db_variable_player, {
	player_id,
	role_id,
	key,
	value = 0
}).

%% 玩家简要数据
-record(db_player_summary, {
	player_id = 0, %% 玩家Id（唯一Id）
	account, %% 帐号
	name, %% 名字
	language, %% 语言
	sex,
	level,
	offlinetime,
	battleValue
}).

%% 玩家货币
-record(db_currency, {
	player_id,
	key,
	value = 0
}).

%% 玩家副本次数
-record(db_dungeons_times, {
	player_id, %% 玩家Id
	group_id, %% 次数组Id
	recover_times = 0, %% 恢复的次数
	buy_times = 0, %% 购买的次数
	daily_refresh_times = 0, %% 每日刷新次数
	daily_buy_times = 0 %% 每日购买次数
}).

%% 王者1V1玩法数据
-record(db_fight_data, {
	id = 0, %% 数据Id（唯一Id）
	season = 0, %% 赛季
	season_open_time = 0, %% 赛季开始时间
	season_close_time = 0, %% 赛季结束时间
	activity_state = 0, %% 活动状态
	activity_open_time = 0, %% 活动开始时间
	activity_close_time = 0, %% 活动结束时间
	cluster_time = 0, %% 联服时间
	rank_list = [] %% 排行榜数据
}).
%% 王者1V1玩家数据
-record(db_fight_player, {
	player_id = 0, %% 玩家Id（唯一Id）
	server_id = 0, %% 服务器Id
	player_name = "", %% 玩家名字
	player_career = 0, %% 玩家职业
	grade = 0, %% 段位
	score = 0, %% 积分
	victory_times = 0, %% 连续胜利次数
	daily_fight_times = 0, %% 每日战斗次数
	recover_times = 0, %% 恢复的次数
	buy_times = 0, %% 购买的次数
	daily_buy_times = 0, %% 每日购买次数
	finish_grade_award = 0, %% 完成每日段位奖励
	fight_list = [], %% 最近对战数据
	task_list = [] %% 任务数据
}).

%% 风暴龙城服务器数据
-record(db_dragon_city_server, {
	server_id = 0,                   %% 服务器Id（唯一Id）
	group_id = 0,                    %% 服务器分组Id
	players = 0
}).
%% 风暴龙城雕像数据
-record(db_dragon_city_statue, {
	manor_id = 0,                   %% 领地Id（唯一Id）
	manor_level = 0,                %% 领地等级
	manor_time = 0,                 %% 领地时间
	server_id = 0,                  %% 服务器Id
	guild_id = 0,                   %% 战盟Id
	guild_name = [],
	chairman_id = 0,                %% 盟主Id
	chairman_ui = {},
	up_num = 0,
	down_num = 0
}).
%% 虚空龙域雕像历史
-record(db_dragon_city_statue_history, {
	manor_time = 0,                 %% 领地时间
	server_id = 0,                  %% 服务器Id
	guild_id = 0,                   %% 战盟Id
	guild_name = [],
	chairman_id = 0,                %% 盟主Id
	chairman_ui = {}
}).

%% 寻宝周期数据
-record(db_xun_bao_period, {
	id = 0,                             %% 唯一Id：DataId * 10000 + Level
	data_id = 0,                        %% 寻宝Id
	level = 0,                          %% 寻宝等级
	hot_id = 0,                            %% 热点ID
	turn_id = 0,                        %% 轮换ID
	period_time = 0                     %% 周期结束时间
}).
%% 寻宝记录数据
-record(db_xun_bao_record, {
	data_id = 0,                %% 寻宝Id
	record_list = []            %% 记录列表
}).
%% 寻宝玩家数据
-record(db_xun_bao_player, {
	player_id = 0,              %% 玩家Id
	data_id = 0,                %% 寻宝Id
	level = 0,                  %% 寻宝等级
	hot_id = 0,                    %% 热点ID
	turn_id = 0,                %% 轮换大奖ID
	free_time = 0,              %% 免费开始时间
	draw_num = 0,               %% 单抽次数
	draw_ten_num = 0,           %% 非单抽次数
	score = 0,                  %% 积分
	period_time = 0,            %% 周期结束时间
	period_level = 0,           %% 周期等级
	period_num = 0,             %% 周期次数
	period_finish_list = [],    %% 周期领奖列表 [{Index, Choice}]
	record_list = [],           %% 记录列表
	person_lucky = 0,           %% 个人幸运值
	time_draw_award_time = 0,   %% 多次寻宝累计次数
	first_tens = 0,              %% 首次连抽
	drop_num_list = [],          %% 掉落次数列表 [{DropId, Num}]
	today_draw_times = 0        %% 今日抽奖次数
}).

%% 世界服阶段全局数据
-record(db_cluster_stage, {
	id = 0,                       %% 数据Id（唯一Id）
	stage = 0,                    %% 当前阶段
	finish_time = 0,              %% 结束时间
	progress = 0,                 %% 进度
	progress_last_time = 0,       %% 进度上次自增时间
	rank_list = [],               %% 排行榜数据(深渊屏障)
	rank_list1 = [],              %% 排行榜数据(黑暗深渊屏障)
	rank_list2 = []               %% 排行榜数据(黑暗森林屏障)
}).
%% 世界服阶段玩家数据
-record(db_cluster_stage_player, {
	player_id,                    %% 玩家Id（唯一Id）
	kill_num = 0,                 %% 击杀数 +12C 修改为 积分
	award_index = 1,              %% 奖励序号
	kill_num1 = 0,                %% 击杀数 +12C 修改为 积分
	award_index1 = 1,             %% 奖励序号
	kill_num2 = 0,                %% 击杀数 +12C 修改为 积分
	award_index2 = 1              %% 奖励序号
}).

%% 累计充值
-record(db_recharge_total, {
	player_id = 0,                %% 玩家Id（唯一Id）
	daily_recharge = 0,           %% 每日累充
	daily_recharge_finish = 0,    %% 每日累充达标标记
	daily_finish1 = 0,            %% 每日累充第一档领取标记
	daily_finish2 = 0,            %% 每日累充第二档领取标记
	daily_finish3 = 0,            %% 每日累充第三档领取标记
	daily_finish4 = 0,            %% 每日累充免费档领取标记
	period_time = 0,              %% 周期累充结束时间，0表示未开启
	period_level = 0,             %% 周期累充世界等级
	period_days = 0,              %% 周期累充达标天数
	period_finish1 = 0,           %% 周期累充第一档领取标记
	period_finish2 = 0,           %% 周期累充第二档领取标记
	period_finish3 = 0            %% 周期累充第三档领取标记
}).

%% 一元秒杀
-record(db_recharge_buy, {
	player_id = 0,                %% 玩家Id（唯一Id）
	daily_finish1 = 0,            %% 一元秒杀第一档领取标记
	daily_finish2 = 0,            %% 一元秒杀第二档领取标记
	daily_finish3 = 0,            %% 一元秒杀第三档领取标记
	daily_finish4 = 0             %% 一元秒杀免费档领取标记
}).

%% 玩家物品
-record(db_item_player, {
	player_id,
	id, %% 唯一Id
	bag_id,
	cfg_id,
	bind = 1,
	expire_time = 0,
	amount = 1
}).
%% 玩家物品
-record(db_bag_player, {
	player_id,
	bag_id,
	capacity,
	extend
}).

%% 头顶表情
-record(db_emoji, {
	playerID, %% 唯一Id
	emojiList
}).

%% 邮件
-record(db_mail, {
	player_id = 0,           %% 接收者ID
	mailID = 0,               %% 邮件ID
	senderID = 0,           %% 发送者ID
	senderName = "",       %% 发送者Name
	title = "",               %% 标题
	describe = "",           %% 描述
	state = 0,               %% 0-未读、1-已读 2-已经领取附件 3-已删除 4- 已经删除的世界邮件(需要暂时放在ets中)
	sendTime = 0,           %% 发送时间
	opTime = 0,               %% 操作时间
	multiple = 1,           %% 奖励倍数
	coinList = [],           %% 货币奖励列表
	itemList = [],           %% 奖励的道具
	exp = 0,
	attachmentReason = 0,  %% 奖励的原因
	isDirect = 1,          %% 是否是直接添加  0 -直接 1- 不直接  (继承领奖中心功能)  不支持世界邮件处理
	itemInstance = [],
	one_key_op = 0      % 一键操作标志 0不可 1可以
}).

%% 聚魂
-record(db_soul, {
	player_id,  %%拥有者ID',
	soul_uid,  %%灵魂实例ID',
	item_data_id, %%cfgid',
	star,  %%星级
	stage, %% 阶级
	level, %%等级',
	position %%位置',
}).

%% 符文
-record(db_rune, {
	player_id,    %% 拥有者ID
	rune_uid,        %% 符文实例ID
	item_data_id,    %% cfgid
	star,            %% 星级
	stage = 0,        %% 阶级
	level,            %% 等级
	role_id,        %% 装备的角色ID
	position        %% 位置
}).

-record(db_hang, {
	player_id = 0,      %% 玩家ID
	type = 0,           %% 类型(1:在线挂机 2:离线挂机)
	dungeon_id = 0,     %% 副本ID
	start_time = 0,     %% 开始时间
	award_time = 0,     %% 上一次结算时间
	stop_time = 0,      %% 结束离线挂机时间
	hang_sec = 0,       %% 累计挂机时长(秒）
	exp = 0,            %% 获得的经验
	coin = 0,           %% 获得的经验
	fade_num = 0,       %% 炼金装备数量
	fade_exp = 0,       %% 炼金经验
	item_list = {[], []},%% 获得的物品奖励 {ItemList, EquipList}
	item_output = [],
	curr_list = []
}).

-record(db_hang_buff, {
	player_id = 0,      %% 玩家ID
	buff_id = 0,        %% buff ID
	start_time = 0,     %% 开始时间
	end_time = 0        %% buff结束时间
}).

-record(db_arena_award, {
	player_id = 0,
	rank = 0,
	coin_list = [],
	item_list = []
}).
%% 万神殿
-record(db_astrolabe, {
	player_id,   %% 玩家ID
	astro_id,    %% 万神殿ID(配置表ID)
	assist_role, %% 助战玩家id
	pos_1,       %% 部位1的装备ID
	pos_2,       %% 部位2的装备ID
	pos_3,       %% 部位3的装备ID
	pos_4,       %% 部位4的装备ID
	pos_5,       %% 部位5的装备ID
	pos_6        %% 部位6的装备ID
}).

%% 万神殿装备
-record(db_aequip, {
	player_id,        %% 拥有者ID
	uid,            %% 装备实例ID
	item_data_id,   %% cfgid
	intensity_lv,   %% 强化等级
	intensity_exp,  %% 强化经验
	prop        %% 随机属性
}).

%% 战神殿
-record(db_pantheon, {
	mapDataID,          %% 地图ID
	bossID,             %% 怪物ID
	type,               %% 类型
	deadNum,            %% 死亡次数
	deadTime,           %% 死亡时间
	drop_list,          %% 高阶物品掉落记录
	tombInfo            %% 墓碑信息
}).

%% 玩家装备
-record(db_eq, {
	player_id, %% 拥有者ID
	uid, %% 装备实例ID
	item_data_id, %% cfgid
	bind, %%
	character, %% 品质
	star, %% 星星
	gem_hole_num, %% 宝石可镶嵌的孔数量
	rand_prop, %% 随机属性
	beyond_prop, %% 卓越属性
	gd_prop, %% 龙饰属性(基础属性)
	polarity    %% 极性
}).

%% 玩家装备部位
-record(db_eq_pos, {
	player_id, %% 拥有者ID
	role_id = 0, %% 角色id
	pos, %% 装备位置
	uid, %% 装备实例ID
	intensity_lv, %% 强化等级
	intensity_lv_max, %% 当前部位达到过的最大强化等级
	add_lv, %% 追加等级
	add_lv_max, %% 当前部位达到过的最大追加等级
	ele_intensity_atk_lv = 0,   %% 元素强化攻击等级
	ele_intensity_def_lv = 0,   %% 元素强化防御等级
	ele_intensity_atk_break_lv = 0, %% 元素强化攻击突破等级
	ele_intensity_def_break_lv = 0, %% 元素强化防御突破等级
	ele_add_atk_lv = 0,         %% 元素追加攻击等级
	ele_add_def_lv = 0,         %% 元素追加防御等级
	gem_refine_lv, %% 宝石精炼等级 % todo 废弃
	gem_refine_exp, %% 宝石精炼当前经验
	gem_list, %% 宝石镶嵌信息
	cast_prop,%% 洗练属性
	gd_prop,    %% 龙饰属性(最终属性)
	suit_make_lv,                  %% 套装打造等级  1 普通  2 完美  3 传说
	suit_make_cost,     %% 套装打造的消耗
	card,            %% 卡片信息
	fazhen            %%符文法阵
}).

%% 玩家购买组ID次数
-record(db_group_count, {
	player_id = 0,      %% 玩家ID
	groupID = 0,        %% 副本组ID
	fight_count = 0,    %% 剩余购买次数
	day_buy_count = 0,  %% 今日购买次数
	total_fight_count = 0   %% 挑战次数
}).

%% 宠物 -- new
-record(db_pet_new, {
	player_id                    %% 拥有者ID
	, uid = 0                    %% 唯一ID
	, pet_cfg_id = 0             %% 宠物id (配置表Id)
	, pet_lv = 1                %% 等级
	, pet_exp = 0                %% 经验
	, break_lv = 0                %% 突破等级  和宠物等级相关
	, star = 0                    %% 星数
	, grade = 0                    %% 品质（稀有度）
	, fight_flag = 0            %% 0否 1出战中 2助战中
	, fight_pos = 0                %% 出战/助战位置
	, is_auto_skill = 0        %% 自动释放技能 0是/1否
	, wash = []                    %% 宠物洗髓[{type, value}]
	, is_lock = 0                %% 是否锁定 1是 0否
	, wash_material = []            %% 洗髓消耗道具记录
	, wash_preview = []            %% 洗髓未保存属性[{type, value}]
	, link_uid = 0               %% 幻兽主动链接的宠物uid
	, been_link_uid = 0          %% 宠物 被链接的幻兽uid
	, appendage_uid = 0          %% 幻兽主动附灵的宠物uid
	, been_appendage_uid = 0     %% 宠物被附灵 的幻兽uid
	, get_by_egg = 0             %% 是否通过孵化获得 1是 0否
	, hatch_id = 0               %% 照看孵化 0没有照看
	, shared_flag = 0            %% 是否入驻圣树 0 没有 1 入驻了
	, point = 0                  %% 入驻圣树前出战评分 0 未入驻圣树，前端显示需要...
	, star_pos = []              %% 星位
	, sp_lv = 0                  %% sp英雄战阶，普通则为0
}).

%% 宠物 圣树守卫
-record(db_pet_shared_guard, {
	player_id = 0, % 玩家id
	uid_list = [], % 担任圣树守卫宠物uid列表
	uid = 0, % 被共享属性的宠物uid
	state = 0 % 状态 0-一期 1-二期
}).

%% 宠物圣树栏位
-record(db_pet_shared_pos, {
	player_id = 0, % 玩家id
	pos = 0, % 入驻格子序号
	uid = 0, % 入驻宠物uid
	cd = 0, % 入驻冷却时间
	lv = 0, % 入住位等级
	unlock_time = 0 % 解锁时间
}).

%% 宠物 孵化
-record(db_pet_egg, {
	player_id = 0,                  %% 玩家id
	hatch_id = 0,               %% 孵化id
	hatch_time = 0,             %% 孵化的时间
	start_time = 0,             %% 开始计时时间
	end_time = 0,               %% 结束计时的时间
	look_pet = 0,               %% 照看宠物id
	is_finish = 0,              %% 是否完成孵化 1是 0否
	is_reward = 0,              %% 是否领取孵化奖励 1是 0否
	ac_list = [],                %% 二期龙晶激活列表
	ac_reward = []                %% 二期龙晶已领取奖励
}).

%% 宠物
-record(db_pet, {
	player_id,          %% 拥有者ID
	pet_id,            %% cfgid
	pet_lv,            %% 等级
	pet_exp,           %% 经验
	break_lv,          %% 突破等级
	star,              %% 星星
	grade,           %%品质（稀有度）
	awaken_lv,         %% 觉醒等级
	awaken_potential,  %% 炼魂等级
	is_rein,            %% 是否转生
	ultimate_skill_lv,    %% 必杀技等级
	fight_flag,            %% 0否 1出战中 2助战中
	fight_pos,            %% 出战/助战位置
	is_auto_skill         %% 自动释放技能 0是/1否
}).

%% 宠物装备
-record(db_pet_eq, {
	player_id,          %% 拥有者ID
	uid,                %% 宠物装备实例id
	cfg_id,             %% 配置id
	reset_time,         %% 已重置次数
	skill_list,         %% 装备的所有技能（为空表示没有技能）
	reset_skill_list    %% 待保存的重置技能（为空表示没有）
}).

%% 魔灵
-record(db_moling, {
	player_id,      %%  拥有者ID
	lv,                %%  等级
	exp,            %%  经验
	skills,            %%  装配的技能
	eqs,                %%  穿戴的装备
	pill1,
	pill2,
	pill3
}).
%% 宠物羁绊信息
-record(db_pet_fetter, {
	player_id,      %%  拥有者ID
	fetter_id,                %%  等级
	fetter_lv                %%  等级
}).

%% 玩家守护信息
-record(db_guard, {
	player_id = 0,      %% 拥有者ID
	role_id = 0,        %% 角色ID
	guard_id = 0,       %% 守护ID
	active_id = 0,      %% 激活的道具ID(升级、续期之后重置为0）
	time = 0,           %% 到期时间
	awaken = 0          %% 觉醒等级
}).


%% 翅膀
-record(db_wing, {
	player_id,          %% 拥有者ID
	wing_id,            %% cfgid
	wing_lv,            %% 等级
	wing_exp,           %% 经验
	break_lv,           %% 突破等级
	star,               %% 星星
	feather_lv,         %% 羽化等级
	sublimate_lv,       %% 炼魂等级
	is_rein,            %% 是否转生
	ele_awaken,         %% 元素觉醒
	is_fly,              %% 是否飞翼
	f_level                %%飞翼等级
}).

%% 翅膀羁绊信息
-record(db_wing_fetter, {
	player_id,      %%  拥有者ID
	fetter_id,                %%  等级
	fetter_lv                %%  等级
}).

%% 翼灵
-record(db_yiling, {
	player_id,      %%  拥有者ID
	role_id,        %%  角色ID
	lv,                %%  等级
	exp,            %%  经验
	break_lv,        %% 突破等级
	skill_p,        %%  装配的被动技能
	skill_t_mask,    %%  触发技能格子开启信息
	skill_t,        %%  打造的触发技能
	eqs,            %%  穿戴的装备
	award_list      %% 已领取奖励
}).


%% 坐骑
-record(db_mount, {
	player_id,          %% 拥有者ID
	mount_id,            %% cfgid
	mount_lv,            %% 等级
	mount_exp,           %% 经验
	break_lv,          %% 突破等级
	star,              %% 星星
	awaken_lv,         %% 觉醒等级
	sublimate_lv,          %% 炼魂等级
	is_rein,           %% 是否转生
	ele_awaken,          %% 元素觉醒
	expire_time            %%过期时间 0 为永久  大于0的 表示限时 -1表示限时已过期
}).

%% 坐骑羁绊信息
-record(db_mount_fetter, {
	player_id,      %%  拥有者ID
	fetter_id,                %%  等级
	fetter_lv                %%  等级
}).

%% 兽灵
-record(db_shouling, {
	player_id,      %% 	玩家ID
	role_id,        %% 	角色ID
	lv,             %%  等级
	exp,            %%  经验
	break_lv = 0,    %% 突破等级
	skill_p,        %%  装配的被动技能
	skill_t_mask,   %%  触发技能格子开启信息
	skill_t,        %%  打造的触发技能
	eqs,            %%  穿戴的装备
	unlock_suit_pos,%%  解锁的装备位
	pill1,            %%  磕丹1
	pill2,            %%  磕丹2
	pill3,            %%  磕丹3
	award_list       %% 已领取奖励
}).

%% 龙神
-record(db_gd, {
	player_id = 0,
	id = 0,    %% 配置表Id
	lv = 0,    %% 阶
	exp = 0,   %% 经验
	star = 0,   %% 星
	step = 0,  %% 激活进度
	relate_gd_id = 0,  %% 关联龙神ID 主战<>掠阵
	addition_attr = [],  %% 附加属性
	is_rein = 0,      %% 是否转生
	break_lv = 0,    %% 突破等级
	wing_lv = 0,    %%翅膀等级
	wing_exp = 0        %%翅膀经验
}).

%% 龙神装备/秘典
-record(db_gd_eq, {
	player_id = 0,
	id = 0,    %% 配置表Id
	a_lv = 0    %% 觉醒等级
}).

-record(db_level_gift, {
	level = 0,          %% 等级
	award_count = 0     %% 领奖人数
}).

-record(db_signin, {
	player_id = 0,   %% 玩家ID
	level = 0,      %% 计算奖励的等级
	vip = 0,        %% 计算奖励的vip等级
	days = 0        %% 签到奖励领取的天数
}).

-record(db_signin_pro, {
	player_id = 0,   %% 玩家ID
	group = 0,      %% 奖励组别
	level = 0,      %% 计算奖励的等级
	days = 0,       %% 进度奖励领取的天数
	total_day = 0   %% 本轮累计签到天数
}).

-record(db_guild_building, {
	id = 0,                         %% 战盟ID
	build_id = 0,                   %% 建筑ID
	level = 1                       %% 等级
}).

-record(db_science, {
	player_id = 0,
	science_id = 0,
	level = 0
}).
%% 附加装备  魔/翼/兽灵装备
-record(db_eq_addition, {
	player_id,
	eq_uid,
	item_data_id,
	eq_type,  %% 1魔灵 2翼灵 3兽灵
	rand_prop
}).

%% 玩家vip信息
-record(db_player_vip, {
	player_id,         %% 玩家ID
	vip_lv,         %% vip等级
	vip_exp,         %% vip经验
	tmp_vip_lv,     %% 临时vip等级
	tmp_expire_time,  %% 临时vip到期时间
	dynamic_vip_lv = 0,  %% 动态vip等级
	recharge_list = []   %% 每日充值额度[前一天，前两天...]
}).

-record(db_guild_envelope, {
	en_id = 0,          %% 红包ID
	guild_id = 0,       %% 仙盟ID
	type = 0,           %% 红包类型(1每日首充红包 2每日累计充值红包 3玩家手动发红包 ...)
	money = 0,          %% 红包金额
	number = 0,         %% 红包个数
	cur_num = 0,        %% 已经领取的个数
	send_id = 0,        %% 发红包玩家ID
	msg = "",           %% 随便说两句
	time = 0,           %% 到期时间
	envelope_list = []  %% 红包列表{index, num}
}).

-record(db_player_envelope, {
	player_id = 0,      %% 玩家ID
	en_id = 0,          %% 红包ID
	index = 0,          %% 红包索引
	get_type = 0,       %% 领取的货币
	get_money = 0,      %% 领取金额
	time = 0            %% 时间
}).

-record(db_guild_event, {
	id = 0,         %% ID
	guild_id = 0,   %% 战盟ID
	module = 0,     %% 功能模块
	type = 0,       %% 记录类型
	player_id = 0,  %% 玩家ID
	rank = 0,       %% 玩家名
	time = 0,       %% 记录时间
	params = []     %% 参数列表
}).

%% 圣物
-record(db_holy, {
	player_id,          %% 拥有者ID
	holy_id,            %% 配置表ID
	holy_type,            %% 圣物类型
	holy_lv,            %% 等级
	holy_exp,           %% 经验
	break_lv,          %% 突破等级
	star,              %% 星星
	refine_lv,          %% 精炼等级
	is_rein            %% 是否转生
}).
%% 圣灵
-record(db_shengling, {
	player_id,      %%  拥有者ID
	type,            %%类型
	lv,                %%  等级
	exp,            %%  经验
	skills,            %%  装配的技能
	pill1,
	pill2,
	pill3,
	holy_id
}).

%% 图鉴
-record(db_card, {
	player_id,          %% 拥有者ID
	id,                    %% cfgid
	star,              %% 星星
	q_lv          %% 品质
}).

%% 图鉴羁绊信息
-record(db_card_fetter, {
	player_id,                         %% 拥有者ID
	fetter_id,                             %% 羁绊Id
	fetter_lv                             %% 等级
}).

-record(db_contact, {
	player_id = 0,  %% 玩家ID
	id = 0, %% 联系人ID
	time = 0    %% 最近联系时间
}).

-record(db_enemy, {
	player_id = 0,      %% 玩家ID
	killer_id = 0,      %% 击杀者ID
	server_id = 0,      %% 击杀者服务器ID
	name = "",          %% 击杀者名
	level = 0,          %% 击杀者等级
	headID = 0,         %% 击杀者头像
	vip = 0,            %% 击杀者vip
	killTimes = 0,      %% 击杀次数
	time = 0            %% 最后击杀时间
}).

%% 次日登录奖励信息
-record(db_nextday_award, {
	player_id = 0,        % 玩家id
	id = 0,                % 当前奖励ID
	award_time = 0,        % 领奖时间
	get_award = 0        % 是否领奖（0：未领奖 1：已领奖）
}).

%% 玩家称号
-record(db_player_title, {
	player_id = 0,        % 玩家id
	title_id = 0,        % 称号id
	type = 0,            % 类型
	group = 0,            % 组 todo 废弃
	expire_time = 0        % 过期时间
}).

%% shop
-record(db_shop_data, {
	player_id, %% 唯一Id
	dataList
}).

%% 头衔信息
-record(db_player_honor, {
	player_id,            %% 拥有者ID
	role_id,            %% 角色ID
	intensity_lv = 0,    %% 头衔强化等级
	honor_show = 0        %% 是否展示（0：不展示 1：展示）
}).

-record(db_worship, {
	id = 0, %% 玩家ID
	times = 0    %% 被赞美次数
}).

%% 玩家战斗属性信息
-record(db_battle_info, {
	player_id = 0,
	role_id = 0,
	attr = [],                %% 属性
	part_battle_value = [],     %% 分战力
	attr_detail = []
}).

-record(db_guild_task, {
	player_id = 0,            % 玩家id
	cur_rid = 0,            % 当前任务环序号
	cur_tid = 0,            % 当前任务id
	complete_tid_list,        % 完成任务列表(task_id)
	award_part_list,        % 领取段奖励列表(段)
	expire_time = 0            % 过期时间
}).

-record(db_flower, {
	player1ID = 0,      %% 玩家1ID
	player2ID = 0,      %% 玩家2ID
	value = 0,          %% 亲密度
	time = 0            %% 最后改变时间
}).

-record(db_playerflowerrecord, {
	playerID = 0,       %% 玩家ID
	charm = 0,          %% 魅力值  每周重置
	cherish = 0         %% 守护值  每周重置
}).

-record(db_intimacy, {
	player1ID = 0,      %% 玩家1ID
	player2ID = 0,      %% 玩家2ID
	level = 0,          %% 等级
	value = 0,          %% 亲密度
	time = 0            %% 最后改变时间
}).

%%%%%%%%%%%%%%%%%装扮
%%头像信息
-record(db_dress_up_head, {
	player_id,        %% 玩家ID
	head_id,    %% 头像ID
	head_star    %% 头像星星
}).

%%头像框信息
-record(db_dress_up_frame, {
	player_id,        %% 玩家ID
	frame_id,    %% 头像框ID
	frame_star    %% 头像框星星
}).

%% 装扮玩家表
-record(db_dress_player, {
	player_id = 0,        %% 玩家ID
	head_id = 0,        %% 佩戴的头像
	frame_id = 0,        %% 佩戴的头像框
	chat_bubble_id = 0,  %% 佩戴的聊天气泡
	photo_album_lv = 0,    %% 相册等级
	photo_album_exp = 0    %% 相册经验
}).

%% 聊天气泡
-record(db_bubble_chat, {
	player_id = 0,        % 玩家id
	bubble_id = 0,        % 气泡id
	bubble_star = 0        % 气泡星级
}).

%% 转职
-record(db_cr_task, {
	player_id = 0,          % 玩家ID
	role_id = 0,            % 角色ID
	type = 0,               % 类型:1-命星，2-龙魂，3-龙晶，4-元素，5-魔源，6-神火
	param1 = 0,             % 参数1：1-命星ID，2-龙魂阶段，3-龙晶阶段，4-元素ID，5-魔源ID，6-龙神ID
	param2 = 0              % 参数2：1-暂无，2-龙魂ID，3-龙晶ID，4-元素等级，5-源ID，6-神火ID
}).

%%预言之书
-record(db_prophecy, {
	player_id = 0,        %% 玩家ID
	role_id = 0,        %% 角色ID
	book_id = 0,                    %% 大类ID
	book_progress = 0,                    %%任务进度
	book_complete = 0,                %%是否完成
	task_list = []                    %%任务列表
}).

%%%%成就
%%-record(db_attainment, {
%%    player_id = 0,        %% 玩家ID
%%    att_overview_list = [],                    %% 成就总览
%%    att_reach_list = [],                    %%任务成就完成列表
%%    att_map_star_list = [],                %%任务成就副本星数列表
%%    att_map_times_list = [],                    %%任务成就副本完成次数列表
%%    att_equip_suit_list = [],                %%任务成就获得装备列表
%%    att_gem_stone_list = []                    %%任务成就获得宝石列表
%%}).
%%%%成就进度 TODO 配置表还在整理先用这个
%%-record(db_attain_cur, {
%%    player_id = 0,                     %% 玩家ID
%%    killed_times = 0,            %% 94 多人战场累计被玩家击败次数
%%    kill_times = 0,              %% 95 多人战场累计击败其他玩家次数
%%    battle_field_kill = 0,       %% 96 三界单场击败玩家次数
%%    battle_field_killed = 0,     %% 97 三界单场被玩家击败次数
%%    wildBoss_kill = 0,          %% 98 诛仙单场击败玩家次数
%%    wildBoss_killed = 0,        %% 99 诛仙单场被玩家击败次数
%%    use_blood_item = 0,           %% 100 多人战场累计使用血瓶个数
%%    killed_by_boss = 0,           %% 101 多人战场累计被BOSS杀死次数
%%    battle_box_total = 0,         %% 102 三界累计开箱子个数
%%    battle_box = 0,              %% 103 三界单场开箱子个数
%%    battle_box_extrTotal = 0,    %% 104 三界累计开至尊宝箱个数
%%    battle_box_extr = 0,         %% 105 三界单场开至尊宝箱个数
%%    battle_field_killBoss = 0,   %% 106 三界击杀boss累计个数
%%    wildBoss_killBoss = 0,      %% 107 诛仙累计击杀BOSS个数
%%    wildBoss_packetNum = 0,     %% 108 诛仙累计开最后的宝箱个数
%%    convene_times = 0            %% 109 多人战场召集/被召集次数
%%}).

%% 完成成就
-record(db_attain_complete, {
	player_id = 0,              % 玩家id
	id = 0,                     % 成就id
	is_get = 0                  % 是否已领奖
}).

%% 成就进度
-record(db_attain_progress, {
	player_id = 0,              % 玩家id
	id = 0,                     % 成就id
	progress = 0,               % 进度
	today_progress = 0          % 当天完成进度
}).

%% 天赋
-record(db_genius, {
	player_id = 0,    % 玩家ID
	type = 0,        % 天赋类型
	index = 0,        % 天赋序号
	level = 0,        % 天赋等级
	dot = 0            % 使用了的天赋点数
}).

%% 红名
-record(db_red_name, {
	player_id = 0, %% 玩家uid
	record_date = {}, %% 记录日期
	kill_list = [] %% 杀死的玩家uid列表
}).

%% 好友赠送体力时间
-record(db_friend_give_energy_time, {
	player_id = 0, %% 玩家uid
	give_id = 0, %% 被赠送的玩家uid
	give_time = 0 %% 时间戳
}).

-record(db_open_func, {
	player_id = 0,  %% 玩家ID
	func_id = 0,    %% 功能ID
	time = 0,        %% 开放时间
	time2 = 0        %% 提示时间
}).

%% 玩家私有列表
-record(db_player_private_list, {
	player_id = 0,  %% 玩家ID
	index = 0,    %% 索引
	list = []        %% 记录数据
}).

%% 引导
-record(db_guide, {
	player_id = 0,  %% 玩家IDdb_cr_dragon_spirit
	guide_id = 0    %% 引导id
}).

%% BUFF
-record(db_buff, {
	player_id, %% 玩家uid
	role_id,
	buff_list %%
}).

%% 玩家参与玩法免费次数
-record(db_func_free, {
	player_id = 0,  %% 玩家id
	func_id = 0,    %% 功能id
	count = 0       %% 参与次数
}).

%% 离线事件
-record(db_offline_event, {
	player_id = 0,  % 玩家id
	id = 0,         % 事件id
	type = 0,       % 事件类型
	time = 0,       % 记录时间
	msg = {}        % 消息内容
}).

%% 任务
-record(db_task_progress, {
	player_id = 0,        % 玩家id
	task_id = 0,        % 任务id
	update_flag = 0,    % 是否更新进度
	next_flag = 0,        % 是否在任务线内
	pre_flag = 0,        % 是否完成前置任务
	progress = 0        % 进度
}).

-record(db_task_complete, {
	player_id = 0,        % 玩家id
	task_id = 0            % 任务id
}).

%% 角色任务
-record(db_role_task_progress, {
	player_id = 0,        % 玩家id
	role_id = 0,        % 角色id
	task_id = 0,        % 任务id
	update_flag = 0,    % 是否更新进度
	next_flag = 0,        % 是否在任务线内
	pre_flag = 0,        % 是否完成前置任务
	progress = 0        % 进度
}).

-record(db_role_task_complete, {
	player_id = 0,        % 玩家id
	role_id = 0,        % 角色id
	task_id = 0            % 任务id
}).

%% 飞镖活动基础存储数据
-record(db_darts_base, {
	id = 0,                     %% 飞镖活动ID
	delTime = 0,                %% 结束时间
	day = 1,                    %% 当前天数
	exchange_list = []          %% 全服兑换列表[{playerID,ID,Times}]
}).

%% 玩家飞镖活动数据
-record(db_darts, {
	player_id = 0,               %% 玩家ID
	dartsID = 0,                %% 活动ID
	cur_point = 0,              %% 当前积分
	max_point = 0,              %% 最大积分
	last_point = 0,             %% 昨日积分
	get_point = 0,              %% 已领飞镖场次积分
	day_point = 0,              %% 已领答谢积分
	spent_gold = 0,             %% 消耗元宝
	recharge = 0,               %% 充值金额
	day_recharge = 0,           %% 今日充值金额
	match_list = [],            %% 飞镖场次数据
	invite_list = [],           %% 收到的邀请函列表[{type, level},]
	exchange_list = []          %% 个人兑换列表[{id,times},]
}).




-record(db_bless, {
	player_id = 0,
	id = 0,                 %% ID
	free_count = 0,         %% 免费祈福次数
	bless_time = 0,         %% 祈福时间
	day_count = 0,          %% 今日次数
	bless_count = 0,        %% 祈福总次数
	uncrit_times = 0        %% 未暴击次数
}).

%% 登录奖励领取
-record(db_login_gift_get, {
	player_id = 0,        % 玩家id
	gift_id = 0,            % 奖励id
	is_double_gift = 0        %%是否领取了双倍奖励
}).

-record(db_retrieve_res, {
	player_id = 0,
	resID = 0,      %%资源类型
	resetTime = 0,  %%当天重置时间
	count = 0,      %%错过的次数
	count_ex = 0,   %% 错过的额外次数
	value = 0,      %%错过的值，比如经验值、耐力值
%%	indexList = [], %%剩余的购买序号，比如体力丹买了第1、2次，剩余3、4、5次，按照序号大小从小到大排列
	param = {},     %%记录参数
	get_count = 0,  %% 已找回的次数
	get_count_ex = 0%% 已找回的额外次数
}).

%% 0元购
-record(db_free_buy, {
	player_id = 0,        % 玩家id
	free_id = 0,        % 奖励id
	buy_time = 0        % 购买时间
}).

%% 基金购买
-record(db_funds_buy, {
	player_id = 0,        % 玩家id
	fund_type = 0,        % 基金类型
	plan = 0,            % 方案
	buy_time = 0        % 购买时间
}).

%% 基金领奖
-record(db_funds_award, {
	player_id = 0,        % 玩家id
	fund_type = 0,        % 基金类型
	award_id = 0,        % 奖励id
	plan = 0,            % 方案
	isGet = 0        % 已领取免费 1，全部领取完 2
}).

%% 全民奖励领奖
-record(db_funds_all_award, {
	player_id = 0,        % 玩家id
	award_id = 0        % 奖励id
}).

%% 理财购买
-record(db_financing_buy, {
	player_id = 0,      % 玩家id
	type = 0,           % 基金类型
	grade = 0,            % 档位
	lv = 0,            % 世界等级
	buy_time = 0,        % 购买时间
	count = 0            % 剩余重置次数
}).

%% 理财领奖
-record(db_financing_award, {
	player_id = 0,      % 玩家id
	type = 0,            % 基金类型
	grade = 0,            % 档位
	award_id = 0        % 奖励id
}).

%% 物品使用计数
-record(db_item_use_player, {
	player_id = 0,      % 玩家id
	item_id = 0,        % 物品id
	use_count = 0       % 使用次数
}).

%% 物品使用cd
-record(db_item_cd, {
	player_id = 0,      % 玩家id
	type = 0,           % 类型
	count = 0           % 数量
}).

%% 全服掉落保底
-record(db_drop_protect_world, {
	item_id = 0,        % 物品id
	use_count = 0       % 使用次数
}).

%% 个人掉落保底
-record(db_drop_protect_player, {
	player_id = 0,      % 玩家id
	item_id = 0,        % 物品id
	use_count = 0       % 使用次数
}).

%% 限时特惠
-record(db_time_limit_gift, {
	player_id = 0,      % 玩家id
	gift_id = 0,        % 礼包id
	open_time = 0,      % 开启时间
	status = 0,         % 状态：0激活 1购买 2过期
	buy_times = 0       % 购买次数
}).

%% 副本次数统计
-record(db_log_times, {
	player_id = 0,        % 玩家id
	type = 0,            % 副本
	times = 0            % 统计次数
}).

%% 七天奖任务进度表
-record(db_seven_gift_task_progress, {
	player_id = 0,        %% 玩家id
	group = 0,            %% 活动组
	day = 0,            %% 天数
	page = 0,            %% 分页
	id = 0,                %% 任务id
	progress = 0,        %% 进度
	today_progress = 0    %% 当天完成进度
}).

%% 七天奖任务完成表
-record(db_seven_gift_task_complete, {
	player_id = 0,    %% 玩家id
	group = 0,        %% 活动组
	day = 0,        %% 天数
	page = 0,        %% 分页
	id = 0,            %% 任务id
	is_get = 0        %% 是否领取
}).

%% 七天奖奖励表
-record(db_seven_gift_award, {
	player_id = 0,    %% 玩家id
	group = 0,        %% 活动组
	id = 0            %% 奖励id
}).

%% 七天奖每日奖励
-record(db_seven_gift_daily, {
	player_id = 0,  %% 玩家id
	group = 0,      %% 活动组
	day = 0,        %% 天数
	score = 0,      %% 积分
	get_list = []   %% 领取列表
}).

%% 玩家运营活动数据
-record(db_player_ac, {
	player_id,
	id,
	recharge,
	consume,
	conditionList,
	reachedList,
	ticket_buy_list,
	multiReward,
	limitShop,
	rechargeAct,
	lotteryNum,
	funds,
	day_recharge,
	weeklyAward,
	card777,
	f_sign,
	firstRechargeRest,
	mystery_shop,
	fireworks,
	f_wage,
	player_lucky_cat,
	player_glory_badge,
	change_package,
	dragon_treasure,
	open_gift_packs,
	player_wheel_luck_one,
	player_wheel_luck_two,
	limit_direct_buy
}).

%% 战盟拍卖玩家限购
-record(db_ga_limit_player, {
	id = 0,                    %% 拍卖id
	player_id = 0,    %% 玩家id
	cur_buy = 0            %% 已购买
}).

%% 配饰
-record(db_ornament, {
	player_id = 0,      %% 玩家id
	uid = 0,            %% 配饰uid
	cfg_id = 0,         %% 配置id
	bind = 0,           %% 绑定状态
	int_lv = 0,         %% 强化等级
	rand_prop = [],     %% 极品属性
	beyond_prop = [],   %% 卓越属性
	base_bind = 0       %% 原始绑定状态
}).

%% 配饰部位
-record(db_ornament_pos, {
	player_id = 0,      %% 玩家id
	pos = 0,            %% 部位
	uid = 0,            %% 配饰uid
	cast_time = 0,      %% 淬炼次数
	cast_prop = [],     %% 淬炼属性
	cast_prop_temp = [] %% 淬炼属性(保留)
}).

%% 魂器
-record(db_horcrux, {
	player_id = 0,      %% 玩家id
	id = 0,             %% 魂器id
	page = 1,           %% 阶数
	point = 1,          %% 点数
	lv = 0              %% 等级
}).

%% 器灵
-record(db_horus, {
	player_id = 0,      %% 玩家id
	lv = 1,             %% 等级
	exp = 0,            %% 经验
	pill1 = 0,          %% 磕丹1
	pill2 = 0,          %% 磕丹2
	pill3 = 0,          %% 磕丹3
	skills = []         %% 装配技能
}).

%% 满减促销
-record(db_discount_shop, {
	ac_id = 0,              %% 活动id
	shop_id = 0,            %% 商店id
	goods_id = 0,           %% 商品id
	sort_id = 0,            %% 排序id
	item = {},              %% 物品{ItemId, Bind}
	item_num = 0,           %% 物品数量
	coin = 0,               %% 货币
	coin_num = 0,           %% 货币数量
	equip = [],             %% 装备[{Career, CfgId, Chara, Star, Bind, Num}]
	cost_curr_type = 0,     %% 需要的货币类型
	cost_curr_num = 0,      %% 需要的货币数量
	cost_item_id = 0,       %% 需要的物品id
	cost_item_num = 0,      %% 需要的物品数量
	discount = [],          %% 折扣方式[{Type, Param1, Param2}]
	limit = [],             %% 限购方式[{Type, Param1, Param2}]
	recommend = 0,          %% 推荐
	show = 0,               %% 特效
	condition_type = 0,     %% 购买条件
	condition_param1 = 0,   %% 购买条件参数1
	condition_param2 = 0,   %% 购买条件参数2
	show_type = 0,          %% 显示条件
	show_param1 = 0,        %% 显示条件参数1
	show_param2 = 0         %% 显示条件参数2
}).

%% 满减促销玩家数据
-record(db_dcs_player, {
	player_id = 0,      %% 玩家id
	ac_id = 0,          %% 活动id
	shop_id = 0,        %% 商店id
	goods_id = 0,       %% 商品id
	buy_count = 0       %% 购买数量
}).

%% 玩家合成数据
-record(db_synt_player, {
	player_id = 0,      %% 玩家id
	type1 = 0,          %% 分类1
	type2 = 0,          %% 分类2
	type3 = 0,          %% 分类3
	type4 = 0,          %% 分类4
	type5 = 0,          %% 分类5
	cf_times = 0        %% 连续失败次数
}).

%% 龙神777大奖数据
-record(db_card777_record, {
	ac_id = 0,      %% 活动id
	award_list = [] %% 奖励数据
}).

%% 3v3成就
-record(db_3v3_achieve, {
	player_id = 0,
	attainment_list = []
}).
%% 3v3活动数据
-record(db_3v3, {
	id = 0,                            %% 主键key
	season = 0,                        %% 赛季
	season_start_time = 0,            %% 赛季开始时间
	season_end_time = 0,            %% 赛季结束时间
	cluster_time = 0,                %% 赛季开始的联服时间
	rank_list = []                    %% 排行榜信息
}).
-record(db_player_3v3, {
	player_id = 0,                %% 主键key
	score = 0,                    %% 积分
	office = 0,                    %% 段位
	max_office = 0,                %% 历史最高段位
	season = 0,                    %% 当前赛季
	last_update_time = 0        %% 最后更新时间
}).

%% 3v3管理进程存储玩家信息
-record(db_3v3_player, {
	player_id = 0,
	server_id = 0,
	server_name = "",
	score = 0,                %% 积分
	office = 0,                %% 官职 默认为0，否则，建号就有官职奖励
	max_office = 0,            %% 历史最高官职
	last_update_time = 0
}).

%% 3v3次数
-record(db_player_3v3_times, {
	player_id = 0,
	season = 0,
	recover_times = 0,
	buy_times = 0,
	daily_buy_times = 0,
	last_reset_time = 0        %% 上一次重置时间
}).
%% 3v3作战记录
-record(db_3v3_history, {
	player_id = 0,
	records = []
}).

%% 成长属性
-record(db_growth_attr, {
	player_id = 0,      %% 玩家ID
	uid = 0,            %% 成长属性uid
	growth_id = 0,      %% 成长属性id
	reaches = []        %% 条件达成
}).

%% 神兵打造
-record(db_weapon_make, {
	player_id = 0,      %% 玩家id
	weapon_id = 0,      %% 神兵id
	progress = 0,       %% 进度
	free_num = 0,       %% 免费打造次数(使用的)
	recharge_num = 0    %% 充值打造次数(使用的)
}).

%% 神兵
-record(db_weapon, {
	player_id = 0,      %% 玩家id
	weapon_id = 0,      %% 神兵id
	reopen = 0,         %% 解封
	level = 0,          %% 阶数
	star = [],          %% 星级
	g_attr_uid = 0      %% 成长属性uid
}).

%% 兵魂
-record(db_weapon_soul, {
	player_id = 0,      %% 玩家id
	role_id = 0,        %% 角色id
	level = 1,          %% 等级
	exp = 0,            %% 经验
	skill = []          %% 技能
}).

%% 玩家召集相关数据
-record(db_convene, {
	player_id = 0,      %% 玩家id
	func_id = 0,        %%
	last_do_time = 0,
	times = 0        %% 连续小于标准冷却时间的次数
}).

%% 猎魔玩家积分排行
-record(db_dh_player_rank, {
	player_id = 0,
	server_id = 0,
	top_msg = {},
	battle_value = 0,
	score_change_time = 0,
	score = 0                %% 积分
}).

%% 猎魔战盟排行
-record(db_dh_guild_rank, {
	guild_id = 0,
	master_id = 0,      %% 盟主ID 变化的时候更新top_msg
	guild_name = 0,
	server_id = 0,
	top_msg = {},
	battle_value = 0,
	score_change_time = 0,
	kill_num = 0        %% 战盟击杀
}).

%% 道具直购
-record(db_gift_package_buy, {
	player_id = 0,      %% 玩家id
	buy_times11 = [],     %% 每日购买次数{礼包ID，购买次数}
	buy_times12 = [],     %% 每日购买次数
	buy_times13 = [],     %% 每日购买次数
	buy_times14 = [],     %% 每日购买次数
	buy_times15 = [],     %% 每日购买次数
	buy_times16 = []      %% 每日购买次数
}).
%% 圣盾
-record(db_holy_shield, {
	player_id = 0, %% 玩家id
	level = 0, %% 等级
	level_exp = 0, %% 等级经验
	break = 0, %% 突破
	stage = 0, %% 阶级
	stage_exp = 0,
	click_attr = [] %% 单次升阶累计属性
}).
%% 神盾技能
-record(db_holy_shield_skill, {
	player_id = 0, %% 玩家id
	skill_id = 0, %%
	level = 0
}).

%%圣甲装备宝石信息(按照阶级存储)
-record(db_shengjia_gem, {
	player_id = 0,        %%玩家id
	stage = 1,            %%圣甲阶级
	gem_list = []        %%{pos,uid,cfgid} 宝石列表
}).

%% 圣纹系统信息
-record(db_shengwen_system, {
	player_id = 0,           %% 玩家ID
	awaken = [],          %% [{num,value}..]  num=1是灵纹，num=2魔纹，num=3神纹   圣纹觉醒等级
	suitlist = []        %% [{key,value1,value2}..]  key:套装种类（同上） value1：套装件数,  value2：套装阶级   灵纹套装等级
}).

%% 圣纹位置信息
-record(db_shengwen_pos, {
	player_id = 0,        %% 玩家id
	pos = 0,              %% 位置
	cfg_id = 0,           %% cfgID
	uid = 0,             %% 实例ID
	character = 0,        %% 品质
	stage = 0,            %% 阶级
	intensify_lv = 0,     %% 强化等级
	gongming_lv = 0,       %% 共鸣等级
	effect_ilv = 0,            %% 生效强化等级
	effect_glv = 0        %% 生效共鸣等级
}).

%% 圣纹信息
-record(db_shengwen, {
	player_id = 0,
	uid = 0,                %% 实例ID
	cfg_id = 0,                %% CfgID
	bind = 1,                %%绑定状态
	jipin_prop = [],        %% 极品属性   {I, V, C, PIndex} 属性ID 值 品质 积分索引
	zhuoyue_prop = []        %% 卓越属性  {I, V, C, PIndex} 属性ID 值 品质 积分索引
}).

%% 深渊角斗管理进程存储玩家信息
-record(db_af_player, {
	player_id = 0,
	server_id = 0,
	server_name = "",
	top_msg = {},
%%	rank = 0,
	join_time = 0,
	success_time = 0,
	grade = 0,
	reach_time = 0,
	reach_battle_value = 0
}).

%% 玩家参加限时活动记录
-record(db_time_limit_ac, {
	player_id = 0,      %% 玩家id
	ac_id = 0,          %% 限时活动ID，同Openaction表的ID保持一致
	order_list = []     %% 当日参与过的场次，场次同{#functionForeCfg.order, end_time}
}).

-record(db_direct_buy_fund, {
	player_id = 0,
	group_id = 0,
	buy_id = 0,
	award_days = 0,
	level = 0,            %% 世界等级
	buy_time = 0,         %% 购买时间
	valid_time = 0        %% 到期时间
}).

-record(db_push_player, {
	player_id = 0,
	not_disturb_start = 0,
	not_disturb_end = 0,
	config = [] %% {id,param1,param2,param3}
}).

%% 星座
%% 星座
-record(db_constellation, {
%%	tuple_id = {player_id, constellation_id},
	player_id = 0, %% 玩家id
	constellation_id = 0, %% 星座id
	star = 0, %% 星级
	star_soul = [], %% 星魂
	guard = [], %% 守护
	gem = [],    %%星石
	gem_skill = {0, 0, 0} %%{id,等级,状态}0-未激活 1-已激活
}).
%% 星座技能
-record(db_constellation_skill, {
	player_id = 0, %% 玩家id
	skill = [] %% 技能
}).
%% 星座装备
-record(db_constellation_equipment, {
	player_id = 0, %% 玩家id
	equipment_id = 0, %% 装备id
	cfg_id = 0, %% 配置id
	excellent_attr = [], %% 极品属性
	excellent_attr1 = [], %% 卓越属性
	bind = 0 %% 绑定状态
}).


%% 圣战遗迹圣坛信息
-record(db_hw_chancel, {
	map_data_id = 0,                %% 地图id
	chancel_id = 0,                 %% 圣坛配置id
	server_id = 0,                  %% 归属服务器id
	buff_list = [],                 %% buff列表
	occupy_time = 0                 %% 占领时间
}).

%% 圣战遗迹boss信息
-record(db_hw_boss, {
	map_data_id = 0,                %% 地图id
	boss_id = 0,                    %% boss配置id
	level = 0,                      %% 等级
	tomb = {},                      %% 墓碑信息
	drop_list = [],                 %% 掉落记录
	revive_time = 0                 %% 复活时间
}).

%% 圣战遗迹玩家信息
-record(db_hw_player, {
	player_id = 0,          %% 玩家id
	server_id = 0,          %% 服务器id
	curse = 0,              %% 诅咒值
	times = 0,              %% 获取奖励次数
	attentions = []         %% [{map_data_id, boss_id}] 关注列表
}).

%% 圣战遗迹掉落信息
-record(db_hw_drop, {
	uid = 0,        %% 装备实例ID
	eq = {}         %% #eq{}
}).

-record(db_border_server_score, {
	server_id = 0,      %% 服务器ID
	score = 0,        %% 当前积分 每日重置
	last_score = 0      %% 昨天的领地积分
}).

-record(db_border_player_score, {
	player_id = 0,      %% 玩家ID
	battle_value = 0,
	top_msg = {},       %% 排行榜ui
	atk_kill = 0,          %% 进攻杀敌数 每日重置
	def_kill = 0,          %% 防守杀敌数 每日重置
	history_score = 0,      %% 历史累计战功 赛季个人战功 赛季重置
	weekly_score = 0,    %% 荣誉值 每周获得的战功累计 每周一重置
	buy_score = 0   %% 玩家购买的荣誉值
}).
%% 服务器排行数据
-record(db_border_server_rank, {
	server_id = 0,      %% 服务器ID
	score = 0,          %% 结算时积分
	rank = 0,          %% 排名
	buff = [],      %% Buff
	is_union = 0,   %% 是否可结盟
	union_server_id = 0 %% 结盟服务器ID
}).

-record(db_border_season, {
	id = 0,
	season = 0,
	world_lv = 0,
	unite_num = 0,
	start_time = 0,
	end_time = 0,
	union_msg = [], %% [#union_msg{}]
	history_score = 0,
	buy_score = 0
}).

-record(db_border_bp_player, {
	player_id = 0,      %% 玩家ID
	season_time = 0,    %% 参与时赛季的结束时间
	season_world_lv = 0,  %% 参与时赛季的世界等级
	season_type = 0, %% 参与时的赛季类型 1-体验赛季  2-正式赛季
	buy_flag = 0,   %% 进阶版解锁标记 bit1 荣誉证书 bit2 征战令牌
	personal_award = [], %% 荣誉证书 每周重置 领取记录 [{1,1},{1,2},{2,1},{2,2}]  1低级 2高级
	server_award = [], %% 征战令牌 赛季重置  领取记录 [{1,1},{1,2},{2,1},{2,2}]	1低级 2高级
	next_week_reset_time = 0, %%下一次周重置时间
	player_season = 1,   %% 玩家当前赛季
	player_week_season = 1, %% 玩家周BP赛季
	weekly_lv = 0,       %% 荣誉证书等级 每周一重置
	weekly_score = 0,    %% 荣誉证书经验 每周一重置
	conquer_lv = 0,      %% 征战令牌等级 赛季重置
	conquer_exp = 0      %% 征战令牌经验 赛季重置
}).

%% 边境玩家战功排行
-record(db_border_score_rank, {
	player_id = 0,          %% 玩家id
	top_msg = {},           %% 排行ui信息
	battle_value = 0,       %% 战力
	score_change_time = 0,  %% 战功改变时间
	score = 0               %% 战功
}).

%% 边境防守杀人排行
-record(db_border_def_kill_rank, {
	player_id = 0,          %% 玩家id
	top_msg = {},           %% 排行ui信息
	battle_value = 0,       %% 战力
	kill_change_time = 0,   %% 杀人数改变时间
	kill_num = 0            %% 杀人数
}).

%% 边境进攻杀人排行
-record(db_border_atk_kill_rank, {
	player_id = 0,          %% 玩家id
	top_msg = {},           %% 排行ui信息
	battle_value = 0,       %% 战力
	kill_change_time = 0,   %% 杀人数改变时间
	kill_num = 0            %% 杀人数
}).


%% 古神圣装
-record(db_ancient_holy_eq, {
	player_id = 0,          %% 玩家id
	uid = 0,                %% id
	cfg_id = 0,             %% 配置id
	high_quality_attr = [],  %% 极品属性
	superior_attr = []       %% 卓越属性
}).

%% 古神圣装装备位
-record(db_ancient_holy_eq_position, {
	player_id,          %% 玩家id
	position,           %% 位置
	equipment_id,       %% 穿戴装备uid
	is_locked,          %% 是否锁定
	refresh_awaken_attr,   %% 刷新出的觉醒属性
	awaken_attr,         %% 觉醒属性
	awaken_times,       %% 觉醒次数
	enhancement_level = 0  %% 强化等级
}).

%% 职业转换装备继承表
-record(db_eq_pos_inherit, {
	player_id, %% 拥有者ID
	pos = 0, %% 装备位置
	owner_id = 0, %% 拥有者ID
	intensity_lv_max = 0, %% 当前部位达到过的最大强化等级
	add_lv_max = 0, %% 当前部位达到过的最大追加等级
	gem_refine_lv = 0, %% 宝石精炼等级
	gem_refine_exp = 0, %% 宝石精炼当前经验
	gem_list = [], %% 宝石镶嵌信息
	cast_prop = [],          %% 洗练属性 {P, I, V, C}
	suit_make_lv = 0,      %% 套装打造等级  1 普通  2 完美  3 传说
	suit_make_cost = [],     %% 套装打造的消耗
	ele_intensity_atk_lv = 0,   %% 元素强化攻击等级
	ele_intensity_def_lv = 0,   %% 元素强化防御等级
	ele_intensity_atk_break_lv = 0, %% 元素强化攻击突破等级
	ele_intensity_def_break_lv = 0, %% 元素强化防御突破等级
	ele_add_atk_lv = 0,         %% 元素追加攻击等级
	ele_add_def_lv = 0         %% 元素追加防御等级
}).
-record(db_dragon_honor, {
	id = 0,
	ac_id = 0,
	startTime = 0,
	endTime = 0,
	show_start = 0,
	show_end = 0,
	is_final = 0,           %% 最终结算 0 否 1是
	guild_rank = [],        %%{rank,guildID}
	guild_member_rank = [], %% {guildID,[{rank,playerID}]}
	title_info = [],        %% {PlayerID,TitleId}
	update_time = 0
}).

%% 神力天赋
-record(db_divine_talent, {
	player_id = 0, %% 玩家id
	talent_list = [], %% 天赋列表
	used_point = 0, %% 已使用天赋点
	reset_times = 0 %% 重置次数
}).
%% 神位
-record(db_god_position, {
	player_id = 0,      %% 玩家id
	type = 0,           %% 神系
	level = 0,          %% 等级
	change_times = 0,    %% 转换次数
	last_reset_time = 0 %% 最近一次转换次数重置时间
}).

%% 神力战场玩家数据
-record(db_gf_dungeon, {
	player_id = 0,      %% 玩家id
	god_type = 0,       %% 神系
	god_level = 0,      %% 神位
	max_wave = 0,       %% 最大波数
	max_score = 0,      %% 最高积分
	battle_value = 0,   %% 战力
	top_msg = {}        %% 排行ui
}).

%% 神位争夺活动信息
-record(db_god_fight, {
	id = 1,             %% 固定为1
	state = 0,          %% 当前阶段
	start_time = 0,     %% 活动开始时间
	next_time = 0,      %% 下一阶段开始时间
	end_time = 0,       %% 活动结束时间
	is_gm = 0           %% 是否是gm活动
}).

%% 神位争夺玩家数据
-record(db_gf_player, {
	player_id = 0,      %% 玩家id
	type = 0,           %% 神系
	group = 0,          %% 分组(1:A,2:B)
	rank = 0,           %% 排名
	score = 0           %% 积分
}).

%% 神位争夺轮次数据
-record(db_gf_round, {
	fight_id = 0,       %% 场次id
	type = 0,           %% 神系
	round = 0,          %% 轮次
	group = 0,          %% 分组
	player1 = 0,        %% 参与玩家1
	player2 = 0,        %% 参与玩家2
	start_time = 0,     %% 开始时间
	end_time = 0,       %% 结束时间
	winner = 0          %% 胜者
}).

%% 主神争夺数据
-record(db_gf_data, {
	type = 0,               %% 系别
	cur_id = 0,             %% 本轮主神id
	pre_id = 0              %% 上轮主神id
}).

%% 协助-心意宝箱协助者信息
-record(db_help_box, {
	player_id = 0,      %% 玩家id
	help_list = [[]]           %% 协助者id列表
}).

-record(db_help_thanks_msg, {
	player_id = 0,      %% 协助者id
	id = 0,  %% 消息id
	help_id = 0,  %% 求助者id
	index = 0, %% 感谢内容编号
	expire_time = 0 %% 过期时间
}).

%%圣翼基础养成
-record(db_holy_wing_base, {
	player_id = 0,      %% 玩家id
	type = 0,           %% 类型
	info = "",          %% 装备、强化、觉醒、觉醒技能、翅膀加成id列表、外显id
	wings_bonus = "",   %% 翅膀加成列表
	show_id = 0         %% 外显id 0表示未设置
}).

%%圣翼符文装配
-record(db_holy_wing_rune_pos, {
	player_id = 0,      %% 玩家id
	level_id = 0,       %% 圣翼级别id
	position_info = ""  %% 镶嵌信息
}).
%% 圣翼技能
-record(db_holy_wing_skill, {
	player_id = 0,      %% 玩家id
	skill_id = 0,       %% 技能id
	level = 0,  %% 强化等级
	exp = 0
}).
%% 圣翼技能装配
-record(db_holy_wing_skill_pos, {
	player_id = 0,      %% 玩家id
	initiative_pos = "",    %% 主动技能装配信息 {技能槽数量, 技能装配信息, 已使用的技能槽数量}
	passive_pos = ""       %% 被动技能装配信息  {技能槽数量, 技能装配信息, 已使用的技能槽数量}
}).
%%圣翼
-record(db_holy_wing, {
	player_id = 0,      %% 玩家id
	holy_wing_id = 0,   %% 圣翼id
	cfg_id = 0,         %% 强化等级
	attr = ""           %% 圣翼属性
}).

%% 快速收益
-record(db_quick_award, {
	player_id = 0,  %% 玩家id
	fun_id = 0,    %% 功能id 1 个人boss 2 世界boss
	times = 0      %% 已使用次数
}).

%% 世界boss疲劳值
-record(db_wb_fatigue, {
	player_id = 0,  %% 玩家id
	fatigue = 0,    %% 疲劳
	last_restore_time = 0,      %% 最近一次恢复时间
	restore_times = 0,   %% 恢复次数
	follow_list = [],   %% 关注列表
	pass_map_list = [],   %% 通过的地图
	enter_multi = 1        %% 进入倍数
}).

%% 星空圣墟地图信息
-record(db_hr_map, {
	map_data_id = 0,        %% 地图id
	weekday = 0,            %% 周几
	status = 0,             %% 状态
	open_time = 0,          %% 开放时间
	close_time = 0          %% 关闭时间
}).

%% 星空圣墟boss信息
-record(db_hr_boss, {
	map_data_id = 0,                %% 地图id
	boss_id = 0,                    %% boss配置id
	level = 0,                      %% 等级
	tomb = {},                      %% 墓碑信息
	drop_list = [],                 %% 掉落记录
	revive_time = 0                 %% 复活时间
}).

%% 星空圣墟掉落信息
-record(db_hr_drop, {
	uid = 0,        %% 装备实例ID
	eq = {}         %% #eq{}
}).

%% 特殊掉落服务器记录
-record(db_drop_sp_server, {
	group_id = 0,   %% 组
	kill_num = 0    %% 击杀数
}).

%% 特殊掉落玩家记录
-record(db_drop_sp_player, {
	player_id = 0,  %% 玩家id
	item_id = 0,    %% 物品id
	amount = 0      %% 获得数
}).

-record(message_notify, {
	player_id = 0,
	id = 0,
	notify_msg = {}
}).

%% 元素试炼玩家信息
-record(db_et_player, {
	player_id = 0,      %% 玩家id
	server_id = 0,      %% 服务器id
	buy_curse = 0,      %% 购买的诅咒值
	day_buy_times = 0,  %% 当天购买的次数
	used_curse = 0      %% 当前诅咒值
}).

%% 暗炎魔装
-record(db_dark_flame_eq, {
	player_id = 0,
	uid = 0,
	cfg_id = 0,
	best_attr = [],
	exc_attr = []
}).
%% 暗炎魔装 装配
-record(db_dark_flame_pos, {
	player_id = 0,
	pos = 0,
	uid = 0,
	forge = [],
	forge_cache = []
}).

%% 暗炎魔装 大师
-record(db_dark_flame_grandmaster, {
	player_id = 0,
	type = 0,
	level = 0,
	times = 0
}).

%% 资源盛典 消耗
-record(db_res_cb, {
	player_id = 0,
	type = 0,
	num = 0
}).

-record(db_client_dungeon_bless, {
	player_id = 0,
	bless_list = [],    %% {Pos, BlessID}
	bless_pool = []        %% {Type, Quality, BlessID}
}).

%% 装备收藏
-record(db_collect_pos, {
	player_id = 0,        %% 玩家ID
	role_id = 0,        %% 角色ID
	order = 0,            %% 阶数
	pos = 0,            %% 部位
	uid = 0,            %% 装备uid
	reborn_lv = 0,        %% 再生等级
	reborn_fail_times = 0,  %% 再生失败次数
	reborn_prop = []    %% 再生属性列表（属性库ID）
}).

%% 赏金任务玩家表
-record(db_bounty_task_player, {
	player_id = 0,        %% 玩家ID
	is_special = 0,        %% 是否有特权 0 未拥有 1 已拥有
	free_refresh_times = 0, %% 使用的免费刷新次数
	pay_refresh_times = 0,  %% 使用的付费刷新次数
	used_dispatch_times = 0, %% 已派遣次数
	accumulated_exp = 0,    %% 累计特权经验
	used_add_item_times = 0,     %% 使用增加派遣次数道具数
	fail_times = 0, %% 累计刷新失败次数（未刷出SSS任务即为失败）
	lock = 0,        %% 锁定状态 0 未锁定 1 锁定中
	ss_fail_times = 0 %% SS任务累计刷新失败次数（未刷出SS任务即为失败 与fail_times互相独立）
}).

%% 赏金任务任务表
-record(db_bounty_task_task, {
	player_id = 0,    %% 玩家ID
	task_id = 0,    %% 任务ID
	state = 0,        %% 任务状态 0 未开始 1 已派遣 2 已完成未领取 3 已领取
	begin_time = 0,    %% 开始时间戳 0 未开始
	unit_list = []    %% 单位列表
}).

%% 赏金任务单位表
-record(db_bounty_task_unit, {
	player_id = 0,    %% 玩家ID
	unit_id = 0,    %% 单位ID
	type = 0,    %% 单位类型 1 角色 2 坐骑 3 魔宠 4 翅膀
	state = 0    %% 单位状态 0 空闲中 1 占用中
}).

-record(db_cp_rune_tower, {
	player_id = 0,        %% 玩家ID
	had_bless = [],        %% 已有祝福
	random_bless = [],    %% 已经随出来的祝福
	none_bless_layer = [], %% 尚未随机祝福的层数
	reset_time = 0        %% 下次重置时间
}).

%% 新1v1玩法数据
-record(db_king_1v1, {
	id = 1,             %% 固定为1
	cluster_stage = 0,    %% 联服阶段
	state = 0,          %% 状态
	start_time = 0,     %% 赛季开始时间
	next_time = 0,      %% 下一阶段时间
	end_time = 0,        %% 赛季结束时间
	season_num = 0,     %% 赛季数
	timeline = [],        %% 时间表 [{state, start, end}, ...]
	bp_data = [],        %% bp倍率 [{fix_type, fix}, ...]
	ext_data = []        %% 额外数据
}).

%% 新1v1玩家信息
-record(db_king_1v1_player, {
	player_id = 0,      %% 玩家id
	server_id = 0,      %% 服务器id
	king_rank = 0,      %% 巅峰赛排名
	is_active = 0,      %% 是否活跃
	score = 0,          %% 积分
	grade = 0,          %% 段位
	season_id = 0,      %% 赛季id
	day_def_score = 0,  %% 每日防守积分
	last_def_score = 0, %% 昨日防守积分
	day_buy_times = 0,  %% 每日增加的次数
	day_fight_times = 0,%% 每日参与次数
	last_fight_times = 0,   %% 昨日参与次数
	used_free_times = 0,    %% 已使用免费次数
	buy_times = 0,      %% 增加的次数
	victory_times = 0,  %% 连胜次数
	defeat_times = 0,   %% 连败次数
	season_fight_times = 0, %% 赛季参与次数
	season_win_times = 0,   %% 赛季胜利次数
	bet_times = 0,      %% 竞猜次数
	challenge_times = 0,%% 挑战次数
	records = [],       %% 对战记录
	award_tasks = [],   %% 完成的任务列表
	bet_info = []       %% 竞猜信息
}).

%% 新1v1轮次信息
-record(db_king_1v1_round, {
	fight_id = 0,       %% 唯一id
	round = 0,          %% 轮次
	group = 0,          %% 分组
	atk_id = 0,         %% 进攻方id
	def_id = 0,         %% 防守方id
	start_time = 0,     %% 开始时间
	end_time = 0,       %% 结束时间
	result = 0,         %% 结果
	num1 = 0,           %% 结果1支持数
	num2 = 0            %% 结果2支持数
}).

%% 跨服拍卖-商品组
-record(db_cluster_auction_group, {
	open_action = 0,          %% 功能编号
	bonus_player_list = [],   %% 分红玩家列表 [{player_id, server_id}]
	start_time = 0,           %% 开始时间
	finish_time = 0,          %% 结束时间
	state = 0                 %% 状态
}).

%% 跨服拍卖-商品
-record(db_cluster_auction_goods, {
	goods_id = 0,             %% 商品Id
	open_action = 0,          %% 功能编号
	%%
	item_cfg_id = 0,          %% 物品配置Id
	item_chara = 0,           %% 物品品质
	item_star = 0,            %% 物品星级
	item_amount = 0,          %% 物品数量
	item_data = {},           %% 物品数据 {Item, Equipment}
	price_type = 0,           %% 货币类型
	price_add = 0,            %% 加价单价
	price_buy = 0,            %% 一口价单价
	%%
	bid_price = 0,            %% 当前出价单价
	bid_player_id = 0,        %% 当前出价玩家Id（0表示系统出价）
	bid_player_name = "",     %% 当前出价玩家名字
	bid_server_id = 0,        %% 当前出价服务器Id（0表示系统出价）
	bid_player_list,          %% 出价玩家集合
	%%
	state = 0                 %% 状态
}).

%% 奖杯
-record(db_cup, {
	player_id = 0,       %% 玩家ID
	cup_id = 0,    %% 奖杯ID
	char = 0,    %% 品质
	char_exp = 0, %% 品质经验
	stage = 0,    %% 段位
	level = 0,  %% 等级
	exp = 0,  %% 经验
	stamp = 0  %% 已激活的最大印记编号
}).

%% 角色站位
-record(db_role_pos, {
	player_id = 0      %% 拥有者ID
	, role_id = 0        %% 角色ID
	, type = 0            %% 1竞技场 2 王者1v1
	, ad_type            %% 1 进攻方 2防守方
	, pos = 0        %% 站位
}).

%% 时装玩家表
-record(db_fashion_player, {
	player_id = 0,    %% 玩家ID
	fashion_id = 0,        %% 时装ID
	color_index1 = 0,    %% 颜色索引1
	color_index2 = 0,    %% 颜色索引2
	star = 0,            %% 星数
	expire_time = 0     %% 过期时间 0为永久
}).

%% 外观玩家表
-record(db_appearance_player, {
	player_id = 0,        %% 玩家ID
	role_id = 0,    %% 角色ID
	weapon = 0,        %% 时装：武器
	head = 0,        %% 时装：头部
	body = 0,        %% 时装：身体
	ornament = 0,    %% 时装：饰品
	suit = 0        %% 时装：套装
}).

%% 衣橱玩家表
-record(db_wardrobe_player, {
	player_id = 0,        %% 玩家ID
	wardrobe_lv = 0,    %% 衣橱等级
	wardrobe_exp = 0    %% 衣橱经验
}).

%% 天神祝福
-record(db_dungeons_bless_player, {
	player_id = 0,        %% 玩家ID
	chapter = 0,        %% 章节
	bless_list = []    %% 祝福列表 [{Index, Times}]
}).

%% 法阵
-record(db_fazhen, {
	player_id = 0,        %% 玩家id
	fazhen_uid = 0,        %% 法阵实例id
	cfg_id = 0,            %% 配置id
	star = 0,            %% 星级
	eq_rune = []        %% 装配符文 [{Pos, RuneUid}]
}).

%% 符文
-record(db_fazhen_rune, {
	player_id = 0,        %% 玩家id
	rune_uid = 0,        %% 符文实例id
	cfg_id = 0,            %% 配置id
	lv = 0,                %% 等级
	star = 0            %% 星级
}).

%% 职业塔玩家
-record(db_career_tower_player, {
	player_id = 0, %% 玩家ID
	reward_id = 0, %% 全局奖励已领取最大索引
	pet_id = 0,  %% 出战魔宠ID
	yesterday_layer = 0, %% 昨日结算层数
	super_yesterday_layer = 0  %% 超级塔昨日结算层数
}).

%%  职业塔
-record(db_career_tower, {
	player_id = 0, %% 玩家ID
	tower_id = 0, %% 塔ID
	layer = 0,  %% 最大成功层数
	reward = 0, %% 最大奖励进度索引
	first_reward_list = [] %% 首通奖励已领取列表
}).

%% 全局变量 -- 类似世界变量, 不过value改为text类型
-record(db_global_value, {
	key, %% 唯一Id
	value = 0
}).

%% 玩家其他信息
-record(db_player_other, {
	player_id = 0
	, hunt_phy_value = 0 %% 猎魔体力值
	, hunt_recover_time = 0 %% 上次恢复时间
	, hunt_lv = 0 %% 猎魔等级
	, use_force_times %% %% 今日已使用的强征次数
	, challenge_time = 0        %% 今日挑战特殊BOSS次数
	, rank_pass_time = 0  %% 今日挑战特殊BOSS最短耗时
	, rank_pass_time_yesterday = 0    %% 昨天挑战特殊BOSS最短耗时
}).

%% 远征猎魔
-record(db_expedition_hunt, {
%%	tuple_id = {player_id, level}
	player_id = 0      %% 玩家ID
	, level = 0    %% 猎魔等级
	, is_challenge = 0 %% 是否为赛季首次挑战
	, is_pass = 0 %% 是否挑战通过
}).

%% 赛季信息  重置清空
-record(db_expedition_info, {
	id = 0,
	stage = 0,                %% 阶段(0 - 功能未开放，1 - 休战阶段，2 - 普通城池争夺阶段，3 - 皇城争霸阶段)
	group_info = [],        %% 小队信息(阵营ID, 小队ID, 战盟ID)
	guild_active_num = [],   %% 战盟活跃玩家 {战盟ID，活跃玩家数}
	area_info = [],            %% (位置, 阵营ID)
	first_camp = 0,            %% 皇城占领阵营
	first_camp_title = 0,   %% 皇城占领阵营称号
	first_player = 0,        %% 大元帅
	camp_title_list = [],    %% 本周阵营称号积分列表(每周最后一场皇城争夺后清空)
	start_time1 = 0,        %% 普通城战开始时间
	end_time1 = 0,            %% 普通城战结束时间
	start_time2 = 0,        %% 皇城战开始时间
	end_time2 = 0,            %% 皇城战结束时间
	last_end_time = 0,        %% 上一次第三场皇城战结束时间
	city_info = [],            %% 结算时城池信息 #expedition_city_info{}
	strong_camp_time = {},    %% 成为强阵营的次数，{CampID, Time}
	notice_camp = 0
}).

%% 阵营信息 重置清空
-record(db_expedition_camp_info, {
	camp_id = 0,                %% 阵营ID
	publish_task_times = 0,        %% 本场已经发布任务次数
	leader1 = 0,                %% 统帅1
	leader2 = 0,                %% 统帅2
	leader3 = 0                    %% 统帅3
}).

%% 小队信息 重置清空
-record(db_expedition_group_info, {
%%	tuple_id = {0, 0},
	camp_id = 0,                %% 阵营ID
	group_id = 0,                %% 小队ID
	leader_guild = 0,            %% 队长所属阵营
	leader_id = 0,                %% 队长ID
	score = 0,                    %% 小队积分
	exploit = 0,                %% 小队功勋(皇城争霸使用)  todo 感觉没用
	member_list = [],            %% 成员列表
	award_list = []                %% 小队任务结算奖励[{ItemId, Num}]
}).

%% 任务信息 重置清空
-record(db_expedition_task_info, {
	task_id = 0,                %% 任务ID
	camp_id = 0,                %% 阵营ID
	type1 = 0,                    %% 0-初始任务，1-动态任务
	type2 = 0,                    %% 任务作战类型
	target_area = 0,            %% 目标区域
	team_id = 0,                %% 接取该任务的小队
	state = 0,                    %% 任务当前状态 0 - 未接取, 1 - 未完成, 2 - 已完成
	progress = 0,                %% 任务进度
	target_score = 0            %% 任务目标
}).

%% 玩家信息 存在本服，同步至所有服 重置不清空
-record(db_expedition_player_info, {
	player_id = 0,                %% 玩家ID
	player_server = 0,            %% 玩家服务器ID
	player_fight = 0,            %% 玩家远征战力
	award_status = 0,           %% 是否授予奖励
	camp_id = 0,                %% 阵营ID
	group_id = 0,                %% 小队ID
	award_list = [],            %% 城池争夺的奖励 #expedition_award_info()
	energy = 0,                    %% 能量
	buy_energy = 0,             %% 购买的能量
	time_buy_energy_times = 0,  %% 本场购买能量次数
	now_area = 0,                %% 所在地区
	all_score = 0,                %% 本赛季功勋
	week_score = 0,                %% 本周功勋
	carry_energy = 0,            %% 携带能量
	reset_time = 0,                %% 赛季重置时间
	week_reset_time = 0,        %% 本周重置时间
	nobility_id = 0,            %% 爵位ID
	title_id = 0,                %% 称号ID
	is_got_salary = 0,            %% 工资是否领取 -- 每日重置
	box_id = 0,                    %% 宝箱ID
	hunt_lv = 0,                %% 猎魔等级
	true_nobility_id = 0,        %% 真实的爵位称号(获得特殊爵位时将真实爵位暂存在这里)
	explore_award_time = 0,        %% 探险获奖次数
	explore_fight_time = 0,        %% 探险争夺次数
	restore_explore_fight_timestamp = 0,    %% 天线争夺次数回复时间戳
	explore_bag_time = 0,        %% 探险宝箱已经累计次数
	explore_bag_award = []        %% 探险宝箱尚未发奖次数{City_Type, Num}
}).

%% 阵营战报 存在主服，同步至所有服 重置清空 任务类的需要即时清空
-record(db_expedition_camp_fight_info, {
	id = 0,                %% 战报ID
	camp_id = 0,        %% 阵营ID
	type = 0,            %% 战报类型 1-占领,2-被占领,3-任务类
	task_type = 0,        %% 任务类型
	task_score = 0,        %% 任务目标分数
	area_id = 0,        %% 地区
	time = 0            %% 时间
}).

%% 个人战报 只存在本服，不需要同步  重置清空
-record(db_expedition_player_fight_info, {
	id = 0,                %% 战报ID
	player_id = 0,        %% 玩家ID
	area_id = 0,        %% 地区
	type = 0,            %% 战报类型
	enemy_title = 0,    %% 敌人爵位
	enemy_name = [],    %% 敌人名字
	energy = 0,            %% 消耗能量
	score = 0,            %% 获得功勋
	time = 0            %% 时间
}).

%% 探险战报 只存在本服 不需要同步 重置清空
-record(db_expedition_explore_fight_info, {
	player_id = 0,        %% 玩家ID
	info_list = []        %% {type,server,name,time}
}).

%% 远征令牌任务
-record(db_expedition_notes, {
	player_id = 0,         %% 玩家id
	type = 0,              %% 任务类型
	task_process = 0,      %% 进度
	already_award_list = [], %% 该任务类型已经完成的任务id
	ext_param = 0           %% 额外参数 个别任务需要此参数判断是否增加进度
}).

%% 猎魔挑战boss 存在本服，同步至所有服 重置不清空
-record(db_expedition_hunt_boss_info, {
	id = 0,
	boss_type = 0,                    %% 今天随机的bossID
	boss_type_yesterday = 0,        %% 昨天随机的bossID
	rank_list = [],                 %% 排名{PlayerID, FightTime(通关的时间戳), UseTime(通关耗时), Rank}
	rank_list_yesterday = []        %% 排名{PlayerID, FightTime(通关的时间戳), UseTime(通关耗时), Rank, IsReceive(是否领取)}
}).

%% 远征图鉴
-record(db_expedition_card, {
%%	tuple_id = {player_id, type},
	player_id = 0,    %% 玩家id
	type = 0,        %% 图鉴类别
	level = 0,        %% 吞噬等级
	exp = 0,        %% 吞噬经验
	fetter_level = 0,        %% 羁绊等级
	card_list = []    %% 已经激活的图鉴ID列表
}).

%% 远征探险
-record(db_expedition_explore_info, {
	city_id = 0,            %% 城池ID
	type = 0,                %% 资源类别
	occ_player_id = 0,        %% 占领玩家ID
	protect_timestamp = 0,    %% 保护时间
	award_timestamp = 0        %% 发奖时间
}).

%% 蓝钻祈福
-record(db_green_bless, {
	player_id = 0,
	id = 0,                 %% ID
	free_count = 0,         %% 免费祈福次数
	bless_time = 0,         %% 祈福时间
	day_count = 0,          %% 今日次数
	bless_count = 0,        %% 祈福总次数
	uncrit_times = 0        %% 未暴击次数
}).

-record(db_weapon_fetter, {
	player_id = 0,
	id = 0,                %% 羁绊id
	level = 0            %% 羁绊等级
}).

%% 宠物图鉴
-record(db_pet_atlas, {
	player_id = 0,
	atlas_id = 0, %% 图鉴id
	stars = 0, %% 图鉴星级
	active_time = 0, %% 图鉴激活时间
	max_star = 0, %% 曾经获得过的最大星级
	is_reward = 0 %% 是否领取了激活奖励 0未领取  1已领取
}).

%% 宠物上阵
-record(db_pet_pos, {
	player_id = 0,
	type = 0,           %% 类型
	pos = 0,            %% 位置
	uid = 0,            %% 宠物uid
	is_auto_skill = 0,  %% 是否自动释放技能 0是/1否
	ring_eq_list = [],   %% 宠物戒指装备列表[{pos, uid}]
	altar_list = []     %% 阵石列表[{pos,uid}]
}).

%% 宠物防守阵容
-record(db_pet_pos_def, {
	player_id = 0,
	func_id = 0,        %% 功能id
	type = 0,           %% 类型
	pos = 0,            %% 位置
	uid = 0             %% 宠物uid
}).

%% 宠物大师
-record(db_pet_master, {
	player_id = 0,   %% 玩家id
	lv = 0           %% 等级
}).

%% 宠物抽奖
-record(db_pet_draw, {
	player_id = 0,       %% 玩家id
	id = 0,              %% 抽奖ID
	free_time = 0,       %% 下一次可以免费召唤时间
	draw_time = 0,       %% 抽奖总次数
	day_time = 0,        %% 今日抽奖次数
	uncrit_time = 0,     %% 未保底次数
	element_time = 0,    %% 元素切换次数
	wish = [],           %% 心愿宠物  [{Type, PetCfgId}]
	count_time = [],     %% 根据类型保底次数
	spec_time = []       %% 类型和条件库累计次数
}).
%% 英雄塔首杀
-record(db_career_tower_first_kill, {
	tower_id = 0,
	layer = 0,
	player_id = 0,
	pet_list = [],
	time = 0,
	battle_value = 0,
	player_level = 0
}).

%% 圣物
-record(db_relic, {
	player_id,        %% 玩家ID
	relic_id,        %% 圣物ID
	level,            %% 等级
	grade_lv,        %% 品级
	awaken_lv,        %% 觉醒等级
	awaken_skill,    %% 觉醒技能
	break_lv         %% 突破技能
}).

%%%% 英雄装备
%%-record(db_bless_eq, {
%%	player_id = 0,      %% 玩家id
%%	uid = 0,            %% 配饰uid
%%	cfg_id = 0,         %% 配置id
%%	bind = 0,           %% 绑定状态
%%	int_lv = 0,         %% 强化等级
%%	rand_prop = [],     %% 极品属性
%%	base_bind = 0       %% 原始绑定状态
%%}).
%%
%%%% 英雄装备部位
%%-record(db_bless_eq_pos, {
%%	player_id = 0,      %% 玩家id
%%	uid = 0,            %% 英雄uid
%%	pos = 0,            %% 部位
%%	stage =0,						%% 阶段数
%%	battle_pos = 0 ,		%% 出战位置
%%	cast_time = 0,      %% 淬炼次数
%%	cast_prop = [],     %% 淬炼属性
%%	cast_prop_temp = [] %% 淬炼属性(保留)
%%}).


-endif.        %% -ifndef























