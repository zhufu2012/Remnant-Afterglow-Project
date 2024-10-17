import Config

class CSharpClassGenerator:
    def __init__(self, data, ConfigData):
        self.data = data
        self.Config = ConfigData
        self.define_str = self.Config["默认开头添加的库名"]
        self.define_str2 = self.Config["类2默认开头添加的库名"]
        self.class_str_dict = self.Config["导出类型对应库名称"]
        self.class_name = self._get_class_name()  # 避免重复调用

    def combine_strings(self, input_string):
        class_dict = {key: val for key, val in self.class_str_dict.items() if key in input_string}
        return ''.join(class_dict.keys())

    def generate_class(self, result_dict, subtable_name_list2):
        properties = self._generate_properties(result_dict)
        constructor = self._generate_constructor()
        constructor2 = self._generate_constructor2()
        constructor3 = self._generate_constructor3()
        xlsx_dec = self._get_xlsx_dec(subtable_name_list2)

        all_str = f'namespace {self.Config["导出类的命名空间"]}\n{{\n    /// <summary>\n    /// 自动生成的配置类 {self.class_name} 用于 {xlsx_dec},拓展请在expand_class文件下使用partial拓展\n    /// </summary>\n' \
                  f'    public partial class {self.class_name}\n    ' + '{\n        #region 参数及初始化\n' + properties + '\n' + \
                  constructor + "\n        " + constructor3 + "\n        " + constructor2 + '        #endregion\n    }\n}\n'

        class_str = self.combine_strings(all_str)
        return self.define_str + class_str + all_str

    def _get_class_name(self):
        return self.data['file_name'][4:5].upper() + self.data['file_name'][5:]

    def _generate_properties(self, result_dict):
        key_list = self.data['key_list']
        properties = []
        for key, value_type in key_list.items():
            if key == 'KEY_INDEX':
                continue
            describe = next((result_dict[0][i] for i, key_name in enumerate(result_dict[2]) if key_name == key and len(result_dict[1]) > i and result_dict[1][i] in [1, 2, 3]), '')
            describe = describe.replace("\n", "\n        ///")
            properties.append(f'        /// <summary>\n        /// {describe}\n        /// </summary>\n        public {self.type_replace(value_type)} {key} {{ get; set; }}')
        return '\n'.join(properties)

    def _generate_properties2(self):
        key_list = self.data['key_list']
        return '\n'.join(
            f'			{key} = ({self.type_replace(value_type)})dict["{key}"];'
            for key, value_type in key_list.items() if key != 'KEY_INDEX'
        )

    def _generate_constructor(self):
        assignment_statements = self._generate_properties2()
        return f'\n        public {self.class_name}(int id)\n        ' + '{' + \
            f'\n            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_{self.class_name}, id);' + \
            f'//public const string Config_{self.class_name} = "{self.data["file_name"]}"; \n' \
            '' + assignment_statements + '\n			InitData();\n' + \
            '        }\n'

    def _generate_constructor2(self):
        assignment_statements = self._generate_properties2()
        return f'public {self.class_name}(Dictionary<string, object> dict)\n        ' + '{\n' + \
            assignment_statements + '\n			InitData();\n' + \
            '        }\n'

    def _generate_constructor3(self):
        assignment_statements = self._generate_properties2()
        return f'\n        public {self.class_name}(string cfg_id)\n        ' + '{' + \
            f'\n            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_{self.class_name}, cfg_id);' + \
            f'//public const string Config_{self.class_name} = "{self.data["file_name"]}"; \n' \
            '' + assignment_statements + '\n			InitData();\n' + \
            '        }\n'

    def _get_xlsx_dec(self, subtable_name_list2):
        for sub_table_name in subtable_name_list2:
            if sub_table_name.find(self.class_name) != -1:
                if sub_table_name.rfind("_") != sub_table_name.find("_"):  # 存在两个以上_
                    return sub_table_name[sub_table_name.rfind("_") + 1:]
        return ""

    def type_replace(self, value_type):
        dicts = self.Config["特殊的导出类型,需要替换"]
        return dicts.get(value_type, value_type)

    def generate_class2(self, subtable_name_list2):
        xlsx_dec = self._get_xlsx_dec(subtable_name_list2)
        all_str = f'namespace {self.Config["导出类的命名空间"]}\n{{\n    /// <summary>\n    /// 自动生成的配置类2 {self.class_name} 用于 {xlsx_dec},拓展请在expand_class文件下使用partial拓展\n    /// </summary>\n' \
                  f'    public partial class {self.class_name}\n    ' + ('{\n        /// <summary>\n        /// 初始化数据-构造函数后运行\n        /// </summary>\n        '
                                                                    'public void InitData()\n        {\n        }\n'
                                                                    '\n        /// <summary>\n        /// 初始化数据-构造函数后运行\n        /// </summary>        '
                                                                    '\n        public void InitData2()\n        {\n        }\n    }'
                                                                    '\n}\n')
        class_str = self.combine_strings(all_str)
        return self.define_str2 + class_str + all_str