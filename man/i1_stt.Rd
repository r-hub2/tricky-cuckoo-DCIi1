\name{i1_stt}
\alias{i1_stt}
\title{Compute the Unrounded I1 Statistic Without Calibration}
\description{Compute the reference adaptive I1 statistic independently of the
empirical calibration repository.}
\usage{i1_stt(y, archeck = 0, w1 = 22)}
\arguments{
\item{y}{Finite numeric vector with the length and scaling restrictions of
\code{\link{i1_test}}.}
\item{archeck}{0 for differenced-IQR scaling; 1 to estimate dependence.}
\item{w1}{Integer full-window parameter, at least 4, with half-width
\code{round(w1 / 2)} and at least twice that half-width observations.}

}
\details{Uses adaptive contrasts and symmetric aggregation as described in
\code{\link{i1_test}}. No p-value, critical value or significance decision is
available here. WD scaling follows Appendix B.1 and the supplied script. Estimated dependence must
lie strictly in (-1,1), and no p-value is assigned. Undefined
scaling and non-finite inputs produce errors.}
\value{One unrounded nonnegative numeric statistic.}
\examples{
set.seed(13)
y <- rnorm(100)
i1_stt(y)
i1_stt(y, w1 = 10)
i1_stt(y, archeck = 1)
}
\seealso{\code{\link{i1_test}}}
\references{
Waychal, N., Laha, A. K. and Sinha, A. (2026).
Closely spaced change-point detection with an application to geopolitical
shocks in oil and gas markets. \doi{10.48550/arXiv.2610.23476}.
}
