plotPop <- function(data, qname, year, month){
  # subset the data
  dat <- subset(data, QuarLang == qname & Year == year & StichtagDatMM == month)
  # plot the population
  ggplot(dat, aes(x = Gender, y = AnzBestWir, alpha = Origin, fill = Gender)) + 
    geom_bar(stat = "identity", position = "stack", color="black", width = 0.9) +
    facet_wrap(~AlterV20Kurz, nrow = 1, strip.position = "bottom") +
    labs(x = "Age Group", y = "Population", title = paste0("Total Population in ",qname,": ",sum(dat$AnzBestWir)),
         caption = "Source: Stadt Zürich Open Data") + 
    ylim(c(0, max(aggregate(AnzBestWir ~ Year + SexCd + AlterV20Sort, 
                            data = subset(data, QuarLang == qname & StichtagDatMM == month), sum)$AnzBestWir))) +
    theme(panel.spacing = unit(0, "lines"),  panel.border = element_blank(), 
          panel.background = element_rect(fill = "transparent", colour = "transparent"),
          plot.background = element_rect(fill = "transparent", colour = NA),
          panel.grid.major.y = element_line(colour = "#e8e8e8"), 
          panel.grid.major.x = element_blank(), 
          panel.grid.minor.y = element_blank(), 
          panel.grid.minor.x = element_blank(),
          axis.line.y = element_blank(), 
          axis.line.x = element_blank(), 
          axis.ticks.x = element_blank(), 
          axis.ticks.y = element_line(colour = "#aaaaaa"),
          axis.text.x = element_blank(),
          legend.background = element_rect(fill = "transparent", colour = "transparent"))
}

