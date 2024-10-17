import pandas as pd
import openpyxl


##读取文字表数据(某个)
def read_text(path, table_name, query_str):
    ds = pd.read_excel(io=path, sheet_name=table_name, usecols="A,B",
                       na_values='#N')
    return ds[ds['language_id'] == query_str]


def read_text_info(path, table_name, query_str):
    return pd.read_excel(io=path, sheet_name=table_name, usecols="A,B",
                         na_values='#N')


def read_text_all(path):
    xls = pd.ExcelFile(path)
    table_names = xls.sheet_names  # 获取所有表名
    result_dict = {}
    for table_name in table_names:
        ds = pd.read_excel(xls, sheet_name=table_name)  # 逐个读取表格
        result_list = []
        for index, row_list in ds.iterrows():  # 遍历每一行数据
            result = []
            result.append(index)
            for row in row_list:
                result.append(row)
            result_list.append(result)
        result_dict[table_name] = result_list
    xls.close()
    return result_dict


def read_xlsm_file(file_path):
    datalist = {}
    try:
        workbook = openpyxl.load_workbook(file_path)
        sheet = workbook.active
        for row in sheet.iter_rows(values_only=True):
            # 获取后两项数据
            last_two_columns = tuple(row[1:3])
            # 在这里进行其他处理或打印输出
            # print(row)

            # 将后两项数据作为元组添加到datalist中
            datalist.update({last_two_columns[0]: last_two_columns[1]})
        workbook.close()
    except FileNotFoundError:
        print(f"文件 '{file_path}' 未找到")
    except IOError:
        print(f"无法打开文件 '{file_path}'")
    return datalist

# print(read_text("Server", "CurrencyText_SoulValue"))
# dicts = read_text_all()
# for table_name, list in dicts.items():
#     print(table_name)
#     for rows in list:
#         print(rows)
