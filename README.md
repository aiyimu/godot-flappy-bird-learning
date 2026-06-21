# Flappy Bird Clone

基于 Godot Engine 4.x 开发的 Flappy Bird 复刻项目，用于学习 2D 游戏开发的核心概念：角色物理跳跃、障碍物滚动生成、碰撞检测、计分系统以及像素风格着色器。

## 游戏截图

> 运行项目后在 Godot 编辑器中按 F5 或点击运行按钮即可体验。

## 功能特性

- **物理跳跃系统**：模拟重力加速度与跳跃冲量，小鸟根据垂直速度实时旋转
- **管道障碍物**：随机间隙、随机 Y 位置动态生成管道对，从右侧向左侧持续滚动
- **碰撞检测**：双通道碰撞检测（物理碰撞 + Area2D 重叠），支持障碍物、地面和得分区域
- **计分系统**：通过管道间隙得分，本地持久化最高分记录
- **像素化着色器**：AI 生成的复古像素风格后处理特效，可调节像素块大小和调色板颜色数
- **合成音效**：通过 AudioStreamGenerator 实时合成跳跃、得分和死亡音效，无需外部音频文件
- **游戏状态管理**：菜单 → 游戏中 → 游戏结束 三状态流转，支持重新开始
- **最高分记录**：使用 FileAccess 将最高分保存到本地文件，跨会话保留

## 项目结构

```
.
├── assets/                  # 资源文件
│   ├── shaders/             # 着色器
│   │   └── pixelate.gdshader    # 像素化后处理着色器
│   └── sprites/             # 精灵图片
│       ├── background.png       # 游戏背景
│       ├── bird.png / bird2.png # 小鸟精灵
│       ├── ground.png           # 地面贴图
│       └── pipe.png             # 管道贴图
├── scenes/                  # 场景文件
│   ├── ui/                  # UI 场景
│   │   ├── start_menu.tscn      # 开始菜单界面
│   │   └── game_over.tscn       # 游戏结束界面
│   ├── main.tscn                # 主场景（场景管理器）
│   ├── game.tscn                # 游戏主场景
│   ├── bird.tscn                # 小鸟角色场景
│   ├── pipe.tscn                # 单个管道场景
│   ├── pipe_pair.tscn           # 管道对场景（上下管道 + 得分区）
│   └── ground.tscn              # 地面场景
├── scripts/                 # 脚本文件
│   ├── ui/                  # UI 脚本
│   │   ├── start_menu.gd        # 开始菜单逻辑
│   │   └── game_over.gd         # 游戏结束面板逻辑
│   ├── main.gd                  # 主入口脚本（场景切换）
│   ├── game.gd                  # 游戏核心逻辑（信号连接、流程控制）
│   ├── bird.gd                  # 小鸟物理、跳跃、碰撞与死亡
│   ├── pipe.gd                  # 管道脚本（碰撞检测）
│   ├── pipe_pair.gd             # 管道对移动与布局
│   ├── pipe_spawner.gd          # 管道定时生成器
│   ├── ground.gd                # 地面无限滚动
│   ├── game_manager.gd          # 游戏状态管理（Autoload 单例）
│   ├── score_manager.gd         # 分数管理（Autoload 单例）
│   └── audio_manager.gd         # 音频管理（Autoload 单例）
├── project.godot            # Godot 项目配置文件
├── LICENSE                  # 开源许可
└── README.md                # 项目说明
```

## 核心架构

### Autoload 单例

项目使用 3 个 Autoload 单例实现跨场景数据共享：

| 单例 | 职责 |
|------|------|
| `GameManager` | 游戏状态管理（MENU / PLAYING / GAME_OVER），状态切换信号发射 |
| `ScoreManager` | 当前分数与最高分管理，本地文件持久化（`user://highscore.save`） |
| `AudioManager` | 音频总线设置，合成音效播放（跳跃 600Hz / 得分 880Hz / 死亡 200Hz） |

