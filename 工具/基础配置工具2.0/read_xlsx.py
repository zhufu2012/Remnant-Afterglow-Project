import pandas as pd
import openpyxl
import zipfile
import os
import xml.etree.ElementTree as ET
import openpyxl
import Config


##读取txt文件内数据
def read_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()
    return content

##检查某个数据是否是某数据，或者其.0 版
def check_value(value, key):
    if value == key or value == (str(key) + ".0") or value == str(key):
        return True
    else:
        return False


##读取xlsx文件的所有数据,包括图片数据
def read_text_all(path):
    xls = pd.ExcelFile(path)
    table_names = xls.sheet_names  # 获取所有表名
    result_dict = {}
    exportimage = False  ##该表是否需要导出
    for table_name in table_names:
        if not table_name.startswith("cfg_"):  ##开头不是cfg_的表都不算
            continue
        ds = pd.read_excel(xls, sheet_name=table_name)  # 逐个读取表格
        result_list = []
        isimage = False  ##该子表是否需要导出图片
        for index, row_list in ds.iterrows():  # 遍历每一行数据，从0开始
            result = []
            result.append(index)
            for i, row in enumerate(row_list):
                if index == 2 and row == "PNG":  ##导出项是特殊的，单元格中图片
                    export_type = result_list[0][i + 1]
                    if check_value(export_type, 1) or check_value(export_type, 2) or check_value(export_type, 3):  ##确保是可导出的行
                        isimage = True
                result.append(row)
            result_list.append(result)
        if len(result_list) < 3:  ##子表数据为空
            continue
        if isimage == True and len(result_list) >= 4:
            exportimage = True
        result_dict[table_name] = result_list

    xls.close()
    if exportimage:  ##需要导出图片
        return result_dict, [path]
    else:
        return result_dict, []


def read_excel_data(filename_path):
    # 加载 Excel 文件
    workbook = openpyxl.load_workbook(filename_path, data_only=False)
    sheet_name_list = workbook.get_sheet_names()
    data = []  # data就是文本信息
    image_list = []
    for sheet_name in sheet_name_list:
        sheet = workbook.get_sheet_by_name(sheet_name)
        ##print(sheet)
        for row in sheet.iter_rows(min_row=1, values_only=False):
            row_data = []
            for cell in row:
                if cell.value and isinstance(cell.value, str) and '=_xlfn.DISPIMG(' in cell.value:
                    # 提取嵌入的图片 ID
                    formula = cell.value
                    start = formula.find('"') + 1
                    end = formula.find('"', start)
                    image_id = formula[start:end]
                    row_data.append(f"{image_id}")
                    image_list.append(image_id)

                    # print(image_id)
                else:
                    # 其他数据直接添加
                    row_data.append(cell.value)
            data.append(row_data)
    return data, image_list


##检测文件是否在zip文件中
def checkzipfile_exists(zip_filename, filename):
    with zipfile.ZipFile(zip_filename, 'r') as zip_ref:
        if filename in zip_ref.namelist():
            return True
        else:
            return False


def get_xml_id_image_map(xlsx_file_path):
    # 打开 XLSX 文件
    with zipfile.ZipFile(xlsx_file_path, 'r') as zfile:
        pathlist = zfile.namelist()
        if 'xl/cellimages.xml' in pathlist:
            with zfile.open('xl/cellimages.xml') as file:
                xml_content = file.read()
            if 'xl/_rels/cellimages.xml.rels' in pathlist:
                with zfile.open('xl/_rels/cellimages.xml.rels') as file:
                    relxml_content = file.read()
            else:
                return None
        else:
            return None
    # 将读取的内容转换为 XML 树
    root = ET.fromstring(xml_content)

    # 初始化映射字典
    name_to_embed_map = {}

    # 命名空间
    namespaces = {
        'xdr': 'http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing',
        'a': 'http://schemas.openxmlformats.org/drawingml/2006/main'
    }

    # 遍历所有 pic 元素
    for pic in root.findall('.//xdr:pic', namespaces=namespaces):
        name = pic.find('.//xdr:cNvPr', namespaces=namespaces).attrib['name']
        embed = pic.find('.//a:blip', namespaces=namespaces).attrib[
            '{http://schemas.openxmlformats.org/officeDocument/2006/relationships}embed']
        name_to_embed_map[name] = embed
    root1 = ET.fromstring(relxml_content)
    # 命名空间字典，根据 XML 中定义的命名空间进行设置
    namespaces = {'r': 'http://schemas.openxmlformats.org/package/2006/relationships'}
    # 创建 ID 和 Target 的映射
    id_target_map = {child.attrib['Id']: child.attrib.get('Target', 'No Target Found') for child in
                     root1.findall('.//r:Relationship', namespaces=namespaces)}

    # print(id_target_map)

    # 使用字典推导构建新的映射表
    name_to_target_map = {name: id_target_map[embed] for name, embed in name_to_embed_map.items() if
                          embed in id_target_map}
    return name_to_target_map


