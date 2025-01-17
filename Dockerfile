# Build stage of Docker Image
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app
# Copy only the necessary .csproj file into the container
WORKDIR /app
COPY /var/lib/jenkins/workspace/dotdocker/hello-world.csproj ./
# Adjust the path as per your project structure

# Restore the dependencies
RUN dotnet restore hello-world.csproj

# Copy the rest of the application
COPY . ./

# Build the application
RUN dotnet build -c Release --no-restore

RUN dotnet publish -c Release -o /app/publish --no-build
 
# Final image AS a RUNTIME
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish ./
ENTRYPOINT ["dotnet", "hello-world.dll"]
