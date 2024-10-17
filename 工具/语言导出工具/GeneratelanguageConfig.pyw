import json
import read_xlsm
import os


##删除对应文件夹下所有文件
def del_file(path):
    if not os.listdir(path):
        print('目录已为空！')
    else:
        for i in os.listdir(path):
            path_file = os.path.join(path, i)  # 取文件绝对路径
            print("删除语言配置：" + path_file)
            if os.path.isfile(path_file):
                os.remove(path_file)
            else:
                del_file(path_file)
                shutil.rmtree(path_file)


languages_export = {
    "zh_cn": 4,  ##简体中文
    "en_us": 5,  ##英语(美国)
    # "in_id": 4,     ##印尼
    # "th_th": 5,     ##泰语
    # "eu_ru": 6,     ##俄语
    # "eu_fr": 7,     ##法语
    # "eu_ge": 8,     ##德语
    # "eu_tr": 9,     ##土耳其语
    # "eu_sp": 10,    ##西班牙语
    # "eu_pt": 11,    ##葡萄牙语
    # "ko_kr": 12,    ##韩语
    # "zh_tw": 13,    ##繁体中文
    # "ja_jp": 14,    ##日语
    # "time": 15,
    # "type": 16,
}
languages_table_name = []
define_path = r""
#define_path = r"."
dicts = read_xlsm.read_text_all(define_path + r"./语言.xls")
json_dict = {}

for table_name, item_list in dicts.items():
    result = {}
    for item in item_list:
        if item[1] == 1:  ##1 导出  0不导出
            languages = {}
            for key, value in languages_export.items():
                languages[key] = item[value]
            result[item[2]] = {"languages": languages}
        if item[1] == 2:  # 最后一行导出
            languages = {}
            for key, value in languages_export.items():
                languages[key] = item[value]
            result[item[2]] = {"languages": languages}
            break
    json_text = json.dumps(result, indent=4, ensure_ascii=False)
    json_dict[table_name] = json_text

del_file("./语言导出工具/data/")

for table_name, jsonstr in json_dict.items():
    # 打开文件进行写入，如果文件不存在则创建文件
    with open("./语言导出工具/data/language_" + table_name + '.json', 'w', encoding='utf-8') as file:
        file.write(jsonstr)
    languages_table_name.append({"file_name": table_name,
                                 "file_path": "./data/language/data/language_" + table_name + '.json'})
    print(table_name + " 已重新导出！")

##生成语言配置文件
languages_table_name_text = json.dumps({"language_files": languages_table_name}, indent=4, ensure_ascii=False)
with open("./语言导出工具/file_name.json", 'w', encoding='utf-8') as file:
    file.write(languages_table_name_text)
