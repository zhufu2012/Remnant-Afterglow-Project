namespace Remnant_Afterglow
{
    //最基础的可拓展类，理论上所有类就继承于此
    public class ModObject : IJsonModelWrapper
    {
        public string ModelFullName { get; set; }
    }
}
