
## 利率

$PV$ (Present Value)，年利率 $r$ ，时间 (y) $t$ ，预期未来收益 $FV$ (Future Value)

* 单利率： $$FV=PV\times(1+rt)$$
* 复利率： $$FV_{annual}=PV\times(1+r)^{t}$$
* 月复利率（按月支付）： $$FV_\text{monthly}=PV\times \left( 1+\frac{r}{n} \right)^{t n},\quad n=12$$
* 连续利率：当 $r$ 足够小时，复利也可以视为连续利率
	$$FV\approx PV\times e^{rt}\approx PV \left(1 + rt + \frac{t(t-1)}{2}r^2 + \cdots \right),\quad n\to \infty$$

> 可以证明，月复利率最终的实际年利率（effective rate），高于名义年利率（nominal rate）。
> 即只要一年内发生多于一次 Compounding ，实际的利率就高于名义利率。
> 复利频率 $n$ 越高，实际利率越高，复利率随 $n$ 增加而单调递增，趋近于连续复利率（上界）。

| 约定 | 累积因子 $A(0,T)$ | 折现因子 $D(0,T)=1/A$ |
|---|---|---|
| 单利（simple interest）$r$ | $1+r\tau$ | $\frac{1}{1+r\tau}$ |
| 名义年率（nominal annual rate）$j$，年复利 $m$ 次 | $(1+j/m)^{m\tau}$ | $(1+j/m)^{-m\tau}$ |
| 有效年率（effective annual rate）$i$ | $(1+i)^\tau$ | $(1+i)^{-\tau}$ |
| 连续复利（continuous compounding）$r_c$ | $e^{r_c\tau}$ | $e^{-r_c\tau}$ |

$$1+i=\left(1+\frac{j}{m}\right)^m=e^{r_c}$$

![](../../attach/img/econ/compounding-accumulation.svg) 

累计因子 $A$ 回答 “今天 1 元到期时变为多少”，折现因子则取其倒数。

复利率和投资回报率其实是数学上等价的。

Short-term investment (< 1y, use simple rate):

$$FV = PV \times (1 + \text{yield} \times \frac{d}{365})$$

$$\text{yield}=\left(\frac{FV}{PV} - 1\right)\times \frac{365}{d}$$

$$\text{effective yield} = \left(\frac{FV}{PV}\right)^{365/d} - 1$$

<br>

Long-term investment (for N years, use compounding rate per year):

$$FV = PV \times (1+ \text{yield})^n$$

$$\text{yield} = \left(\frac{FV}{PV}\right)^{1/n} - 1$$

<br>

假设 $d=30$ 天，短线投资下的收益关系为：

$$\text{30天实际收益率} < \text{简单年化 yield} < \text{复利年化 yield}$$

$$\frac{FV}{PV}-1 < \left(\frac{FV}{PV} - 1\right)\frac{365}{d} < \left(\frac{FV}{PV}\right)^{365/d}-1$$

和累计利率收益相反，短期投资反推年化利率时，*复利年化利率*要高于*简单年化利率*才能拉平总收益。
以切蛋糕为例，简单利率是平均分隔为 365 份，而复利率是按指数增长地切割，因此短期（近期）
切割出的蛋糕，复利率相反弱于简单利率。

## Accumulation Factor

## Discount (折现) Factor

对于某一未来时刻 $t$，其**折现 (DF, Discoun Factor)** 记为：

$$D(t) = \frac{PV}{FV}$$

```
        Compounding
PV  --------------------->  FV

PV  <---------------------  FV
        Discounting
```

也可以理解为未来 \$1 折现到现在的具体价值。


## Annuity, NPV and IRR

**净现值 (net present value, FPV)** 按机会成本 $k$ 衡量净增值；$NPV > 0$ 意味着项目创造价值。    
**内部收益率 (internal rate of return , IRR)** 是使 $NPV = 0$ 的折现率，也是现金流隐含的收益率。

$$
\operatorname{NPV}(k)=\sum_{j=0}^{n}\frac{C_j}{(1+k)^j},
\qquad
\operatorname{NPV}(\operatorname{IRR})=0
$$ [^2]

