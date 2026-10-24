\name{dcii1}
\alias{dcii1}
\title{Generate and Refine DCI Candidate Change Locations}
\description{Flag candidate mean changes with localized IQR exceedances, then
calculate the I1 statistic and a refined location in each neighboring window.
This is descriptive candidate detection, without significance testing.}
\usage{dcii1(y, r1 = 0, nbrhudfracleni1 = 1, i1ar = 0,
  w1 = 22, il_cutoff = 0, flag_method = c("legacy", "runs"))}
\arguments{
\item{y}{Finite numeric vector, subject to the length and scale restrictions
of \code{\link{i1_test}}. Each local IQR must be positive.}
\item{r1}{Nonnegative minimum absolute flag weight. Positive weights exactly
equal to r1 are retained for reference compatibility.}
\item{nbrhudfracleni1}{Localization fraction in (0,1]. Scaling-window length
is round((length(y)-1)*nbrhudfracleni1), at least 2.}
\item{i1ar}{0 for independent-noise standardization; 1 for the manuscript WD
scale in local statistic calculations. Neither setting produces DCI p-values.}
\item{w1}{Full-window parameter; see \code{\link{i1_test}}.}
\item{il_cutoff}{Nonnegative exceedance threshold applied before summing weights.}
\item{flag_method}{\code{"legacy"} preserves original run selection and centroid
conventions with negative-terminal indexing repaired. \code{"runs"} uses every
maximal nonzero same-sign run and its rounded arithmetic midpoint.}}
\details{
Apply adaptive contrasts to y. Within each scaling window, subtract the upper
quartile for observations above it or the lower quartile below it, and divide
by the window IQR; observations inside the quartiles contribute zero. Average
transformed values across all windows containing each contrast. The manuscript's
Hankel row count is p = length(y) - round((length(y)-1)*nbrhudfracleni1).

Legacy centroids are run_end - round(run_length/2); its counter rule omits
some interfacing runs or the first singleton. The runs option is a separate
explicit convention. Flag weights are signed; Direction need not agree with
the sign of the subsequently fitted Magnitude.

Prune flags from left to right until each neighboring pair of segments has
enough observations. The source length check uses length(y)-1 as the terminal
boundary; local evaluation uses length(y). Evaluate each retained flag using
its initial neighbors, with statistic-only I1 calculations. Refined locations
can coincide or appear out of order. No hypothesis is accepted or rejected,
and no sequential significance filtering is performed. The reference I1
calibration is not applied to data-selected DCI windows, even when a window
happens to have length 100. Candidate locations can occur in noise-only data.

Undefined local scales or inadmissible WD dependence estimates cause an error
identifying the affected flag. No artificial jitter or fallback distribution
is introduced. The alpha, output, evaluation and calibration arguments from
development version 0.1.0 are not part of this interface.
}
\value{Data frame with the original six column names:
\item{Flag}{Numeric preliminary last-observation-before-change index.}
\item{Direction}{Character flag sign, +ve or -ve.}
\item{pvalue}{Always NA_real_: retained as a structural compatibility column.}
\item{istatistic}{Local I1 statistic rounded to four decimals.}
\item{etavec}{Refined global candidate location.}
\item{Magnitude}{Signed local contrast in that window's standardized units.}
Empty results have zero rows and the same column types. The settings attribute
explicitly identifies candidate-only inference.}
\examples{
set.seed(21)
y <- rnorm(160) + rep(c(0, 4, -3, 1), c(50, 15, 15, 80))
candidates <- dcii1(y)
candidates
change_points(candidates)
dcii1(y, nbrhudfracleni1 = .5)
}
\seealso{\code{\link{i1_test}}, \code{\link{change_points}}}
\references{Waychal, N., Laha, A. K. and Sinha, A. (2026).
Closely spaced change-point detection with an application to geopolitical
shocks in oil and gas markets. \doi{10.48550/arXiv.2610.23476}.}
