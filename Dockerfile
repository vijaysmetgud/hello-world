# Build stage of Docker Image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the necessary .csproj files into the container
COPY hello-world.csproj ./   
COPY lib/library.csproj ./lib/  # If applicable
COPY test/unit-tests.csproj ./test/  # If applicable

# Restore dependencies
RUN dotnet restore

# Now copy the rest of the project files
COPY . ./  # Copy all project files into the container

# Build the project (no restore since it's already done)
RUN dotnet build -c Release --no-restore

# Publish the project to /app/publish
RUN dotnet publish -c Release -o /app/publish --no-build

# Runtime image (for running the application)
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

# Set the working directory for the runtime image
WORKDIR /app

# Copy the published files from the build stage
COPY --from=build /app/publish ./ 

# Set the entry point for the container
ENTRYPOINT ["dotnet", "hello-world.dll"]
