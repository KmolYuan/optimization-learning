\section*{\center Homework 3}

Class: ME7129 Optimization in Engineering, National Taiwan University.

Student: Yuan Chang

Due date: 2019-11-08

This PDF is generated from Markdown[@homework3-md], scripping in Matlab[@homework3-ml].

**The original Matlab code has been modified ALL OVER for better readability and performance.**

# Ten Bar Truss Problem

Please use 'fmincon' in Matlab to obtain the deterministic optimal design.

$$
\begin{aligned}
\min_{r_1, r_2} f &= 6\pi r_1^2l + 4\pi r_2^2\sqrt{2}l
\\
F_i &\le P^c = \frac{\pi^2EI}{l_i^2}
\\
\sigma_i &\le \sigma_Y
\\
\delta_2 &\le 2
\end{aligned}
$$

The parameters are: $\rho$, $F$, $E$, $l$ and $\sigma_Y$, where:

$$
\begin{aligned}
\rho &= 7860 \text{ kg/m}^3
\\
F_{1\sim3} &= 0 \text{ N}
\\
F_4 &= -1\times 10^7 \text{ N}
\\
F_{5\sim12} &= 0 \text{ N}
\\
E &= 200\times 10^9 \text{ Pa}
\\
l &= 9.14 \text{ m}
\\
\sigma_Y &= 250\times 10^6 \text{ Pa}
\end{aligned}
$$

The boundary conditions of the variables:

$$
\begin{aligned}
0 \le x_1 &= r_1 \le 100
\\
0 \le x_2 &= r_2 \le 100
\end{aligned}
$$

Expand and normalize the constraints into negative null form:

$$
\begin{aligned}
g_{1\sim6} &= F_{1\sim6} - \frac{\pi^3r_1^2E}{4l^2} \le 0
\\
g_{7\sim10} &= F_{7\sim10} - \frac{\pi^3r_2^2E}{4(\sqrt{2}l)^2} \le 0
\\
g_{11\sim20} &= \sigma_{1\sim10} - \sigma_Y \le 0
\\
g_{21} &= \delta_2 - 2 \le 0
\end{aligned}
$$

**Using "optimset" option in function "fmincon" function, which chosen
"interior-point" algorithm for the following test.**

## Try at least three different starting points. Are the results the same?

Tested 7 results in the following table:

| Start point | Result | Iteration |
|:-----------:|:------:|:---------:|
| $(-1, -1)$ | $f(0.1383096430, 0.0979554117) = 4.8543104544$ | $11$ |
| $(0, 0)$ | $f(0.1383096430, 0.0979554117) = 4.8543104544$ | $11$ |
| $(1, 1)$ | $f(0.1383091842, 0.0979554418) = 4.8542895450$ | $11$ |
| $(2, 2)$ | $f(0.1383441451, 0.0979635647) = 4.8562143922$ | $12$ |
| $(3, 3)$ | $f(0.1383038827, 0.0979553927) = 4.8540353327$ | $18$ |
| $(10, 10)$ | $f(0.1383037187, 0.0979551606) = 4.8540201319$ | $19$ |
| $(100, 100)$ | $f(0.1383112568, 0.0981042941) = 4.8591287181$ | $32$ |

Among them, the negative start point $(-1, -1)$ just a boundaral test for the algorithm.

Actually, the results are not same at all ($10^{-3}$).

## What are the optimal values of all cross sections?

With the start point $(10, 10)$ above:

$$f(0.1383037187, 0.0979551606) = 4.8540201319$$

Maybe this is not the best solution, test the values around.
Try other values shown in the following table:

| Start point | Result | Iteration |
|:-----------:|:------:|:---------:|
| $(8, 8)$ | $f(0.1383078670, 0.0979559978) = 4.8542444643$ | $13$ |
| $(9, 9)$ | $f(0.1383081190, 0.0979555476) = 4.8542421478$ | $14$ |
| $(10, 10)$ | $f(0.1383037187, 0.0979551606) = 4.8540201319$ | $19$ |
| $(11, 11)$ | $f(0.1383045732, 0.0979563704) = 4.8540993507$ | $16$ |
| $(12, 12)$ | $f(0.1383205455, 0.0979562115) = 4.8548555070$ | $14$ |

Which shows the "interior-point" algorithm of "fmincon" function in Matlab would be yielding
the **better** answer $(10, 10)$ when the initial point $x_1 = x_2$ applied with  "optimset" option.

## What is the minimal weight of the truss obtained?

The minimal value $4.8540201319$ obtains $4.8540201319\rho = 38195.5623383421$ kg.

## How was your design problem terminated?

The terminated state with the initial value $(10, 10)$:

| State | Value |
|:------|:------|
| Exit code | $1$ |
| Iteration | $19$ |
| Function count | $107$ |
| Maximum of constraint functions | $0$ |
| Step size | $5.478800\times 10^{-10}$ |
| First order optimality | $5.6070\times 10^{-7}$ |
| Number of PCG iterations | $8$ |

The message says:

Local minimum found that satisfies the constraints.
Optimization completed because the objective function is non-decreasing
in feasible directions, to within the default value of the optimality tolerance,
and constraints are satisfied to within the default value of the constraint tolerance.

## Which constraint(s) is(are) active?

For each constraint $g_i$, disable one by one to show the changes or not.

| Disabled | Result | Is changed |
|:--------:|:------:|:----------:|
| No | $f(0.1383037187, 0.0979551606) = 4.8540201319$ | The original one |
| $g_{1\sim3}$ | $f(0.1383891471, 0.0979989506) = 4.8594863026$ | O |
| $g_4$ | $f(0.1383894512, 0.0979961222) = 4.8594107626$ | O |
| $g_{5\sim6}$ | $f(0.1383891468, 0.0979989523) = 4.8594863424$ | O |
| $g_{7\sim10}$ | $f(0.1383042181, 0.0979561769) = 4.8540762706$ | O |
| $g_{11}$ | $f(0.0738500279, 0.1016583700) = 2.6182513218$ | O |
| $g_{12}$ | $f(0.1383037187, 0.0979551606) = 4.8540201319$ | X |
| $g_{13}$ | $f(0.1383297103, 0.0979824182) = 4.8561263967$ | O |
| $g_{14}$ | $f(0.1383289543, 0.0979870556) = 4.8562379805$ | O |
| $g_{15}$ | $f(0.1383037187, 0.0979551606) = 4.8540201319$ | X |
| $g_{16}$ | $f(0.1383037187, 0.0979551606) = 4.8540201319$ | X |
| $g_{17}$ | $f(0.1383204594, 0.0979796454) = 4.8555972160$ | O |
| $g_{18}$ | $f(0.1383081120, 0.0979550741) = 4.8542267458$ | O |
| $g_{19}$ | $f(0.1382940124, 0.0946892937) = 4.7513634367$ | O |
| $g_{20}$ | $f(0.1383080693, 0.0979550744) = 4.8542247212$ | O |
| $g_{21}$ | $f(0.1383037187, 0.0979551600) = 4.8540201123$ | O |

After the test, disabled constraints $g_{12}$, $g_{15}$ and $g_{16}$ was not change the result.
So apparently they are not active to the objective function, but the others do.

## Please provide a rationale that you have found the correct result.

Instead of input an actual objective function,
the algorithm uses trial and error to obtain discrete values from a "function object" during runtime.

This will cause the algorithm unable to get the correct extrema
unless its values are got from the slope of the objective function $f'(r_1, r_2)$.

# Reference
