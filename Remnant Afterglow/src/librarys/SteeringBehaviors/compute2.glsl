#[compute]
#version 460

// Boid 数据结构
struct Boid {
    vec2 Position;      // 位置向量
    vec2 Velocity;      // 速度向量
    float FlockID;      // 所属鸟群ID
    float SpatialBinID; // 空间分区ID
};

// Unit 数据结构
struct Unit {
    float Logotype;           //单位唯一id
    vec2 Position;          // 位置向量
    vec2 SteerForce;        // 当前行为力
    float Mass;             // 质量
    float SeparationRadius; //分离半径
    float SpatialBinID;     // 空间分区ID
};

// 设置计算着色器的工作组大小（64个线程/工作组）
layout(local_size_x = 64, local_size_y = 1, local_size_z = 1) in;

// 输入缓冲区：当前帧的Boid数据（只读）
layout(set = 0, binding = 0, std430) restrict readonly buffer BoidBuffer {
    float boid[][16]; // 每个Boid由16个float组成
} BoidBufferLookup;

// 输出缓冲区：更新后的Boid数据
layout(set = 0, binding = 1, std430) restrict buffer BoidUpdateBuffer {
    float boid[];
} BoidBufferUpdate;

// 空间分区相关缓冲区 --------------------------
// 空间分区查找表（只读）
layout(set = 0, binding = 2, std430) restrict readonly buffer BoidHashLocationBuffer {
    int tile[][64]; // 每个分区最多存储64个Boid ID
} BoidHashLookup;

// 空间分区更新缓冲区
layout(set = 0, binding = 3, std430) restrict buffer BoidHashUpdateBuffer {
    int tile[][64];
} BoidHashUpdate;

// 空间分区大小缓冲区（记录每个分区的Boid数量）
layout(set = 0, binding = 4, std430) restrict buffer BoidHashSizeBuffer {
    int tile[];
} BoidHashSizeLookup;

// 全局参数缓冲区（只读）
layout(set = 0, binding = 5, std430) restrict readonly buffer globalBuffer {
    float VisualRange;       // 视觉范围
    float SeperationDistance; // 分离距离
    float SeperationWeight;  // 分离权重
    float AlignmentWeight;   // 对齐权重
    float CohesionWeight;    // 凝聚权重
    float MoveSpeed;         // 移动速度
    float TotalBoids;        // Boid总数
    float BoundryWidth;      // 边界宽度
    float BoundryEnabled;    // 边界是否启用
    float Screen_X;          // 屏幕宽度
    float Screen_Y;          // 屏幕高度
    float BoundryTurn;       // 边界转向力
    float DeltaTime;         // 帧时间
} Global;

// 计算空间分区数量
int TotalRows = int(ceil(Global.Screen_Y / 60)); // 行数 = 屏幕高度/分区大小(60)
int TotalColumns = int(ceil(Global.Screen_X / 60)); // 列数
int totalTiles = TotalRows * TotalColumns; // 总分区数

// 从缓冲区加载Boid数据
Boid createBoid(int boidID) {
    Boid boid;
    // 从缓冲区读取位置数据（索引3和7）
    boid.Position = vec2(BoidBufferLookup.boid[boidID][3], BoidBufferLookup.boid[boidID][7]);
    // 从缓冲区读取速度数据（索引12和13）
    boid.Velocity = vec2(BoidBufferLookup.boid[boidID][12], BoidBufferLookup.boid[boidID][13]);
    // 从缓冲区读取群组ID（索引14）
    boid.FlockID = BoidBufferLookup.boid[boidID][14];
    // 从缓冲区读取空间分区ID（索引15）
    boid.SpatialBinID = BoidBufferLookup.boid[boidID][15];
    return boid;
}

// 获取当前分区周围的9个相邻分区（包括自身）
int[9] getRelevantBins(int binID) {
    int relevantBins[9] = {-1, -1, -1, -1, binID, -1, -1, -1, -1};

    // 检查边界情况
    bool LEFT = (binID % TotalColumns == 0);
    bool RIGHT = (binID % TotalColumns == TotalColumns - 1);
    bool TOP = (binID < TotalColumns);
    bool BOTTOM = (binID > totalTiles - TotalColumns);

    // 计算相邻分区索引
    if(!TOP) {
        relevantBins[1] = binID - TotalColumns; // 上方分区
        if(!LEFT) relevantBins[0] = binID - TotalColumns - 1; // 左上
        if(!RIGHT) relevantBins[2] = binID - TotalColumns + 1; // 右上
    }

    if(!BOTTOM) {
        relevantBins[7] = binID + TotalColumns; // 下方分区
        if(!LEFT) relevantBins[6] = binID + TotalColumns - 1; // 左下
        if(!RIGHT) relevantBins[8] = binID + TotalColumns + 1; // 右下
    }

    if(!LEFT) relevantBins[3] = binID - 1; // 左侧
    if(!RIGHT) relevantBins[5] = binID + 1; // 右侧

    return relevantBins;
}

