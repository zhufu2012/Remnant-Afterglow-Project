using System;
using System.Xml;
using System.Xml.Schema;
using BulletMLLib.SharedProject.Nodes;
using GameLog;

namespace BulletMLLib.SharedProject
{
    /// <summary>
    /// 这是一个完整的文档，用于描述一个子弹模式。
    /// </summary>
    public class BulletPattern
    {
        #region Members

        /// <summary>
        /// 描述子弹模式的树结构的根节点。
        /// </summary>
        public BulletMLNode RootNode { get; private set; }

        /// <summary>
        /// 获取文件名。
        /// 此属性仅在调用解析方法时设置。
        /// </summary>
        public string Filename { get; private set; }

        /// <summary>
        /// 子弹模式的方向：水平或垂直。
        /// 从 XML 中读取。
        /// </summary>
        public EPatternType Orientation { get; private set; } = EPatternType.none;

        #endregion //Members

        #region Methods

        /// <summary>
        /// 初始化 <see cref="BulletPattern"/> 类的新实例。
        /// </summary>
        public BulletPattern()
        {
            RootNode = null;
        }

        /// <summary>
        /// 将字符串转换为模式类型枚举。
        /// </summary>
        /// <param name="str">字符串。</param>
        /// <returns>模式类型。</returns>
        private static EPatternType StringToPatternType(string str)
        {
            return (EPatternType)Enum.Parse(typeof(EPatternType), str);
        }

        /// <summary>
        /// 解析 BulletML 文档并将其加载到此子弹模式中。
        /// </summary>
        /// <param name="xmlFileName">XML 文件名。</param>
        public void ParseXML(string xmlFileName)
        {
            // 获取文件名
            Filename = xmlFileName;

            try
            {
#if NETFX_CORE
                XmlReaderSettings settings = new XmlReaderSettings();
                settings.DtdProcessing = DtdProcessing.Ignore;
#else
                var settings = new XmlReaderSettings
                {
                    ValidationType = ValidationType.None,
                    DtdProcessing = DtdProcessing.Parse
                };
                settings.ValidationEventHandler += MyValidationEventHandler;
#endif
                Log.Error(xmlFileName);
                // 使用 XmlReader 读取 XML 文件
                using (var reader = XmlReader.Create(xmlFileName, settings))
                {
                    // 加载 XML 文档
                    var xmlDoc = new XmlDocument();
                    xmlDoc.Load(reader);
                    ReadXmlDocument(xmlDoc);
                }
            }
            catch (Exception ex)
            {
                // 读取文件时发生错误
                throw new Exception("Error reading \"" + xmlFileName + "\"", ex);
            }

            // 验证所有子弹节点的有效性
            try
            {
                RootNode.ValidateNode();
            }
            catch (Exception ex)
            {
                // 验证节点时发生错误
                throw new Exception("Error reading \"" + xmlFileName + "\"", ex);
            }
        }

        /// <summary>
        /// 读取 XML 文档并解析子弹模式。
        /// </summary>
        /// <param name="xmlDoc">XML 文档。</param>
        private void ReadXmlDocument(XmlDocument xmlDoc)
        {
            XmlNode rootXmlNode = xmlDoc.DocumentElement;

            // 确保它是有效的 XML 节点
            if (rootXmlNode == null || rootXmlNode.NodeType != XmlNodeType.Element)
                return;

            // 检查根节点是否为 bulletml
            var strElementName = rootXmlNode.Name;
            if ("bulletml" != strElementName)
            {
                throw new Exception(
                    "Error reading \""
                    + Filename
                    + "\": XML root node needs to be \"bulletml\", found \""
                    + strElementName
                    + "\" instead"
                );
            }

            // 创建子弹模式树的根节点
            RootNode = new BulletMLNode(ENodeName.bulletml);

            // 解析整个 bulletml 树
            RootNode.Parse(rootXmlNode, null);

            // 确定模式的方向：水平或垂直
            XmlNamedNodeMap mapAttributes = rootXmlNode.Attributes;
            if (mapAttributes == null)
                return;

            for (var i = 0; i < mapAttributes.Count; i++)
            {
                var strName = mapAttributes.Item(i).Name;
                var strValue = mapAttributes.Item(i).Value;
                if ("type" == strName)
                {
                    // 如果这是顶级节点，"type" 将是 vertical 或 horizontal
                    Orientation = StringToPatternType(strValue);
                }
            }
        }

#if !NETFX_CORE
        /// <summary>
        /// 验证错误发生时调用的委托方法。
        /// </summary>
        /// <param name="sender">发送者。</param>
        /// <param name="args">参数。</param>
        private static void MyValidationEventHandler(object sender, ValidationEventArgs args)
        {
            throw new XmlSchemaException(
                "Error validating bulletml document: " + args.Message,
                args.Exception,
                args.Exception.LineNumber,
                args.Exception.LinePosition
            );
        }
#endif

        #endregion //Methods
    }
}