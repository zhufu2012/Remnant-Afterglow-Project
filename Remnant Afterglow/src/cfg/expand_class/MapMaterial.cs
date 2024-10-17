using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 地图材料
    /// </summary>
    public partial class MapMaterial
    {
        public Cell GetCell(int x, int y)
        {
            return new Cell(x, y, MaterialId, PassTypeId, ImageSetId, ImageSetIndex);
        }

        public Cell GetCell()
        {
            return new Cell(0, 0, MaterialId, PassTypeId, ImageSetId, ImageSetIndex);
        }

        public override string ToString()
        {
            string str = "MaterialId=" + MaterialId + ",MaterialName=" + MaterialName +
              ",Probability=" + Probability + ",ImageSetId=" + ImageSetId + ",ImageSetIndex=" + ImageSetIndex;
            return str;
        }
    }
}
