
# setup ------------------------------------------------------------------------

library(here)
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)

# data -------------------------------------------------------------------------

job_data <- 
  read.csv(here("data", "vacant positions survey.csv"))

# prepare job data
colnames(job_data)[1] <- "period"

job_data <- 
  job_data |> 
  mutate(across(- period, 
                ~ if_else(.x == "--", NA, .x) |> as.numeric())) |> 
  pivot_longer(cols = - period,
               names_to = c("occ_1d", "industry", "occ_2d"),
               names_pattern = "(.*)br(.*)br(.*)br?",
               values_to = "num_positions") |> 
  mutate(period = ym(period))

job_data <- 
  job_data |>
  mutate(industry = if_else(!grepl("[A-Z]", industry), "אחרים", industry))

# plot -------------------------------------------------------------------------

job_data |> 
  group_by(period, occ_1d, industry) |> 
  summarise(num_positions = sum(num_positions, na.rm = T),
            .groups = "drop") |> 
  ggplot(aes(period, num_positions, group = industry, colour = industry))+
  geom_vline(xintercept = ym("2022-11"), linetype = "dotted") +
  tidyquant::geom_ma(ma_fun = SMA, n = 3, linetype = "solid") +
  coord_cartesian(xlim = c(ym("2022-1"), NA)) +
  facet_wrap(~occ_1d, scales = "free_y")
  