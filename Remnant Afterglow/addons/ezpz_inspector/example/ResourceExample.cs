using Calcatz.EzpzInspector;
using Godot;

namespace Calcatz.Example
{

    [Tool]
    public partial class ResourceExample : Resource
    {

        [Export]
        private int _myValue;

        [ExportButton]
        private void RandomizeValue()
        {
            _myValue = GD.RandRange(0, 100);
        }

    }

}
