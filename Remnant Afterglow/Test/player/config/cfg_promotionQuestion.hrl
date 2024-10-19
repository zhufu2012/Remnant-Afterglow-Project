-ifndef(cfg_promotionQuestion_hrl).
-define(cfg_promotionQuestion_hrl, true).

-record(promotionQuestionCfg, {
	%% 题目ID
	iD,
	%% 题目分类
	%% 1、单选题
	%% 2、多选题
	%% 3、问答题
	type,
	%% 类型参数
	%% 类型=1/2时，为最多有几个选项
	%% 其他类型暂时用不到
	parameter,
	%% 选项是否随机
	%% 0选项按顺序出现
	%% 1选项每次会随机排序
	random,
	%% 题目
	subject,
	%% 题目_EN
	subject_EN,
	%% 题目_IN
	subject_IN,
	%% 题目_TH
	subject_TH,
	%% RU
	subject_RU,
	%% FR
	subject_FR,
	%% GE
	subject_GE,
	%% TR
	subject_TR,
	%% SP
	subject_SP,
	%% PT
	subject_PT,
	%% KR
	subject_KR,
	%% TW
	subject_TW,
	%% JP
	subject_JP,
	%% 答案1
	answer1,
	%% EN
	answer1_EN,
	%% IN
	answer1_IN,
	%% TH
	answer1_TH,
	%% RU
	answer1_RU,
	%% FR
	answer1_FR,
	%% GE
	answer1_GE,
	%% TR
	answer1_TR,
	%% SP
	answer1_SP,
	%% PT
	answer1_PT,
	%% KR
	answer1_KR,
	%% TW
	answer1_TW,
	%% JP
	answer1_JP,
	%% 答案2
	answer2,
	%% EN
	answer2_EN,
	%% IN
	answer2_IN,
	%% TH
	answer2_TH,
	%% RU
	answer2_RU,
	%% FR
	answer2_FR,
	%% GE
	answer2_GE,
	%% TR
	answer2_TR,
	%% SP
	answer2_SP,
	%% PT
	answer2_PT,
	%% KR
	answer2_KR,
	%% TW
	answer2_TW,
	%% JP
	answer2_JP,
	%% 答案
	answer3,
	%% EN
	answer3_EN,
	%% IN
	answer3_IN,
	%% TH
	answer3_TH,
	%% RU
	answer3_RU,
	%% FR
	answer3_FR,
	%% GE
	answer3_GE,
	%% TR
	answer3_TR,
	%% SP
	answer3_SP,
	%% PT
	answer3_PT,
	%% KR
	answer3_KR,
	%% TW
	answer3_TW,
	%% JP
	answer3_JP,
	%% 答案
	answer4,
	%% EN
	answer4_EN,
	%% IN
	answer4_IN,
	%% TH
	answer4_TH,
	%% RU
	answer4_RU,
	%% FR
	answer4_FR,
	%% GE
	answer4_GE,
	%% TR
	answer4_TR,
	%% SP
	answer4_SP,
	%% PT
	answer4_PT,
	%% KR
	answer4_KR,
	%% TW
	answer4_TW,
	%% JP
	answer4_JP,
	%% 答案
	answer5,
	%% EN
	answer5_EN,
	%% IN
	answer5_IN,
	%% TH
	answer5_TH,
	%% RU
	answer5_RU,
	%% FR
	answer5_FR,
	%% GE
	answer5_GE,
	%% TR
	answer5_TR,
	%% SP
	answer5_SP,
	%% PT
	answer5_PT,
	%% KR
	answer5_KR,
	%% TW
	answer5_TW,
	%% JP
	answer5_JP,
	%% 答案
	answer6,
	%% EN
	answer6_EN,
	%% IN
	answer6_IN,
	%% TH
	answer6_TH,
	%% RU
	answer6_RU,
	%% FR
	answer6_FR,
	%% GE
	answer6_GE,
	%% TR
	answer6_TR,
	%% SP
	answer6_SP,
	%% PT
	answer6_PT,
	%% KR
	answer6_KR,
	%% TW
	answer6_TW,
	%% JP
	answer6_JP,
	%% 答案
	answer7,
	%% EN
	answer7_EN,
	%% IN
	answer7_IN,
	%% TH
	answer7_TH,
	%% RU
	answer7_RU,
	%% FR
	answer7_FR,
	%% GE
	answer7_GE,
	%% TR
	answer7_TR,
	%% SP
	answer7_SP,
	%% PT
	answer7_PT,
	%% KR
	answer7_KR,
	%% TW
	answer7_TW,
	%% JP
	answer7_JP,
	%% 答案
	answer8,
	%% EN
	answer8_EN,
	%% IN
	answer8_IN,
	%% TH
	answer8_TH,
	%% RU
	answer8_RU,
	%% FR
	answer8_FR,
	%% GE
	answer8_GE,
	%% TR
	answer8_TR,
	%% SP
	answer8_SP,
	%% PT
	answer8_PT,
	%% KR
	answer8_KR,
	%% TW
	answer8_TW,
	%% JP
	answer8_JP,
	%% 答案
	answer9,
	%% EN
	answer9_EN,
	%% IN
	answer9_IN,
	%% TH
	answer9_TH,
	%% RU
	answer9_RU,
	%% FR
	answer9_FR,
	%% GE
	answer9_GE,
	%% TR
	answer9_TR,
	%% SP
	answer9_SP,
	%% PT
	answer9_PT,
	%% KR
	answer9_KR,
	%% TW
	answer9_TW,
	%% JP
	answer9_JP,
	%% 答案
	answer10,
	%% EN
	answer10_EN,
	%% IN
	answer10_IN,
	%% TH
	answer10_TH,
	%% RU
	answer10_RU,
	%% FR
	answer10_FR,
	%% GE
	answer10_GE,
	%% TR
	answer10_TR,
	%% SP
	answer10_SP,
	%% PT
	answer10_PT,
	%% KR
	answer10_KR,
	%% TW
	answer10_TW,
	%% JP
	answer10_JP,
	%% 答案
	answer11,
	%% EN
	answer11_EN,
	%% IN
	answer11_IN,
	%% TH
	answer11_TH,
	%% RU
	answer11_RU,
	%% FR
	answer11_FR,
	%% GE
	answer11_GE,
	%% TR
	answer11_TR,
	%% SP
	answer11_SP,
	%% PT
	answer11_PT,
	%% KR
	answer11_KR,
	%% TW
	answer11_TW,
	%% JP
	answer11_JP,
	%% 答案
	answer12,
	%% EN
	answer12_EN,
	%% IN
	answer12_IN,
	%% TH
	answer12_TH,
	%% RU
	answer12_RU,
	%% FR
	answer12_FR,
	%% GE
	answer12_GE,
	%% TR
	answer12_TR,
	%% SP
	answer12_SP,
	%% PT
	answer12_PT,
	%% KR
	answer12_KR,
	%% TW
	answer12_TW,
	%% JP
	answer12_JP,
	%% 答案
	answer13,
	%% EN
	answer13_EN,
	%% IN
	answer13_IN,
	%% TH
	answer13_TH,
	%% RU
	answer13_RU,
	%% FR
	answer13_FR,
	%% GE
	answer13_GE,
	%% TR
	answer13_TR,
	%% SP
	answer13_SP,
	%% PT
	answer13_PT,
	%% KR
	answer13_KR,
	%% TW
	answer13_TW,
	%% JP
	answer13_JP,
	%% 答案
	answer14,
	%% EN
	answer14_EN,
	%% IN
	answer14_IN,
	%% TH
	answer14_TH,
	%% RU
	answer14_RU,
	%% FR
	answer14_FR,
	%% GE
	answer14_GE,
	%% TR
	answer14_TR,
	%% SP
	answer14_SP,
	%% PT
	answer14_PT,
	%% KR
	answer14_KR,
	%% TW
	answer14_TW,
	%% JP
	answer14_JP,
	%% 答案
	answer15,
	%% EN
	answer15_EN,
	%% IN
	answer15_IN,
	%% TH
	answer15_TH,
	%% RU
	answer15_RU,
	%% FR
	answer15_FR,
	%% GE
	answer15_GE,
	%% TR
	answer15_TR,
	%% SP
	answer15_SP,
	%% PT
	answer15_PT,
	%% KR
	answer15_KR,
	%% TW
	answer15_TW,
	%% JP
	answer15_JP
}).

-endif.
