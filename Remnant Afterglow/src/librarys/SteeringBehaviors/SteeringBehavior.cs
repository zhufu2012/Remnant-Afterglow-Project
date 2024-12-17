
namespace SteeringBehaviors;
//ai转向行为
class SteeringBehavior
{
    public virtual Vector2 Calculate()
    {
        return Vector2.ZERO;
    }
}