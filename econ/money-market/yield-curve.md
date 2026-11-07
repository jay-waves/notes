
Yield Curve 使用一些 Liquid Market 工具来绘制未来的利率报价曲线：
* Deposit 用于绘制短期曲线，如 MM ON / TN / 1W / 2M / 3M
* FRA 用于绘制中短期曲线 (<1y), 1x4 / 2x5 / 3x6 / 6x9
* IRS 用于绘制长期曲线，1Y / 2Y / 5Y / 7Y / 10Y

## Discount Factor 

let:
* $t$ Year Fraction (ACT/365)
* $r$ Market Interest Rate, FRA Forward Rate or Swap Par Rate
* $D$ Discount Factor
* Annual Compounding 

Deposit:

$$D = \frac{1}{1+rt}$$

FRA: 

$$D_E = \frac{D_S}{1+rt}$$

IRS: (每季度支付一次固定利息)

$$D_n = \frac{1-r\sum^{n-1}_{i=1}t_i D_i}{1+ r t_n}$$

## Bootstrapping

利用已知折现率，逐步计算更长期限的折现率。最终得到 *Zero Coupon Rate*, 和 *Yield Curve*. 

### Zero Coupon Rate 

$$
DF_t=\frac{1}{(1+ZC_t)^{days/365}}
$$

等价于：

$$ZC_t = (\frac{1}{DF_t})^{365/days}-1$$

### Spot Discount Factor Curve

将每期 DF 汇总，形成 Spot Discount Facotr Curve 

### Spot Zero Yield Curve 

根据每期 DF Zero Coupon Rate，形成 Spot Zero Yield Curve

<img src="https://oss.jay-waves.cn/studio/yield-curve.svg" alt="Zero spot yield curve and market rates">

<img src="https://oss.jay-waves.cn/studio/discount-factor.svg" alt="Spot discount factor curve">

图中线条为零息即期曲线（Zero Spot Curve / Zero Coupon Curve，ZC）；标记分别为
MM 存款、FRA 远期利率和 IRS 平价互换利率报价。FRA 按远期区间的结束期限标示，
横轴期限为分类刻度，间距不代表实际时间间隔。各数值仅供示意，并非自举计算结果。

## Bond Pricing 

$$PV = \sum^n_{i=1}C_i D_i + PD_n$$

* $C_i$ 每期 Coupon Cashflow 
* $D_i$ 对应付款日期的 DF
* $D_n$ 到期日 DF

