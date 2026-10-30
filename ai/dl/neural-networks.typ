#import "@local/ypst-template:0.1.0" as theme
#show: theme.template

#let vec(x) = math.bold(math.upright(x))

#let argmin = math.op("arg min", limits: true)
#let argmax = math.op("arg max", limits: true)
#let ReLU = math.op("ReLU")
#let softmax = math.op("softmax")
#let sigmoid = math.op("sigmoid")
#let KL = math.op("KL")
#let E = math.op("E")
#let Pr = math.op("Pr")
#let Var = math.op("Var")
#let Cov = math.op("Cov")
#let ELBO = math.op("ELBO")
#let diag = math.op("diag")
#let sign = math.op("sign")

= supervised learning 

$ vec(y)=f[vec(x),phi] $ 

We learn the parameters $phi$ from *training dataset* of pairs of intput and output examples $x_i, y_i$ , 
 to minimize the *loss function*: 

#let argmin = math.op("arg min", limits: true)
#let vphi = $phi.alt$

$ hat(vphi) = argmin_vphi L[vphi] $

After training, we run the model on _separate test data_ to evaluate generalization on
 exmpales that it didn't observe during training.

== shallow neural networks 

$
y &= f[x, vphi] \
& = vphi_0 + vphi_1 h_1 +vphi_2 h_2 + vphi_3 h_3
$ <eq:shallow>

#theme.sidenote[
  We refer to $h_i$ as _hidden units_:
  $
  h_1 &= upright(a) [theta_(1 0) + theta_(1 1)x] \
  h_2 &= upright(a) [theta_(2 0) + theta_(2 1)x] \
  h_3 &= upright(a) [theta_(3 0) + theta_(3 1)x] 
  $
][
  Number of hidden units in a shallow network is called as _network capacity_.
]

The most common choice of _activation function_ $upright(a)[dot]$ is the _rectified linear unit (ReLU)_. 
Activation functions are necessary for *nonlinearity*. 

$
upright(a)[x]=upright(R e L U)[x ]=
cases(
  0 &quad x < 0, 
  x &quad  x >= 0
)
$

#figure(
  image("../../attach/img/ai/shallow-neural-network.webp", width: 40%),
  caption: [Illu of @eq:shallow]
)

By the *Universal Approximation THeorem*, shallow-neural-network  
can approximate *any continuous funciton on a compact domain arbitrarily well*, provided with 
sufficiently *wide* & single hidden layer + suitable nonlinear activation funciton. 

== deep nueral networks 

- $K$ as the number of layers 
- $D_i$ as the number fo hidden units in $i$ layer
- $beta_k$ as the vector of biases (intercepts) contibuted to hidden layer $k+1$
- $k^"th"$ as the weights (slopes) for the $k$ layer

$ vec(y) = f[vec(x), vec(phi.alt)],quad vec(phi.alt) = {vec(beta)_i, vec(Omega)_i}^K $

Matrices of $vec(Omega)_i$ are $D_(i+1)times D_i$. Both deep and shallow networks can model 
arbitrary functions, but some functions can be much more efficiently with deep networks.

$
  vec(h_1) &= a[vec(beta_0) + vec(Omega)_0 vec(x)] \
  vec(h_2) &= a[vec(beta_1) + vec(Omega)_1 vec(h)_1] \
  & dots.v \
  vec(h_K) &= a[vec(beta)_(K-1) + vec(Omega)_(K-1) vec(h)_(K-1)]\ 
  vec(y) &= vec(beta)_K + vec(Omega)_K vec(h)_K 

$ 

#figure(
  image("../../attach/img/ai/deep-neural-network.webp", width: 60%),
)

== Loss function

The likelihood of all training outputs is:

$ product_(i=1)^I Pr(y_i | f(x_i, phi)) $

This factorization assumes the examples are independent and identically distributed: each conditional output distribution has the same form, and the outputs are independent given their inputs.

Maximum likelihood chooses:

