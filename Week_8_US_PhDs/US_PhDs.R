library(tidyverse)
library(directlabels)

#Import data
phds <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-02-19/phd_by_field.csv")

#Set theme using IBM Plex font -> use loadfonts
extrafont::loadfonts(device="win")
my_theme <- theme_bw() +
  theme (
    text = element_text (colour = "#FDFDFD", face = "bold", family = "IBM Plex Sans"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    plot.background = element_rect(fill = "#262A33"),
    panel.background = element_rect(fill = "#262A33"),
    panel.border = element_rect(size = 0),
    axis.text.x = element_text(colour = "#FDFDFD", size = 9),
    axis.text.y = element_text(colour = "#FDFDFD", size = 12),
    plot.title = element_text(colour = "#FDFDFD", size = 24),
    legend.background = element_blank (),
    legend.key = element_blank ()
  )

#Filter data to Biological and biomedical sciences
bio <- phds %>% filter(major_field == "Biological and biomedical sciences" & n_phds != "NA")

epi <- bio %>% filter(field == "Epidemiology" | field == "Bioinformatics" | field == "Neurosciences, neurobiologye" | field == "Cell, cellular biology, and histology")

#Make a line graph
p <- ggplot(epi, aes(x = year, y = n_phds, group = field, colour = field)) + geom_line(size = 1.5) + scale_x_continuous(limits = c(2008, 2021), breaks = c(2008, 2012, 2016)) + geom_dl(aes(label = field, color = field), method = list("last.points")) + labs(x = "Year", y="Number", title="PhDs awarded in the US, 2008-2017", caption="Source: NSF")
p2 <- p + my_theme + theme(legend.position = "none")
p2

#Save the image
ggsave("us_phds.png", width = 12, height = 8)

