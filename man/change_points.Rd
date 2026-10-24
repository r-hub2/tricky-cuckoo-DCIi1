\name{change_points}
\alias{change_points}
\title{Extract Refined Candidate Locations}
\description{Sort and deduplicate refined locations from a DCI candidate result.}
\usage{change_points(x)}
\arguments{\item{x}{A data frame returned by \code{\link{dcii1}}, with finite
numeric etavec and a Flag column.}}
\details{This function performs no significance filtering or refitting.
Returned values are candidate locations, not statistically accepted changes.
Each location denotes the last observation before a candidate boundary.
The alpha argument from development version 0.1.0 is not supported.}
\value{Sorted unique numeric candidate locations; numeric(0) for no candidates.}
\examples{
set.seed(14)
y <- rnorm(100) + rep(c(0, 3), each = 50)
change_points(dcii1(y))
}
\references{Waychal, N., Laha, A. K. and Sinha, A. (2026).
Closely spaced change-point detection with an application to geopolitical
shocks in oil and gas markets. \doi{10.48550/arXiv.2610.23476}.}