### 场景流转

```
main.tscn (入口)
  ├── 加载 start_menu.tscn → 显示最高分，等待点击开始
  │     └── 点击开始 → 触发 start_game 信号
  ├── 加载 game.tscn → 游戏运行
  │     ├── GameManager.start_game() → 发射 game_started 信号
  │     ├── PipeSpawner 开始定时随机生成管道
  │     ├── 小鸟物理模拟（重力 + 跳跃 + 旋转）
  │     ├── 碰撞检测 → die() → 发射 bird_died 信号
  │     │     └── GameManager.end_game() → 显示 GameOverPanel
  │     └── 通过得分区 → 发射 score_passed 信号 → ScoreManager.add_score()
  └── 点击重新开始 → 触发 back_to_menu 信号 → 回到菜单
```

### 小鸟物理

- **重力**：`980 px/s²`，每帧累加到垂直速度
- **最大下落速度**：`600 px/s`，防止下落过快
- **跳跃**：空格键/鼠标左键，瞬时速度设为 `-400 px/s`（向上）
- **旋转**：根据当前垂直速度与最大下落速度的比值插值旋转，范围 `-0.75 ~ 0.75` 弧度
- **死亡条件**：碰撞管道/地面、飞出屏幕顶部

### 管道系统

- `PipeSpawner` 使用 Timer 定时生成，间隔随机 1.5-2.5 秒
- 每个 `PipePair` 包含上管道、下管道和得分区域（Area2D）
- 管道间隙随机 180-260 像素
- Y 位置随机 250-750 像素
- 管道对整体向左移动，超出屏幕后自动销毁（`queue_free`）

### 地面滚动

- 使用两个相同的 `Sprite2D` 首尾拼接实现无限滚动
- 当某个精灵完全移出屏幕左侧时，重置到右侧继续滚动

## 运行方式

### 环境要求

- **Godot Engine 4.x**（推荐 4.6+）
- 支持 Windows、macOS、Linux 平台

### 步骤

1. 克隆仓库：
   ```bash
   git clone <repository-url>
   cd godot-flappy-bird-learning
   ```

2. 使用 Godot Engine 打开项目：
   - 启动 Godot Engine
   - 点击"导入" → 选择项目根目录下的 `project.godot` 文件
   - 或直接将 `project.godot` 拖入 Godot 项目管理器

3. 运行项目：
   - 点击编辑器右上角的运行按钮（▶）或按 `F5`

### 操作方式

| 按键 | 操作 |
|------|------|
| 空格键 / 鼠标左键 | 小鸟跳跃 |
| 点击开始按钮 | 开始游戏 |

## 技术要点

- **Godot 4.x GDScript**：使用 `@export` 导出变量可在编辑器中调节参数
- **信号机制**：解耦场景间通信，通过信号连接实现模块化
- **CharacterBody2D**：使用 `move_and_slide()` 处理物理移动，`get_slide_collision_count()` 检测碰撞
- **Area2D**：用于得分区域检测，通过 `area_entered` 信号触发得分
- **分组系统**：`obstacle`、`ground`、`score` 分组标记，简化碰撞判断
- **CanvasItem Shader**：后处理着色器实现像素化 + 颜色量化复古特效
- **程序化音频**：AudioStreamGenerator 实时合成音效，无需外部音频资源
- **文件持久化**：FileAccess 读写最高分数据

## 着色器效果

像素化着色器（`pixelate.gdshader`）提供两个可调参数：

| 参数 | 范围 | 默认值 | 说明 |
|------|------|--------|------|
| `pixel_size` | 1.0 - 16.0 | 4.0 | 像素块大小，值越大画面越粗糙 |
| `color_count` | 2 - 256 | 32 | 调色板颜色数，值越小色彩越复古 |

## 许可

本项目使用 MIT License 开源，详见 [LICENSE](LICENSE) 文件。