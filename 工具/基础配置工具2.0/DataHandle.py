import read_xlsx  ##文件读取
import Config
import TypeConversion  ##类型转换
import os
import json
import pandas as pd
import win32com.client
import ClassGenerator
import shutil
import ClassExport

isCompact = False  ##False  ##True


# region  数据处理部分
##检查某个数据及其.0 版是否在某个列表中
def check_list(list, key):
    if (key in list) or (str(key) + ".0" in list) or (str(key) in list):
        return True
    else:
        return False


##检查某个数据是否是某数据，或者其.0 版
def check_value(value, key):
    if value == key or value == (str(key) + ".0") or value == str(key):
        return True
    else:
        return False


##检测字典的键中，是否有对应target_key
def check_key_exist(dict_list, target_key):
    if dict_list is None:
        return False
    for dictionary in dict_list:
        if target_key == dictionary:
            return True
    return False


##将列数转换为列名
def number_to_column_name(n):
    result = ""
    while n > 0:
        n, remainder = divmod(n - 1, 26)
        result = chr(65 + remainder) + result
    return result


##删除对应文件夹下所有文件


##对一个xlsx文件的子表名称读取 之前的需要导出数据字典  xlsx路径   返回(子表显示名称列表，)
def OneXlsxDataHandle(NowProjectConfig, path):
    dicts, image_path = read_xlsx.read_text_all(path)
    subtable_show_name_list = [table_name for table_name in dicts if table_name.startswith("cfg_")]
    return subtable_show_name_list, image_path


##获取需要导出的列和主键列，并且注意是否有主键，和最后导出项等,返回的是需要导出的列表的列数
def GetExportRow(file_path, table_name, list):
    if len(list) < 1:
        Config.add_log(
            f"导出失败！   配置文件:[{file_path}]  子表：{table_name}  第二行没有字段导出设置，请添加字段导出设置相关数据，错误码:9")
        return None
    if not check_list(list, 1):
        Config.add_log(
            f"导出失败！   配置文件:[{file_path}]  子表：{table_name}  没有主键，请增加一个导出类型1的主键字段，错误码:1")
        return None
    if not check_list(list, 3):
        Config.add_log(
            f"导出失败！   配置文件:[{file_path}]  子表：{table_name}  没有最后导出字段，请增加一个导出类型3的最后字段，错误码:2")
        return None
    key_export_list = []  ##需要导出的主键 的列数 列表
    export_list = []  ##需要导出的键的 列数
    for index, value in enumerate(list[1:]):  ##0不导出 1导出主键  2导出  3 最后一项
        row = index + 1  ##所在列表
        if check_value(value, 0):
            continue
        elif check_value(value, 1):
            key_export_list.append(row)
            export_list.append(row)
        elif check_value(value, 2):
            export_list.append(row)
        elif check_value(value, 3):
            export_list.append(row)
            break
        else:
            pass
    return (key_export_list, export_list)


##获取需要导出的行
def GetExportLine(item_list):
    export_list = []
    line_dict = {}  ##横排要导出的位置{假行数，真行数}
    line_add = 0
    for index, item in enumerate(item_list[3:]):
        value = item[1]
        line = index + 3
        if check_value(value, 0):
            continue
        elif check_value(value, 1):
            line_dict[line_add] = line + 2
            export_list.append(line)
            line_add += 1
        elif check_value(value, 2):
            line_dict[line_add] = line + 2
            export_list.append(line)
            line_add += 1
            break
        else:
            continue

    return export_list, line_dict


