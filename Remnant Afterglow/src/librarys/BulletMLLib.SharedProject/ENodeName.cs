namespace BulletMLLib.SharedProject;

public enum ENodeName
{
    bullet,//定义子弹的属性
    //定义子弹的初始方向、初始速度以及子弹的行为。label 属性给子弹一个标识。被标记的子弹元素可以通过 bulletRef 元素来引用

    action,
    fire,
    changeDirection,
    changeSpeed,
    accel,
    wait,       //暂停
    repeat,
    bulletRef,
    actionRef,
    fireRef,
    vanish,
    horizontal,
    vertical,
    term,
    times,
    direction,
    speed,
    param,  //参数
    bulletml
}
