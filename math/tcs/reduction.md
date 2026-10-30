
<img src="../../attach/img/math/reduction.avif" alt="" width="400">

A proof that some cryptographic construction $\Pi$ is secure as long as some underlying problem $X$ is hard generally proceeds by presenting an explicit reduction showing how to transform any efficient adversary $\mathcal{A}$ that succeeds in "breaking" $\Pi$ into an efficient algorithm $\mathcal{A}'$ that solves $X$. 

Walking through a high-level outline of the steps of such a proof in detail, We start with the assumption that some problem $X$ cannot be solved (in some precisely defined sense) by any polynomial-time algorithm, except with negligible probability. We then want to prove that some cryptographic construction $\Pi$ is secure (again, in some sense that is precisely defined). A proof by reduction proceeds via the following steps:

1. Fix some efficient (i.e., probabilistic polynomial-time) adversary $\mathcal{A}$ attacking $\Pi$. Denote this adversary's success probability by $\varepsilon(n)$.
2. Construct an efficient algorithm $\mathcal{A}'$ that attempts to solve problem $X$ using adversary $\mathcal{A}$ as a subroutine. An important point here is that $\mathcal{A}'$ knows nothing about how $\mathcal{A}$ works; the only thing $\mathcal{A}'$ knows is that $\mathcal{A}$ is expecting to attack $\Pi$. So, given some input instance of $x$ of problem $X$, our algorithm $\mathcal{A}'$ will *simulate* for $\mathcal{A}$ an instance of $\Pi$ such that:
	- As far as $\mathcal{A}$ can tell, it is interacting with $\Pi$. That is, the view of $\mathcal{A}$ when run as a subroutine by $\mathcal{A}'$ should be distributed identically to (or at least close to) the view of $\mathcal{A}$ when it interacts with $\Pi$ itself.
	- When $\mathcal{A}$ succeeds in "breaking" the instance of $\Pi$ that is being simulated by $\mathcal{A}'$, this should allow $\mathcal{A}'$ to solve the instance $x$ it was given, at least with inverse pollynomial probability $1/p(n)$.  
	I.e. we attempt to *reduce* the problem of solving X to the problem of breaking $\Pi$.
1. Taken together, the above imply that $\mathcal{A}'$ solves $X$ with probability $\varepsilon(n)/p(n)$. Now, if $\varepsilon(n)$ is not negligible then neither is $\varepsilon(n)/p(n)$. Moreover, if $\mathcal{A}$ is efficient then we obtain an efficient algorithm $\mathcal{A}'$ solving $X$ with non-negligible probability, contradicting our initial assumption.
2. Given our assumption regarding $X$, we conclude that no efficient adversary $\mathcal{A}$ can succeed in breaking $\Pi$ with non-negligible probability. Stated differently, $\Pi$ is computationally secure.

> Introduction to Modern Cryptography. Jonathan Katz.
