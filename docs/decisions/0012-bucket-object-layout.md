# ADR 0012：桶对象布局

- 状态：已接受
- 日期：2026-09-26
- 对应决策：D11

## 决策

**对象键**：同一次拍摄的所有文件共用一个前缀，后面加不同后缀。

```
raw/<YYYY>/<MM>/<subject>_<UTC yyyyMMddTHHmmssZ>_<contributor><后缀>
```

- `subject`：商品条码。**没有条码**时用 `nobarcode-<product_id>`（product_id 是 UUID）。
- `contributor`：开发者标识，建议用 GitHub 用户名，来自本地 `secrets.json`（待两人确认，见 DEV_PLAN 7.2）。键里带 contributor，两台设备同一秒扫同一件商品时也不会撞键。
- 时间戳在拍摄时生成，并记进本地 `photos` 行；重传时键保持不变。

**后缀**

| 后缀 | 内容 |
| --- | --- |
| `.orig.jpg` | 原图（去 EXIF） |
| `.jpg` | 派生图，即送给模型的那一份（去 EXIF） |
| `.raw.json` | 见下 |
| `_confirmed.v<N>.json` | 用户确认后的结果；N = 该商品 `nutrient_records.version` |

**`.raw.json` 内容**：API 响应原文，外加 `model`、`effort`、`prompt_version`、`schema_version`、`input_image_sha256`、`original_sha256`、`input_tokens`、`output_tokens`、`latency_ms`、`contributor`、`requested_at`。

**`_confirmed.v<N>.json` 内容**：归一化后的全部字段值、哪些字段被用户改过、`provenance`、`nutrient_record_id`、`version`、`contributor`、`confirmed_at`、`schema_version`。

**后续修改**：用户修改记录产生新 version 时，再 append 一个 `_confirmed.v<N+1>.json`（前缀沿用那次拍摄的前缀），不覆盖旧文件。

**手动输入**：如果之前拍过照片，就上传照片和 `_confirmed.v<N>.json`，没有 `.raw.json`。没拍过照片时，前缀里的时间戳取确认时间，只上传 `_confirmed.v<N>.json`。

## 后果

- 键规则写进 `BucketKeys`（C-5，共享契约），两条线都调用它，不各自拼字符串。
- 桶 client 只暴露 `put`。
