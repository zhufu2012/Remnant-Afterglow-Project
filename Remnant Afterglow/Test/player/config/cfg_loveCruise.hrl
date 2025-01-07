-ifndef(cfg_loveCruise_hrl).
-define(cfg_loveCruise_hrl, true).

-record(loveCruiseCfg, {
	%% 作者:
	%% 巡游id
	iD,
	name,
	%% 新郎默认坐骑id|坐骑星数
	maleMountID,
	%% 作者:
	%% 坐骑坐标x|坐骑坐标z|朝向|相对新娘婚车的左右位移（右为正）|相对新娘婚车的前后位移（前为正）
	maleMount,
	%% 作者:
	%% 新娘婚车载具id,载具坐标x，载具坐标z，朝向
	femaleCar,
	%% 作者:
	%% 牛车载具id,阵型位置x坐标,阵型位置z坐标,牛车朝向,相对新娘婚车的左右位移（右为正）,相对新娘婚车的前后位移（前为正）
	oxcart,
	%% 作者:
	%% NPC阵型：npcid,x坐标,z坐标,朝向,相对新娘婚车的左右位移（右为正）,相对新娘婚车的前后位移（前为正）
	nPC,
	%% 作者:
	%% npc出生位置和朝向
	nPCBorn,
	%% 作者:
	%% npc出生后移动的位置
	nPCWayPoint,
	%% 作者:
	%% npc出生CD时间
	%% （秒）
	nPC_CD,
	%% 作者:
	%% 婚礼新郎新娘的变身，需要的对应职业和性别的变身buffid
	%% {职业id，性别，buffid}
	%% 主角角色ID
	%% 1004、战士
	%% 1005、法师
	%% 1006、弓箭手
	%% 1007、魔剑士
	%% 性别：0男1女
	weddingBuffID,
	%% 作者:
	%% 游行时，婚车的路点
	%% {地图id,路点id,路点id,路点id… …}
	moveWayPoint,
	%% 婚车结束点|触发喊话ID
	endPoint,
	%% 作者:
	%% 巡游音乐
	cruiseMusic,
	%% 掉落的采集物ID|每次掉落波数|掉落波数间隔（毫秒）|到达触发掉宝箱的路点时暂停的时间（毫秒）
	cruiseBox,
	%% 掉落的宝箱数量
	%% 判断条件类型：
	%% 1牛车损坏
	%% 条件参数：损坏牛车数量
	%% 宝箱数量：每次掉落的宝箱总数
	boxNum,
	%% 游行时婚车宝箱的掉落范围
	%% {百分比,圆环小圈，圆环大圈}
	dropRange,
	%% 游行时婚车的宝箱掉落触发
	%% 地图id，婚车路点
	boxPoint,
	%% 作者:
	%% 宝箱掉落
	%% {概率权值,奖励类型,参数1,参数2}
	%% 概率权值：
	%% 按权值随机奖励
	%% 奖励类型：
	%% 1为物品,参数1:道具ID,参数2：道具数量
	%% 2位货币,参数1：货币类型,参数2：货币数量
	boxAward,
	%% 作者:
	%% 单次游行最多采集次数
	boxLimit,
	%% 巡游开始时触发的MonsterTalkID|车队出发时的MonsterTalkID
	startTalk,
	%% 婚车到达路点触发的boss说话
	%% {地图id,路点id,MonsterTalkID}
	wayPointTalk,
	%% 作者:
	%% 烟花特效|音效
	fW_VFX,
	%% 播放烟花间隔时间（毫秒）|播放烟花概率
	fW_Param,
	%% 播放烟花的序列：
	%% 播放触发时间（毫秒）,相对新娘婚车的左右位移（右为正）,相对新娘婚车的前后位移（前为正）
	fW_Param2,
	%% 掉落的小采集物ID|每次触发掉落个数min|每次触发掉落个数max
	cruiseBox2,
	%% 游行时触发婚车掉小宝箱的路点
	%% 地图id，婚车路点
	boxPoint2
}).

-endif.