##根据导出行，导出列，只获取对应行，对应列的数据
##先行后列，获取新的数据，主键位置，和键名称
def GetExportItemList(file_path, table_name, export_list_line, key_export_list_row, export_list_row, item_list):
    new_all_data = []  ##新数据

    row_dict = {}  ##纵排要导出的位置 {假纵数，真纵数}

    main_key_row = []  ##主键在新列表中的每行位置
    key_row = []  ##普通键在新列表中的每行位置
    key_name_list = ["KEY_INDEX"]  ##键列表
    key_type_list = []  ##字段类型
    key_isnull_dict = {}  ##该列数据为空是否使用默认值

    row = 0  ##假纵数
    for line, item in enumerate(item_list):
        if line in export_list_line:  ##这一排需要导出
            new_line_data = []
            for index, value in enumerate(item):
                if index in export_list_row:  ##要导出
                    new_line_data.append(value)
            new_all_data.append(new_line_data)
        elif line == 1:  ##字段名称
            for index, value in enumerate(item):
                if index in export_list_row:  ##要这列导出
                    if str(value) == "nan":  ##报错
                        Config.add_log(
                            f"导出失败！   配置文件:[{file_path}]  子表：{table_name} 第3行, 第{number_to_column_name(index)}列，不应该使用nan或者空的字段名称，错误码:4")
                        return None
                    if value in key_name_list:
                        Config.add_log(f"导出失败！   配置文件:[{file_path}]  子表：{table_name} 第3行,"
                                       f"第{number_to_column_name(index)}列， 字段：{value}  出现重复，已存在字段列表：{key_name_list}，错误码:10")
                        return None
                    if index in key_export_list_row:  ##如果还在主键中
                        main_key_row.append(row)
                    key_row.append(row)
                    row_dict[row] = index  ##假纵数|真纵数
                    if value.startswith('#'):##使用默认值
                        key_isnull_dict[value[1:]] = True
                        key_name_list.append(value[1:])
                    else:
                        if value.startswith('<'):##使用 <>内的默认值
                            start_index = value.find('>')
                            key_isnull_dict[value[start_index+2:]] = value[1:start_index]
                            key_name_list.append(value[start_index+2:])
                        else:
                            key_isnull_dict[value] = False
                            key_name_list.append(value)
                    row += 1
        elif line == 2:  ##字段类型
            for index, value in enumerate(item):
                if index in export_list_row:  ##要这列导出
                    if str(value) == "nan":  ##报错
                        Config.add_log(f"导出失败！   配置文件:[{file_path}]  子表：{table_name} 第4行,"
                                       f"第{number_to_column_name(index)}列， 不应该使用nan，或者字段类型为空，错误码:11")
                        return None
                    key_type_list.append(value)
    return new_all_data, row_dict, main_key_row, key_row, key_name_list, key_type_list, key_isnull_dict


##对一行数据进行组装
##                 文件路径     子表名称     一行数据     主键列数列表   键列数列表     键名称列表    键类型列表
def row_data_conver(NowProjectConfig, row_dict, line_dict, file_path, table_name, line, row_data, main_key_row, key_row,
                    key_name_list, key_type_list, key_isnull_dict):
    key_dict = {}  ##一行的各字段 与数据的字典  字段是键 ,默认有个 KEY_INDEX
    key_index = ""
    if len(main_key_row) == 1:
        key_index = str(row_data[main_key_row[0]])
    else:
        key_index = str(row_data[main_key_row[0]])
        for main_row in main_key_row[1:]:
            key_index = key_index + "_" + str(row_data[main_row])
    key_dict["KEY_INDEX"] = key_index
    for row in key_row:
        Data = TypeConversion.TO_DATA(NowProjectConfig, file_path, table_name, row_dict[row], line_dict[line],
                                      key_type_list[row],
                                      row_data[row], key_isnull_dict[key_name_list[row + 1]])
        if Data is not None:
            key_dict[key_name_list[row + 1]] = Data
        else:
            return None
    return key_dict


# endregion