##
def output_id_image(NowProjectConfig, xlsx_file_path):
    data, image_list = read_excel_data(xlsx_file_path)
    name_to_target_map = get_xml_id_image_map(xlsx_file_path)
    if name_to_target_map == None:
        # Config.add_log(f"导出异常！配置文件:[{xlsx_file_path}]下，没有检测到图片存在，请确认是否有问题！")
        return None
    # 构建id_image_对
    new_map = {key: name_to_target_map.get(key) for key in image_list if key in name_to_target_map}
    # 打开xlsx文件（即Zip文件）
    with zipfile.ZipFile(xlsx_file_path, 'r') as zfile:
        for key, image_path in new_map.items():
            # 构建实际的图片路径
            actual_image_path = f'xl/{image_path}'  # 假设图片在'xl/media/'目录下
            if actual_image_path in zfile.namelist():
                # 读取图片内容
                with zfile.open(actual_image_path) as image_file:
                    image_content = image_file.read()
                    # 保存图片到新的文件夹下面，使用key作为文件名

                    new_file_path = os.path.join(NowProjectConfig["导出配置图片的存放路径"], f"{key}.png")
                    with open(new_file_path, 'wb') as new_file:
                        new_file.write(image_content)
            else:
                Config.add_log(f"导出异常！xlsx内部路径： {actual_image_path} 没找到，未导出图片{image_path} ,相关数据{key} ")


# region  文件相关操作
# 根节点，文件夹，文件
def next_file(root, dirs, files):
    list = []
    for file in files:
        list.append(root + "\\" + file)
    return list


# 读取路径下，每一层的路径
def get_files_from_directory(directory):
    file_list = []
    for root, dirs, files in os.walk(directory):  # 每一层文件夹数据
        list = next_file(root, dirs, files)
        file_list = file_list + list
    return file_list


##读取路径下所有xlsx表中，可用导出的xlsx表以及子表名称
def get_xlsx_key_name(NowProjectConfig):
    pathlist = get_files_from_directory(NowProjectConfig["读取的xlsx文件夹路径"])  ##路径下所有文件数据
    dicts = {}  ##列表中保存 字典  字典中保存{xlsx表路径：[子表名称]}
    for file_path in pathlist:  ##对每一个配置文件进行处理
        if file_path.find("~$") != -1:
            continue
        if file_path.endswith(".xlsx"):
            xls = pd.ExcelFile(file_path)
            table_names = xls.sheet_names  # 获取所有表名
            list = []
            for table_name in table_names:
                if not table_name.startswith("cfg_"):  ##开头不是cfg_的表都不算
                    continue
                list.append(table_name)
            if len(list) != 0:
                dicts[file_path] = list
    return dicts


##读取所有xlsx表的每个子表的列名 和 导出选项 和键名称
def read_sheet_name(NowProjectConfig):
    dicts = get_xlsx_key_name(NowProjectConfig)
    result_dict = {}
    for path in dicts.keys():
        sheet_name_dict = {}
        for sheet_name in dicts[path]:
            data = pd.read_excel(path, header=None, sheet_name=sheet_name)
            result_list = []
            for index, row_list in data.iterrows():  # 遍历每一行数据
                result = []
                if index == 0 or index == 1 or index == 2:  # 第一行 备注行  第二行 导出选项，第三行 字段名称
                    for i, row in enumerate(row_list):
                        result.append(row)
                result_list.append(result)
            sub_table_name = sheet_name  ##一个子表的名称
            if sheet_name.find("_") != sheet_name.rfind("_"):
                sub_table_name = sheet_name[:sheet_name.rfind("_")]
            sheet_name_dict[sub_table_name] = result_list
        result_dict[path] = sheet_name_dict
    return result_dict