// 核心函数：根据邻居计算新速度
vec2 calculateVelocity(Boid thisBoid, int boidID) {
    vec2 newVelocity = thisBoid.Velocity;

    // 仅处理在有效分区内的Boids
    if(thisBoid.SpatialBinID != -1.0) {
        float seperationRangeSquared = Global.SeperationDistance * Global.SeperationDistance;
        int nearbyBoids = 0;

        vec2 seperationVector = vec2(0.0); // 分离向量
        vec2 alignmentVector = vec2(0.0);  // 对齐向量
        vec2 cohesionVector = vec2(0.0);   // 凝聚向量

        // 获取相关分区
        int[] relevantBins = getRelevantBins(int(thisBoid.SpatialBinID));

        // 遍历所有相关分区
        for(int i = 0; i < 9; i++) {
            if(relevantBins[i] == -1) continue;
            int[64] bin = BoidHashLookup.tile[relevantBins[i]];

            // 遍历分区内的所有Boids
            for(int b = 0; b < 64; b++) {
                int otherBoidID = bin[b];
                if(otherBoidID == -1) break; // 空槽位，结束循环
                if(otherBoidID == boidID) continue; // 跳过自身

                Boid otherBoid = createBoid(otherBoidID);
                if(otherBoid.FlockID != thisBoid.FlockID) continue; // 仅处理同群组

                float distanceToOtherBoid = distance(thisBoid.Position, otherBoid.Position);

                // 在视觉范围内的处理
                if(distanceToOtherBoid < Global.VisualRange) {
                    float distanceSquared = distanceToOtherBoid * distanceToOtherBoid;

                    // 分离规则：太近则远离
                    if(distanceSquared < seperationRangeSquared) {
                        seperationVector += thisBoid.Position - otherBoid.Position;
                    }
                    // 对齐和凝聚规则
                    else {
                        alignmentVector += otherBoid.Velocity;
                        cohesionVector += otherBoid.Position;
                        nearbyBoids++;
                    }
                }
            }
        }

        // 应用群体规则
        if(nearbyBoids > 0) {
            vec2 averagedPosition = cohesionVector / float(nearbyBoids); // 平均位置
            vec2 averagedVelocity = alignmentVector / float(nearbyBoids); // 平均速度

            // 凝聚：向平均位置移动
            newVelocity += (averagedPosition - thisBoid.Position) * Global.CohesionWeight;
            // 对齐：匹配平均速度
            newVelocity += (averagedVelocity - thisBoid.Velocity) * Global.AlignmentWeight;
            // 分离：远离太近的Boids
            newVelocity += seperationVector * Global.SeperationWeight;
        }
    }

    return newVelocity;
}

// 边界处理：当Boid接近边界时转向
vec2 returnToBoundry(Boid thisBoid, vec2 velocity) {
    float top = Global.BoundryWidth;
    float left = Global.BoundryWidth;
    float right = Global.Screen_X - Global.BoundryWidth;
    float bottom = Global.Screen_Y - Global.BoundryWidth;

    if(thisBoid.Position.y < top) velocity.y += Global.BoundryTurn;
    if(thisBoid.Position.x > right) velocity.x -= Global.BoundryTurn;
    if(thisBoid.Position.y > bottom) velocity.y -= Global.BoundryTurn;
    if(thisBoid.Position.x < left) velocity.x += Global.BoundryTurn;

    return velocity;
}

// 速度限制
vec2 containSpeed(vec2 velocity) {
    float speed = length(velocity);

    // 最小速度
    if(speed < 1.0) velocity = normalize(velocity);
    // 最大速度
    if(speed > 2.0) velocity = normalize(velocity) * 2.0;

    return velocity;
}

