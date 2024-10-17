using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public partial class ErrorBase
    {
        public string GetError(string key)
        {
            switch (key)
            {
                case "zh_cn":
                    return zh_cn;
                default:
                    return zh_cn;
            }
        }
    }
}

