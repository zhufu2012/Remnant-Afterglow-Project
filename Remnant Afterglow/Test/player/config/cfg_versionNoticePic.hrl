-ifndef(cfg_versionNoticePic_hrl).
-define(cfg_versionNoticePic_hrl, true).

-record(versionNoticePicCfg, {
	%% 预告图ID
	iD,
	num,
	index,
	%% 图片ID
	pic,
	%% 作者:
	%% 奖励物品 一组活动中，只会发放一个奖励，多个图片不会发放多个
	%% {序号，职业，类型，ID，数量，品质，星级，是否绑定，是否显示转圈特效}
	%% 序号，从1开始，选择性，序号填不一样的
	%% 职业:
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	%% 是否显示转圈特效：1.显示  0.不显示
	%% 做好后“coin、item”两字字段删除
	itemNew,
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
	%% JP
	bannerText1_JP,
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
	%% JP
	bannerText2_JP,
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
	%% JP
	bannerText3_JP,
	%% 程序字3位置
	%% {PositionX,PositionY,PositionZ,文字对齐方式}
	%% 文字对齐方式：UpperLeft = 0,UpperCenter = 1,UpperRight = 2,MiddleLeft = 3,
	%% MiddleCenter = 4,MiddleRight = 5,LowerLeft = 6,LowerCenter = 7,LowerRight = 8
	imageText3
}).

-endif.
