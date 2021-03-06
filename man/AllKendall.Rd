% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllKendall.R
\name{AllKendall}
\alias{AllKendall}
\title{All Kendall's distances between two sets of total rankings or real-valued vectors}
\usage{
AllKendall(r, seqs = NULL, data.info = NULL, use.kernel.trick = FALSE,
  kmat = NULL, type = c("type-b", "type-a"), mc = 0.25)
}
\arguments{
\item{r}{A vector or a matrix of m1 sequences in rows and orders of n items in cols.}

\item{seqs}{Another vector or a matrix of m2 sequences in rows and orders of n items in cols. By default "seqs" is set equal to "r".}

\item{data.info}{Optional argument giving the Kendall embedding of "r", that is the result of KendallInfo(r), 
to facilitate computing Kendall's difference for "r" to "seqs" without exploring the kernel trick.}

\item{use.kernel.trick}{Logical indicating whether the kernel trick is explored. 
This is particularly interesting when the number of items to be ranked is high 
and pcaPP::cor.fk() is available. 
By default (set FALSE), Kendall embedding is explicitly computed; 
otherwise kernel trick is explored.}

\item{kmat}{Kendall kernel matrix of dimension m1 x m2, correlation type correponding to "type". If given, kernel trick is explored directly.}

\item{type}{A character string indicating the type of Kendall correlation for "kmat".}

\item{mc}{A normalization constant default to 0.25 such that output normalized squared Euclidean distance in the feature space induced by Kendall embedding amounts exactly to Kendall distances.}
}
\value{
A matrix of dimension m1 x m2 where entry [i,j] is the distance from sequence "i"
in "r" to sequence "j" in "seqs".
}
\description{
Calculates all of the Kendall's distances between two sets of total 
rankings or real-valued vectors.
}
\note{
Kernel trick is explored in the sense that "r" and "seq" are only used for checking dimensions and getting attributes but not used explicitly to compute the distance.
This is particularly interesting when data is high-dimensional in constrast to rather few observations (m1,m2>>n). 
Option "use.kernel.trick" set TRUE or FALSE may give slightly different results due to computation precision.
}
\examples{

#### Ex 1: compute Kendall distance matrix and Mallows kernel matrix
data1 <- do.call("rbind", list(1:5, 5:1, c(3, 2, 1, 4, 5)))
data2 <- do.call("rbind", list(1:5, 5:1))

# Kendall distance matrix
s.K.d.mat <- AllKendall(data1, data2)

# Mallows kernel matrix with dispersion parameter lambda
lambda <- 0.1
M.k.kmat <- exp(-lambda * s.K.d.mat)

#### Ex 2: why kernel trick?
r <- lapply(1:20, function(i) sample.int(1000, replace = TRUE))
r <- do.call('rbind', r)
dim(r)

# I) without kernel trick
pt <- proc.time()
dmat1 <- AllKendall(r, use.kernel.trick = FALSE)
proc.time() - pt

# II) with kernel trick (should be much faster in this setting)
require(pcaPP)
pt <- proc.time()
dmat2 <- AllKendall(r, use.kernel.trick = TRUE)
proc.time() - pt

# NOTE: dmat1 and dmat2 may return slightly different values due to computation precision
isTRUE(all.equal(dmat1, dmat2, check.attributes = FALSE)) # may sometimes output FALSE
isTRUE(max(abs(dmat1 - dmat2)) < 1e-6) # always output TRUE

}
\references{
Kendall rank correlation coefficient: \url{https://en.wikipedia.org/wiki/Kendall_rank_correlation_coefficient}

Jiao, Y., & Vert, J.-P. (2016). The Kendall and Mallows Kernels for Permutations. 2016. \href{https://hal.archives-ouvertes.fr/hal-01279273}{hal-01279273}
}
\author{
Yunlong Jiao
}
\keyword{Distance}
\keyword{Kendall}
\keyword{TotalRanking}
