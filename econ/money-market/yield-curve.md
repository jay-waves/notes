
Yield Curve 使用一些 Liquid Market 工具来绘制未来的利率报价曲线：
* Deposit 用于绘制短期曲线，如 MM ON / TN / 1W / 2M / 3M
* FRA 用于绘制中短期曲线 (<1y), 1x4 / 2x5 / 3x6 / 6x9
* IRS 用于绘制长期曲线，1Y / 2Y / 5Y / 7Y / 10Y

## Discount Factor 

let:
* $\alpha$ Year Fraction (ACT/365)
* $D$ Discount Factor
* Annual Compounding 

Deposit: (market Interest rate $r$)

$$D = \frac{1}{1+r_i \alpha_i}$$

FRA: (Forward Rate $F$)

$$D_{i} = \frac{D_{i-1}}{1+F_i \alpha_i}$$

Par swap:

$$K \sum_i \alpha_i D_i = 1- D_n$$

$$D_n=\frac{1-K\sum_{i=1}^{n-1}\alpha_iD_i}{1+K\alpha_n}$$

Coupon bond: 

$$D_n=\frac{P-\sum_{i=1}^{n-1}C_iD_i}{M+C_n}$$

## Bootstrapping

利用已知折现率，逐步计算更长期限的折现率。最终得到 *Zero Coupon Rate*, 和 *Yield Curve*. 

### Zero Coupon Rate 

Zero-Coupon (零息) 就是指某个金融产品中途不支付任何利息，到期一次性收回本息。
因此，年化零息利率 (Zero-Coupon Rate, Spot Rate) 满足： 

$$
    D(t) (1 + z(t))^\alpha = 1
$$

对于不同期限 $\alpha = 1, 2,  3\ y$ , 市场给出的定价可能不同。连在一起被称为 (**Spot) Zero Coupon Yield
Curve (即期零息收益率曲线)**.

### Spot Discount Factor Curve

将每期 DF 汇总，形成 Spot Discount Facotr Curve 

### Spot Zero Yield Curve 

根据每期 DF Zero Coupon Rate，形成 Spot Zero Yield Curve

<img src="https://oss.jay-waves.cn/studio/yield-curve.svg" alt="Zero spot yield curve and market rates">

<img src="https://oss.jay-waves.cn/studio/discount-factor.svg" alt="Spot discount factor curve">

图中线条为零息即期曲线（Zero Spot Curve / Zero Coupon Curve，ZC）；标记分别为
MM 存款、FRA 远期利率和 IRS 平价互换利率报价。FRA 按远期区间的结束期限标示，
横轴期限为分类刻度，间距不代表实际时间间隔。各数值仅供示意，并非自举计算结果。


