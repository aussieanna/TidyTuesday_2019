
library(tidyverse)
options(scipen=999)
#Import data
fed_rd <- read_csv("fed_rd.csv")

#Set theme using NASA font -> use loadfonts
extrafont::loadfonts(device="win")
my_theme <- theme_bw() +
  theme (
    text = element_text (colour = "#FDFDFD", face = "bold", family = "Nasalization Rg"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    plot.background = element_rect(fill = "#262A33"),
    panel.background = element_rect(fill = "#262A33"),
    panel.border = element_rect(size = 0),
    axis.text.x = element_text(colour = "#FDFDFD", size = 9),
    axis.text.y = element_text(colour = "#FDFDFD", size = 12),
    plot.title = element_text(colour = "#FDFDFD", size = 24)
  )
#Filter to just NASA and convert rd_budget to $US Billions
nasa <- fed_rd %>% filter(department == "NASA") %>% mutate(rd_billion = rd_budget/1000000000, total = total_outlays/1000000000, percent_rd = rd_billion/total*100)

#How has NASA R&D spending changed over time?
p <- ggplot(nasa, aes(year, rd_billion)) + geom_line(colour = "#0169F4", size = 2)  + theme_bw() +
  labs(x = "Date", y = "$US billion", title = "NASA R&D Spending, 1976 to 2017", caption = "Source: AAAS")
p + my_theme
p

#Area chart
p2 <- ggplot(nasa, aes(year, rd_billion)) + geom_area(colour = "black", fill = "blue", alpha = 0.6)  + my_theme +
  labs(x = "Date", y = "$US billion", title = "NASA R&D Spending, 1976 to 2017", caption = "Source: AAAS")
p2

#Total spending
p3 <- ggplot(nasa, aes(year, total)) + geom_area(colour = "black", fill = "green", alpha = 0.6)  + my_theme +
  labs(x = "Date", y = "$US billion", title = "NASA Total spending, 1976 to 2017", caption = "Source: AAAS")
p3

#Function to preview the image before saving
ggpreview <- function (..., device = "png") {
  fname <- tempfile(fileext = paste0(".", device))
  ggplot2::ggsave(filename = fname, device = device, ...)
  system2("open", fname)
  invisible(NULL)
}
#Preview the image
ggpreview(p2)
#Save the image
ggsave("nasa_rd.png", width = 8, height = 6)

#Knit the file but also generate a R markdown file (precious = TRUE)
knitr::spin("Week_7_Fed_RD.R", precious = TRUE)

##################Check of billions####################################
#https://stackoverflow.com/questions/28159936/formatting-large-currency-or-dollar-values-to-millions-billions
# Format numbers with suffixes K, M, B, T and optional rounding. Vectorized
# Main purpose: pretty formatting axes for plots produced by ggplot2
#
# Usage in ggplot2: scale_x_continuous(labels = suffix_formatter)

suffix_formatter <- function(x, digits = NULL)
{
  intl <- c(1e3, 1e6, 1e9, 1e12);
  suffixes <- c('K', 'M', 'B', 'T');
  
  i <- findInterval(x, intl);
  
  result <- character(length(x));
  
  # Note: for ggplot2 the last label element of x is NA, so we need to handle it
  ind_format <- !is.na(x) & i > 0;
  
  # Format only the elements that need to be formatted 
  # with suffixes and possible rounding
  result[ind_format] <- paste0(
    formatC(x[ind_format]/intl[i[ind_format]], format = "f", digits = digits)
    ,suffixes[i[ind_format]]
  );
  # And leave the rest with no changes
  result[!ind_format] <- as.character(x[!ind_format]);
  
  return(invisible(result));
}

p4 <- ggplot(nasa, aes(year, rd_budget)) + geom_area(colour = "black", fill = "blue", alpha = 0.6)  + my_theme +
  labs(x = "Date", y = "$US billion", title = "NASA R&D Spending, 1976 to 2017") + scale_y_continuous(labels = suffix_formatter())
p4
############################################################################
#How to the budgets compare across departments?
fed_rd_billion <- fed_rd %>%  mutate(rd_billion = rd_budget/1000000000)
p5 <- ggplot(fed_rd_billion, aes(year, rd_billion)) + geom_area(colour = "black", fill = "#228B22", alpha = 0.6)  + my_theme +
  labs(x = "Date", y = "$US billion", title = "R&D Spending by US Department, 1976 to 2017") + facet_wrap(~department)
p5

p6 <- ggplot(fed_rd_billion, aes(year, rd_billion)) + geom_area(colour = "black", fill = "#228B22", alpha = 0.6)  + my_theme +
  labs(x = "Date", y = "$US billion", title = "R&D Spending by US Department, 1976 to 2017") + scale_x_continuous(breaks = seq(1976, 2017, by = 20))+ facet_wrap(~department, scales = "free_y", nrow = 2) 
p6

#Preview the image
ggpreview(p6, width = 10)
#Save the image
ggsave("fed_rd.png", width = 10, height = 6)
