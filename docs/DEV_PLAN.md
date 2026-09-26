# NutriScan MVP — 开发计划

2026-09-26 · 草案 v0.1，待 Hannes 审阅

本文档把 [PRD](./PRD.md) 拆成可执行的任务。PRD 是"做什么、为什么"，本文是"按什么顺序、做到什么程度算完"。凡是 PRD 没写、本计划自行补充或偏离 PRD 的地方，都在第 7 节集中列出，方便审阅时逐条过。

**阅读顺序建议**：第 1 节（需要你拍板的决策）→ 第 7 节（对 PRD 的补充）→ 第 4 节（任务清单）→ 其余按需。

---

## 1. 开工前需要拍板的决策

PRD 第 9 节的待决问题，加上拆任务时新冒出来的几项。每项给出建议值；你同意的直接打勾，不同意的写在备注里。**标 ★ 的会阻塞阶段 1 编码，必须在阶段 0 结束前定下来。**

| # | 问题 | 建议 | 理由 | 何时定 |
| --- | --- | --- | --- | --- |
| D1 ★ | App 名称与包名 | 名称 `NutriScan`，包名 `dev.hannesgao.nutriscan`（占位，上架前可改） | 与仓库名一致；Flutter 改包名成本低，但越晚改越烦 | 阶段 1 开工前 |
| D2 ★ | 界面语言 | 从第一天起走 Flutter ARB 国际化，MVP 只填 **中文** 一种 | 自用优先读得快；ARB 结构在，后补德/英文只是加文件 | 阶段 1 开工前 |
| D3 ★ | 对象存储桶 | **Backblaze B2，EU Central（阿姆斯特丹）**，S3 兼容接口 | B2 的 application key 可以只给 `writeFiles` 不给 `deleteFiles`，且默认保留所有文件版本——"append-only"由凭证和存储端双重保证，不靠代码自觉。R2 / Hetzner 若能提供同等"只写不删"的凭证或 Object Lock 也可，阶段 0 核实 | 阶段 0 |
| D4 ★ | 营养素字段命名主标准 | 内部主键用 PRD 编码规范里的**带单位后缀 snake_case**（`energy_kcal`、`salt_g`），EuroFIR 代码、OFF 字段名、USDA nutrient ID 三者都是映射列 | 这样"以 BLS 为主还是以 OFF 为主"不再是二选一；主键稳定、自解释，映射表随阶段 0 的 BLS 笔记补全 | 阶段 0 看完 BLS 后确认 |
| D5 | OFF 命中率 | 由阶段 0 实测得出 | 命中率 ≥ 60%：阶段 1 先做 F1 完整链路再做 F2；< 30%：F2 提前，F1 只做本地缓存 + 最简 OFF 查询 | 阶段 0 结束 |
| D6 | 是否打包 USDA Foundation Foods | **MVP 不打包** | BLS 覆盖德国食材已足够；多一个许可来源多一份合规负担 | 阶段 2 再议 |
| D7 | ODbL 法律咨询 | 上架前再做，MVP 不阻塞 | MVP 不分发 | 阶段 5 前 |
| D8 ★ | 离线未命中时能否先记账 | **可以**：离线拍照后生成"待提取"的记录条目，份量照记；当日汇总单独显示"N 条待提取，未计入合计"；联网后提示去确认 | PRD 要求"拍照可先存本地，联网后再提取"，但没说这段时间里吃的东西怎么记。不允许的话，地下超市扫到新商品就只能事后补记 | 阶段 1 开工前 |
| D9 ★ | 手动输入的数据 provenance 记什么 | 记为 `vlm_user`，对应 extraction 记录的 `model = "manual"`、无 raw JSON | PRD 的四个取值里没有纯手动；手动录入与 VLM+用户确认在许可上同属"自有"，没必要多一个枚举值。若你希望区分，改成新增 `user_manual` | 阶段 1 开工前 |
| D10 | 照片存几份分辨率 | **只存一份**：拍完即缩放到长边 2048px、JPEG q90；本地、送 VLM、上传桶是同一份字节 | "raw JSON 由哪张图得来"必须精确可追溯；存原图 + 派生图会引入第二个版本。2048px 对营养成分表足够，也控制 VLM token 与上传体积。Opus 5 / Sonnet 5 支持到长边 2576px，2048px 不会被服务端再缩；若 D14 选 Haiku 4.5（上限 1568px），改为直接缩到 1568px，避免服务端二次缩放导致"送进去的图"与存档不一致 | 阶段 0.5 用评测集验证清晰度 |
| D11 | 桶里是否额外存"用户确认后的值" | **建议存**：除照片与 raw JSON 外，再 append 一个 `_confirmed.json`（归一化结果 + 用户改了哪些字段） | 用户修正是最有价值的标注数据，将来就是评测集的扩充来源；PRD 的"错误反馈闭环"需要它落到不可删的地方 | 阶段 1 开工前 |
| D12 | 状态管理 / 本地数据库库选型 | Riverpod + drift | drift：类型安全、迁移可测、支持内存库做单测、能写 SQLite trigger；Riverpod：样板少、易测。都是 Flutter 社区主流，Claude Code 熟悉 | 阶段 1 开工前 |
| D13 | VLM API Key 放哪 | MVP 用 `--dart-define-from-file=secrets.json` 编译期注入，`secrets.json` 进 `.gitignore`；Anthropic Console 为这个 Key 单独建 workspace 并设月度消费上限 | Claude API 是付费 Key，泄露直接产生费用，消费上限兜底；只装在自己手机上可接受，任何形式分发前必须改成无状态代理转发，Key 不落客户端 | 阶段 1 开工前 |
| D14 ★ | VLM 用哪个 Claude 型号 | 阶段 0.5 在评测集上跑 Opus 5（`claude-opus-5`，PRD 默认）、Sonnet 5（`claude-sonnet-5`）、Haiku 4.5（`claude-haiku-4-5`），按准确率 / 单次成本 / P90 延迟由你拍板 | 三者价格差 5 倍（输入 $5 / $2 / $1 每百万 token）；自用每天几次调用，任一型号月成本都在个位数美元，所以主要看准确率和能否在 25 s 内返回 | 阶段 0.5 结束 |
| D15 | 是否保留 Mistral 作为备选 | 保留，评测时一起跑 | Claude 直连 API 能否在 EU 境内推理待核实；Mistral 是现成的 EU 数据驻留退路 | 阶段 0.5 结束 |