// 屏幕环绕（当边界禁用时）
vec2 wrapScreen(vec2 position) {
    if(position.x < 0.0) position.x += Global.Screen_X;
    if(position.x > Global.Screen_X) position.x -= Global.Screen_X;
    if(position.y < 0.0) position.y += Global.Screen_Y;
    if(position.y > Global.Screen_Y) position.y -= Global.Screen_Y;

    return position;
}

// 检查是否超出边界
bool isOutOfBounds(vec2 position) {
    return position.x < 0.0 || position.x > Global.Screen_X ||
           position.y < 0.0 || position.y > Global.Screen_Y;
}

// 根据速度方向生成颜色
vec3 getColor(vec2 vector) {
    float r = (vector.x + 1) / 2;   // X分量映射到红色
    float b = (vector.y + 1) / 2;   // Y分量映射到蓝色
    float g = (r + b) / 2;          // 混合分量映射到绿色

    return normalize(vec3(r, 1 - g, b)); // 归一化颜色
}

// 计算朝向角度（基于速度方向）
float getAngle(vec2 vector) {
    return -atan(vector.y, vector.x); // 负角度+90度补偿（基于网格方向）
}

// 将Boid添加到空间分区
void addToHash(int boidID, int binID) {
    // 原子操作增加分区计数
    int index = atomicAdd(BoidHashSizeLookup.tile[binID], 1);

    // 如果分区未满（<64），添加Boid ID
    if(index < 64) {
        BoidHashUpdate.tile[binID][index] = boidID;
    }
}

// 将Boid数据打包回缓冲区
void compileBoid(int boidID, vec2 newPosition, vec2 newVelocity) {
    // 计算新的空间分区
    float SpatialBinID = -1.0; // 默认为无效分区

    if(!isOutOfBounds(newPosition)) {
        float Row = floor(newPosition.y / 60);
        float Column = floor(newPosition.x / 60);
        SpatialBinID = (Row * TotalColumns) + Column;
    }

    // 更新空间分区
    addToHash(boidID, int(SpatialBinID));

    // 计算缓冲区索引
    int trueID = boidID * 16;

    // 计算颜色和旋转
    vec2 velocityNormal = normalize(newVelocity);
    vec3 color = getColor(velocityNormal);
    float rotation = getAngle(velocityNormal);

    // 旋转矩阵分量
    float cr = cos(rotation);
    float sr = sin(rotation);

    // 写入变换矩阵
    BoidBufferUpdate.boid[trueID]     = cr;      // transform[0][0]
    BoidBufferUpdate.boid[trueID + 1] = sr;      // transform[0][1]
    BoidBufferUpdate.boid[trueID + 3] = newPosition.x; // transform[0][2]
    BoidBufferUpdate.boid[trueID + 4] = -sr;     // transform[1][0]
    BoidBufferUpdate.boid[trueID + 5] = cr;      // transform[1][1]
    BoidBufferUpdate.boid[trueID + 7] = newPosition.y; // transform[1][2]

    // 写入颜色
    BoidBufferUpdate.boid[trueID + 8] = color.r;  // color.r
    BoidBufferUpdate.boid[trueID + 9] = color.g;  // color.g
    BoidBufferUpdate.boid[trueID + 10] = color.b; // color.b

    // 写入速度和元数据
    BoidBufferUpdate.boid[trueID + 12] = newVelocity.x; // velocity.x
    BoidBufferUpdate.boid[trueID + 13] = newVelocity.y; // velocity.y
    BoidBufferUpdate.boid[trueID + 15] = SpatialBinID; // 空间分区ID
}

// 主计算函数（每个Boid执行一次）
void main() {
    // 获取当前处理的Boid ID
    int boidID = int(gl_GlobalInvocationID.x);

    // 加载当前Boid数据
    Boid thisBoid = createBoid(boidID);

    // 计算新速度（应用群体规则）
    vec2 newVelocity = calculateVelocity(thisBoid, boidID);

    // 边界处理
    if(Global.BoundryEnabled == 1.0) {
        newVelocity = returnToBoundry(thisBoid, newVelocity);
    }

    // 速度限制
    newVelocity = containSpeed(newVelocity);
    newVelocity *= Global.MoveSpeed; // 应用全局速度系数

    // 计算新位置
    vec2 newPosition = thisBoid.Position + newVelocity;

    // 屏幕环绕（当边界禁用时）
    if(Global.BoundryEnabled == 0.0) {
        newPosition = wrapScreen(newPosition);
    }

    // 更新Boid数据
    compileBoid(boidID, newPosition, newVelocity);
}