import Config


##根据数据合成一个配置类
class CSharpClassGenerator:
    def __init__(self, data, ConfigData):
        self.data = data
        self.Config = ConfigData
        self.define_str = self.Config["默认开头添加的库名"]
        self.define_str2 = self.Config["类2默认开头添加的库名"]
        self.class_str_dict = self.Config["导出类型对应库名称"]

    def combine_strings(self, input_string):
        str_to_return = ""
        class_dict = {}
        # 遍历字典中的键
        for key in self.class_str_dict.keys():
            # 检查输入字符串是否包含当前键
            if key in input_string:
                # 如果包含，则将对应的值添加到返回的字符串中
                class_dict[self.class_str_dict[key]] = self.class_str_dict[key]
        for key in class_dict.keys():
            str_to_return += key

        return str_to_return

    def generate_class(self, result_dict, subtable_name_list2):
        class_name = self._get_class_name()
        properties = self._generate_properties(result_dict)
        constructor = self._generate_constructor()  ##int id
        constructor2 = self._generate_constructor2()  ##Dictionary<string, object> dict
        constructor3 = self._generate_constructor3()  ##string cfg_id
        xlsx_dec = ""
        for sub_table_name in subtable_name_list2:
            if sub_table_name.find(class_name) != -1:
                if sub_table_name.rfind("_") != sub_table_name.find("_"):  # 存在两个以上_
                    xlsx_dec = sub_table_name[sub_table_name.rfind("_") + 1:]
                break
        all_str = f'namespace {self.Config["导出类的命名空间"]}\n{{\n    /// <summary>\n    /// 自动生成的配置类 {class_name} 用于 {xlsx_dec},拓展请在expand_class文件下使用partial拓展\n    /// </summary>\n' \
                  f'    public partial class {class_name}\n    ' + '{\n        #region 参数及初始化\n' + properties + '\n' + \
                  constructor + "\n        " + constructor3 + "\n        " + constructor2 + '        #endregion\n    }\n}\n'
        class_str = self.combine_strings(all_str)
        return self.define_str + class_str + all_str

    def _get_class_name(self):
        return self.data['file_name'][4:5].upper() + self.data['file_name'][5:]

    def _generate_properties(self, result_dict):
        properties = []
        for key, value_type in self.data['key_list'].items():
            if key == 'KEY_INDEX':
                continue  # Skip the index key as it's not a property of the class.
            describe = ""
            for i, key_name in enumerate(result_dict[2]):
                if key_name == key and (len(result_dict[1]) >= i + 1) and (result_dict[1][i] in [1, 2, 3]):
                    describe = result_dict[0][i]
            describe = describe.replace("\n", "\n        ///")
            properties.append(
                f'        /// <summary>        \n        /// {describe}\n        /// </summary>\n        public {self.type_replace(value_type)} {key} {{ get; set; }}')

        return '\n'.join(properties)

    def _generate_properties2(self):
        properties = []
        for key, value_type in self.data['key_list'].items():
            if key == 'KEY_INDEX':
                continue  # Skip the index key as it's not a property of the class.
            properties.append(f'			{key} = ({self.type_replace(value_type)})dict[\"{key}\"];')
        return '\n'.join(properties)

    def _generate_constructor(self):
        class_name = self._get_class_name()
        assignment_statements = self._generate_properties2()
        filename = self.data['file_name']
        return f'\n        public {class_name}(int id)\n        ' + '{' + \
            f'\n            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_{self._get_class_name()}, id);' + \
            f'//public const string Config_{self._get_class_name()} = \"' + f'{filename}\"; \n' \
                                                                            '' + assignment_statements + '\n			' + 'InitData();\n' + \
            '        }\n'

    def _generate_constructor2(self):
        class_name = self._get_class_name()
        assignment_statements = self._generate_properties2()
        filename = self.data['file_name']
        return f'public {class_name}(Dictionary<string, object> dict)\n        ' + '{\n' + \
            '' + assignment_statements + '\n			InitData();\n' + \
            '        }\n'

    def _generate_constructor3(self):
        class_name = self._get_class_name()
        assignment_statements = self._generate_properties2()
        filename = self.data['file_name']
        return f'\n        public {class_name}(string cfg_id)\n        ' + '{' + \
            f'\n            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_{self._get_class_name()}, cfg_id);' + \
            f'//public const string Config_{self._get_class_name()} = \"' + f'{filename}\"; \n' \
                                                                            '' + assignment_statements + '\n			InitData();\n' + \
            '        }\n'

    def _generate_to_string(self):
        class_name = self._get_class_name()
        start_str = "       public override string ToString()\n        {\n            return $\"" + class_name + "  ["
        ##[ObjectId={ObjectId}, AttributeId={AttributeId}, StartValue={StartValue}, Max={Max}, Min={Min}, Regen={Regen}, RegenFps={RegenFps}, AttrEventIdList={AttrEventIdList.Count} entries]";

    def type_replace(self, value_type):
        dicts = self.Config["特殊的导出类型,需要替换"]
        if value_type in dicts:
            return dicts[value_type]
        else:
            return value_type

    ##基础类2生成
    def generate_class2(self, subtable_name_list2):
        class_name = self._get_class_name()
        xlsx_dec = ""
        for sub_table_name in subtable_name_list2:
            if sub_table_name.find(class_name) != -1:
                if sub_table_name.rfind("_") != sub_table_name.find("_"):  # 存在两个以上_
                    xlsx_dec = sub_table_name[sub_table_name.rfind("_") + 1:]
                break
        all_str = f'namespace {self.Config["导出类的命名空间"]}\n{{\n    /// <summary>\n    /// 自动生成的配置类2 {class_name} 用于 {xlsx_dec},拓展请在expand_class文件下使用partial拓展\n    /// </summary>\n' \
                  f'    public partial class {class_name}\n    ' + ('{\n        /// <summary>\n        /// '
                                                                    '初始化数据-构造函数后运行\n        /// </summary>\n        '
                                                                    'public void InitData()\n        {\n        }\n'
                                                                    '\n        /// <summary>\n        /// '
                                                                    '初始化数据-构造函数后运行\n        /// </summary>        '
                                                                    '\n        public void InitData2()\n        {\n        }\n    }'
                                                                    '\n}\n')
        class_str = self.combine_strings(all_str)
        return self.define_str2 + class_str + all_str

# Usage example
# data = {
#     'file_name': 'cfg_MapMaterial',
#     'file_path': './data/config/data/cfg_MapMaterial.json',
#     'key_list': {
#         'KEY_INDEX': 'string',
#         'MaterialId': 'int',
#         'MaterialName': 'string',
#         'Probability': 'float',
#         'ImageSetId': 'int',
#         'ImageSetIndex': 'int',
#         'Parame': 'float'
#     }
# }
#
# generator = CSharpClassGenerator(data)
# csharp_code = generator.generate_class()
# print(csharp_code)