---

## 2. 仓库骨架与工程约定

沿用 PRD 第 8 节的目录结构，阶段 1 结束时的样子：

```
app/                    Flutter 客户端
  lib/
    generated/          ← schema/ codegen 产物，禁止手改（CI 校验）
    data/               唯一的 data access 层：drift 数据库、repository、外部 client
      db/               表定义、迁移、trigger
      repositories/     ProductRepository / LogRepository / UploadQueueRepository …
      clients/          OffClient / VlmClient / BucketClient（全部带超时）
    domain/             纯 Dart：归一化、规则校验、份量换算（无 Flutter 依赖，便于单测）
    features/           scan/ confirm/ portion/ summary/ settings/
    l10n/               ARB 文件
  test/
api/                    阶段 4 前只放 README
schema/
  nutrients.yaml        营养素字段唯一定义（主键、单位、EuroFIR/OFF/USDA 映射、标签顺序、父子关系）
  nutriscan_schema/     Pydantic v2 模型：VLM 输出结构、校验规则常量
  prompts/              vlm_extract.v1.md …（文件名即版本号）
  codegen/              生成 JSON Schema + Dart 代码的脚本
  generated/            vlm_output.v1.schema.json（Claude `output_config.format` / Mistral 的 response schema）
  eval/                 评测集图片、人工标注真值、评测脚本
  tools/                阶段 0 的一次性脚本（OFF 命中率探测等）
docs/
  PRD.md  DEV_PLAN.md  LICENSES.md  decisions/  notes/
.github/workflows/      app.yml / schema.yml / api.yml（path filter）
```

**关于"schema 唯一来源"的落地方式**（PRD 规则 1 + "Pydantic v2 作为 schema 源"）：

