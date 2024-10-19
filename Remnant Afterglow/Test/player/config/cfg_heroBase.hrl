-ifndef(cfg_heroBase_hrl).
-define(cfg_heroBase_hrl, true).

-record(heroBaseCfg, {
	%% 英雄id
	iD,
	%% 英雄碎片ID
	pieceID,
	%% 碎片稀有度
	%% 0为A
	%% 1为S
	%% 2为SS
	pieceType,
	%% 可被赠送的数量上限
	beGivenTimes,
	%% 每次赠送可送多少个，对应会扣除相同的碎片
	givenNum,
	%% 赠送成功后获得的奖励货币类型,数量
	%% 货币类型
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	rewards,
	%% 是否可许愿
	%% 0不可
	%% 1可以
	isWish,
	%% 名字
	name,
	%% 可赠送碎片
	%% 所需该英雄星级
	givenNeedStar,
	%% 主界面UI模型缩放及相关位置参数
	%% 获得界面在model表中配置
	modelUIScale,
	%% 主界面UI模型缩放及相关位置参数
	%% 获得界面在model表中配置
	modelUIPositionX,
	%% 主界面UI模型缩放及相关位置参数
	%% 获得界面在model表中配置
	modelUIPositionY,
	%% 主界面UI模型缩放及相关位置参数
	%% 获得界面在model表中配置
	modelUIPositionZ,
	%% 主界面UI模型缩放及相关位置参数
	%% 获得界面在model表中配置
	modelUIRotationX,
	%% 主界面UI模型缩放及相关位置参数
	%% 获得界面在model表中配置
	modelUIRotationY,
	%% 主界面UI模型缩放及相关位置参数
	%% 获得界面在model表中配置
	modelUIRotationZ
}).

-endif.