# region  xlsx文件数据相关操作
##对一个子表的数据读取     子表名称      子表数据    所有配置表的数据  所有配置表的字段数据
def SubTableDataHandle(NowProjectConfig, file_path, table_name, item_list, data_dict, data_key_dict, image_path):
    sub_table_name = table_name  ##一个子表的名称
    res_image_path = image_path
    if table_name.find("_") != table_name.rfind("_"):
        sub_table_name = table_name[:table_name.rfind("_")]
    if check_key_exist(data_dict, sub_table_name):
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  有出现重复的子表，请确保子表名称不会重复！ 表名:{table_name}，错误码:5")
        return None
    row_data = GetExportRow(file_path, table_name, item_list[0])
    if row_data is not None:
        ##需要导出的主键列 列表，以及导出列数列表
        (key_export_list_row, export_list_row) = row_data
        ##需要导出的行数
        (export_list_line, line_dict) = GetExportLine(item_list)
        ##去掉不需要导出部分的剩余数据
        all_data = GetExportItemList(file_path, table_name, export_list_line, key_export_list_row, export_list_row,
                                     item_list)
        if all_data is not None:
            # {新数据，主键列数，键名列表，类型列表}
            (new_all_data, row_dict, main_key_row, key_row, key_name_list, key_type_list,
             key_isnull_dict) = all_data
            data_list = []
            for line, row_data in enumerate(new_all_data):
                key_dict_list = row_data_conver(NowProjectConfig, row_dict, line_dict, file_path, table_name, line,
                                                row_data, main_key_row, key_row, key_name_list,
                                                key_type_list, key_isnull_dict)  ##对一行数据进行组装
                if key_dict_list is not None:
                    if len(key_dict_list) > 0:
                        data_list.append(key_dict_list)
                else:
                    return None
            if len(data_list) == 0:
                res_image_path = []
            data_key_dict[sub_table_name] = TypeConversion.Type_Conversion(key_row, key_name_list, key_type_list)
            if isCompact:
                data_dict[sub_table_name] = json.dumps(data_list, separators=(',', ':'), indent=None,
                                                       ensure_ascii=False)  # 紧凑版
            else:
                data_dict[sub_table_name] = json.dumps(data_list, indent=4, ensure_ascii=False)
        else:
            return None
    else:
        return None
    return data_dict, data_key_dict, sub_table_name, res_image_path


def TableDataHandle(NowProjectConfig, file_path, image_path_list, data_dict, data_key_dict, subtable_name_list,
                    subtable_name_list2):
    dicts, image_path = read_xlsx.read_text_all(file_path)
    for table_name, item_list in dicts.items():  ##配置文件的一个子表
        if len(item_list) < 3:
            continue
        data = SubTableDataHandle(NowProjectConfig, file_path, table_name, item_list, data_dict, data_key_dict,
                                  image_path)
        if data is not None:
            (data_dict, data_key_dict, sub_table_name, image_path2) = data
            image_path_list += image_path2
            if sub_table_name not in subtable_name_list:
                subtable_name_list.append(sub_table_name)
                subtable_name_list2.append(table_name)
            else:  # 子表名已存在
                Config.add_log(
                    f"导出失败！ 配置文件:[{file_path}]  有出现重复的子表，请确保导出的子表名称不会重复"
                    f"（导出子表名称是在子表名存在两个及以上\"_\"时，去掉最后一个\"_\"以及之后的数据 ）！ 表名:{table_name}，错误码:5")
                return None
        else:
            return None
    return image_path_list, data_dict, data_key_dict, subtable_name_list, subtable_name_list2


##对文件路径列表进行检查，导出每一个是.xls或者.xlsx文件的数据
def data_conver(NowProjectConfig, pathlist):
    image_path_list = []  ##保存存在图片的表，然后在数据导出正确后，再导出图片，防止数据污染
    data_dict = {}  ##所有配置表的数据
    data_key_dict = {}  ##所有配置表的字段数据
    subtable_name_list = []  ##所有子表名称，检查是否存在重复名称子表，不带之后的描述文字
    subtable_name_list2 = []  ##所有子表名称，检查是否存在重复名称子表，带之后的描述文字
    for file_path in pathlist:  ##对每一个配置文件进行处理
        if file_path.find("~$") != -1:
            continue
        if file_path.endswith(".xlsx"):
            data = TableDataHandle(NowProjectConfig, file_path, image_path_list, data_dict, data_key_dict,
                                   subtable_name_list,
                                   subtable_name_list2)
            if data is not None:
                pass
            else:
                return None
    if data_dict is None:
        Config.add_log(f"导出失败！ 没有配置可导出！错误码:6")
        return None
    else:
        return image_path_list, data_dict, data_key_dict, subtable_name_list, subtable_name_list2


# endregion

# region  文件相关操作
# 根节点，文件夹，文件
def get_files_from_directory(directory):
    file_list = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.xlsx') and '~$' not in file:  # 直接过滤.xlsx和临时文件
                file_list.append(os.path.join(root, file))
    return file_list


# endregion