- `schema/nutrients.yaml` 是营养素**清单**的唯一定义；`schema/nutriscan_schema/` 里的 Pydantic 模型读取它，定义 VLM 输出**结构**。
- `schema/codegen/generate.py` 一条命令产出：
  1. `schema/generated/vlm_output.v<N>.schema.json`（直接喂给 VLM 的结构化输出参数）
  2. `app/lib/generated/nutrients.g.dart`（营养素枚举、单位、标签顺序、映射表）
  3. `app/lib/generated/vlm_output.g.dart`（VLM 输出的 Dart 解析类）
- CI 里重跑 codegen 后 `git diff --exit-code`，保证没人手改生成文件。

**其他约定**

- 提交信息前缀 `app:` / `api:` / `schema:` / `docs:`（PRD 规定），跨层改动拆成多个提交。
- 所有外部数据源许可写在 `docs/LICENSES.md`，代码中引用它（PRD 规则 10）。
- 仓库若公开：API Key、桶凭证一律不入库；评测集照片入库前自查是否带个人信息。

---

## 3. 关键技术细节（PRD 基础上的细化）

### 3.1 本地数据库（drift / SQLite）

三层数据 + 用户记录 + 上传队列。表名与主要列：

| 表 | 层 | 主要列 | 删除策略 |
| --- | --- | --- | --- |
| `products` | — | `id`, `barcode`(unique, 可空：BLS 食材无条码), `brand`, `name`, `created_at` | 不删 |
| `photos` | 第 1 层 | `id`, `product_id`, `local_path`, `sha256`, `taken_at`, `bucket_key` | **禁止删除**（trigger） |
| `extractions` | 第 2 层 | `id`, `photo_id`(可空，手动输入时为空), `model`, `prompt_version`, `schema_version`, `raw_json`, `status`(`pending`/`done`/`failed`/`unreadable`), `created_at` | **禁止删除**（trigger） |
| `nutrient_records` | 第 3 层 | `id`, `product_id`, `version`, `provenance`(NOT NULL, CHECK ∈ off/bls/usda/vlm_user), `source_version`, `source_retrieved_at`, `extraction_id`, `basis`(`per_100g`/`per_100ml`), `original_basis`, `serving_text`, `serving_amount`, `serving_unit`, `source_raw`(OFF 原始响应), `confirmed_at` | **禁止删除**（trigger） |
| `nutrient_values` | 第 3 层 | `record_id`, `nutrient_key`, `value_per_100`, `value_original`, `user_edited`(bool) | **禁止删除**（trigger） |
| `log_entries` | 用户记录 | `id`, `product_id`, `nutrient_record_id`(可空 = 待提取，见 D8), `consumed_at`, `amount`, `unit`(g/ml/serving), `deleted_at` | 软删除（用户可删可改，PRD 第 5 节） |
| `upload_queue` | 出口 | `id`, `object_key`, `local_path`, `content_type`, `status`, `attempts`, `last_error`, `next_attempt_at`, `uploaded_at` | 上传成功只改状态，不删行 |

要点：

- **"不可删"用 SQLite trigger 硬性保证**：`CREATE TRIGGER ... BEFORE DELETE ON photos BEGIN SELECT RAISE(ABORT, 'append-only'); END;`，四张表都加，并有单测验证删除会抛错。这是本地 SQLite 的 trigger，不违反 PRD 规则 7（那条针对 Supabase）。
- **provenance 双保险**：列级 `NOT NULL + CHECK`，repository 写入前再校验一次（PRD 规则 4）。
- **版本化**：同一商品新的营养素记录 `version + 1`；"当前记录" = 最新 `confirmed_at`。`log_entries` 指向具体版本，改版本不影响历史记录的热量。
- 生成的 `nutrients.g.dart` 提供 `nutrient_key` 的合法取值，写入时校验。

### 3.2 归一化规则

实现为 `app/lib/domain/normalize.dart`，纯函数，输入 raw 提取结果 + 用户编辑，输出归一化记录。

