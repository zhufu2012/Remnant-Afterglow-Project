-ifndef(cfg_versionNotice1_hrl).
-define(cfg_versionNotice1_hrl, true).

-record(versionNotice1Cfg, {
	iD,
	%% 主界面入口图标
	%% ·不读取功能开启表的图标
	%% ·触发新的功能预览后，5点刷新时，如果新的功能预览没有关闭，就用新的预览的入口图标.
	%% 例如：
	%% 触发了先触发了【玩法1预告】，后又触发了【玩法2预告】，如果【玩法2预告】没有关闭，那么5点重置时就改为显示【玩法2预告】的入口图标.
	icon,
	%% 图片ID
	pic,
	%% 触发个人功能预览的条件
	%% （组号，条件类型，参数1，参数2，参数3，参数4）
	%% 组号：同一组的必须同时满足才达成，不同组的只要满足其中一组就算达成；
	%% 类型=1表示：等级达到，参数1=等级，参数2、3、4=0；
	%% 类型=2表示：开启功能，参数1=功能开启ID，参数2、3、4=0；
	%% 类型=3表示：完成转生，参数1=转生数，参数2、3、4=0；
	%% 类型=4表示：通关主线关卡，参数1=关卡ID，参数2、3、4=0；
	%% 类型=5表示：接取任务，参数1=任务ID，参数2、3、4=0；
	%% 类型=6表示：完成任务，参数1=任务ID，参数2、3、4=0；
	condition,
	%% 触发个人功能预览，单个预告图片，达到某个条件后单独关闭，关闭条件：
	%% （组号，条件类型，参数1，参数2，参数3，参数4）
	%% 组号：同一组的必须同时满足才达成，不同组的只要满足其中一组就算达成；
	%% 类型=1表示：等级达到，参数1=等级，参数2、3、4=0；
	%% 类型=2表示：开启功能，参数1=功能开启ID，参数2、3、4=0；
	%% 类型=3表示：完成转生，参数1=转生数，参数2、3、4=0；
	%% 类型=4表示：通关主线关卡，参数1=关卡ID，参数2、3、4=0；
	%% 类型=5表示：接取任务，参数1=任务ID，参数2、3、4=0；
	%% 类型=6表示：完成任务，参数1=任务ID，参数2、3、4=0；
	picClose,
	%% 领奖后是否不再预告：
	%% 0：已领取奖励则不再弹出
	%% 1：每次登录正常弹出
	typeID,
	%% banner图中的文字1
	bannerText1,
	%% 英文
	bannerText1_EN,
	%% 印尼
	bannerText1_IN,
	%% 泰语
	bannerText1_TH,
	%% RU
	bannerText1_RU,
	%% FR
	bannerText1_FR,
	%% GE
	bannerText1_GE,
	%% TR
	bannerText1_TR,
	%% SP
	bannerText1_SP,
	%% PT
	bannerText1_PT,
	%% KR
	bannerText1_KR,
	%% TW
	bannerText1_TW,
	%% 程序字1位置
	%% {PositionX,PositionY,PositionZ,文字对齐方式}
	%% 文字对齐方式：UpperLeft = 0,UpperCenter = 1,UpperRight = 2,MiddleLeft = 3,
	%% MiddleCenter = 4,MiddleRight = 5,LowerLeft = 6,LowerCenter = 7,LowerRight = 8
	imageText1,
	%% banner图中的文字2
	bannerText2,
	%% 英文
	bannerText2_EN,
	%% 印尼
	bannerText2_IN,
	%% 泰语
	bannerText2_TH,
	%% RU
	bannerText2_RU,
	%% FR
	bannerText2_FR,
	%% GE
	bannerText2_GE,
	%% TR
	bannerText2_TR,
	%% SP
	bannerText2_SP,
	%% PT
	bannerText2_PT,
	%% KR
	bannerText2_KR,
	%% TW
	bannerText2_TW,
	%% 程序字2位置
	%% {PositionX,PositionY,PositionZ,文字对齐方式}
	%% 文字对齐方式：UpperLeft = 0,UpperCenter = 1,UpperRight = 2,MiddleLeft = 3,
	%% MiddleCenter = 4,MiddleRight = 5,LowerLeft = 6,LowerCenter = 7,LowerRight = 8
	imageText2,
	%% banner图中的文字2
	bannerText3,
	%% 英文
	bannerText3_EN,
	%% 印尼
	bannerText3_IN,
	%% 泰语
	bannerText3_TH,
	%% RU
	bannerText3_RU,
	%% FR
	bannerText3_FR,
	%% GE
	bannerText3_GE,
	%% TR
	bannerText3_TR,
	%% SP
	bannerText3_SP,
	%% PT
	bannerText3_PT,
	%% KR
	bannerText3_KR,
	%% TW
	bannerText3_TW,
	%% 程序字3位置
	%% {PositionX,PositionY,PositionZ,文字对齐方式}
	%% 文字对齐方式：UpperLeft = 0,UpperCenter = 1,UpperRight = 2,MiddleLeft = 3,
	%% MiddleCenter = 4,MiddleRight = 5,LowerLeft = 6,LowerCenter = 7,LowerRight = 8
	imageText3
}).

-endif.
