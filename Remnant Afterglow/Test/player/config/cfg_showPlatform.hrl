-ifndef(cfg_showPlatform_hrl).
-define(cfg_showPlatform_hrl, true).

-record(showPlatformCfg, {
	%% 作者:
	%% 展示平台
	%% 1、翅膀主界面
	%% 2、坐骑主界面
	%% 3、宠物主界面
	%% 4、背包主界面
	%% 5、强化主界面
	%% 6、怪物模型
	%% 7、通用模型
	%% 8、龙神武器界面
	%% 9、龙神秘典界面
	%% 10、守护主界面
	%% 11、圣物主界面
	%% 12、精英副本主界面
	%% 13、云购界面
	%% 101、翅膀获得界面
	%% 102、坐骑获得界面
	%% 103、宠物获得界面
	%% 104、龙神获得界面
	%% 105、圣物获得界面
	%% 106、精灵龙神获得界面
	%% 107、龙神武器获得界面
	%% 108、龙神秘典获得界面
	%% 201、翅膀预览界面
	%% 202、坐骑预览界面
	%% 203、宠物预览界面
	%% 204、强化预览界面（读取强化界面参数）
	%% 205、龙神预览界面
	%% 206、圣物预览界面
	%% 301、翅膀飞翼界面
	%% 401、翅膀灵翼界面
	%% 402、坐骑兽灵界面
	%% 403、宠物魔灵界面
	%% 404、竞技场/1V1结算界面
	%% 406、海神套装界面
	iD,
	%% 0为无
	%% 1为模型
	%% 2为图片
	type,
	%% 资源地址
	typePara,
	%% 界面平台缩放
	%% 主界面在model表中配置
	%% 缩放值最好一样，否则IOS会有异常
	modelUIScaleX,
	modelUIScaleY,
	modelUIScaleZ,
	%% 平台模型位置
	%% 主界面在model表中配置
	modelUIPositionX,
	%% 平台模型位置
	%% 主界面在model表中配置
	modelUIPositionY,
	%% 平台模型位置
	%% 主界面在model表中配置
	modelUIPositionZ,
	%% 平台模型选择
	%% 主界面在model表中配置
	modelUIRotationX,
	%% 平台模型选择
	%% 主界面在model表中配置
	modelUIRotationY,
	%% 平台模型选择
	%% 主界面在model表中配置
	modelUIRotationZ,
	%% AutoBVT:
	%% 台子是够跟随模型旋转
	%% 0.不旋转
	%% 1.旋转
	modelUIfollow
}).

-endif.
