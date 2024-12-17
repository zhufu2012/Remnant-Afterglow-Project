import read_xlsx
import Config
import numpy as np


def number_to_column_name(n):
    result = ""
    while n > 0:
        n, remainder = divmod(n - 1, 26)
        result = chr(65 + remainder) + result
    return result


##转换为INT
def TO_INT(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    if isinstance(variable, int):
        return variable
    else:
        try:
            converted_variable = int(variable)
            return converted_variable
        except ValueError:
            Config.add_log(
                f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为INT 时出现错误！")
            return None


##转换为BOOL
def TO_BOOL(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    strs = str(variable)
    if strs == 'true' or strs == 'TRUE' or strs == "True":
        return True
    if strs == 'false' or strs == 'FALSE' or strs == 'False':
        return False
    Config.add_log(
        f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据{strs}转换为BOOL 时出现错误！")


##转换为BYTE
def TO_BYTE(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    if isinstance(variable, bytes):
        return variable
    else:
        try:
            converted_variable = int(variable).to_bytes(1, byteorder='big')
            return converted_variable
        except ValueError:
            Config.add_log(
                f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为BYTE 时出现错误！")
            return None


def TO_UINT64(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    if isinstance(variable, int):
        return variable
    else:
        try:
            converted_variable = int(variable)
            return converted_variable
        except ValueError:
            Config.add_log(
                f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为UINT64 时出现错误！")
            return None


def TO_FLOAT(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == "nan":
            raise Exception("")
        converted_variable = float(variable)
        return converted_variable
    except ValueError:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为FLOAT 时出现错误！")
        return None


def TO_STR(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    if (str(variable) == "nan"):
        return ""
    else:
        return str(variable)


def TO_BOOL_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        return [True if (val.strip().lower() == 'true' or val.strip().lower() == 'TRUE') else False for val in
                str(variable).split('|')]
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为BOOL列表时出现错误：{e}")
        return None


def TO_BYTE_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        return [int(val.strip()).to_bytes(1, byteorder='big') for val in str(variable).split('|')]
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为BYTE列表时出现错误：{e}")
        return None


def TO_INT_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        return [int(val.strip()) for val in str(variable).split('|')]
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为INT列表时出现错误：{e}")
        return None


def TO_SHORT_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        return [int(val.strip()) for val in variable.split('|')]
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为SHORT列表时出现错误：{e}")
        return None


def TO_UINT64_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        return [int(val.strip()) for val in variable.split('|')]
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为UINT64列表时出现错误：{e}")
        return None


def TO_FLOAT_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        return [float(val.strip()) for val in variable.split('|')]
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为FLOAT列表时出现错误：{e}")
        return None


def TO_STR_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        return [str(val) for val in variable.split('|')]
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为STR列表时出现错误：{e}")
        return None


def TO_BOOL_TUPLE(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:

        if variable.find("(") != -1 or variable.find(")") != -1:
            values = variable.strip('()').split(',')
            return tuple(
                True if (val.strip().lower() == 'true' or val.strip().lower() == 'TRUE') else False for val in values)
        else:
            values = variable.strip('（）').split(',')
            return tuple(
                True if (val.strip().lower() == 'true' or val.strip().lower() == 'TRUE') else False for val in values)
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为BOOL元组时出现错误：{e}")
        return None


def TO_BYTE_TUPLE(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if variable.find("(") != -1 or variable.find(")") != -1:
            values = variable.strip('()').split(',')
            return tuple(int(val.strip()).to_bytes(1, byteorder='big') for val in values)
        else:
            values = variable.strip('（）').split(',')
            return tuple(int(val.strip()).to_bytes(1, byteorder='big') for val in values)
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为BYTE元组时出现错误：{e}")
        return None


def TO_INT_TUPLE(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if variable.find("(") != -1 or variable.find(")") != -1:
            values = variable.strip('()').split(',')
            return tuple(int(val.strip()) for val in values)
        else:
            values = variable.strip('（）').split(',')
            return tuple(int(val.strip()) for val in values)
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为INT元组时出现错误：{e}")
        return None


def TO_UINT64_TUPLE(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if variable.find("(") != -1 or variable.find(")") != -1:
            values = variable.strip('()').split(',')
            return tuple(int(val.strip()) for val in values)
        else:
            values = variable.strip('（）').split(',')
            return tuple(int(val.strip()) for val in values)
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为UINT64元组时出现错误：{e}")
        return None


def TO_FLOAT_TUPLE(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if variable.find("(") != -1 or variable.find(")") != -1:
            values = variable.strip('()').split(',')
            return tuple(float(val.strip()) for val in values)
        else:
            values = variable.strip('（）').split(',')
            return tuple(float(val.strip()) for val in values)
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为FLOAT元组时出现错误：{e}")
        return None


def TO_STR_TUPLE(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if variable.find("(") != -1 or variable.find(")") != -1:
            values = variable.strip('()').split(',')
            return tuple(str(val.strip()) for val in values)
        else:
            values = variable.strip('（）').split(',')
            return tuple(str(val.strip()) for val in values)
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为STR元组时出现错误：{e}")
        return None


def TO_BOOL_TUPLE_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        tuples = variable.replace("\n", "").split('|')
        result = []
        for tup in tuples:
            if tup.find("(") != -1 or tup.find(")") != -1:
                values = tup.strip('()').split(',')
                bool_tuple = tuple(
                    True if (val.strip().lower() == 'true' or val.strip().lower() == 'TRUE') else False for val in
                    values)
                result.append(bool_tuple)
            else:
                values = tup.strip('（）').split(',')
                bool_tuple = tuple(
                    True if (val.strip().lower() == 'true' or val.strip().lower() == 'TRUE') else False for val in
                    values)
                result.append(bool_tuple)
        return result
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为<(BOOL)>列表时出现错误：{e}")
        return None


def TO_BYTE_TUPLE_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        tuples = variable.replace("\n", "").split('|')
        result = []
        for tup in tuples:
            if tup.find("(") != -1 or tup.find(")") != -1:
                values = tup.strip('()').split(',')
                byte_tuple = tuple(int(val.strip()).to_bytes(1, byteorder='big') for val in values)
                result.append(byte_tuple)
            else:
                values = tup.strip('（）').split(',')
                byte_tuple = tuple(int(val.strip()).to_bytes(1, byteorder='big') for val in values)
                result.append(byte_tuple)
        return result
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为<(BYTE)>列表时出现错误：{e}")
        return None


def TO_INT_TUPLE_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        tuples = variable.replace("\n", "").split('|')
        result = []
        for tup in tuples:
            if tup.find("(") != -1 or tup.find(")") != -1:
                values = tup.strip('()').split(',')
                int_tuple = tuple(int(val.strip()) for val in values)
                result.append(int_tuple)
            else:
                values = tup.strip('（）').split(',')
                int_tuple = tuple(int(val.strip()) for val in values)
                result.append(int_tuple)
        return result
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为<(INT)>列表时出现错误：{e}")
        return None


def TO_UINT64_TUPLE_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        tuples = variable.replace("\n", "").split('|')
        result = []
        for tup in tuples:
            if tup.find("(") != -1 or tup.find(")") != -1:
                values = tup.strip('()').split(',')
                uint64_tuple = tuple(int(val.strip()) for val in values)
                result.append(uint64_tuple)
            else:
                values = tup.strip('（）').split(',')
                uint64_tuple = tuple(int(val.strip()) for val in values)
                result.append(uint64_tuple)
        return result
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为<(UINT64)>列表时出现错误：{e}")
        return None


def TO_FLOAT_TUPLE_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        tuples = variable.replace("\n", "").split('|')
        result = []
        for tup in tuples:
            if tup.find("(") != -1 or tup.find(")") != -1:
                values = tup.strip('()').split(',')
                float_tuple = tuple(float(val.strip()) for val in values)
                result.append(float_tuple)
            else:
                values = tup.strip('（）').split(',')
                float_tuple = tuple(float(val.strip()) for val in values)
                result.append(float_tuple)
        return result
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为<(FLOAT)>列表时出现错误：{e}")
        return None


def TO_STR_TUPLE_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        tuples = variable.split('|')
        result = []
        for tup in tuples:
            if tup.find("(") != -1 or tup.find(")") != -1:
                values = tup.strip('()').split(',')
                str_tuple = tuple(str(val.strip()) for val in values)
                result.append(str_tuple)
            else:
                values = tup.strip('（）').split(',')
                str_tuple = tuple(str(val.strip()) for val in values)
                result.append(str_tuple)
        return result
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为<(STR)>列表时出现错误：{e}")
        return None


def TO_SHORT(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    if isinstance(variable, int):
        return variable
    else:
        try:
            converted_variable = int(variable)
            return converted_variable
        except ValueError:
            Config.add_log(
                f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为SHORT时出现错误！")
            return None


def TO_SHORT_TUPLE(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        values = variable.strip('()').split(',')
        return tuple(int(val.strip()) for val in values)
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为SHORT元组时出现错误：{e}")
        return None


def TO_SHORT_TUPLE_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        tuples = variable.split('|')
        result = []
        for tup in tuples:
            values = tup.strip('()').split(',')
            short_tuple = tuple(int(val.strip()) for val in values)
            result.append(short_tuple)
        return result
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为<(SHORT)>列表时出现错误：{e}")
        return None


def TO_PNG(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == "nan":
            raise Exception("")
        else:
            path1 = variable[variable.find("\"") + 1:]
            path2 = path1[:path1.find("\"")]
            return NowProjectConfig["项目中读取PNG资源的路径"] + path2 + ".png"
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为图片时出现错误，看起来没有图片数据！：{e}")
        return None


def TO_RGB(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if variable.find("(") != -1 or variable.find(")") != -1:
            values = variable.strip('()').split(',')
            if len(values) == 3:
                return tuple(int(val.strip()) for val in values)
            else:
                raise Exception("颜色数量应该为3个，(x,x,x)")
        else:
            values = variable.strip('（）').split(',')
            if len(values) == 3:
                return tuple(int(val.strip()) for val in values)
            else:
                raise Exception("颜色数量应该为3个，(x,x,x)")
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为RGB颜色时出现错误！：{e}")
        return None


def TO_RGBA(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if variable.find("(") != -1 or variable.find(")") != -1:
            values = variable.strip('()').split(',')
            if len(values) == 4:
                return tuple(int(val.strip()) for val in values)
            else:
                raise Exception("颜色数量应该为4个，(x,x,x,x)")
        else:
            values = variable.strip('（）').split(',')
            if len(values) == 4:
                return tuple(int(val.strip()) for val in values)
            else:
                raise Exception("颜色数量应该为4个，(x,x,x,x)")
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为RGBA颜色时出现错误！：{e}")
        return None


def TO_INT_VECTOR_LIST(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        tuples = variable.replace("\n", "").split('|')
        result = []
        for tup in tuples:
            if tup.find("(") != -1 or tup.find(")") != -1:
                values = tup.strip('()').split(',')
                int_tuple = tuple(int(val.strip()) for val in values)
                result.append(int_tuple)
            else:
                values = tup.strip('（）').split(',')
                int_tuple = tuple(int(val.strip()) for val in values)
                result.append(int_tuple)
        return result
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为<Vector2I>列表时出现错误：{e}")
        return None


def TO_SEQUENCE_MAP(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        return str(variable)
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为SequenceMap序列图时出现错误：{e}")
        return None

def TO_INT_HashSet(NowProjectConfig, file_path, table_name, Col_x, Col_y, variable):
    try:
        if str(variable) == 'nan' or str(variable) == '':
            return []
        return [int(val.strip()) for val in str(variable).split('|')]
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据:[{variable}]转换为HashSet<INT>列表时出现错误：{e}")
        return None

BaseType = {
    'BOOL': (TO_BOOL, True, 'bool'),
    ##'BYTE': (TO_BYTE, b'\x00','byte'),
    'SHORT': (TO_SHORT, 0, 'short'),
    'INT': (TO_INT, 0, 'int'),
    'LONG': (TO_UINT64, 0, 'long'),
    'FLOAT': (TO_FLOAT, 0, 'float'),
    'STR': (TO_STR, "", 'string'),
    '<BOOL>': (TO_BOOL_LIST, [], 'List<bool>'),
    ##'<BYTE>': (TO_BYTE_LIST, [], 'List<byte>'),
    '<SHORT>': (TO_SHORT_LIST, [], 'List<short>'),
    '<INT>': (TO_INT_LIST, [], 'List<int>'),
    '<LONG>': (TO_UINT64_LIST, [], 'List<long>'),
    '<FLOAT>': (TO_FLOAT_LIST, [], 'List<float>'),
    '<STR>': (TO_STR_LIST, [], 'List<string>'),
    '(BOOL)': (TO_BOOL_TUPLE, (), 'List<bool>'),
    ##'(BYTE)': (TO_BYTE_TUPLE, (), 'List<byte>'),
    '(SHORT)': (TO_SHORT_TUPLE, (), 'List<short>'),
    '(INT)': (TO_INT_TUPLE, (), 'List<int>'),
    '(LONG)': (TO_UINT64_TUPLE, (), 'List<long>'),
    '(FLOAT)': (TO_FLOAT_TUPLE, (), 'List<float>'),
    '(STR)': (TO_STR_TUPLE, (), 'List<string>'),
    '<(BOOL)>': (TO_BOOL_TUPLE_LIST, [], 'List<List<bool>>'),
    ##'<(BYTE)>': (TO_BYTE_TUPLE_LIST, [], 'List<List<byte>>'),
    '<(SHORT)>': (TO_SHORT_TUPLE_LIST, [], 'List<List<short>>'),
    '<(INT)>': (TO_INT_TUPLE_LIST, [], 'List<List<int>>'),
    '<(LONG)>': (TO_UINT64_TUPLE_LIST, [], 'List<List<long>>'),
    '<(FLOAT)>': (TO_FLOAT_TUPLE_LIST, [], 'List<List<float>>'),
    '<(STR)>': (TO_STR_TUPLE_LIST, [], 'List<List<string>>'),
    'PNG': (TO_PNG, "null", 'Texture2D'),
    'LANG': (TO_STR, "KeyBase", "language_id"),  ##语言id类型
    '<LANG>': (TO_STR_LIST, [], "<language_id>"),  ##语言id列表类型
    'POINT': (TO_FLOAT_TUPLE, (0, 0), 'Vector2'),  ##坐标类型
    '<POINT>': (TO_FLOAT_TUPLE_LIST, [], 'List<Vector2>'),  ##坐标列表类型
    'Vector2I': (TO_INT_TUPLE, (0, 0), 'Vector2I'),  ##坐标类型
    'ULONG': (TO_UINT64, 0, 'ulong'),  ##坐标类型
    'RGB': (TO_RGB, (0, 0, 0), 'Color'),  ##坐标类型
    'RGBA': (TO_RGBA, (0, 0, 0, 0), 'Color'),  ##坐标类型
    '<Vector2I>': (TO_INT_VECTOR_LIST, [], 'List<Vector2I>'),  ##坐标列表类型
    'SequenceMap': (TO_SEQUENCE_MAP, "", 'SequenceMapType'),  ##坐标列表类型
    'BBCode': (TO_STR, "", 'BBCode'),
    'HashSet<INT>': (TO_INT_HashSet, [], 'HashSet<int>'),
}


def TO_DATA(NowProjectConfig, file_path, table_name, Col_x, Col_y, Type, Data, IsDefault):
    try:
        function, default_value, NewType = BaseType.get(Type, (
            lambda NowProjectConfig, file_path, table_name, Col_x, Col_y, variable: "Invalid", None))
        if Data == "#BASEVALUE" or (IsDefault and (Data == '' or str(Data) == 'nan')):  ## 值为#BASEVALUE 或者 值为空的同时，数据为可默认
            return default_value
        else:
            NewData = function(NowProjectConfig, file_path, table_name, Col_x, Col_y, Data)
            return NewData
    except Exception as e:
        Config.add_log(
            f"导出失败！  配置文件:[{file_path}]  子表：{table_name} 第{Col_y}行，第{number_to_column_name(Col_x)}列 ，数据类型错误！不存在类型{Type}")
        return None


def Type_Conversion(export_list, KeyList, TypeList):
    key_dict = {"KEY_INDEX": "string"}
    for export in export_list:
        key_dict[KeyList[export + 1]] = BaseType[TypeList[export]][2]
    return key_dict

# Data = TO_DATA(1, 1, "INT", "1")
# Data2 = TO_DATA(1, 1, 'BYTE', "0")
# Data3 = TO_DATA(2, 2, 'BOOL', "true")
# Data4 = TO_DATA(2, 2, '<INT>', '1|2')
# Data5 = TO_DATA(2, 2, '<INT>', '1')
# Data6 = TO_DATA(2, 2, '<STR>', 'keysasda')
# Data7 = TO_DATA(2, 2, '(STR)', '(asdasd,asdws)')
# Data8 = TO_DATA(2, 2, '<(INT)>', '(1,100)|(2,200)')
# Config.add_log(Data)
# Config.add_log(Data2)
# Config.add_log(Data3)
# Config.add_log(Data4)
# Config.add_log(Data5)
# Config.add_log(Data6)
# Config.add_log(Data7)
# Config.add_log(Data8)
