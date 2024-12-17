-ifndef(cfg_monsterAttr_hrl).
-define(cfg_monsterAttr_hrl, true).

-record(monsterAttrCfg, {
	%% 等级：
	%% 寻找第1个大于等于指定等级n为N行
	%% 若N=1,那属性就是第一行
	%% 若没有比他大的,就取最大行
	%% 否则,属性为N与N-1中平均到每等级中n级的属性
	%% 例如：N=11行,ID1=20,n=17
	%% Attr1={2,900}|{14,100}|{15,10}
	%% N=10行,ID2=15,
	%% Attr2={2,450}|{14,50}|{15,5}
	%% 属性：(Attr1-Attr2)/(ID1-ID2)*(n-ID2)+Attr2
	%%       {2,630}|{14,70}|{15,7}
	iD,
	%% 注意：该表可以往后扩充,同种内容程序不需要处理;
	%% 若在前面插入程序需要处理
	%% 前端：前5个生效
	%% 第一类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara1,
	%% 第1类：属性列
	%% 普通小怪
	attrBase1,
	%% 第2类
	%% 怪物其他参数
	%% (战斗力,血管数)
	%% 剧情boss
	monsterPara2,
	%% 第2类：属性列
	attrBase2,
	%% 第3类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara3,
	%% 第3类：属性列
	attrBase3,
	%% 第4类
	%% 怪物其他参数
	%% (战斗力,血管数)
	%% 精英小怪
	monsterPara4,
	%% 第4类：属性列
	attrBase4,
	%% 第5类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara5,
	%% 第5类：属性列
	attrBase5,
	%% 第6类精英本
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara6,
	%% 第6类：属性列
	attrBase6,
	%% 第7类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara7,
	%% 第7类：属性列
	attrBase7,
	%% 第8类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara8,
	%% 第8类：属性列
	attrBase8,
	%% 第9类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara9,
	%% 第9类：属性列
	attrBase9,
	%% 第10类固伤Boss
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara10,
	%% 第10类固伤Boss
	%% 属性列
	attrBase10,
	%% 第11类固伤小怪
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara11,
	%% 第11类固伤小怪
	attrBase11,
	%% 第12类
	monsterPara12,
	%% 第12类属性
	attrBase12,
	%% 第13类
	monsterPara13,
	%% 第13类属性
	attrBase13,
	%% 第14类
	monsterPara14,
	%% 第14类属性
	attrBase14,
	%% 第15类
	monsterPara15,
	%% 第15类属性
	%% 法老宝库
	attrBase15,
	%% 第16类
	monsterPara16,
	%% 第16类属性
	attrBase16,
	%% 第17类
	monsterPara17,
	%% 第17类属性
	attrBase17,
	%% 第18类
	monsterPara18,
	%% 第18类属性
	attrBase18,
	%% 第19类
	monsterPara19,
	%% 第19类属性
	attrBase19,
	%% 第20类
	monsterPara20,
	%% 第20类属性
	%% 勇者试炼第1-6波
	attrBase20,
	%% 第21类
	monsterPara21,
	%% 第21类属性
	attrBase21,
	%% 第22类
	monsterPara22,
	%% 第22类属性
	%% 诅咒禁地
	attrBase22,
	%% 第23类
	monsterPara23,
	%% 第23类属性
	attrBase23,
	%% 第24类
	monsterPara24,
	%% 第24类属性
	attrBase24,
	%% 第25类
	monsterPara25,
	%% 第25类属性
	attrBase25,
	%% 第26类
	monsterPara26,
	%% 第26类属性
	%% 勇者试炼第7波
	attrBase26,
	%% 第27类
	monsterPara27,
	%% 第27类属性
	%% 封印副本小怪
	attrBase27,
	%% 第28类
	monsterPara28,
	%% 第28类属性
	%% 封印副本精英怪
	attrBase28,
	%% 第29类
	monsterPara29,
	%% 第29类属性
	%% 封印副本boss
	attrBase29,
	%% 第30类
	%% （战斗力，血管数）
	monsterPara30,
	%% 第30类属性
	%% 商船机器人
	attrBase30,
	%% 第31类
	monsterPara31,
	%% 第31类属性
	%% 寒风森林Boss1
	attrBase31,
	%% 第32类
	monsterPara32,
	%% 第32类属性
	%% 寒风森林Boss2
	attrBase32,
	%% 第33类
	monsterPara33,
	%% 第33类属性
	%% 寒风森林Boss3
	attrBase33,
	%% 第34类
	monsterPara34,
	%% 第34类属性
	%% 寒风森林小怪
	attrBase34,
	%% 第35类
	monsterPara35,
	%% 第35类属性
	%% 主线精英boss
	attrBase35,
	%% 第36类
	monsterPara36,
	%% 第36类属性
	attrBase36,
	%% 第37类
	monsterPara37,
	%% 第37类属性
	%% 主线大boss
	attrBase37,
	%% 第38类
	monsterPara38,
	%% 第38类属性
	%% 勇者试炼第8波
	attrBase38,
	%% 第39类
	monsterPara39,
	%% 第39类属性
	attrBase39,
	%% 第40类
	monsterPara40,
	%% 第40类属性
	attrBase40,
	%% 第41类
	monsterPara41,
	%% 第41类属性
	%% 勇者试炼第9波
	attrBase41,
	%% 第42类
	monsterPara42,
	%% 第42类属性
	attrBase42,
	%% 第43类
	monsterPara43,
	%% 第43类属性
	%% 翅膀副本boss2
	attrBase43,
	%% 第44类
	monsterPara44,
	%% 第44类属性
	%% 翅膀副本boss3
	attrBase44,
	%% 第45类
	monsterPara45,
	%% 第45类属性
	%% 领地战相关所有属性
	attrBase45,
	%% 第46类
	monsterPara46,
	%% 第46类属性
	attrBase46,
	%% 第47类
	monsterPara47,
	%% 第47类属性
	attrBase47,
	%% 第48类
	monsterPara48,
	%% 第48类属性
	%% 法老宝库精英非boss
	attrBase48,
	%% 第49类
	monsterPara49,
	%% 第49类属性
	attrBase49,
	%% 第50类
	monsterPara50,
	%% 第50类属性
	attrBase50,
	%% 第51类
	monsterPara51,
	%% 第51类属性
	%% 翅膀副本boss1
	attrBase51,
	%% 第52类
	monsterPara52,
	%% 第52类属性
	%% 勇者试炼第10波
	attrBase52,
	%% 第53类死亡森林超级boss
	monsterPara53,
	%% 第53类属性
	attrBase53,
	%% 第54类远征
	monsterPara54,
	%% 第54类属性
	attrBase54,
	%% 第55类远征
	monsterPara55,
	%% 第55类属性
	attrBase55,
	%% 第56类远征
	monsterPara56,
	%% 第56类属性
	attrBase56,
	%% 第57类远征
	monsterPara57,
	%% 第57类属性
	attrBase57,
	%% 第58类远征
	monsterPara58,
	%% 第58类属性
	attrBase58,
	%% 第59类远征
	monsterPara59,
	%% 第59类属性
	attrBase59,
	%% 第60类远征
	monsterPara60,
	%% 第60类属性
	attrBase60,
	%% 第61类远征
	monsterPara61,
	%% 第61类属性
	attrBase61,
	%% 第62类远征
	monsterPara62,
	%% 第62类属性
	attrBase62,
	%% 第63类远征
	monsterPara63,
	%% 第63类属性
	attrBase63,
	%% 第64类远征
	monsterPara64,
	%% 第64类属性
	attrBase64,
	%% 第65类远征
	monsterPara65,
	%% 第65类属性
	attrBase65,
	%% 第66类远征
	monsterPara66,
	%% 第66类属性
	attrBase66,
	%% 第67类远征
	monsterPara67,
	%% 第67类属性
	attrBase67,
	%% 第67类远征
	monsterPara68,
	%% 第68类属性
	attrBase68,
	%% 第69类远征
	monsterPara69,
	%% 边境皇城
	attrBase69,
	%% 第70类远征
	monsterPara70,
	%% 边境城墙
	attrBase70,
	%% 第71类远征
	monsterPara71,
	%% 边境堡垒&基地
	attrBase71,
	%% 第72类远征
	monsterPara72,
	%% 边境要塞
	attrBase72,
	%% 第73类远征
	monsterPara73,
	%% 边境领地
	attrBase73,
	%% 第74类神启
	monsterPara74,
	%% 神启
	attrBase74,
	%% 第75类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara75,
	%% 第75类：属性列
	%% 技能挑战的小怪
	attrBase75,
	%% 第76类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara76,
	%% 第76类：属性列
	%% 法老宝库小怪
	attrBase76,
	%% 第77类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara77,
	%% 第77类：属性列
	attrBase77,
	%% 第78类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara78,
	%% 第78类：属性列
	attrBase78,
	%% 第79类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara79,
	%% 第79类：属性列
	attrBase79,
	%% 第80类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara80,
	%% 第80类：属性列
	attrBase80,
	%% 第81类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara81,
	%% 第81类：属性列
	attrBase81,
	%% 第82类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara82,
	%% 第82类：属性列
	attrBase82,
	%% 第83类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara83,
	%% 第83类：属性列
	attrBase83,
	%% 第84类 
	%% 寒风森林1层
	monsterPara84,
	%% 第84类：属性列
	attrBase84,
	%% 第85类 
	%% 寒风森林2层
	monsterPara85,
	%% 第85类：属性列
	attrBase85,
	%% 第86类 
	%% 寒风森林2层
	monsterPara86,
	%% 第86类：属性列
	attrBase86,
	%% 第87类 
	%% 寒风森林2层
	monsterPara87,
	%% 第87类：属性列
	attrBase87,
	%% 第88类 
	%% 寒风森林2层
	monsterPara88,
	%% 第88类：属性列
	attrBase88,
	%% 第89类 
	%% 寒风森林2层
	monsterPara89,
	%% 第89类：属性列
	attrBase89,
	%% 第90类 
	%% 寒风森林2层
	monsterPara90,
	%% 第90类：属性列
	attrBase90,
	%% 第91类 
	%% 寒风森林2层
	monsterPara91,
	%% 第91类：属性列
	attrBase91,
	%% 第92类 
	%% 寒风森林2层
	monsterPara92,
	%% 第92类：属性列
	attrBase92,
	%% 第93类 
	%% 测试地图小怪
	%% （复制92，修改血量）
	monsterPara93,
	%% 第93类：属性列
	attrBase93,
	%% 第94类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara94,
	%% 第94类：属性列
	attrBase94,
	%% 第95类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara95,
	%% 第95类：属性列
	attrBase95,
	%% 第96类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara96,
	%% 第96类：属性列
	attrBase96,
	%% 第97类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara97,
	%% 第97类：属性列
	attrBase97,
	%% 第98类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara98,
	%% 第98类：属性列
	attrBase98,
	%% 第99类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara99,
	%% 第99类：属性列
	attrBase99,
	%% 第100类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara100,
	%% 第100类：属性列
	attrBase100,
	%% 第101类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara101,
	%% 第101类：属性列
	attrBase101,
	%% 第102类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara102,
	%% 第102类：属性列
	attrBase102,
	%% 第103类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara103,
	%% 第103类：属性列
	attrBase103,
	%% 第104类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara104,
	%% 第104类：属性列
	attrBase104,
	%% 第105类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara105,
	%% 第105类：属性列
	attrBase105,
	%% 第106类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara106,
	%% 第106类：属性列
	attrBase106,
	%% 第107类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara107,
	%% 第107类：属性列
	attrBase107,
	%% 第108类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara108,
	%% 第108类：属性列
	attrBase108,
	%% 第109类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara109,
	%% 第109类：属性列
	attrBase109,
	%% 第110类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara110,
	%% 第110类：属性列
	attrBase110,
	%% 第111类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara111,
	%% 第111类：属性列
	attrBase111,
	%% 第112类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara112,
	%% 第112类：属性列
	attrBase112,
	%% 第113类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara113,
	%% 第113类：属性列
	attrBase113,
	%% 第114类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara114,
	%% 第114类：属性列
	attrBase114,
	%% 第115类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara115,
	%% 第115类
	%% 怪物其他参数
	%% (战斗力,血管数)
	attrBase115,
	%% 第116类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara116,
	%% 第116类
	%% 怪物其他参数
	%% (战斗力,血管数)
	attrBase116,
	%% 第117类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara117,
	%% 第117类
	%% 怪物其他参数
	%% (战斗力,血管数)
	attrBase117,
	%% 第118类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara118,
	%% 第118类
	%% 怪物其他参数
	%% (战斗力,血管数)
	attrBase118,
	%% 第119类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara119,
	%% 第119类
	%% 怪物其他参数
	%% (战斗力,血管数)
	attrBase119,
	%% 第120类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara120,
	%% 第120类
	%% 怪物其他参数
	%% (战斗力,血管数)
	attrBase120,
	%% 第121类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara121,
	%% 第121类
	%% 怪物其他参数
	%% (战斗力,血管数)
	attrBase121,
	%% 第122类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara122,
	%% 第122类
	%% 怪物其他参数
	%% (战斗力,血管数)
	attrBase122,
	%% 第123类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara123,
	%% 第123类
	%% 怪物其他参数
	%% (战斗力,血管数)
	attrBase123,
	%% 第124类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara124,
	%% 第124类
	%% 怪物其他参数
	%% (战斗力,血管数)
	attrBase124,
	%% 第125类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara125,
	%% 第125类
	%% 怪物其他参数
	%% (战斗力,血管数)
	attrBase125,
	%% 第126类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara126,
	%% 第126类
	%% 怪物其他参数
	%% (战斗力,血管数)
	attrBase126,
	%% 第127类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara127,
	%% 第127类
	%% 怪物其他参数
	%% (战斗力,血管数)
	attrBase127,
	%% 第128类远征
	monsterPara128,
	%% 第128类属性
	attrBase128,
	%% 第129类远征
	monsterPara129,
	%% 第129类属性
	attrBase129,
	%% 第130类远征
	monsterPara130,
	%% 第130类属性
	attrBase130,
	%% 第131类远征
	monsterPara131,
	%% 第131类属性
	attrBase131,
	%% 第132类远征
	monsterPara132,
	%% 第132类属性
	attrBase132,
	%% 第133类远征
	monsterPara133,
	%% 第133类属性
	attrBase133,
	%% 第134类远征
	monsterPara134,
	%% 第134类属性
	attrBase134,
	%% 第135类远征
	monsterPara135,
	%% 第135类属性
	attrBase135,
	%% 第136类远征
	monsterPara136,
	%% 第136类属性
	attrBase136,
	%% 第137类远征
	monsterPara137,
	%% 第137类属性
	attrBase137,
	%% 第138类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara138,
	%% 第138类：属性列
	attrBase138,
	%% 第139类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara139,
	%% 第139类：属性列
	attrBase139,
	%% 第140类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara140,
	%% 第140类：属性列
	attrBase140,
	%% 第141类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara141,
	%% 第141类：属性列
	attrBase141,
	%% 第142类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara142,
	%% 第142类：属性列
	attrBase142,
	%% 第143类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara143,
	%% 第143类：属性列
	attrBase143,
	%% 第144类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara144,
	%% 第144类：属性列
	attrBase144,
	%% 第145类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara145,
	%% 第145类：属性列
	attrBase145,
	%% 第146类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara146,
	%% 第146类：属性列
	attrBase146,
	%% 第147类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara147,
	%% 第147类：属性列
	attrBase147,
	%% 第148类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara148,
	%% 第148类：属性列
	attrBase148,
	%% 第149类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara149,
	%% 第149类：属性列
	attrBase149,
	%% 第150类
	%% 怪物其他参数
	%% (战斗力,血管数)
	monsterPara150,
	%% 第150类：属性列
	attrBase150
}).

-endif.
