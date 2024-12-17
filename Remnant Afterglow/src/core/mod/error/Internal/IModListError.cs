using Remnant_Afterglow;

namespace GenericModEngine.Core.Types.Error;

public interface IModListError
{
    //来源名称
    public string Source { get; init; }
    public string? Target { get; init; }
    public ModListErrorSeverity Severity { get; }
    
    public string ToString();
}