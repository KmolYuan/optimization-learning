\section*{\center Homework 2}

Class: ME7129 Optimization in Engineering, National Taiwan University.

Student: Yuan Chang

Due date: 2019-10-08

This PDF is generated from Markdown[@homework2-md], scripping in Python[@homework2-py].

# Functional Monotonicity Analysis

1. $e^{\sqrt{x^{-1}(1-x^2)}}$

    We known the $x$ can not be zero, and $\frac{1-x^2}{x}$ must greater or equal than zero (for square root).
    The range of $x$ is $\{-\infty < x \le -1\}$ and $\{0 < x \le 1\}$.
    The differential function $f'(x)$ is:

    $$f'(x) = -\left(\frac{1+x^2}{2x^2\sqrt{\frac{1-x^2}{x}}}\right)e^{\sqrt{\frac{1-x^2}{x}}}$$

    Because of $x^2$ must greater than zero,
    so $1+x^2$ and $e^{\sqrt{\frac{1-x^2}{x}}}$ will greater than zero as well.
    This makes $f'(x)$ lower than zero in range $\{-\infty < x \le -1\}$ and $\{0 < x \le 1\}$.
    The function is decreasing monotonic $f(x^-)$.
    The plot looks like:

    ![](img/homework2-1.png){width=75%}

1. $\sin(x^2 + \ln{y^{-1}})$

    Since "sine" is a periodic function, so this function is not monotonic with $\{-\infty < x < \infty\}$ and $\{0 < y < \infty\}$.

1. $e^x / e^{\frac{1}{x}}$

    The function can be simplified as $e^{x-\frac{1}{x}} = e^{\frac{x^2-1}{x}}$,
    and $x$ must not equal than zero.
    The range of $x$ is $\{-\infty < x < 0\}$ and $\{0 < x < \infty\}$.
    The differential function $f'(x)$ is:

    $$f'(x) = \frac{x^2+1}{x^2}e^{\frac{x^2-1}{x}}$$

    Because of $x^2$ and $e^{\frac{x^2-1}{x}}$ must greater than zero,
    so the function is increasing monotonic $f(x^+)$.
    The plot looks like:

    ![](img/homework2-2.png){width=75%}

1. $\int_{a}^{b} \exp(-xt)dt$

    The function can be write as:

    $$\frac{df(x, t)}{dt} = e^{-xt}$$

    The exponential function returns always positive, so:

    + If $a<b$, the function is increasing monotonic $f(t^+)$.
    + If $a>b$, the function is decreasing monotonic $f(t^-)$.

# Well-Boundedness

$$
\begin{aligned}
\text{maximize } f & = x_1 - x_2
\\
\text{subject to } g_1 & = 2x_1 + 3x_2 - 10 \le 0
\\
g_2 & = -5x_1 - 2x_2 + 2 \le 0
\\
g_3 & = -2x_1 + 7x_2 - 8 \le 0
\end{aligned}
$$

Minimize $-f$ has same result of this objective function,
where $-f = -x_1 + x_2$.
The monotonicity table shown as:

|   | $x_1$ | $x_2$ |
|:---:|:---:|:-----:|
| $-f$ | $-$ | $+$ |
| $g_1$ | $+$ | $+$ |
| $g_2$ | $-$ | $-$ |
| $g_3$ | $-$ | $+$ |

By MP1, w.r.t $x_1$ and $g_1$ is active, w.r.t $x_2$ and $g_2$ is active.
Solving $g_1=0$ and $g_2=0$, get $x_1=-\frac{14}{11}$ and $x_2=\frac{46}{11}$.

But the results are not feasible with $g_3$.
Since the Monotonicity Principles are only applicable with well-constrained minimization problem.
w.r.t $x_1$ and $g_1$ is active, makes $g_1=0$ to eliminate $x_1$, we got:

$$

$$

# Reference
