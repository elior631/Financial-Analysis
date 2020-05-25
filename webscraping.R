
set_url <- 'https://en.wikipedia.org/wiki/List_of_S%26P_500_companies'
xpath <- '//*[@id="constituents"]/thead/tr/th[1]'

library(rvest)

# set url and xpath
my_url <- 'https://en.wikipedia.org/wiki/List_of_S%26P_500_companies'
my_xpath <- '//*[@id="mw-content-text"]/div/table[1]'

# get nodes from html
out_nodes <- html_nodes(read_html(my_url),
                        xpath = my_xpath)

# get table from nodes (each element in 
# list is a table)
df_SP500_comp <- html_table(out_nodes)

# isolate it 
df_SP500_comp <- df_SP500_comp[[1]]

# change column names (remove space)
names(df_SP500_comp) <- make.names(names(df_SP500_comp))

# print it
glimpse(df_SP500_comp)

#BOI


library(rvest)

# set address of BOI
set_url_boi <- 'https://www.boi.org.il/heb/Pages/HomePage.aspx'

# read html
html_code <- read_html(set_url_boi)

# set xpaths
xpath_int_rate <- '//*[@id="ctl00_PlaceHolderMain_BoiInterestViewer_currentInterest"]'

# get interest rate from html
my_int_rate <- html_text(html_nodes(x = html_code,
                                    xpath = xpath_int_rate ))





