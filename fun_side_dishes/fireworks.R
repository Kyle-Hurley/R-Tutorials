library(ggplot2)
library(gganimate)


generate_explosion <- function(n_fireworks = 2, n_rounds = 2) {
  
  # Define bounds for firework initiation
  max_height <- 100
  max_left <- -100
  max_right <- 100
  
  # Define common firework colors
  firework_colors <- c(
    "#FF0000", "#FFD700", "#00FFFF", "#800080", "#FFA500", "#00FF00", "#0000FF",
    "#FF1493", "#00CED1", "#8A2BE2", "#FF4500", "#32CD32", "#87CEEB", "#FF69B4",
    "#7B68EE", "#4682B4", "#008080", "#FF6347", "#DB7093", "#40E0D0", "#7FFF00",
    "#FA8072", "#9370DB", "#40E0D0", "#D2691E", "#2E8B57", "#FF8C00", "#8B008B",
    "#DAA520", "#B0C4DE", "#8B4513", "#D2B48C", "#5F9EA0", "#CD5C5C", "#808080",
    "#6495ED", "#20B2AA", "#B22222", "#6B8E23", "#00FA9A", "#778899", "#FF00FF",
    "#008000", "#800000", "#800080", "#000080", "#808000", "#008080", "#0000FF", 
    "white"
  )
  
  # Create lists for firework clusters and rounds of clusters
  rounds_list <- list()
  fireworks_list <- list()
  
  for (r in 1:n_rounds) {
    
    for (i in 1:n_fireworks) {
      
      # Define important variables
      n_particles <- sample(15:50, 1) # Number of firework particles
      particle_its <- sample(5:25, 1) # Number of times each particle is plotted
      time <- rep(1:particle_its, each = n_particles) # Time vector
      decay_rate <- round(1 - ((time - (0.05 * max(time))) / (0.95 * max(time)))^2, digits = 2) # Rate of "light" decay
      
      # Create dataframe of firework explosion
      explosion_df <- data.frame(
        x = rep(sample(max_left:max_right, 1), n_particles), # Initial x position
        y = rep(sample((0.25*max_height):max_height, 1), n_particles), # Initial y position
        angle = runif(n_particles, 0, 2*pi), # Angle of trajectory
        speed = runif(n_particles, runif(1, 0.25, 0.5), runif(1, 5, 20)), # Speed of each particle
        time = time,
        colors = rep(firework_colors[sample(1:length(firework_colors), 1)], times = n_particles), # Color
        size = rep(sample(c(0.25, 0.5, 0.75, 1), 1), times = n_particles), # Random particle size
        alpha = ifelse(time < 0.1 * max(time), 1, 
                       ifelse(time == max(time), 0, decay_rate)) # "Light" intensity over time
      )
      
      # Update positions based on trajectory
      explosion_df <- within(explosion_df, {
        x <- x + speed * cos(angle) * time
        y <- y + speed * sin(angle) * time
      })
      
      # Give randowm alpha-numeric name to the firework for grouping in ggplot
      explosion_df$firework <- paste0(sample(0:9, 5, TRUE), 
                                      sample(LETTERS, 5, TRUE), 
                                      sample(letters, 5, TRUE), 
                                      collapse = "")
      
      # If more than one firework, separate them in time
      if (i != 1 & n_fireworks > 1) {
        explosion_df$time <- explosion_df$time + sample(2:(5*n_fireworks), 1)
      }
      
      # Put firework df in list
      fireworks_list[[i]] <- explosion_df
      
    }
    
    # Put all firework data into one df
    if (i == 1) {
      round <- fireworks_list[[i]]
    } else {
      round <- do.call(rbind, fireworks_list)
    }
    
    # Add time between rounds if needed
    if (n_rounds > 1) {
      
      if (r != 1) {
        round$time <- round$time + (max(rounds_list[[r-1]]$time) + sample(1:10, 1))
        rounds_list[[r]] <- round
      } else {
        rounds_list[[r]] <- round
      }
      
    } else {
      rounds <- round
    }
    
  }
  
  # Put all rounds of fireworks into one df
  if (n_rounds > 1) {
    rounds <- do.call(rbind, rounds_list)
  }
  
  # Set limits and plot
  x_lims <- c(max_left*2, max_right*2)
  y_lims <- c(-abs(min(rounds$y))*2, max_height*2)
  
  p <- ggplot(rounds, aes(x, y)) + 
    geom_point(shape = 16, aes(color = colors, size = size, 
                               group = firework, alpha = alpha)) + 
    xlim(x_lims) + ylim(y_lims) + 
    scale_size_area(max_size = 2) + 
    theme_void() + 
    theme(legend.position = "none", 
          plot.background = element_rect(fill = "black")) + 
    transition_time(time)
  
  return(p)
  
}


# Create fireworks show!!
n_fireworks <- 10
n_rounds <- 4
p <- generate_explosion(n_fireworks = n_fireworks, n_rounds = n_rounds)

# Animate
# ANIMATING LARGE TOTAL NUM OF FIREWORKS MAY CAUSE CRASH
# IF (N_FIREWORKS * N_ROUNDS) IS LARGE (E.G. ~100) DO NOT ANIMATE IN RSTUDIO
# SAVE IT DIRECTLY THEN OPEN THE FILE
animate(plot = p, 
        nframes = max(p$data$time) - min(p$data$time), 
        fps = 10)

a <- animate(plot = p, 
             nframes = max(p$data$time) - min(p$data$time), 
             fps = 10)

# Save it!!
anim_save(filename = "fireworks.gif", path = file.path(getwd()), animation = a)
