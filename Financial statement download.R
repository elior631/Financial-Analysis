# Financial statement download
install.packages("simfinR")
install.packages("memoise")
library(memoise)
library(simfinR)
library(tidyverse)
library(scales)
library(tidyquant)
my_api_key <- 'BCyGJflQJY0ZWt9WhAiKSYwMlIZTW5pm'


# get info
df_info_companies <- simfinR_get_available_companies(my_api_key)

fintech_ids <- c(109664, 889703, 182201, 88558, 786096, 83293)

id_companies <- fintech_ids # id of APPLE INC
type_statements <- 'pl' # profit/loss
periods = 'FY' # final year
years = 2015:2019

df_fin_FY <- simfinR_get_fin_statements(
  id_companies,
  type_statements = type_statements,
  periods = periods,
  year = years,
  api_key = my_api_key)


net_income <- df_fin_FY %>%
  filter(acc_name == 'Net Income')


net_income %>%
ggplot( aes(x = year, y = (acc_value)/1000000), color = year) +
  geom_col(aes(fill = year)) + 
  labs(title = 'Annual Profit/Loss of the Companies (M)',
       x = '',
       y = 'Net Profit/Loss',
       caption = 'Data from simfin') + 
  facet_wrap(~company_name, scales = 'free_y') + 
  scale_y_continuous(labels = function(x) format(x, scientific = FALSE))+
  theme_tq()


#Quarter
type_statements <- 'pl' # profit/loss
periods = c('Q1', 'Q2', 'Q3', 'Q4') # final year
years = 2019:2020

df_fin_quarters <- simfinR_get_fin_statements(
  id_companies,
  type_statements = type_statements,
  periods = periods,
  year = years,
  api_key = my_api_key)

glimpse(df_fin_quarters)


net_income_q <- df_fin_quarters %>% 
  filter(acc_name == 'Net Income')


net_income_q %>%
  ggplot(aes(x = ref_date, y = acc_value/1000000), color = period ) +
  geom_col(aes(fill = period)) + 
  labs(title = 'Auarterly Profit/Loss of the Companies',
       x = '',
       y = 'Net Profit/Loss',
       caption = 'Data from simfin') + 
  scale_y_continuous(labels = function(x) format(x, scientific = FALSE))+
  facet_wrap(~company_name ,scales = 'free' , ncol = 2) +
  theme_tq()

#BS_data

type_statements <- 'bs' # profit/loss
periods = c('Q1', 'Q2', 'Q3', 'Q4') # final year
years = 2019:2020

df_bs_quarters <- simfinR_get_fin_statements(
  id_companies,
  type_statements = type_statements,
  periods = periods,
  year = years,
  api_key = my_api_key)
  

glimpse(df_bs_quarters)
