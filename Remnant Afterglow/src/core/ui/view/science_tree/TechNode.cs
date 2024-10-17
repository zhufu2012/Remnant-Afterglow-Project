
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public class TechNode
    {
        public string Name { get; set; }
        public List<TechNode> Children { get; set; }

        public TechNode(string name)
        {
            Name = name;
            Children = new List<TechNode>();
        }
    }
}