| 情形 | 处理 |
| --- | --- |
| 标签有 per 100g / 100ml 列 | 直接取该列 |
| 只有 per serving | 需要 serving 的克数/毫升数；标签没写 → 该字段在确认界面标红，要求用户填 |
| kJ 与 kcal 只有其一 | 按 1 kcal = 4.184 kJ 补全另一个，标记为派生值 |
| 只有钠 / 只有盐 | 盐 = 钠 × 2.5，互补，标记为派生值 |
| 总糖 / 添加糖 | 分成两个字段，德国标签的 "davon Zucker" 映射为**总糖** |
| 膳食纤维 | 独立字段；记录"来源法规是否将其计入碳水"（EU 标签不计入） |
| 固体 vs 液体 | `per_100ml` 与 `per_100g` 不互转（不猜密度）；份量单位必须与 basis 一致或经 serving 换算 |

### 3.3 规则校验

实现为 `app/lib/domain/validate.dart`，纯函数，返回 `List<ValidationIssue{fieldKeys, code, message}>`。确认界面每次编辑后重跑。

| 规则 | 条件 | 来源 |
| --- | --- | --- |
| Atwater | \|P×4 + C×4 + F×9 − kcal\| / kcal > 15% → 可疑 | PRD |
| Atwater 低热量豁免 | 标示热量 < 40 kcal 时改用绝对偏差 > 8 kcal 判定 | **补充**：水、茶饮、零度饮料的相对偏差没有意义，否则每次都误报 |
| 质量守恒 | 脂肪 + 碳水 + 蛋白质 + 纤维 + 盐 ≤ 100 g（per 100g 时；per 100ml 放宽到 ≤ 110） | PRD（明确只加顶层字段，子项不重复计入） |
| 子项 ≤ 父项 | 饱和脂肪 ≤ 脂肪；糖 ≤ 碳水 | **补充**：零成本，直接抓 12 / 1.2 类误读 |
| kJ / kcal 一致 | kJ / kcal 偏离 4.184 超过 5% | **补充**：能量值本身被误读时 Atwater 不一定能指出是哪一个 |
| 低置信度 | VLM 报告的 confidence < 0.8（阈值阶段 0.5 调） | PRD |

Atwater 是否加入纤维 × 2 kcal/g（EU 1169/2011 的算法）：阶段 0.5 用评测集对比两种算法的误报率再定，默认先按 PRD 不加。

### 3.4 外部调用与降级

所有 client 放在 `data/clients/`，每个调用都有超时和降级分支（PRD 规则 5）。

| 调用 | 超时 | 失败时 |
| --- | --- | --- |
| 本地 SQLite 查条码 | — | 不可能失败；< 1 秒反馈的主路径 |
| OFF `GET /api/v2/product/<barcode>?fields=...` | 4 s | 一句提示"联网查询失败"，直接进拍照；OFF 请求带规范 User-Agent（`NutriScan/<ver> (<email>)`），只在真实扫码时调用 |
| VLM 提取（Claude Messages API） | 25 s，可取消 | 离线：照片存本地，extraction 记 `pending`，按 D8 先记账；在线但失败 / 取消 / `stop_reason` 为 `refusal` 或 `max_tokens`：转手动输入 |
| 桶上传 | 30 s / 对象 | 留在 `upload_queue`，指数退避（1 min → 最长 6 h）；触发时机：App 启动、回到前台、每次确认后 |

### 3.5 桶出口（F3）

- 对象键：`raw/<YYYY>/<MM>/<barcode>_<UTC 时间戳 yyyyMMddTHHmmssZ>.{jpg,json}`，D11 通过则再加 `_confirmed.json`。时间戳同时在本地 `photos` 行里记下，重传时键不变。
- raw JSON 文件内包含：VLM 原始响应、`model`、`prompt_version`、`schema_version`、请求时间——PRD"可回溯"要求的全部字段。
- 客户端只持有只写凭证（见 D3）。代码中桶 client **只暴露 `put` 一个方法**，没有 delete / overwrite 的接口可调用（PRD 规则 3）。
- S3 SigV4 签名用现成 Dart 包，不手写。

