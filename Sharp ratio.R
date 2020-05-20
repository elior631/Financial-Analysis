library(PerformanceAnalytics)
library(quantmod)
library(dygraphs)

symbols <- c("MMM","SPEN.TA", "SPY", "SGOL","ORL.TA", "BIL" )

prices <- 
  getSymbols(symbols, src = 'yahoo', 
             from = "2013-01-01",
             to = "2020-05-16",
             auto.assign = TRUE, warnings = FALSE) %>% 
  map(~Ad(get(.))) %>%
  reduce(merge) %>% 
  `colnames<-`(symbols)

prices_monthly <- to.monthly(prices, indexAt = "last", OHLC = FALSE)

asset_returns_xts <- na.omit(Return.calculate(prices_monthly, method = "log"))

######################################################################
dygraph(asset_returns_xts, main = "everybody") %>%
  dyAxis("y", label = "%") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(3, "Set2"))
######################################################################


w <- c(0.01, 0.20, 0.20, 0.20, 0.20, 0.19)

# Now use the built in PerformanceAnalytics function Return.portfolio
# to calculate the monthly returns on the portfolio, supplying the vector of weights 'w'.
portfolio_monthly_returns <- Return.portfolio(asset_returns_xts, weights = w)

# Add the wealth.index = TRUE argument and, instead of returning monthly returns,
# the function will return the growth of $1 invested in the portfolio.
dollar_growth <- Return.portfolio(asset_returns_xts,
                                  weights = w, wealth.index = TRUE)

# Use dygraphs to chart the growth of $1 in the portfolio.
dygraph(dollar_growth, main = "Growth of $1 Invested in Portfolio") %>%
  dyAxis("y", label = "$")


sharpe_ratio <- round(SharpeRatio(asset_returns_xts, Rf = .0003), 4)

sharpe_ratio
