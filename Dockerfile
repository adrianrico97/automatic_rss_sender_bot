# Use a lightweight Ruby image as the base
# Consider replacing the image with a specific digest for reproducibility and security.
FROM docker.io/ruby:3.3.8-slim-bullseye

# Set the working directory inside the container
WORKDIR /app

# Install necessary packages for Ruby gems and application dependencies
# For example, if you have native extensions that require build tools
RUN apt-get update -qq && apt-get install -y build-essential libsqlite3-0 libsqlite3-dev nodejs

# Copy the Gemfile and Gemfile.lock first to leverage Docker cache
# This step installs dependencies only when Gemfile or Gemfile.lock changes
COPY src/Gemfile src/Gemfile.lock ./

# Install Ruby gems
RUN bundle install --jobs 4 --retry 3

# Copy the rest of the application code
COPY src/ .

# Define the command to run the application
# This will depend on how your application is started.
# Assuming `src/bin/rss_sender.rb` is the main script.
CMD ["ruby", "bin/rss_sender.rb"]
