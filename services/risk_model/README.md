# Risk Model Tooling

This module hosts liquidation probability estimators and related analytics.
Currently it contains `binance_liq_probability.py`, a CLI utility for
estimating liquidation chance using Binance mark-price data.

## Usage

```bash
python binance_liq_probability.py --symbol BTCUSDT --side long --lev 20 --hours 8 24 72
```

The script outputs JSON with the computed p-values. Use the sample command in
the QA checklist to validate changes.

## Roadmap

- Wrap the estimator into a reusable Python package inside `services/risk_model`.
- Expose a REST API for consumption by other services.
- Add unit tests and fixtures under `tests/`.
