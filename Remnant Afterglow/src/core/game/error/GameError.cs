
using GameLog;

namespace Remnant_Afterglow
{
    public class GameError
    {
        public int error = 0;
        public GameError() { }
        public GameError(int error)
        {
            this.error = error;
        }

        public static void PrintError(int error)
        {
            ErrorBase errorBase = ConfigCache.GetErrorBase(error);
            Log.Print(errorBase.GetError(GameResources.gameParam.language));
        }
    }
}
