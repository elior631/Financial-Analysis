# pachages: quantmod, tidymodels, dplyr, tidyve, tidyquant 
library(quantmod)
library(tidymodels)
library(dplyr)
library(tidyverse)
library(tidyquant)

# single share
AAPL <- tq_get('AAPL',
               from = "2017-01-01",
               to = "2018-03-01",
               get = "stock.prices")
AAPL %>%
  ggplot(aes(x = date, y = adjusted)) +
  geom_line() +
   labs(x = 'Date',
       y = "Adjusted Price",
       title = "Apple price chart") +
  scale_y_continuous(breaks = seq(0,300,5))


# multiple share as table
tickers = c("SGOL", "SPEN.TA", "MLSR.TA", "^GSPC", "ORL.TA", "TA35.TA")

prices <- tq_get(tickers,
                 from = "2020-01-01",
                 to = now(),
                 get = "stock.prices")


prices$symbol[prices$symbol == "TA35.TA"] <- "Tel Aviv 35"
prices$symbol[prices$symbol == "ORL.TA"] <- "Bazan"
prices$symbol[prices$symbol == "^GSPC"] <- "S&P 500"
prices$symbol[prices$symbol == "SPEN.TA"] <- "Shaffir"
prices$symbol[prices$symbol == "SGOL"] <- "Gold"
prices$symbol[prices$symbol == "MLSR.TA"] <- "Melisron"

#prices %>%
 # ggplot(aes(x = date, y = adjusted, color = symbol)) +
  #geom_line()

prices %>%
  ggplot(aes(x = date, y = adjusted, color = symbol)) +
  geom_line() +
  facet_wrap(~symbol,scales = 'free_y') +
  labs(x = 'Date',
       y = "Adjusted Price",
       title = "Preffered stock form 01/2020") +
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_date(date_breaks = "month",
               date_labels = "%b") +
   theme(legend.position="bottom")