### 3.6 VLM 输出结构（v1 草案，阶段 0.5 定稿）

```json
{
  "schema_version": "1",
  "unreadable": false,
  "product_name_guess": "string | null",
  "columns": [
    {"id": "c1", "basis": "per_100g | per_100ml | per_serving", "serving_text": "string | null", "serving_amount": 30, "serving_unit": "g | ml | null"}
  ],
  "nutrients": [
    {"key": "energy_kj", "column": "c1", "value": 1523, "raw_text": "1523 kJ", "confidence": 0.95}
  ]
}
```

- 通过 Claude 结构化输出（`output_config.format` 传 JSON Schema）约束返回格式；codegen 产出的 schema 要落在 Claude 结构化输出支持的 JSON Schema 子集内，P05-2 用真实请求验证一次。
- `key` 的枚举由 `nutrients.yaml` 生成，VLM 只能从中选。
- 保留 `raw_text`（标签上的原字符串），出问题时能判断是 OCR 错还是映射错。
- VLM 自报的 confidence **不可靠**（不是校准过的概率），只作为提示；真正的闸门是第 3.3 节的规则校验。

---

## 4. 分阶段任务清单

时间以"周末"为单位估算。PRD 写"阶段 1 一个周末完成"偏乐观——四屏 + 三个外部 client + 上传队列 + 测试，实际按 3 个周末排，每个周末结束时都是可用的增量。

任务编号规则：`P<阶段>-<序号>`，每个任务大致是一次 Claude Code 会话能完成并提交的粒度。

### 阶段 0 · 验证（周末 1，不写 App 代码）

| 任务 | 内容 | 产出 |
| --- | --- | --- |
| P0-1 | 列出 10 个常买商品条码（至少含 Rewe、Lidl、Alnatura 自有品牌各 2 个，外加 2 个亚洲商品） | `schema/tools/barcodes.txt` |
| P0-2 | 写 `schema/tools/off_probe.py`：逐个请求 OFF v2 API，统计"存在 / nutriments 七项齐全 / 部分 / 空"比例 | 脚本 + `docs/notes/off-hit-rate.md`（含命中率数字）→ 决定 D5 |
| P0-3 | 下载 BLS 4.0，记录：营养素代码列表、参考量（per 100g 可食部分？）、食材与菜品如何区分、文件格式与大小、署名要求 | `docs/notes/bls-fields.md` → 决定 D4 |
| P0-4 | 在超市拍 20–30 张营养成分表（覆盖：per 100g/per serving 两列、kJ/kcal 并列、反光/弯曲包装、小字、德文以外至少 3 张） | `schema/eval/images/` |
| P0-5 | 为每张照片**手工录入真值**（七项核心字段 + 参考量） | `schema/eval/ground_truth/*.json` |
| P0-6 | 核实 D3 桶供应商：注册、建 EU bucket、创建只写 key，手动 PUT 一个对象，确认该 key 无法删除 | `docs/decisions/0001-bucket.md` |
| P0-7 | 写 `docs/LICENSES.md`：OFF ODbL、BLS CC BY 4.0（署名 MRI 的具体文字）、USDA 公有领域 | 文档 |

**完成标志**：PRD 要求的三件（命中率、BLS 笔记、评测集目录）+ 第 1 节所有 ★ 决策已定。

### 阶段 0.5 · schema 与选模型（周末 2 前半）