$ hat(phi) = argmax_(phi) [product_(i=1)^I Pr(y_i | f(x_i, phi))] $

Products of many probabilities can underflow. Since $log$ is monotonically increasing, maximizing likelihood is equivalent to maximizing log-likelihood:

$ hat(phi) = argmax_(phi) [sum_(i=1)^I log Pr(y_i | f(x_i, phi))] $

By convention, training is framed as minimization, so the loss is the negative log-likelihood:

$ L(phi) = - sum_(i=1)^I log Pr(y_i | x_i, phi) $

Inference can return the full predicted distribution, but often returns the most probable output:

$ hat(y) = argmax_(y) Pr(y | f(x, hat(phi))) $

=== Distribution & Loss

A neural network produces deterministic outputs, while the target may be stochastic. 
We therefore use the network outputs to parameterize a probability distribution over the target.

The model is trained by minimizing a loss, typically the negative log-likelihood, 
which measures how well the predicted distribution explains the observed target.

#table(
  columns: (auto, auto, 1.2fr),
  [], [*Distribution*], [*NLL / Loss*],

  [Gaussian],
  [$Y | X ~ cal(N)(mu(x), sigma^2)$],
  [$L = frac((y-mu)^2, 2 sigma^2) + log sigma$],

  [Gaussian ($sigma$ fixed)],
  [$Y | X ~ cal(N)(mu(x), sigma^2)$],
  [$L prop (y-mu)^2 quad "MSE"$],

  [Laplace],
  [$Y | X ~ "Laplace"(mu(x), b)$],
  [$L prop abs(y-mu) quad "MAE"$],

  [Bernoulli],
  [$Y | X ~ "Bernoulli"(p(x))$],
  [Binary Cross Entropy],

  [Categorical],
  [$Y | X ~ "Cat"(p_1,...,p_K)$],
  [Cross Entropy],

  [Poisson],
  [$Y | X ~ "Poisson"(lambda(x))$],
  [$L = lambda - y log lambda + "const".$],

  [Negative Binomial],
  [$Y | X ~ "NB"(r,p)$],
  [NLL],

  [Student-$t$],
  [$Y | X ~ t_nu(mu(x), sigma(x))$],
  [NLL],

  [Asymmetric Laplace],
  [$Y | X ~ "ALD"(mu,b,tau)$],
  [Quantile Loss],
)

==== Gaussian $->$ MSE

Gaussian 分布的概率分布为：

$
p (y divides x) = frac(1, sqrt(2 pi) sigma) exp (- frac((y - mu (x))^(2), 2 sigma^(2))) 
$

取负对数，并假设 $sigma$ 是固定常数，得到 MSE：

$
L prop (y-mu)^2 
$

这里隐含的建模假设是，预测误差是高斯分布的，并且不同样本的噪声方差差不多（没有严重离群）。

$
y = f(x)+ epsilon,quad epsilon ~ cal(N)(0, sigma^2)
$

如果 $sigma$ 不是常数，也需要模型预测 $sigma(x)$, 那么模型完全不一样。

==== Laplace $->$ MAE

$ 
p (y divides x) = frac(1, 2 b) exp (- frac(| y - mu (x)|, b)) 
$

取负对数，并假设 $b$ 固定，得到 _MAE / L1 loss_:

$ L prop | y - mu| $

和 Gaussian 相比，Laplace 在偏离均值后衰减更慢，因此对离群值相对不敏感。

在统计学上，
- MSE 的最优预测倾向于条件均值 $E[Y|X]$ 
- MAE 的最优预测倾向于条件中位数 $"Median"(Y | X)$

==== Bernoulli $->$ Binary Cross Entropy

$
P (Y = y divides X = x) = p (x)^(y) 1 - p (x)^(1 - y), wide y in {0,1 }
$

取对数，得到 Binary Cross Entropy (BCE)：

$
L = -y log(p) - (1-y)log(1-p)
$


==== Categorical $->$ Cross Entropy