##导出配置数据到文件
def export_config_file(NowProjectConfig, image_path_list, data_dict, data_key_dict, subtable_name_list2):
    languages_table_name = []
    Config.del_file(NowProjectConfig["导出配置的存放路径"])  ##删除原基础配置
    Config.del_file(NowProjectConfig["导出配置图片的存放路径"])  ##删除原图片资源
    new_image_path_list = []
    for i in image_path_list:
        if i not in new_image_path_list:
            new_image_path_list.append(i)
    for image_path in new_image_path_list:
        read_xlsx.output_id_image(NowProjectConfig, image_path)
    for table_name, jsonstr in data_dict.items():
        # 打开文件进行写入，如果文件不存在则创建文件
        with open(NowProjectConfig["导出配置的存放路径"] + table_name + NowProjectConfig["导出的数据后缀"], 'w',
                  encoding='utf-8') as file:
            file.write(jsonstr)
        subtable_names = ""
        for subtable_name in subtable_name_list2:
            if subtable_name.find(table_name) != -1:
                if subtable_name.count("_") > 1:  # 存在两个以上_
                    subtable_names = subtable_name
                    xlsx_dec = subtable_name[subtable_name.rfind("_") + 1:]
                break
        if subtable_names != "":
            subtable_name_list2.remove(subtable_names)
        languages_table_name.append({"file_name": table_name,
                                     "file_path": NowProjectConfig["项目中读取配置文件的路径"] + table_name +
                                                  NowProjectConfig["导出的数据后缀"],
                                     "xlsx_dec": xlsx_dec,
                                     "key_list": data_key_dict[table_name]})
    ##生成基础配置文件
    if isCompact:
        languages_table_name_text = json.dumps({"cfg_files": languages_table_name}, separators=(',', ':'), indent=None,
                                               ensure_ascii=False)  # 紧凑版
    else:
        languages_table_name_text = json.dumps({"cfg_files": languages_table_name}, indent=4, ensure_ascii=False)
    ##languages_table_name_text = json.dumps({"cfg_files": languages_table_name}, separators=(',', ':'), indent=None, ensure_ascii=False) #紧凑版
    with open(NowProjectConfig["导出配置的索引文件路径"], 'w',
              encoding='utf-8') as file:
        file.write(languages_table_name_text)


##导出配置的类
def export_config_class(NowProjectConfig, data_dict, data_key_dict, subtable_name_list2):
    result_dict = read_xlsx.read_sheet_name(NowProjectConfig)  ##所有xlsx表的每个子表的列名 和 导出选项 和键名称
    export_class1(NowProjectConfig, result_dict, data_dict, data_key_dict, subtable_name_list2)
    export_class2(NowProjectConfig, result_dict, data_dict, data_key_dict, subtable_name_list2)
    if NowProjectConfig["是否导出配置类"]:  ##复制到开发路径
        ClassExport.export_config_constant(NowProjectConfig, data_dict.items(), result_dict, subtable_name_list2)  ##导出
    if NowProjectConfig["是否导出缓存类"]:  ##复制到开发路径
        ClassExport.export_ConfigCache(NowProjectConfig, data_dict.items(), result_dict, subtable_name_list2)  ##导出


##导出基础类到基础类路径
def export_class1(NowProjectConfig, result_dict, data_dict, data_key_dict, subtable_name_list2):
    Config.del_file(NowProjectConfig["配置类导出路径"])  ##删除原class文件
    for table_name, jsonstr in data_dict.items():  ##导出所有配置类
        if table_name in NowProjectConfig["不自动生成配置类的配置表"]:
            continue
        sheet_data = []
        for xlsx_path in result_dict:
            if table_name in result_dict[xlsx_path].keys():
                sheet_data = result_dict[xlsx_path][table_name]
                break
        data = {"file_name": table_name,
                "file_path": NowProjectConfig["项目中读取配置文件的路径"] + table_name +
                             NowProjectConfig["导出的数据后缀"],
                "key_list": data_key_dict[table_name]}
        generator = ClassGenerator.CSharpClassGenerator(data, NowProjectConfig)
        csharp_code = generator.generate_class(sheet_data, subtable_name_list2)
        # 打开文件进行写入，如果文件不存在则创建文件
        with open(NowProjectConfig["配置类导出路径"] + "/" + table_name[4:5].upper() + table_name[5:] + ".cs", 'w',
                  encoding='utf-8') as file:
            file.write(csharp_code)
        if NowProjectConfig["导出类是否需要复制到开发路径"]:  ##复制到开发路径
            project_path = NowProjectConfig["根路径"] + NowProjectConfig["根路径+配置类复制路径"]
            Config.delete_folder(project_path)
            class_export_path = NowProjectConfig["配置类导出路径"]
            shutil.copytree(class_export_path, project_path)