| 任务 | 内容 | 产出 |
| --- | --- | --- |
| P05-1 | `schema/nutrients.yaml`：七项核心字段 + 纤维、钠、添加糖等常见扩展；每项含主键、单位、德国标签顺序、父字段、EuroFIR / OFF / USDA 映射 | yaml |
| P05-2 | Pydantic 模型 + codegen 脚本，生成 JSON Schema 与 Dart 文件；schema 单测 | `schema/nutriscan_schema/`、`schema/codegen/` |
| P05-3 | 写 prompt `vlm_extract.v1.md`（德国标签特点：kJ/kcal 并列、"davon" 缩进子项、逗号小数点、"<0,5 g" 的处理） | prompt 文件 |
| P05-4 | 评测脚本 `schema/eval/run.py --model claude-opus-5\|claude-sonnet-5\|claude-haiku-4-5\|mistral`（Claude 走官方 Python SDK）：跑全部评测图，输出每模型的 ① Atwater 失败率（PRD 指标）② 对照真值的逐字段准确率 ③ P90 延迟 ④ 按 `usage` 算的单次成本；Opus 5 / Sonnet 5 另扫 `effort` 的 low / medium 两档；结果存 `schema/eval/results/<date>_<model>.json` | 一条命令可复现（对应 PRD 验收标准第 8 条） |
| P05-5 | 对比各候选型号，供你拍板 D14 / D15；同时验证 D10 的 2048px 是否够用、Atwater 是否加纤维项、置信度阈值取多少 | `docs/decisions/0002-vlm-model.md` |

> 补充 ② 的理由：只看 Atwater 失败率会漏掉"四个数一起读错但恰好自洽"以及"盐读错"（盐不参与 Atwater）的情况。有 P0-5 的真值，逐字段准确率几乎零成本。

**完成标志**：选定 MVP 模型；codegen 与评测脚本在 CI 里跑通。

### 阶段 1 · MVP（周末 2 后半 ～ 周末 4）

#### 1a · 骨架与数据层（周末 2 后半）

| 任务 | 内容 |
| --- | --- |
| P1-1 | `flutter create`（按 D1 包名），接入 `flutter_lints`、Riverpod、drift、ARB 国际化；`secrets.json` 机制（D13） |
| P1-2 | CI：`.github/workflows/` 三个 workflow + path filter（PRD 规则 9）；app 跑 `flutter analyze && flutter test`，schema 跑 `ruff && pytest && codegen diff 检查` |
| P1-3 | drift 表定义（第 3.1 节）+ append-only trigger + provenance CHECK；单测：删除三层数据必抛错、provenance 为空写入失败 |
| P1-4 | `domain/normalize.dart` + `domain/validate.dart` 及单测；用 `schema/eval/ground_truth` 作为测试夹具，外加"12 → 1.2"专项用例 |
| P1-5 | Repository 层：`ProductRepository.findByBarcode / saveFromOff / saveConfirmed`，`LogRepository`，`UploadQueueRepository`；UI 不直接碰 drift |

#### 1b · F1 扫码记录 + 份量屏（周末 3 前半）

| 任务 | 内容 |
| --- | --- |
| P1-6 | 扫码屏：`mobile_scanner`（Android 走 ML Kit；iOS 端核实底层实现是否为 AVFoundation/Vision，否则换插件），打开即扫，命中震动反馈 |
| P1-7 | `OffClient`：字段裁剪、4 s 超时、`nutriments` 为空视为未命中；命中后以 `provenance=off` 写入并保存原始响应 |
| P1-8 | 份量屏：g / ml / 份，默认值 = 该商品上次记录的份量，时间默认现在 |
| P1-9 | 查找链路编排：本地 → OFF → 拍照；各分支的一句提示文案 |

**里程碑**：已被 OFF 收录的商品可以扫码记录，第二次扫码本地命中（离线也行）。

#### 1c · F2 拍照提取 + 确认（周末 3 后半 ～ 周末 4 前半，最大的一块）

| 任务 | 内容 |
| --- | --- |
| P1-10 | 拍照屏：`camera` 插件，拍后缩放到 2048px（D10），落盘并写 `photos` |
| P1-11 | `VlmClient`：Anthropic 无官方 Dart SDK，直接 HTTP 调 `POST /v1/messages`；codegen 的 JSON Schema 作为 `output_config.format`，型号、effort、prompt 版本随请求记录；25 s 超时 + 取消；检查 `stop_reason` 后再读内容；结果写 `extractions` |
| P1-12 | **确认/编辑屏**：固定德国标签顺序、其余折叠；原图缩略可点开放大；每行显示原始值 + 原始参考量 + 归一化值；低置信度与校验失败同一视觉（高亮 + 原因文字，如"Atwater 偏差 23%"）；每次编辑即时重跑校验；高亮字段未逐一确认时"确认"按钮不可用；"无法识别"入口转手动 |
| P1-13 | 手动输入模式（同一屏，字段为空，D9 的 provenance 规则） |
| P1-14 | 确认后事务写入：`nutrient_records` + `nutrient_values` + 入 `upload_queue` → 进份量屏 |
| P1-15 | 离线待提取（D8）：pending extraction 列表入口放在当日汇总页顶部，联网后可逐条进入确认屏 |
| P1-16 | Widget 测试：确认屏的"高亮未确认不能提交"与"改 12 为 1.2 立即标红" |

