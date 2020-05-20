library(tidyquant)
library(tidyverse)
library(timetk)
library(tibbletime)
library(broom)

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

w <- c(0.01, 0.20, 0.20, 0.20, 0.20, 0.19)

portfolio_returns_xts_rebalanced_monthly <- 
  Return.portfolio(asset_returns_xts, weights = w, rebalance_on = "months") %>%
  `colnames<-`("returns") 

#merge to one column
asset_returns_long <-  
  prices %>% 
  to.monthly(indexAt = "last", OHLC = FALSE) %>% 
  tk_tbl(preserve_index = TRUE, rename_index = "date") %>%
  gather(asset, returns, -date) %>% 
  group_by(asset) %>%  
  mutate(returns = (log(returns) - log(lag(returns)))) %>% 
  na.omit()

portfolio_returns_tq_rebalanced_monthly <- 
  asset_returns_long %>%
  tq_portfolio(assets_col  = asset, 
               returns_col = returns,
               weights     = w,
               col_rename  = "returns",
               rebalance_on = "months")

# The market portfolio

spy_monthly_xts <- 
  getSymbols("SPY", 
             src = 'yahoo', 
             from = "2013-01-01", 
             to = "2020-05-16",
             auto.assign = TRUE, 
             warnings = FALSE) %>% 
  map(~Ad(get(.))) %>% 
  reduce(merge) %>%
  `colnames<-`("SPY") %>% 
  to.monthly(indexAt = "last", OHLC = FALSE)

market_returns_xts <-
  Return.calculate(spy_monthly_xts, method = "log") %>% 
  na.omit()


#GOOG - for a single share
GOOG_monthly_xts <- 
  getSymbols("GOOG", 
             src = 'yahoo', 
             from = "2013-01-01", 
             to = "2020-05-16",
             auto.assign = TRUE, 
             warnings = FALSE) %>% 
  map(~Ad(get(.))) %>% 
  reduce(merge) %>%
  `colnames<-`("SPY") %>% 
  to.monthly(indexAt = "last", OHLC = FALSE)

google_returns_xts<- 
  Return.calculate(GOOG_monthly_xts, method = "log") %>% 
  na.omit()

beta_builtin_xts <- CAPM.beta(google_returns_xts, market_returns_xts)

beta_builtin_xts
  
dow<- data.frame(google_returns_xts, market_returns_xts)

write.csv(
  dow ,
  file = ("betta.csv"),
  row.names = FALSE
)