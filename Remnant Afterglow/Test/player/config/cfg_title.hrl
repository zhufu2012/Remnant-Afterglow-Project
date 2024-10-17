-ifndef(cfg_title_hrl).
-define(cfg_title_hrl, true).

-record(titleCfg, {
	%% 称号ID
	iD,
	%% 称号类型
	%% 0.代币不限制称号类型，其他代表对应玩法获得
	%% 1.竞技场称号
	%% 2.战斗力排行称号
	%% 3.诛仙击杀玩家称号
	%% 4.诛仙击杀BOSS称号
	%% 5.活动称号
	%% 6.领地称号
	%% 7.修罗战场称号
	%% 8.麒麟洞称
	%% 9.跨服称号
	%% 10.仙侣奇缘仙侣战力排行榜
	%% 11.仙侣发红包排行榜
	%% 12.宾客送礼周榜
	%% 13.仙侣收贺礼排行榜
	%% 14.举办皇家婚礼排行榜
	%% 15.宾客送礼总榜
	%% 16.魅力榜称号
	%% 17.守护榜称号
	%% 18.仙侣2V2排行榜
	type,
	%% 排名
	%% 战斗力排名
	%% 竞技场排名
	%% {凡人榜，名次，名次}
	%% {1,500,200}表示，凡人榜500-200名
	%% 1.凡人榜
	%% 2.圣人榜
	%% 3.玄仙榜
	%% 4.金仙榜
	%% 5.帝仙榜
	%% 6.天尊帮
	ranking,
	%% 作者:
	%% 弹幕显示与否？
	%% 0=不显示
	%% 1=显示
	danmuShow,
	%% 称号名字（改到文字表）
	%% TitlTNameN，N为称号ID
	name,
	%% 激活条件：
	%% 客户端称号显示激活条件
	%% TitleConditionN，N为成就ID
	condition,
	%% 当该称号ID存在时，本称号的激活属性不生效
	%% 激活属性字段：Attribute
	%% 配0则为不受其他称号存在影响激活属性
	cancelAttribute,
	%% 头顶图
	icon,
	%% 聊天图
	icon1,
	%% 称号激活属性
	%% {附加属性ID，附加值}
	attribute,
	%% 称号佩戴属性
	%% {附加属性ID，附加值}
	%% “具备时效的称号，附带属性消失，激活属性也会同步消失”
	attribute_act,
	%% 显示优先级（从上至下1.2.3.4）
	%% 1.最上层
	%% 2.第二层
	%% 3.第三层
	%% 4.第四层
	showDown,
	%% 膜拜
	%% 1.主角经验
	%% 2.仙盟贡献
	%% 3.铜币
	%% 4.元宝
	worship,
	%% 填写UI上对应的图片名
	uiphoto,
	%% 作者:
	%% 在hud底层默认会显示称号的地图上无论什么情况下一定要显示的称号标示
	%% 1 一定显示
	%% 0 不用
	%% 先判断这里为1的就不管后面neverShow，为0的再去判断后面
	mustShow,
	%% 0.不显示
	%% 1.名人称号
	%% 2.成就称号
	%% 3.排名称号
	%% 4.情侣称号
	%% 5.活动称号
	%% TitlTagLibN，N为称号分类ID
	tagLib,
	%% 作者:
	%% 所需成就客户端ID
	attainIndex,
	%% 作者:
	%% 在hud底层默认显示称号的底图
	%% 填写了内容的就是默认不显示的称号
	%% 101|102|103  标示在在这几个地图默认隐藏
	%% 填0，的如果MustShow为1，那么就保持一直显示
	%% 在三界里面有一个称号显示开关，控制的就是mustshow=0，nevershow=0的
	neverShow,
	%% 作者:是否需要公告
	needNotice,
	%% 作者:
	%% 道具品质
	%% 0白1蓝2紫3橙4红5粉6赤金5幻彩
	character,
	%% 称号时效
	%% 填0代表永久
	%% 非0填小时数
	%%  
	%% 限时称号重复获得时，叠加时间
	timeLimit,
	%% 永久称号重复获得时，分解成货币
	%% (货币类型，货币数量)
	%% 限时称号重复获得时，该字段无效
	recount,
	%% 称号分组
	%% 不同组称号可以共存，同一组称号需要按照优先级进行替换
	%% 优先级2>1
	titleGroup,
	%% D2X新增称号时效：
	%% 1.普通时效类
	%% 2.刷新时效类
	refreshType,
	%% 替换优先级
	%% 激活新称号后三个角色佩戴的称号进行判断，优先替换掉优先级低的，如果三角色佩戴的称号优先级都大于等于新获得称号，则不替换
	replaceOrder,
	%% 补发邮件类型
	%% 1、时效过期补发邮件
	%% 2、被顶替补发邮件
	%% 填0则代表无顶替邮件
	mail,
	%% 补发邮件内容
	%% 填0表示无邮件
	mailText
}).

-endif.