**里程碑**：OFF 未收录的商品可以拍照 → 确认 → 记录。

#### 1d · F3 桶出口 + F4 当日汇总（周末 4 后半）

| 任务 | 内容 |
| --- | --- |
| P1-17 | `BucketClient`（只有 `put`）+ 上传 worker：启动 / 回前台 / 确认后触发，指数退避 |
| P1-18 | 设置页：上传队列状态（待传 / 失败条数、最后错误）、手动重试按钮、BLS 署名位置预留 |
| P1-19 | 当日汇总屏：热量与七项核心营养素合计、记录列表、左滑删除（软删除）/ 点按修改份量；待提取条目单独显示；单测"合计 = 各条按份量折算之和" |

#### 1e · 验收（周末 4 结束 + 之后一周）

| 任务 | 内容 |
| --- | --- |
| P1-20 | 按第 5 节逐条过 PRD 验收标准，结果记入 `docs/notes/mvp-acceptance.md` |
| P1-21 | 自己连续用一周；每天记录"本地命中 / OFF 命中 / 拍照"的次数（可在设置页加一个简单计数），作为是否达标的依据 |

**完成标志**（PRD）：连续用一周，日常商品基本在本地命中。

### 阶段 2 · 食材层 F5（周末 5）

| 任务 | 内容 |
| --- | --- |
| P2-1 | 构建期脚本：把 BLS 转成裁剪后的 SQLite 片段（只保留 `nutrients.yaml` 映射到的营养素 + 名称），`provenance=bls`、`source_version=4.0` |
| P2-2 | App 首次启动时导入（或以附带数据库文件方式打包），导入幂等 |
| P2-3 | 查询屏：本地全文搜索（SQLite FTS5）中文/德文名称；选中后进份量屏 |
| P2-4 | 自制饭菜：多个食材 + 各自克数组成一次"餐"，汇总按食材计算（不新建商品）|
| P2-5 | BLS 署名：查询结果页与设置页显示 "Datenquelle: Bundeslebensmittelschlüssel (BLS) 4.0, Max Rubner-Institut"（具体措辞以 P0-7 为准） |

**完成标志**：能记录一顿自己做的饭。

### 阶段 3–5（触发后，本计划只列入口条件）

| 阶段 | 触发条件 | 届时首先要做的 |
| --- | --- | --- |
| 3 · 云同步 | PRD 第 4 节三个触发条件任一 | 在现有 repository 层下加 Supabase 同步实现；SQLite 仍是权威；写 `supabase/migrations` |
| 4 · 批处理 | 需要换模型重跑 | `api/` 复用 `schema/` 的 prompt 与 Pydantic 模型；读桶 → 重跑 → 写回，支持断点续跑与按条件选子集 |
| 5 · 对外开放 | 有第三方需求 | 只读 API + CDN + 按日 dump，按 provenance 过滤；上架前完成 D7 |

到阶段 3 时再为其单独写开发计划。

---

## 5. 测试策略与验收映射

| 层 | 测什么 | 怎么测 |
| --- | --- | --- |
| `schema/` | Pydantic 模型、codegen 产物一致性、评测脚本 | pytest；CI 中 codegen diff |
| `domain/` | 归一化、校验、份量换算 | Dart 单测，评测集真值做夹具 |
| `data/` | trigger、provenance 约束、repository、上传队列退避 | drift 内存库单测；外部 client 用 fake |
| `features/` | 确认屏交互规则、汇总计算 | Widget 测试 |
| 端到端 | PRD 验收标准 | 真机手动，按清单逐条 |