##导出基础类2到基础类路径
def export_class2(NowProjectConfig, result_dict, data_dict, data_key_dict, subtable_name_list2):
    Config.del_file(NowProjectConfig["配置类拓展导出路径"])  ##删除原class文件
    for table_name, jsonstr in data_dict.items():  ##导出所有配置类
        if table_name in NowProjectConfig["不自动生成配置类的配置表"]:
            continue
        sheet_data = []
        for xlsx_path in result_dict:
            if table_name in result_dict[xlsx_path].keys():
                sheet_data = result_dict[xlsx_path][table_name]
                break
        data = {"file_name": table_name,
                "file_path": NowProjectConfig["项目中读取配置文件的路径"] + table_name +
                             NowProjectConfig["导出的数据后缀"],
                "key_list": data_key_dict[table_name]}
        generator = ClassGenerator.CSharpClassGenerator(data, NowProjectConfig)
        csharp_code = generator.generate_class2(subtable_name_list2)
        # 打开文件进行写入，如果文件不存在则创建文件
        with open(NowProjectConfig["配置类拓展导出路径"] + "/" + table_name[4:5].upper() + table_name[5:] + ".cs", 'w',
                  encoding='utf-8') as file:
            file.write(csharp_code)
        if NowProjectConfig["导出类是否需要复制到开发路径"]:  ##复制到开发路径
            project_path = NowProjectConfig["根路径"] + NowProjectConfig["根路径+配置类拓展复制路径"]
            Config.del_file2(project_path, NowProjectConfig["不自动覆盖的配置类拓展"])
            class_export_path = NowProjectConfig["配置类拓展导出路径"]
            Config.copy_dir2(class_export_path, project_path, NowProjectConfig["不自动覆盖的配置类拓展"])


##对该路径下所有xlsx文件的数据处理后，导出配置
def AllXlsxDataHandle(NowProjectConfig, isCompacts):
    global isCompact
    if isCompacts == 1:
        isCompact = False
    else:
        isCompact = True
    Config.close_log()  ##清除日志
    pathlist = get_files_from_directory(NowProjectConfig["读取的xlsx文件夹路径"])  ##路径下所有文件数据
    data = data_conver(NowProjectConfig, pathlist)
    if data is not None:
        (image_path_list, data_dict, data_key_dict, subtable_name_list, subtable_name_list2) = data
        ##导出所有配置数据
        export_config_file(NowProjectConfig, image_path_list, data_dict, data_key_dict, subtable_name_list2)


##对该路径下所有xlsx文件的数据处理后，导出为Class
def AllXlsxDataHandleClass(NowProjectConfig):
    Config.close_log()  ##清除日志
    pathlist = get_files_from_directory(NowProjectConfig["读取的xlsx文件夹路径"])  ##路径下所有文件数据
    data = data_conver(NowProjectConfig, pathlist)
    if data is not None:
        (image_path_list, data_dict, data_key_dict, subtable_name_list, subtable_name_list2) = data
        ##导出所有配置数据
        export_config_class(NowProjectConfig, data_dict, data_key_dict, subtable_name_list2)


# 刷新表中的数据类型
def RefreshAllData(NowProjectConfig, filepath):
    pathlist = get_files_from_directory(filepath)
    for path in pathlist:
        if ".xlsx" in path and "~$" not in path:
            RefreshOneData(path)
    pass


def RefreshOneData(path):
    xlapp = win32com.client.DispatchEx("Excel.Application")
    wb = xlapp.Workbooks.Open(os.path.abspath(path))
    wb.RefreshAll()
    xlapp.CalculateUntilAsyncQueriesDone()
    xlapp.DisplayAlerts = False
    wb.Save()
    wb.Close()
    xlapp.Quit()
