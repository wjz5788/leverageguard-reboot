# LeverageGuard 微服务架构

根据审核报告中的架构优化建议，本目录包含LeverageGuard项目的微服务架构实现代码。该目录现在归属于全新仓库，并与手动工作流联动。

## 系统架构概览

```
┌───────────────────────┐     ┌───────────────────────┐     ┌───────────────────────┐
│  订单验证服务         │     │  赔付处理服务         │     │  报告生成服务         │
│ (Order Verification)  │────>│  (Payout Processing)  │────>│ (Report Generation)   │
└───────────────────────┘     └───────────────────────┘     └───────────────────────┘
         │                           │                             │
         │                           │                             ▼
         │                           ▼                   ┌───────────────────────┐
         │                   ┌───────────────────────┐    │  数据可视化服务       │
         │                   │  资金管理服务         │    │ (Data Visualization)  │
         │                   │ (Fund Management)     │    └───────────────────────┘
         ▼                   └───────────────────────┘
┌───────────────────────┐             │
│  API网关服务          │             │
│ (API Gateway)         │<────────────┘
└───────────────────────┘
         │
         ▼
┌───────────────────────┐     ┌───────────────────────┐
│  外部系统接口         │     │  区块链节点           │
│ (External API)        │     │ (Blockchain Node)     │
└───────────────────────┘     └───────────────────────┘
```

## 微服务目录结构

```
microservices/
├── api_gateway/           # API网关服务
├── order_verification/    # 订单验证服务
├── payout_processing/     # 赔付处理服务
├── fund_management/       # 资金管理服务
├── report_generation/     # 报告生成服务
├── data_visualization/    # 数据可视化服务
├── common/                # 共享组件和工具类
├── configs/               # 配置文件
├── docker-compose.yml     # Docker Compose配置
└── README.md              # 项目说明
```

## 技术栈

- Python 3.11（推荐使用 `uv` 管理依赖）
- FastAPI + Uvicorn
- RabbitMQ（消息队列）、Redis（缓存）、PostgreSQL（持久化）
- Web3.py 与以太坊兼容链交互
- Pandas / Matplotlib / Seaborn（风控报表）
- Docker、Docker Compose（部署）

## 本地初始化（无 CI/CD）

1. 安装依赖：
   ```bash
   # 在仓库根目录
   ./scripts/bootstrap_local.sh
   ```
2. 根据需要复制配置模板：
   ```bash
   cp env/templates/microservices.env.example services/microservices/.env
   cp services/microservices/config.example.yml services/microservices/config.yml
   ```
   将 `.env` 与 `config.yml` 中的连接信息调整为本地环境可用的地址。
3. 运行手动检查：
   ```bash
   ./scripts/run_local_checks.sh --services
   ```
   脚本将自动安装依赖、执行 `python -m compileall`，并在安装了 `ruff` 时运行静态检查。

> 注意：仓库未启用 CI/CD。所有部署、测试必须手动执行并记录证据，符合 `docs/10-processes/qa-checklist.md` 的要求。

## 服务说明

### API Gateway
- 统一入口、认证授权、限流。
- 通过 `config.yml` 指定下游服务地址。

### Order Verification
- 对接中心化交易所与链上合约，验证订单与签名。
- 使用 `LEVERAGEGUARD_SECURITY_*` 配置风险阈值。

### Payout Processing
- 驱动赔付流程，调用智能合约。
- 需要链上私钥（使用密钥管理器或临时注入环境变量，避免写入仓库）。

### Fund Management / Report Generation / Risk Assessment / User Management
- 负责资金流转、报表生成、实时风险监控与后台权限管理。
- 依赖 RabbitMQ、Redis、PostgreSQL、链上数据。

## 安全要求

1. 所有敏感凭据（私钥、API Key）只通过环境变量或密钥管理器注入。
2. 服务间通信建议部署在私有网络中，通过 TLS 加固。
3. 每次变更需更新 `docs/10-processes/qa-checklist.md` 及相关运行手册。
4. 至少每季度执行一次灾备演练，并记录于 `docs/30-decisions/`。

## 扩展建议

1. 根据业务需求，可以水平扩展各个微服务
2. 增加更多交易所支持
3. 实现多链支持
4. 增加AI预测功能，提高风险控制能力