PRD 验收标准 → 负责的任务：

| 验收标准 | 任务 | 自动化？ |
| --- | --- | --- |
| 无网络扫已缓存商品并记录，不出错不等待 | P1-6、P1-9 | 手动（飞行模式） |
| OFF 未收录商品拍照后 30 s 内进确认屏，可疑字段高亮 | P1-10 ～ P1-12 | 手动 + 延迟由 P05-4 统计 |
| 手动把 12 改成 1.2，Atwater 立即标红 | P1-4、P1-16 | 自动 |
| 确认后照片与 raw JSON 出现在桶里，文件名含条码与时间戳 | P1-17 | 手动（查桶） |
| 同一商品第二次扫码本地命中 | P1-7、P1-9 | 自动（repository 测试）+ 手动 |
| 当日汇总热量 = 各条按份量折算之和 | P1-19 | 自动 |
| 每条营养素记录 provenance 非空 | P1-3 | 自动（约束 + 测试） |
| 评测脚本一条命令输出各模型 Atwater 失败率 | P05-4 | 自动 |

---

## 6. 风险与应对

| 风险 | 影响 | 应对 |
| --- | --- | --- |
| OFF 对德国自有品牌 / 亚洲商品命中率很低 | F1 价值下降，F2 成主路径 | 阶段 0 先测；D5 已预留调整顺序的分支 |
| Claude API 故障、限流或价格变化 | 提取不可用或成本上升 | 评测脚本支持多型号，可在 Claude 型号间或切到 Mistral；降级到手动输入始终可用；D13 的消费上限兜底 |
| VLM 置信度不可信 | 该高亮的字段没高亮 | 规则校验作为主要闸门；阶段 0.5 按真值校准阈值 |
| 25 s 内 VLM 响应不稳定 | 验收标准"30 s 内"不达标 | 图片 2048px 控制体积；评测时统计 P90 延迟；超时即转手动，不卡死 |
| 确认屏过于繁琐，自己都懒得用 | 核心目标"录入成本接近零"失败 | 置信度高且校验全过时，所有字段默认视为已确认，一键通过；只有高亮字段要求逐一点 |
| iOS 扫码插件底层实现与 PRD 不符 | 违反 PRD 规则 6 的字面要求 | P1-6 核实；MVP 只在自己设备上跑，若只有 Android 设备可先只验 Android |
| 桶凭证泄露（打包在 App 内） | 他人可往桶里写垃圾 | 凭证只写不删不读，最坏情况是垃圾数据而非数据丢失；分发前改为代理签发预签名 URL |

---

## 7. 本计划对 PRD 的补充与偏离（请重点审阅）

以下是 PRD 没有写、由本计划自行加入的内容。每条都可以单独否决。

1. **离线未命中先记账**（D8）：新增"待提取"状态的记录条目。
2. **手动输入的 provenance**（D9）：记为 `vlm_user`，靠 `model = "manual"` 区分。
3. **单一分辨率照片**（D10）：存 2048px 版本，不保留相机原图。
4. **桶里额外存 `_confirmed.json`**（D11）：用户修正结果也进不可删的出口。
5. **本地 SQLite 用 trigger 禁止删除三层数据**：把 PRD 规则 3 从约定变成硬约束。
6. **额外的校验规则**：低热量豁免、子项 ≤ 父项、kJ/kcal 一致性（第 3.3 节）。
7. **评测指标加逐字段准确率**：需要为评测集手工录入真值（P0-5，约 1–2 小时工作量）。
8. **营养素内部主键用带单位后缀 snake_case**（D4），EuroFIR/OFF/USDA 都作为映射。
9. **阶段 1 排期从 1 个周末调整为约 3 个周末**。
10. **确认屏"全部通过时一键确认"**（第 6 节）：PRD 只规定了高亮字段必须逐一确认，未规定无高亮时的交互，这里明确为一键通过。
11. **桶对象键加 `raw/<年>/<月>/` 前缀**：仍满足 PRD 的 `<barcode>_<timestamp>` 命名，只是便于将来按时间批处理。
