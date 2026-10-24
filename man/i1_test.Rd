\name{i1_test}
\alias{i1_test}
\title{I1 Mean-Change Test or Statistic-Only Analysis}
\description{Compute an adaptive mean-change statistic. Reference p-values
are available only for independent Gaussian series of length 100 with w1 = 22.}
\usage{i1_test(y, archeck = 0, w1 = 22, calibration = c("reference", "none"))}
\arguments{
\item{y}{Finite numeric vector or univariate time series. At least
\code{max(w1, 2 * round(w1 / 2))} observations are required. Missing,
infinite, complex and matrix inputs are rejected.}
\item{archeck}{0 for independent-noise standardization; 1 for the manuscript's
WD scale. WD mode requires \code{calibration = "none"}.}
\item{w1}{Integer full-window parameter, at least 4. Each side uses at most
\code{w = round(w1 / 2)} observations; R rounds ties to even.}
\item{calibration}{\code{"reference"} requires length 100, w1 = 22 and archeck = 0.
It assumes independent Gaussian noise. \code{"none"} returns NA for pvalue
and allows other supported lengths, windows and WD standardization.}}
\details{
Center the data and divide by
\eqn{\mathrm{IQR}(\Delta y)/[-2\sqrt{2}\Phi^{-1}(0.25)]}.
For boundary t, subtract the preceding min(w,t) observation mean from the
following min(w,n-t) observation mean. Sum these contrasts from t-w+1 through
t+w-1; maximize the absolute aggregate over t = w,...,n-w, choosing the
first maximum. This preserves the original script's adaptive implementation;
the theoretical interior-only index set is different.

WD estimates \eqn{\hat\rho=1+2\mathrm{cor}(\Delta y_{1:(n-2)},\Delta y_{2:(n-1)})}
and uses \eqn{\mathrm{IQR}(\Delta y)/[-2\sqrt{2}(1-\hat\rho)\Phi^{-1}(0.25)]},
as in Appendix B.1. The radical covers 2 only. The dependence identity is
appropriate for stationary AR(1) noise, not arbitrary serial dependence.
Non-finite estimates or estimates outside (-1,1), zero IQR and arithmetic
overflow cause descriptive errors. WD results are statistics, not calibrated tests.

Reference p-values sum the supplied zero-correlation density ordinates at or
above the unrounded statistic, multiply by grid spacing, bound to [0,1] and
round to four decimals. A zero is a finite-grid tail approximation, not proof
of zero probability. The null is a constant mean with independent Gaussian
noise. Distributional assumptions are the user's responsibility; they cannot
be established from input length alone. The method is not a general test for
variance changes, trends, or arbitrary dependent noise.

In 10000 independent Gaussian null validation series of length 100, rejection
rates at nominal .01, .05 and .10 were .0086, .0415 and .0857. Thus the retained
calibration is approximate and was conservative at these levels in this study.
These results do not establish exact size at every significance level. There
is no multiplicity adjustment or asymptotic p-value substitution.
}
\value{One-row data frame with numeric columns:
\item{pvalue}{Approximate reference upper-tail probability; NA for statistic-only mode.}
\item{i1}{Absolute maximum aggregate, rounded to four decimals.}
\item{etahat}{Estimated last observation before the change, between w and n-w,
even when the test is not significant.}
\item{cpmag}{Signed right-minus-left contrast in standardized units. Multiply
by the diagnostics sigma to express it in the original data units.}
The diagnostics attribute records scale, dependence estimate, calibration mode,
reference length, selected key, unrounded statistic and inference scope.}
\examples{
set.seed(12)
y <- rnorm(100) + rep(c(0, 3), each = 50)
result <- i1_test(y)
result
attr(result, "diagnostics")
i1_test(y, w1 = 16, calibration = "none")
i1_test(y, archeck = 1, calibration = "none")
}
\seealso{\code{\link{i1_stt}}, \code{\link{dcii1}}}
\references{Waychal, N., Laha, A. K. and Sinha, A. (2026).
Closely spaced change-point detection with an application to geopolitical
shocks in oil and gas markets. \doi{10.48550/arXiv.2610.23476}.}