有 $K$ 个互斥类别单选，概率模型为：

$
P (Y = y divides X = x) = product_(k = 1)^(K) p_(k)(x)^(y_(k)), quad sum_(k = 1)^(K) p_(k)(x)= 1
$

Loss 函数就是交叉熵：

$
L = -sum_(k=1)^K y_k log p_k
$

==== Poisson 

假设 $Y$ 是计数，概率分布满足泊松分布：

$
P (Y = y divides X = x) = frac(e^(- lambda (x)) lambda (x)^(y), y !), wide y = 0,1,2,...
$

取负对数（$y$ 是已知数据，对模型参数无影响）：

$
  L = lambda - y log(lambda) + log(y!) = lambda - y log(lambda) + "const"
$

同时，需要注意 Poisson 分布假设方差和均值都是 $lambda$ ，如果方差明显大于均值，
就会有 Overdispersion (过度离散) 现象，此时应该用 Negative Binomial

==== Negative Binomial


#theme.sidenote[
  负二项分布 

  $ P(X = k) = binom(k + r - 1, k) p^(r)(1 - p)^(k), wide k = 0,1,2,... $

  取负对数：

  $ l = -log p(y = y | r,p) $
][
  bernoulli (伯努利分布) $->$ one trial: success or failure

  binomial (二项分布) $->$ fixed n trials: how many success?

  negative binomail $->$ fixed r successes: how many tirals are needed?
]




=== Link Function

#table(
  columns: 5,
  [*Task*],
  [*Model Output*],
  [*Link / Transform*],
  [*Distribution*],
  [*Loss*],

  [Continuous Regression],
  [$z in RR$],
  [$mu = z$],
  [$Y | X ~ cal(N)(mu, sigma^2)$],
  [MSE],

  [Probabilistic Regression],
  [$(z_mu, z_sigma)$],
  [$mu = z_mu,\ sigma = "softplus"(z_sigma)$],
  [$Y | X ~ cal(N)(mu, sigma^2)$],
  [NLL],

  [Binary Classification],
  [$z in RR$],
  [$p = "sigmoid"(z)$],
  [$Y | X ~ "Bernoulli"(p)$],
  [BCE],

  [Multi-class Classification],
  [$(z_1, ..., z_K)$],
  [$p = "softmax"(z)$],
  [$Y | X ~ "Categorical"(p_1, ..., p_K)$],
  [CE],

  [Count Regression],
  [$z in RR$],
  [$lambda = exp(z)$],
  [$Y | X ~ "Poisson"(lambda)$],
  [NLL],

  [Robust Regression],
  [$z in RR$],
  [$mu = z$],
  [$Y | X ~ "Laplace"(mu, b)$],
  [MAE],

  [Overdispersed Counts],
  [$(z_mu, z_r)$],
  [$mu = exp(z_mu),\ r = "softplus"(z_r)$],
  [$Y | X ~ "NB"(mu, r)$],
  [NLL],
)

#align(center)[
  $
  "Model Output"
  arrow.r
  "Link / Transform"
  arrow.r
  "Distribution Parameters"
  arrow.r
  "Probability Distribution"
  arrow.r
  "NLL / Loss"
  $
]


Common Link functions:

#table(
  columns: 4,
  [*Function*], [*Definition*], [*Input → Output*], [*Main role*],

  [Sigmoid],
  [$sigma(z) = 1 / (1 + e^(-z))$],
  [$RR arrow (0, 1)$],
  [Convert one real logit to a probability],

  [Softmax],
  [$"softmax"(z)_k = e^(z_k) / sum_(j=1)^K e^(z_j)$],
  [$RR^K arrow Delta^(K-1)$],
  [Convert logits to categorical probabilities],

  [Softplus],
  [$"softplus"(z) = log(1 + e^z)$],
  [$RR arrow (0, +infinity)$],
  [Stable positive parameters such as $sigma$ or $r$],
)

== I'm