[^2]: FPV 和 PV 计算没有什么不同。FPV 只是允许每期 $C$ 不一样，并且加入 $C_0$ 本金。

### Annuity

年金 (Annuity) 是 NPV 的一种简单情况：*等金额、等时间间隔*。每期末支付 $C$，每期利率 $i$ ，共 $n$ 期。

年金的现值 (present value)：

$$
PV = C \frac{1 - (1+i)^{-n}}{i}
$$ [^1]

[^1]: $(1 - (1+i)^{-n}) / i$ 是累加的等比数列，按本金 1 元计算的

终值 (future value)

$$
FV = C \frac{(1+i)^{n} - 1}{i}
$$

### Amortization

详见 [Amortization Model](./amortization-model.typ)

### Return Model

#### ~~DCF (Discounted Cash FLow)~~

把一项资产未来 $t$ 年能产生的现金流 $CF_i$ ，通过折现率 $r$ ，折现为资产今天的价值 $PV$ 。
其中 $CF_0$ 是初始投资（本金），不计入折现计算，通常记为负数。

$$PV=\sum^T_{t=1} \frac{CF_t}{(1+r)^t}$$

净折现值（加上初始本金，注意本金是负数）：

$$NPV = CF_0 + PV$$


#### ~~IRR (Internal Rate of Return)~~

IRR 目的是找到一个折现率 $r$ ，使得所有未来现金流折现回今天后，净现值 NPV 为零。
**通过 IRR，可以将现金流复杂的投资产品计算出一个近似的年化收益，方便投资比较**。

$$0=CF_0 + \sum^T_{t=1} \frac{CF_t}{(1+IRR)^t}$$

## Appendix 

### perputuity (永续年金)

现值为 $C/i$ ，增长永续为 $C_1 / (i-g), \quad i > g$

### level payments (等额付款)

每期等额付款，但每月的金额可能不一样。

### Day/Year Count Convention

Different markets use different date convention:

| Convention | Purpose | Rule |
|---|---|---|
| Following | Business-day adjustment | Move to next business day |
| Modified Following | Business-day adjustment | Move forward; if month changes, move backward |
| Preceding | Business-day adjustment | Move to previous business day |
| Modified Preceding | Business-day adjustment | Move backward; if month changes, move forward |
| End-of-Month (EOM) | Date generation | Preserve month-end status |
| Roll Date | Schedule generation | Keep dates on a fixed day, e.g. the 15th |
| IMM Date | Standardized schedule date | Usually the third Wednesday of Mar/Jun/Sep/Dec |
| Stub | Irregular accrual period | Short/long first or last period |
| Spot Lag | Settlement timing | T+0, T+1, T+2, etc. |
| Day Count | Interest calculation | ACT/360, ACT/365F[^1], 30/360[^2], ACT/ACT |

[^1]: *Actual/365 Fixed*, actual days divided by 365

[^2]: *30/360*, assume 30 days for a month, 360 days for a year

假设某个产品在 31 Jan 买入，一月后结息，使用 EOM (End-End Rule) 和 Modified Following 规则，那么，
根据 EOM 惯例，保留“月末”这个属性，那么下个月结息日会是 28 Feb；假设这天不是 Business day，
向后延期一天到 1 Mar。Modified Following 不允许跨月，会从 Following 改为 Preceding，最终计息
日期是 27 Feb。

#### Following Business Day & Modified Following

* `d-1` 向过去找一个工作日
* `d` 当天是不是工作日，如果不是则向后寻找
* `d+1` 向未来找一个工作日

需要引用 Holiday 表。第二个参数 `1` 表示 Saturday/Dunday weekend

```excel
    f=WORKDAY(d-1,1,Holiday...)
```

Modified Following:

```excel
    IF(MONTH(f)=MONTH(d),f,WORKDAY(d+1,-1,Holiday...))
```

#### End-End Role (EOM)

`fpdate`: First Payment Date. 这里 End-of-Month 是指最后一个 Business Day，而不是自然月末

```excel
    IF(
        fpdate=WORKDAY(
            EOMONTH(fpdate,0)+1,-1,Holiday!$A$1:$A$277
        ),
        EOMONTH(EOMONTH(fpdate,0),A32),
        EDATE(fpdate,A32)
    ),
```
